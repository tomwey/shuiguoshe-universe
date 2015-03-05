class Cart < ActiveRecord::Base
  has_many :line_items, -> { includes(:product) }, dependent: :destroy
  
  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product: product)
    end
    current_item
  end
  
  def add_cart(other_cart)
    if other_cart and other_cart.line_items.any?
      total_item = 0
      other_cart.line_items.each do |item|
        current_item = line_items.find_by(product_id: item.product.id)
        if current_item
          current_item.quantity += item.quantity
        else
          current_item = line_items.build(product_id: item.product.id, quantity: item.quantity)
        end
        current_item.save
        total_item += item.quantity
      end
      self.update_attribute('line_items_count', self.line_items_count + total_item)
    end
    return true
  end
  
  def total_price
    line_items.where(visible: true).to_a.sum { |item| item.total_price }  
  end
  
  def update_items_count(counter)
    self.update_attribute('line_items_count', counter.to_i + self.line_items_count)
  end
  
  def my_cache_key
    line_items.map { |a| "#{a.id}-#{a.quantity}-#{a.product_updated_at}" }
  end
  
end

# == Schema Information
#
# Table name: carts
#
#  id               :integer          not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  line_items_count :integer          default(0)
#
