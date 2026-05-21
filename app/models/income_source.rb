class IncomeSource < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user
  has_many :expenses, dependent: :nullify

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :name, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :source, presence: true  # Campo obligatorio ahora

  scope :active, -> { where(active: true) }

  attribute :active, :boolean, default: true

  def estimated_monthly_amount
    amount  # Para ingresos únicos, es el monto mismo
  end
end