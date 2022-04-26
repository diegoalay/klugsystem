class BranchOffice < ApplicationRecord
  include LoggerConcern

  validates :name,       presence: true
  validates :telephone,  presence: true

  before_destroy :can_be_destroyed

  has_many :users
  has_many :sales
  has_many :expeditures
  has_many :products

  private

  def electronic_billing_active?
    electronic_billing && account.electronic_billing?
  end

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a esta sucursal'") and throw(:abort) unless account.sales.where(branch_office: self).blank?
    errors.add(:base, "Existen productos asignadas a esta sucursal'") and throw(:abort) unless account.products.where(branch_office: self).blank?
  end
end
