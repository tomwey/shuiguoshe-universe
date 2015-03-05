class AddSuggestedAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :suggested_at, :datetime
    add_index :products, :suggested_at
  end
end
