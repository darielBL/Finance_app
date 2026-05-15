class Expense < ApplicationRecord
  include MoneyNormalizable
  belongs_to :user
  belongs_to :category

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :description, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :spent_at, presence: true
  validates :spent_at, date: { not_in_future: true }, if: -> { spent_at.present? }

  scope :by_month, ->(date) { where(spent_at: date.beginning_of_month..date.end_of_month) }
  scope :by_currency, ->(currency) { where(amount_currency: currency) }
  scope :ordered, -> { order(spent_at: :desc, created_at: :desc) }

  def formatted_date
    spent_at.strftime("%d/%m/%Y")
  end

  attribute :amount_currency, :string, default: "CUP"

end