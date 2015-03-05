class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @line_items = LineItem.all
    
  end

  def show
    
  end

  def new
    @line_item = LineItem.new
    
  end

  def edit
  end

  def create
    
    @product = Product.find(params[:product_id])
    if @product.stock_count <= 0
      return false
    end
    
    if @product.is_discount and @product.discounted_at and @product.discounted_at < Time.zone.now
      return false
    end
    
    @cart = current_cart
    @line_item = @cart.add_product(@product)

    @result_dom_id = "result-#{@product.id}"
    @item_id = "item-#{@product.id}"
    @product_id = "product-#{@product.id}"
    
    @success = false
    if @line_item.save
      @success = true
      @cart.update_items_count(1)
      # render text: "1"
    else
      # render text: "-1"
    end
    
  end

  def update
    
    if current_user.id != @line_item.cart.user_id
      return false
    end
    
    @type = params[:type]
    @success = false
    
    if params[:type] == '-1'
      @oper_id = "reduce-#{@line_item.id}"
      if @line_item.quantity > 1
        @line_item.quantity -= 1
        if @line_item.save
          @success = true
          cart.update_items_count(-1)
        end
      end
    elsif params[:type] == '1'
      @oper_id = "increase-#{@line_item.id}"
      @line_item.quantity += 1
      if @line_item.save
        @success = true
        cart.update_items_count(1)
      end
    end
    
    @line_item_id = "line_item_#{@line_item.id}"
  end

  def destroy
    if current_user.id != @line_item.cart.user_id
      return false
    end
    
    @line_item_id = "line_item_#{@line_item.id}"
    @order_line_item_id = "order_line_item_#{@line_item.id}"
    
    @success = true
    if @line_item.destroy
      @success = true
      cart.update_items_count(- @line_item.quantity)
    else
      @success = false
    end
  end

  private
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

end
