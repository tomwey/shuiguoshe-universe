class AddOrdersCountToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :orders_count, :integer, default: 0
  end
end
