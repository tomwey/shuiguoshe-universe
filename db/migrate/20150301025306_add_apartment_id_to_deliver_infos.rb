class AddApartmentIdToDeliverInfos < ActiveRecord::Migration
  def change
    add_column :deliver_infos, :apartment_id, :integer
    add_index :deliver_infos, :apartment_id
  end
end
