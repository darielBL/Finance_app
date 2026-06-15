class Expense < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :income, foreign_key: :income_source_id

  has_many :records, class_name: "ExpenseRecord", dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :name, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :due_day, inclusion: { in: 1..31, allow_nil: true }
  validates :income, presence: true

  validates :spent_at, presence: true, if: :unique?
  validate :spent_at_not_in_future, if: :unique?

  scope :unique, -> { where(recurring: false) }
  scope :recurring, -> { where(recurring: true) }
  scope :by_month, ->(date) { unique.where(spent_at: date.beginning_of_month..date.end_of_month) }
  scope :by_currency, ->(currency) { where(amount_currency: currency) }
  scope :ordered, -> { order(spent_at: :desc, created_at: :desc) }
  scope :ordered_recurring, -> { order(:due_day, :name) }

  attribute :amount_currency, :string, default: "CUP"

  def unique?
    !recurring?
  end

  def formatted_date
    spent_at&.strftime("%d/%m/%Y")
  end

  def current_month_record
    records.find_by(month: Date.current.beginning_of_month)
  end

  def last_record
    records.order(month: :desc).first
  end

  def next_estimated_amount
    last_record&.actual_amount_cents || amount_cents
  end

  private

  def spent_at_not_in_future
    if spent_at.present? && spent_at > Date.current
      errors.add(:spent_at, "no puede ser una fecha futura")
    end
  end
end
