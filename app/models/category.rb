class Category < ApplicationRecord
  belongs_to :user, optional: true  # Categorías base no tienen user

  has_many :expenses, dependent: :nullify

  scope :base, -> { where(user_id: nil) }
  scope :active, -> { where(deleted_at: nil) }
  scope :for_user, ->(user) { where(user_id: user.id).or(where(user_id: nil)) }

  def soft_delete
    update(deleted_at: Time.current)
  end

  def active?
    deleted_at.nil?
  end
end