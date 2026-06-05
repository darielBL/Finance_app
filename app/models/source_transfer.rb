class SourceTransfer < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :from_source, presence: true
  validates :to_source, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :transferred_at, presence: true
  validate :sources_must_differ

  scope :ordered, -> { order(transferred_at: :desc, created_at: :desc) }
  scope :for_date_range, ->(range) { where(transferred_at: range) }
  scope :by_currency, ->(currency) { where(amount_currency: currency) }

  private

  def sources_must_differ
    if from_source.present? && to_source.present? && from_source == to_source
      errors.add(:to_source, "debe ser diferente al origen")
    end
  end
end
