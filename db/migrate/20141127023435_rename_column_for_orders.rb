class RenameColumnForOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :apartment, :deliver_address
  end
end
