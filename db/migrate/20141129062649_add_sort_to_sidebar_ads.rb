class AddSortToSidebarAds < ActiveRecord::Migration
  def change
    add_column :sidebar_ads, :sort, :integer, default: 0
  end
end
