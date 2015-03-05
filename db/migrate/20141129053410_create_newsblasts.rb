class CreateNewsblasts < ActiveRecord::Migration
  def change
    create_table :newsblasts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
