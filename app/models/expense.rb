class Expense < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user
  belongs_to :category
  belongs_to :income_source, optional: true

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :description, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :spent_at, presence: true
  validate :spent_at_not_in_future  # <-- Esta línea estaba faltando

  scope :by_month, ->(date) { where(spent_at: date.beginning_of_month..date.end_of_month) }
  scope :by_currency, ->(currency) { where(amount_currency: currency) }
  scope :ordered, -> { order(spent_at: :desc, created_at: :desc) }

  attribute :amount_currency, :string, default: "CUP"

  def formatted_date
    spent_at.strftime("%d/%m/%Y")
  end

  private

  def spent_at_not_in_future
    if spent_at.present? && spent_at > Date.current
      errors.add(:spent_at, "no puede ser una fecha futura")
    end
  end
end