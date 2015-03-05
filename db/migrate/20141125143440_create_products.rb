class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :type_id
      t.string :title
      t.string :intro
      t.string :image
      t.decimal :low_price, precision: 8, scale: 2, default: 0.01
      t.decimal :origin_price, precision: 8, scale: 2, default: 0.01

      t.timestamps
    end
    add_index :products, :type_id
  end
end
