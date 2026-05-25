class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  layout :layout_by_resource

  private

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
