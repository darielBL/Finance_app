class FinancialAccount < ApplicationRecord
  belongs_to :user

  ACCOUNT_TYPES = {
    "cash" => "Efectivo",
    "card" => "Tarjeta",
    "savings" => "Ahorros",
    "other" => "Otro"
  }.freeze

  validates :name, presence: true
  validates :account_type, inclusion: { in: ACCOUNT_TYPES.keys }

  scope :active, -> { where(archived_at: nil) }
  scope :ordered, -> { order(:name) }

  def active?
    archived_at.nil?
  end

  def archive
    update(archived_at: Time.current)
  end

  def account_type_name
    ACCOUNT_TYPES[account_type] || account_type.humanize
  end
end
