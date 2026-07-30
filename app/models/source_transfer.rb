class SourceTransfer < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user
  belongs_to :from_account, class_name: "FinancialAccount", optional: true
  belongs_to :to_account, class_name: "FinancialAccount", optional: true
  belongs_to :goal, optional: true

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :from_source, presence: true, unless: :from_account_id?
  validates :to_source, presence: true, unless: :to_account_id?
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :transferred_at, presence: true
  validate :sources_must_differ

  before_validation :set_to_account_from_goal, on: :create
  before_validation :sync_source_strings

  scope :ordered, -> { order(transferred_at: :desc, created_at: :desc) }
  scope :for_date_range, ->(range) { where(transferred_at: range) }
  scope :by_currency, ->(currency) { where(amount_currency: currency) }

  def display_from
    from_account&.name || from_source
  end

  def display_to
    to_account&.name || to_source
  end

  private

  def set_to_account_from_goal
    if goal_id? && goal && !to_account_id?
      self.to_account = goal.target_account
    end
  end

  def sync_source_strings
    self.from_source = from_account.name if from_account_id? && from_account
    self.to_source = to_account.name if to_account_id? && to_account
  end

  def sources_must_differ
    from = from_account&.name || from_source
    to = to_account&.name || to_source
    if from.present? && to.present? && from == to
      errors.add(:base, "El origen y el destino deben ser diferentes")
    end
  end
end
