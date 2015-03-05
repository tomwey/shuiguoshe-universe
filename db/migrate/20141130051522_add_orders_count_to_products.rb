class AddOrdersCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :orders_count, :integer, default: 0
  end
end
