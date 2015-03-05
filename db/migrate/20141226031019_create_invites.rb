class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :code
      t.string :invitee_mobile
      t.boolean :verified, default: true
      t.integer :user_id

      t.timestamps
    end
    add_index :invites, :code, :unique => true
    add_index :invites, :user_id
  end
end
