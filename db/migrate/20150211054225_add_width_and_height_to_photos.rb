class AddWidthAndHeightToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :width, :string
    add_column :photos, :height, :string
  end
end
