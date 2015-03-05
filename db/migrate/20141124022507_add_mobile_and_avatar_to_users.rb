class AddMobileAndAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile, :string
    add_column :users, :avatar, :string
  end
end
