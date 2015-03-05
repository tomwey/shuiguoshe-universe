class AddUnitsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :units, :string
    add_column :products, :note, :string
    change_column :products, :low_price, :integer, default: 0
    change_column :products, :origin_price, :integer, default: 0
  end
end
