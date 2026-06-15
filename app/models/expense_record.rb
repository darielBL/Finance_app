class ExpenseRecord < ApplicationRecord
  include MoneyNormalizable

  belongs_to :expense
  belongs_to :income, foreign_key: :income_source_id

  monetize :actual_amount_cents, with_model_currency: :actual_amount_currency

  validates :month, presence: true
  validates :income, presence: true
  validate :month_not_in_future

  before_save :set_currency_from_parent, if: -> { actual_amount_currency.blank? }
  after_save :update_next_month_estimate
  after_save :resolve_notifications, if: -> { saved_change_to_actual_amount_cents? }

  private

  def resolve_notifications
    expense.notifications.where(notification_type: "pending", read: false).update_all(read: true)
  end

  def month_not_in_future
    if month.present? && month > Date.current.beginning_of_month
      errors.add(:month, "no puede ser un mes futuro")
    end
  end

  def set_currency_from_parent
    self.actual_amount_currency = expense.amount_currency
  end

  def update_next_month_estimate
    return unless actual_amount_cents

    next_month = month.next_month
    next_record = expense.records.find_or_initialize_by(month: next_month)
    next_record.actual_amount_currency = actual_amount_currency
    next_record.save if next_record.changed?

    expense.update(amount_cents: actual_amount_cents, amount_currency: actual_amount_currency)
  end
end
