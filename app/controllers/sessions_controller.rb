class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: session_params[:email].to_s.strip.downcase)
    if user&.authenticate(session_params[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, notice: "Bienvenido/a, #{user.name}"
    else
      flash.now[:alert] = "Email o contraseña incorrectos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: "Tu sesión se cerró"
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end