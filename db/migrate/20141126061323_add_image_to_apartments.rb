class AddImageToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :image, :string
  end
end
