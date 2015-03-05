class AddLineItemsCountToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :line_items_count, :integer, default: 0
  end
end
