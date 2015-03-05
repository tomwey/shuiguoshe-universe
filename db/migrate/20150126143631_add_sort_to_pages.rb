class AddSortToPages < ActiveRecord::Migration
  def change
    add_column :pages, :sort, :integer, default: 0
    add_index :pages, :sort
    remove_column :pages, :body_html
  end
end
