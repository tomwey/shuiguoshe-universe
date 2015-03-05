class AddApartmentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apartment_id, :integer, default: 0
    add_index :users, :apartment_id
  end
end
