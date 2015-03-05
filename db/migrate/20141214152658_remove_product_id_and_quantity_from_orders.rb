class RemoveProductIdAndQuantityFromOrders < ActiveRecord::Migration
  def change
    remove_index :orders, :product_id
    remove_column :orders, :product_id
    remove_column :orders, :quantity
    remove_column :orders, :deliver_address
    add_column :orders, :mobile, :string
  end
end
