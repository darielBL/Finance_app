class NotificationCheckJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      check_pending_incomes(user)
      check_pending_expenses(user)
      resolve_outdated_notifications(user)
    end
  end

  private

  def check_pending_incomes(user)
    user.incomes.recurring.active.find_each do |income|
      next unless income.due_day
      next if income.current_month_record&.actual_amount_cents?

      due_date = due_date_for_month(income.due_day)
      next if Date.current < due_date

      create_notification(
        user: user,
        notifiable: income,
        notification_type: "pending",
        title: "Ingreso pendiente: #{income.name}",
        message: "El ingreso recurrente «#{income.name}» de #{humanized_money(income.amount)} venc\u00eda el d\u00eda #{income.due_day} y a\u00fan no lo has registrado."
      )
    end
  end

  def check_pending_expenses(user)
    user.expenses.recurring.find_each do |expense|
      next unless expense.due_day
      next if expense.current_month_record&.actual_amount_cents?

      due_date = due_date_for_month(expense.due_day)
      next if Date.current < due_date

      create_notification(
        user: user,
        notifiable: expense,
        notification_type: "pending",
        title: "Gasto pendiente: #{expense.name}",
        message: "El gasto recurrente \u00ab#{expense.name}\u00bb de #{humanized_money(expense.amount)} venc\u00eda el d\u00eda #{expense.due_day} y a\u00fan no lo has registrado."
      )
    end
  end

  def resolve_outdated_notifications(user)
    user.notifications.unread.find_each do |notification|
      next unless notification.notifiable

      case notification.notifiable
      when Income
        if notification.notifiable.current_month_record&.actual_amount_cents?
          notification.update(read: true)
        end
      when Expense
        if notification.notifiable.current_month_record&.actual_amount_cents?
          notification.update(read: true)
        end
      end
    end
  end

  def create_notification(user:, notifiable:, notification_type:, title:, message:)
    return if user.notifications.unread.exists?(
      notifiable: notifiable,
      notification_type: notification_type
    )

    user.notifications.create(
      notifiable: notifiable,
      notification_type: notification_type,
      title: title,
      message: message
    )
  end

  def due_date_for_month(day)
    today = Date.current
    last_day = today.end_of_month.day
    Date.new(today.year, today.month, [day, last_day].min)
  end

  def humanized_money(amount)
    "#{amount.amount} #{amount.amount_currency}"
  end
end
