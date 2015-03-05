class AddIsOpenToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :is_open, :boolean, default: false
  end
end
