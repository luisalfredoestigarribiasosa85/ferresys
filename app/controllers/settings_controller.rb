class SettingsController < ApplicationController
  before_action :require_owner

  def edit
    @account = current_account
  end

  def update
    @account = current_account
    if @account.update(settings_params)
      redirect_to edit_settings_path, notice: "Configuración guardada"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:account).permit(:name, :address, :phone, :ticket_footer)
  end
end