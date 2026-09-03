module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_request_attributes
    helper_method :current_user, :current_account, :logged_in?
  end

  def current_user
    Current.user
  end

  def current_account
    Current.account
  end

  def logged_in?
    Current.user.present?
  end

  def require_login
    return if logged_in?

    redirect_to new_session_path, alert: "Iniciá sesión para continuar"
  end

  def require_owner
    return if current_user&.owner?

    redirect_to root_path, alert: "Esta acción requiere permisos de administrador"
  end

  private

  def set_current_request_attributes
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end