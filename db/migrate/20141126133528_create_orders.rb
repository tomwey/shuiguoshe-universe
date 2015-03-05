class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_no
      t.integer :user_id
      t.integer :product_id
      t.decimal :quantity, precision: 8, scale: 1, default: 1.0
      t.string :apartment

      t.timestamps
    end
    add_index :orders, :order_no, unique: true
    add_index :orders, :user_id
    add_index :orders, :product_id
  end
end
