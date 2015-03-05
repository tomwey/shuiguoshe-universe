class AddApartmentIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :apartment_id, :integer
    add_index :orders, :apartment_id
  end
end
