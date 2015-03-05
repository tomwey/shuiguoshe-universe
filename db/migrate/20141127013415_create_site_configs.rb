class CreateSiteConfigs < ActiveRecord::Migration
  def change
    create_table :site_configs do |t|
      t.string :key
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
