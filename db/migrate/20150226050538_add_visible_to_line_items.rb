class AddVisibleToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :visible, :boolean, default: true
  end
end
