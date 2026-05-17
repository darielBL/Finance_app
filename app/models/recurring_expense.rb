class RecurringExpense < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user
  has_many :records, class_name: "RecurringExpenseRecord", dependent: :destroy

  monetize :estimated_amount_cents, with_model_currency: :estimated_amount_currency

  validates :name, presence: true
  validates :estimated_amount_cents, numericality: { greater_than: 0 }

  scope :ordered, -> { order(:due_date, :name) }

  def current_month_record
    records.find_by(month: Date.current.beginning_of_month)
  end

  def last_record
    records.order(month: :desc).first
  end

  def next_estimated_amount
    last_record&.actual_amount_cents || estimated_amount_cents
  end

  def due_day
    due_date&.day
  end
end