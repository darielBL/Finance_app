class Income < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user
  has_many :expenses, foreign_key: :income_source_id, dependent: :nullify
  has_many :expense_records, foreign_key: :income_source_id, dependent: :nullify
  has_many :records, class_name: "IncomeRecord", dependent: :destroy

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :name, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :source, presence: true
  validates :due_day, inclusion: { in: 1..31, allow_nil: true }

  scope :active, -> { where(active: true) }
  scope :unique, -> { where(recurring: false) }
  scope :recurring, -> { where(recurring: true) }
  scope :ordered, -> { order(:due_day, :name) }

  attribute :active, :boolean, default: true

  def unique?
    !recurring?
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
end
