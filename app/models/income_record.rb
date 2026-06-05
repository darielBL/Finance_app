class IncomeRecord < ApplicationRecord
  include MoneyNormalizable

  belongs_to :income

  monetize :actual_amount_cents, with_model_currency: :actual_amount_currency

  validates :month, presence: true
  validates :received_date, presence: true
  validate :month_not_in_future
  validate :received_date_not_in_future

  before_save :set_currency_from_parent, if: -> { actual_amount_currency.blank? }
  after_save :update_next_month_estimate
  after_save :resolve_notifications, if: -> { saved_change_to_actual_amount_cents? }

  scope :for_month, ->(date) { where(month: date.beginning_of_month) }

  def difference_cents
    return nil unless actual_amount_cents
    actual_amount_cents - income.amount_cents
  end

  def difference_percentage
    return nil unless actual_amount_cents
    return 0 if income.amount_cents == 0
    (difference_cents.to_f / income.amount_cents * 100).round(1)
  end

  private

  def month_not_in_future
    if month.present? && month > Date.current.beginning_of_month
      errors.add(:month, "no puede ser un mes futuro")
    end
  end

  def set_currency_from_parent
    self.actual_amount_currency = income.amount_currency
  end

  def update_next_month_estimate
    return unless actual_amount_cents

    next_month = month.next_month
    next_record = income.records.find_or_initialize_by(month: next_month)
    next_record.actual_amount_currency = actual_amount_currency
    next_record.save if next_record.changed?

    income.update(amount_cents: actual_amount_cents, amount_currency: actual_amount_currency)
  end

  def resolve_notifications
    income.notifications.where(notification_type: "pending", read: false).update_all(read: true)
  end

  def received_date_not_in_future
    if received_date.present? && received_date > Date.current
      errors.add(:received_date, "no puede ser una fecha futura")
    end
  end
end
