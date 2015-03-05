class ChangeIndexForAuthCodes < ActiveRecord::Migration
  def change
    remove_index :auth_codes, :mobile
    add_index :auth_codes, :mobile
  end
end
