class AddDiscountedAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :discounted_at, :datetime
  end
end
