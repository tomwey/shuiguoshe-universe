class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart, inverse_of: :line_items,  touch: true
  belongs_to :order
  
  def total_price
    product.low_price * quantity
  end
  
  def update_sales_count(oper)
    if oper == 1
      product.orders_count += self.quantity
    elsif oper == -1
      product.orders_count -= self.quantity
    end
    product.save
  end
  
  def product_updated_at
    if product
      product.updated_at.strftime("%Y%m%d%H%M%S")
    else
      ""
    end
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      pid: product.id,  # 产品id
      title: product.title || "", # 产品标题
      icon_url: product_image_url,#product.image.url(:small), # 产品icon
      quantity: self.quantity, # 购买数量
      visible: self.visible,
      price: format("%.2f", product.low_price), # 我的价格
      total_price: format("%.2f", total_price)
    }
  end
  
  def product_image_url
    if self.product.blank?
      ""
    else
      if self.product.image.blank?
        ""
      else
        self.product.image.url(:thumb) || ""
      end
    end
  end
  
end

# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  product_id :integer
#  cart_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  quantity   :integer          default(1)
#  order_id   :integer
#
