class AddSortToNewsblasts < ActiveRecord::Migration
  def change
    add_column :newsblasts, :sort, :integer, default: 0
  end
end
