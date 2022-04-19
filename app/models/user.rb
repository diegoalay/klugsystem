class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  include LoggerConcern

  has_many :user_roles, foreign_key: 'user_id',class_name: 'User::Role'
  has_many :roles, through: :user_roles, source: :roles

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
end