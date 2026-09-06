class AddTicketFooterToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :accounts, :ticket_footer, :text
  end
end