class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  layout :layout_by_resource

  before_action :set_unread_notifications_count, if: :user_signed_in?

  private

  def set_unread_notifications_count
    @unread_notifications_count = current_user.notifications.unread.count
  end

  def unread_notifications_count
    @unread_notifications_count || current_user&.notifications&.unread&.count || 0
  end
  helper_method :unread_notifications_count

  def layout_by_resource
    if devise_controller?
      if controller_name == "registrations" && %w[edit update destroy].include?(action_name)
        "application"
      else
        "devise"
      end
    else
      "application"
    end
  end
end
