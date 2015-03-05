class AddBackgroundColorAndLogoToSales < ActiveRecord::Migration
  def change
    add_column :sales, :background_color, :string
    add_column :sales, :logo, :string
  end
end
