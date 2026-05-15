class Investment < ApplicationRecord
  include MoneyNormalizable

  belongs_to :user

  monetize :amount_cents, with_model_currency: :amount_currency

  validates :name, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :invested_at, presence: true
  validate :invested_at_not_in_future

  scope :ordered, -> { order(invested_at: :desc, created_at: :desc) }

  def formatted_date
    invested_at.strftime("%d/%m/%Y")
  end

  private

  def invested_at_not_in_future
    if invested_at.present? && invested_at > Date.current
      errors.add(:invested_at, "no puede ser una fecha futura")
    end
  end
end