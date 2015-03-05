class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :sort, default: 0
      t.integer :product_id

      t.timestamps
    end
    
    add_index :photos, :product_id
  end
end
