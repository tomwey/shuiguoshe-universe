class AddSubtitleAndClosedAtToSales < ActiveRecord::Migration
  def change
    add_column :sales, :subtitle, :string
    add_column :sales, :closed_at, :datetime
  end
end
