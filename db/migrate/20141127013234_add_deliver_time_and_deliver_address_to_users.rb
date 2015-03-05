class AddDeliverTimeAndDeliverAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deliver_time, :string, default: ""
    add_column :users, :deliver_address, :string, default: ""
  end
end
