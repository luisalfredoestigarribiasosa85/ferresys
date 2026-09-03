class UsersController < ApplicationController
  before_action :require_owner

  def index
    @users = current_account.users.order(:name)
  end

  def new
    @user = current_account.users.build
  end

  def create
    @user = current_account.users.build(user_params.merge(role: :employee))
    if @user.save
      redirect_to employees_path, notice: "Empleado agregado"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end