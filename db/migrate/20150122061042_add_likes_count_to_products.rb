class AddLikesCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :likes_count, :integer, default: 0
  end
end
