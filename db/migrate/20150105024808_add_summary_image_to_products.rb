class AddSummaryImageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :summary_image, :string
  end
end
