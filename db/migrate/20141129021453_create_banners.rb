class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title
      t.string :subtitle
      t.string :intro
      t.string :image
      t.string :url

      t.timestamps
    end
  end
end
