class Debt < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :name, presence: true
  validates :debt_type, inclusion: { in: %w[to_pay to_receive] }
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :person_name, presence: true

  scope :to_pay, -> { where(debt_type: "to_pay") }
  scope :to_receive, -> { where(debt_type: "to_receive") }
  scope :pending, -> { where(paid_at: nil) }
  scope :paid, -> { where.not(paid_at: nil) }
  scope :ordered, -> { order(paid_at: :desc, due_date: :asc, created_at: :desc) }

  def paid?
    paid_at.present?
  end

  def status
    if paid?
      "pagada"
    elsif due_date.present? && due_date < Date.current
      "vencida"
    else
      "pendiente"
    end
  end

  def formatted_due_date
    due_date&.strftime("%d/%m/%Y")
  end

  def to_pay?
    debt_type == "to_pay"
  end

  def to_receive?
    debt_type == "to_receive"
  end

  def formatted_paid_at
    paid_at&.strftime("%d/%m/%Y")
  end
end
