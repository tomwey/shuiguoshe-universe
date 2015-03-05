class AddDiscountPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :discount_price, :decimal, precision: 8, scale: 2, default: 0.00
  end
end
