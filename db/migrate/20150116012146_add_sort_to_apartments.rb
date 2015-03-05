class AddSortToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :sort, :integer, default: 0
  end
end
