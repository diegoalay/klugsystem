class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  include LoggerConcern

  belongs_to :branch_office
  has_many :user_roles, foreign_key: 'user_id',class_name: 'User::Role'
  has_many :cash_registers, foreign_key: 'user_creator_id'
  has_many :roles, through: :user_roles, source: :roles
  has_many :menu_items, through: :user_roles, source: :roles
  has_many :logs, inverse_of: :user
  has_many :sessions, inverse_of: :user
  has_many :requests, inverse_of: :user

  def self.search account, query
    search = query[:filters][:search]&.downcase

    users = account.users.select(
      'id',
      'email'
    )

    users = users.where("
      lower(email) like '%#{search}%'
    ") if search
  end

  def name
    [first_name, first_surname].join(' ')
  end

  def current_cash_register
    cash_register = cash_registers.where(close_date: nil).last
  end

  def show
    attributes.merge(role_id: roles.first.id)
  end

  def profile
    {
      id: id,
      first_name: first_name,
      first_surname: first_surname,
      second_name: second_name,
      second_surname: second_surname,
      email: email
    }
  end

  def create_session(request)
    remote_ip = request.env["HTTP_USER_AGENT"]
    http_user_agent = request.env["HTTP_USER_AGENT"]

    # register a new unique session
    self.sessions.create({
      user_agent: get_user_agent(http_user_agent),
      user_remote: remote_ip,
      last_used_at: Time.now
    })
  end

  def get_user_agent(http_user_agent, as_string = true)
    # parse user agent
    user_agent = UserAgent.parse(http_user_agent)

    # return user agent info as string
    return "#{user_agent.platform} #{user_agent.os} - #{user_agent.browser} #{user_agent.version}" if as_string == true

    user_agent
  end

  def abilities
    ::MenuItem.select('id', 'key', 'permissions') if admin?

    items = menu_items.joins(menu_items: [:menu_item]).where("role_menu_items.status = ?", true)

    items.select('menu_items.id', 'menu_items.key', 'menu_items.permissions')
  end

  def generate_password_reset_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    self.save(validate: false)

    raw
  end

  def log_request(request, params)
    remote_ip = request.env["HTTP_USER_AGENT"]
    http_user_agent = request.env["HTTP_USER_AGENT"]

    requests.create(
      url: request.path,
      method: request.method,
      action: params[:action],
      controller: params[:controller],
      format: request.format.symbol.to_s,
      params: request.request_parameters,
      user_agent: get_user_agent(http_user_agent)
    )
  end

  def admin?
    roles.map(&:code).include?('admin')
  end

  def can?(permission)
    return true if permission == 'profile'
    return true if permission == 'dashboard'
    return true if admin?

    granted = roles.joins(menu_items: [:menu_item])
    .where('menu_items.key = ?', permission)
    .where('role_menu_items.status = ?', true)
    .first

    return false if granted.nil?
    return true
  end
end