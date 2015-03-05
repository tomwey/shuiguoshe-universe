module CartsHelper
  def cart_tag
    html = <<-HTML
      <a href="#{show_cart_path}" class="cart-result" id="u-cart-result"><i class="green glyphicon glyphicon-shopping-cart" id="cart_icon"></i> 购物车<span class="green cart-total" id="cart_2_total_items" data-cart-total="#{cart.line_items_count}">#{cart.line_items_count}</span>件<div class="hover-mask2"></div></a>
    HTML
    html.html_safe
  end
end
