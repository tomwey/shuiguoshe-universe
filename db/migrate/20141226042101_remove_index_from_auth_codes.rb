class RemoveIndexFromAuthCodes < ActiveRecord::Migration
  def change
    remove_index :auth_codes, :code
    add_index :auth_codes, :code
    # add_index :auth_codes, :mobile
  end
end
