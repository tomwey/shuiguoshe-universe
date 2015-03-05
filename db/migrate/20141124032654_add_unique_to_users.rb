class AddUniqueToUsers < ActiveRecord::Migration
  def change
    add_index :users, :mobile, :unique => true
  end
end
