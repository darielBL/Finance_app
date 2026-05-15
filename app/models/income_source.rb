class IncomeSource < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :name, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :frequency, presence: true, inclusion: { in: %w[monthly biweekly weekly one_time] }

  scope :active, -> { where(active: true) }

  def estimated_monthly_amount
    case frequency
    when "monthly"
      amount
    when "biweekly"
      amount * 2.166
    when "weekly"
      amount * 4.33
    when "one_time"
      Money.new(0, amount_currency)
    end
  end

  def formatted_frequency
    {
      "monthly" => "Mensual",
      "biweekly" => "Quincenal",
      "weekly" => "Semanal",
      "one_time" => "Único"
    }[frequency]
  end

  attribute :amount_currency, :string, default: "CUP"

end