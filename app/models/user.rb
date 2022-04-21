class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  include LoggerConcern

  belongs_to :branch_office
  has_many :user_roles, foreign_key: 'user_id',class_name: 'User::Role'
  has_many :roles, through: :user_roles, source: :roles
  has_many :menu_items, through: :user_roles, source: :roles

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

  def cash_register
    CashRegister
    .where(account: self.account)
    .where(user_creator_id: self.id)
    .where(close_date: nil)
    .last
  end

  def show
    {
      id: id,
      first_name: first_name,
      first_surname: first_surname,
      email: email,
      role_id: user_roles.first&.role_id,

    }
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

  def can?(permission)
    return true if roles.map(&:code).include?('admin')

    granted = roles.joins(menu_items: [:menu_item])
    .where('menu_items.key = ?', permission)
    .where('role_menu_items.status = ?', true)
    .first

    return false if granted.nil?
    return true
  end
end