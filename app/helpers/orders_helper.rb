module OrdersHelper
  
  def render_orders_total_price(orders)
    return 0.0 if orders.blank?
    return 0.0 if orders.empty?
    
    sum = 0
    orders.each do |order|
      sum += order.total_price
    end
    
    sum
    
  end
  
  def render_order_state(order, size = 14)
    return "" if order.blank?
    
    if order.normal?
      content_tag :span, "待配送", class: "label label-default", style: "font-size: #{size}px;"
    elsif order.prepare_delivering?
      content_tag :span, "配送准备", class: "label label-warning", style: "font-size: #{size}px;"
    elsif order.delivering?
      content_tag :span, "配送中", class: "label label-info", style: "font-size: #{size}px;"
    elsif order.canceled?
      content_tag :span, "已取消", class: "label label-danger", style: "font-size: #{size}px;"
    elsif order.completed?
      content_tag :span, "已完成", class: "label label-success", style: "font-size: #{size}px;"
    end
  end
  
  def render_order_address(order)
    return "" if order.blank?
    return "" if order.apartment.blank?
    if order.apartment.name == '其他'
      if order.user && order.user.deliver_address.present?
        return "#{order.apartment.name}（#{order.user.deliver_address}）"
      end
      return "#{order.apartment.name}（#{order.note}）"
    end
    
    "#{order.apartment.name}（#{order.apartment.address}）"
  end
  
  def can_cancel?(order)
    return false if order.blank?
    
    ( order.can_cancel? and order.state?(:normal) )
  end
  
  def can_complete?(order)
    return false if order.blank?
    ( order.can_complete? and order.state?(:delivering) )
  end
  
  def order_total_price(cart)
    return 0 if cart.total_price == 0
    cart.total_price - ( user_discount_score(cart.total_price) / 100.0 )
  end
  
  def order_breadcrumb_tag(order)
    return '' if order.blank?
    return %(<a href="#{orders_user_path}">所有订单</a> &gt;).html_safe if params[:tab] == 'all'
    
    if %w(prepare_delivering delivering normal).include?(order.state)
      %(<a href="#{incompleted_orders_user_path}">未完成</a> &gt; ).html_safe
    elsif order.state?(:completed)
      %(<a href="#{completed_orders_user_path}">已完成</a> &gt; ).html_safe
    elsif order.state?(:canceled)
      %(<a href="#{canceled_orders_user_path}">已取消</a> &gt; ).html_safe
    else
      ''
    end
  end
  
end
