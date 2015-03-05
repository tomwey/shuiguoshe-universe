class ChangeColumnForUsers < ActiveRecord::Migration
  def change
    remove_index :users, :apartment_id
    remove_column :users, :apartment_id
    add_column :users, :apartment_id, :integer
    add_index :users, :apartment_id
  end
end
