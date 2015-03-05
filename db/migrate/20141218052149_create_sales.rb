class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :title
      t.string :cover_image
      t.string :ad_image

      t.timestamps
    end
  end
end
