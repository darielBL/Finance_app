class ExchangeRate < ApplicationRecord
  validates :date, presence: true, uniqueness: true

  scope :ordered, -> { order(date: :desc) }
  scope :since, ->(date) { where("date >= ?", date) }
end
