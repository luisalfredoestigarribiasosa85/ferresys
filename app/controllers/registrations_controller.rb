class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    @account = Account.new
    @user = User.new
  end

  def create
    @account = Account.new(name: registration_params[:account_name])
    @user = @account.users.build(
      registration_params.slice(:name, :email, :password, :password_confirmation).merge(role: :owner)
    )

    if @account.save
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Cuenta creada. ¡Bienvenido/a a Ferresys!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:account_name, :name, :email, :password, :password_confirmation)
  end
end