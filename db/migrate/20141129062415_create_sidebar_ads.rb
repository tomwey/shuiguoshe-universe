class CreateSidebarAds < ActiveRecord::Migration
  def change
    create_table :sidebar_ads do |t|
      t.string :image
      t.string :url
      t.string :summary

      t.timestamps
    end
  end
end
