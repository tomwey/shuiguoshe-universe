class AddIsDiscountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_discount, :boolean, default: false
  end
end
