class AddCurrentDeliverInfoIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_deliver_info_id, :integer
  end
end
