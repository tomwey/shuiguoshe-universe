class AddVerifiedAndPrivateTokenToUsers < ActiveRecord::Migration
  def change
    
    # remove_column :users, :verified
    # remove_column :users, :private_token
    
    add_column :users, :verified, :boolean, default: true
    add_column :users, :private_token, :string
    
    add_index :users, :private_token, unique: true
  end
end
