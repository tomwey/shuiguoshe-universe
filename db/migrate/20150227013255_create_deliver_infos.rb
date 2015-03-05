class CreateDeliverInfos < ActiveRecord::Migration
  def change
    create_table :deliver_infos do |t|
      t.string :mobile
      t.integer :user_id
      t.text :address

      t.timestamps
    end
    add_index :deliver_infos, :user_id
  end
end
