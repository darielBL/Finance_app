class Goal < ApplicationRecord
  include MoneyNormalizable

  GOAL_ICONS = {
    "fa-plane" => "Viaje",
    "fa-umbrella-beach" => "Vacaciones",
    "fa-home" => "Casa",
    "fa-car" => "Carro",
    "fa-gem" => "Boda/Anillo",
    "fa-graduation-cap" => "Educación",
    "fa-heartbeat" => "Salud",
    "fa-paw" => "Mascota",
    "fa-tv" => "Electrodoméstico",
    "fa-couch" => "Muebles",
    "fa-piggy-bank" => "Ahorros",
    "fa-chart-line" => "Inversión",
    "fa-shield-alt" => "Emergencia",
    "fa-birthday-cake" => "Celebración",
    "fa-mountain" => "Aventura",
    "fa-bullseye" => "Meta"
  }.freeze

  belongs_to :user
  belongs_to :target_account, class_name: "FinancialAccount", optional: true
  has_many :contributions, class_name: "GoalContribution", dependent: :destroy

  monetize :target_amount_cents, with_model_currency: :target_amount_currency

  validates :name, presence: true
  validates :target_amount_cents, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[in_progress completed cancelled] }
  validates :icon, inclusion: { in: GOAL_ICONS.keys, allow_blank: true }

  scope :in_progress, -> { where(status: "in_progress") }
  scope :completed, -> { where(status: "completed") }
  scope :cancelled, -> { where(status: "cancelled") }
  scope :ordered, -> { order(status: :asc, deadline: :asc, created_at: :desc) }

  def current_amount_cents
    contributions.sum(:amount_cents)
  end

  def current_amount
    Money.new(current_amount_cents, target_amount_currency)
  end

  def progress_percentage
    return 0 if target_amount_cents.zero?
    [(current_amount_cents.to_f / target_amount_cents * 100).round(1), 100].min
  end

  def remaining_cents
    [target_amount_cents - current_amount_cents, 0].max
  end

  def remaining_amount
    Money.new(remaining_cents, target_amount_currency)
  end

  def completed?
    status == "completed" || current_amount_cents >= target_amount_cents
  end

  def in_progress?
    status == "in_progress"
  end

  def days_remaining
    return nil unless deadline
    (deadline - Date.current).to_i
  end

  def on_track?
    return true unless deadline && target_amount_cents > 0
    return false if deadline <= Date.current

    days_total = (deadline - created_at.to_date).to_i
    days_elapsed = (Date.current - created_at.to_date).to_i
    return true if days_total.zero?

    expected_progress = (days_elapsed.to_f / days_total * 100)
    progress_percentage >= expected_progress
  end
end
