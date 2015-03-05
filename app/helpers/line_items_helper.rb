module LineItemsHelper
  def add_to_cart_tag(product, class_name = "btn btn-sm btn-success")
    return "" if product.blank?
    
    if product.stock_count == 0
      class_names = class_name.split(' ').delete('btn-success')
      class_names << 'btn-warning'
      html = <<-HTML
        <div class="btn-wrapper">
          <a class="#{class_names.join(' ')}" disabled>此商品已售完</a>
        </div>
      HTML
    else
      if product.is_discount
        if product.discounted_at and product.discounted_at > Time.zone.now
          html = <<-HTML
            <div class="btn-wrapper">
              <a onclick="App.addToCart(this)" data-product-id="#{product.id}" class="#{class_name}" id="item-#{product.id}" data-loading="0">加入购物车</a>
            </div>
          HTML
        else
          html = <<-HTML
            <div class="btn-wrapper">
              <a class="btn btn-sm btn-warning" disabled>活动已结束,不支持预订</a>
            </div>
          HTML
        end
      else
        html = <<-HTML
          <div class="btn-wrapper">
            <a onclick="App.addToCart(this)" data-product-id="#{product.id}" class="#{class_name}" id="item-#{product.id}" data-loading="0">加入购物车</a>
          </div>
        HTML
      end
      
    end
    
    html.html_safe
  end
  
  def render_item_quantity(item)
    return "" if item.blank?
    html = <<-HTML
      <span class="quantity-ctrl">
        <a onclick="App.reduceQuantity(this)" class="reduce #{item.quantity == 1 ? "disabled" : ""}" data-loading='0' data-id="#{item.id}" id="reduce-#{item.id}" disabled>&#65293;</a>
        <span class="quantity" id="line_item_quantity_#{item.id}" data-quantity="#{item.quantity}">#{item.quantity}</span>
        <a onclick="App.increaseQuantity(this)" class="increase" data-loading='0' data-id="#{item.id}" id="increase-#{item.id}">+</a>
      </span>
    HTML
    
    html.html_safe
  end
end
