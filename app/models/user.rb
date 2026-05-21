class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, foreign_key: :user_id, dependent: :destroy
  has_many :income_sources, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :investments, dependent: :destroy
  has_many :recurring_expenses, dependent: :destroy
  has_many :recurring_incomes, dependent: :destroy

  # Relaciones a través de los modelos padres
  has_many :recurring_expense_records, through: :recurring_expenses, source: :records
  has_many :recurring_income_records, through: :recurring_incomes, source: :records
end