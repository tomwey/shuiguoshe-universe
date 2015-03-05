# coding: utf-8
class OrdersController < ApplicationController
  before_filter :require_user
  before_filter :check_user
  before_action :set_order, only: [:show]
  
  layout 'user_layout', only: [:search, :incompleted, :completed, :canceled, :cancel, :show]

  respond_to :html
  
  def search
    @orders = current_user.orders.search(params[:q]).includes(:product).order("orders.created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders'
    if params[:q].gsub(/\s+/, "").present?
      @cache_prefix = "user_#{current_user.mobile}-orders-search_#{params[:q].gsub(/\s+/, "")}"
    else
      @cache_prefix = "user_#{current_user.mobile}-#{@current}"
    end
    render :index
  end
  
  def show
    @current = 'user_show_order_detail'
    set_seo_meta("订单详情")
  end
  
  def incompleted
    @orders = current_user.orders.normal.order("created_at DESC").paginate page: params[:page], per_page: 30
    @current = 'user_orders_incompleted'
    @cache_prefix = "user_#{current_user.mobile}-#{@current}"
    set_seo_meta("我的待配送订单")
    @mobile_title = "待配送订单"
    render :index
    # fresh_when(etag: [@orders, @current])
  end
  
  def completed
    @orders = current_user.orders.completed.order("created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders_completed'
    @cache_prefix = "user_#{current_user.mobile}-#{@current}"
    set_seo_meta("我的已完成订单")
    @mobile_title = "已完成订单"
    render :index
    # fresh_when(etag: [@orders, @current])
  end
  
  def canceled
    @orders = current_user.orders.canceled.order("created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders_canceled'
    
    @cache_prefix = "user_#{current_user.mobile}-#{@current}"
    set_seo_meta("我的已取消订单")
    @mobile_title = "已取消订单"
    render :index
    # fresh_when(etag: [@orders, @current])
  end
  
  def cancel
    @incompleted_orders_count = current_user.orders.normal.count

    @order = current_user.orders.find(params[:id])
    @incompleted = params[:current] == 'user_orders_incompleted'
    
    @status = 1
    if @order.state?(:normal)
      if @order.cancel
        @status = 1
        
        # 当用户取消订单的时候，更新销售数据
        @apartment = Apartment.find_by_id(@order.apartment_id)
        if @apartment
          @apartment.orders_count -= 1
          @apartment.save
        end
        @order.update_orders_count(-1)
        
      else
        @status = 0
      end
    else
      puts "非法操作"
      @status = -1
    end
    
  end
  
  def new
    @cart = current_cart
    puts '123'
    if @cart.line_items_count == 0
      flash[:notice] = "购物车是空的"
      redirect_to root_url
      return 
    end
    
    @order = Order.new
    @deliver_info = DeliverInfo.where('user_id = ? and id = ?', current_user.id, current_user.current_deliver_info_id).first
    if @deliver_info.present?
      @order.mobile = @deliver_info.mobile
      @order.apartment_id = @deliver_info.apartment_id
    else
      @order.mobile = current_user.mobile
    end
    
    # @apartments = Apartment.opened.map { |a| ["#{a.name}（#{a.address}）", a.id] }
    set_seo_meta("提交订单")    
    # respond_with(@order)
  end

  def create
    
    @cart = current_cart
    if @cart.line_items_count == 0
      redirect_to checkout_path
      return
    end
    
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    @order.add_line_items_from_cart(@cart)
    
    @deliver_info = DeliverInfo.new
    @deliver_info.mobile = @order.mobile
    @deliver_info.apartment_id = @order.apartment_id
    
    if @order.save
      # 清空购物车
      Cart.find_by(user_id: current_user.id).destroy
      
      score = params[:user_score].to_i
      current_user.update_score(-score, '提交订单') if score > 0
      # @product.add_order_count
      @apartment = Apartment.find_by_id(@order.apartment_id)
      @apartment.add_order_count if @apartment

      @order.update_orders_count
      
      # current_user.update_attribute(:apartment_id, @apartment.id)
      # current_user.apartment_id = @apartment.id if @apartment
      # if @apartment && @apartment.name == '其他'
      #   current_user.deliver_address = @order.note if @order.note.present?
      # end
      info = DeliverInfo.where(user_id: current_user.id, mobile: @order.mobile, apartment_id: @order.apartment_id).first_or_create
      current_user.current_deliver_info_id = info.id
      current_user.save!
      
      flash[:success] = "下单成功"
      redirect_to incompleted_orders_user_path
    else
      render action: :new
    end
    
  end

  # def update
  #   @order.update(order_params)
  #   respond_with(@order)
  # end
  # 
  # def destroy
  #   @order.destroy
  #   respond_with(@order)
  # end

  private
    def set_order
      @order = current_user.orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("无效的订单ID:#{params[:id]}")
      render_404
    end

    def order_params
      params.require(:order).permit(:mobile, :apartment_id, :total_price, :discount_price, :note, :state)
    end
end
