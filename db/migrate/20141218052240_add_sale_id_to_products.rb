class AddSaleIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sale_id, :integer
    add_index :products, :sale_id
  end
end
