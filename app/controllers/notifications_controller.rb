class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.recent
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    @notification.update(read: true)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path, notice: "Notificaci\u00f3n marcada como le\u00edda." }
    end
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read: true)
    redirect_to notifications_path, notice: "Todas las notificaciones fueron marcadas como le\u00eddas."
  end
end
