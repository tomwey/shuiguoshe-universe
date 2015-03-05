class CartsController < ApplicationController
  before_action :require_user, only: [:show]

  # respond_to :html

  def show
    # @cart = current_cart
    # @line_items = cart.line_items.includes(:product)
    fresh_when(etag: cart.my_cache_key)
    set_seo_meta('我的购物车')
    # respond_with(@cart)
  end

  def destroy
    @cart = current_cart
    @cart.destroy
    flash[:success] = "购物车现在是空的了。"
    redirect_to root_url
  end
  
end
