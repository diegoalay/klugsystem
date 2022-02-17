class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  belongs_to :account,          foreign_key: "account_id"

  def self.search account, query
    search = query[:filters][:search]&.downcase

    clients = account.users.select("
      id,
      email
    ")

    clients = clients.where("
      lower(email) like '%#{search}%'
    ") if search
  end

  def name
    [first_name, first_surname].join(" ")
  end

  def cash_register
    CashRegister
    .where(account: self.account)
    .where(user_creator_id: self.id)
    .where(close_date: nil)
    .last
  end
end