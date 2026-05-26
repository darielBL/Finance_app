class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, foreign_key: :user_id, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :investments, dependent: :destroy

  has_many :income_records, through: :incomes, source: :records
  has_many :expense_records, through: :expenses, source: :records
end
