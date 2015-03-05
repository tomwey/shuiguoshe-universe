class AddDiscountScoreAndDeliveredAtAndStockCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :discount_score, :integer, default: 0 # 赠送积分
    add_column :products, :delivered_at, :datetime # 配送时间
    add_column :products, :stock_count, :integer, default: 10000 # 库存
  end
end
