class GoalContribution < ApplicationRecord
  include MoneyNormalizable

  belongs_to :goal

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :contributed_at, presence: true

  scope :ordered, -> { order(contributed_at: :desc, created_at: :desc) }
end
