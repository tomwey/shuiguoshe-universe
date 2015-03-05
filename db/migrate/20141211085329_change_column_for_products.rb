class ChangeColumnForProducts < ActiveRecord::Migration
  def change
    change_column :products, :low_price, :decimal, precision: 8, scale: 2
    change_column :products, :origin_price, :decimal, precision: 8, scale: 2
  end
end
