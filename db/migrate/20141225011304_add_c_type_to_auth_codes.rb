class AddCTypeToAuthCodes < ActiveRecord::Migration
  def change
    add_column :auth_codes, :c_type, :integer
  end
end
