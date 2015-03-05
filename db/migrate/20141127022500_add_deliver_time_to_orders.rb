class AddDeliverTimeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deliver_time, :string
  end
end
