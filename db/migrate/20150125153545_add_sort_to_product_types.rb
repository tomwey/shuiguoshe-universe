class AddSortToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :sort, :integer, default: 0
  end
end
