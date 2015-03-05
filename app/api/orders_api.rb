module Shuiguoshe
  class OrdersAPI < Grape::API
    
    resource :user do
      # 1.获取所有未完成订单
      params do
        requires :token, type: String, desc: "token"
      end
      get '/orders/incompleted' do
        user = authenticate!
        @orders = user.orders.normal.order("created_at DESC")
        if @orders.empty?
          return { code: 404, message: "没有记录" }
        end
        
        { code: 0, message: "ok", data: @orders }
        
      end
      
      # 2.获取所有的订单
      params do
        requires :token, type: String, desc: "token"
        requires :filter, type: String, desc: "选择类型"
        optional :page, type: Integer, desc: "页码"
      end
      get '/orders' do
        user = authenticate!
        @orders = user.orders.order("id desc")#.paginate page: params[:page], per_page: page_size
        
        unless %w[all completed canceled delivering].include?(params[:filter])
          return { code: -1, message: "不正确的参数#{params[:filter]}" }
        end
        
        sym = params[:filter]
        if sym == 'delivering'
          sym = 'normal'
        end
        
        @orders = @orders.send(sym)
        
        page = params[:page].to_i < 1 ? 1 : params[:page].to_i
        @orders = @orders.paginate page: page, per_page: page_size
        { code: 0, message: "ok", data: { total_pages: @orders.total_pages, total_records: @orders.total_entries, items: @orders } }
        
      end # end all
      
      # 3.获取订单详情
      params do
        requires :token, type: String, desc: "token"
      end
      get '/orders/order-:id' do
        user = authenticate!
        @order = user.orders.includes(:line_items).where(id: params[:id]).first
        if @order.blank?
          return { code: 404, message: "没有记录" }
        end
        
        { code: 0, message: "ok", 
          data: {
            order_no: @order.order_no,
            state: @order.state,
            mobile: @order.mobile || "",
            apartment: @order.apartment_name,
            total_price: format("%.2f", @order.total_price),
            discount_price: format("%.2f", @order.discount_price),
            items: @order.line_items
          }
        }
        
      end # end detail
      
      # 4.下订单
      params do
        requires :token, type: String, desc: "Token"
        requires :order_info, type: Hash, desc: "订单信息" # { deliver_info_id: 1, note: '', total_price: 0.0, discount_price: 0.0 } 
        requires :score, type: Integer, desc: "用户抵扣积分"
      end
      post '/orders' do
        @cart = current_cart
        if @cart.line_items_count == 0
          return { code: 404, message: "购物车是空的" }
        end
        
        user = authenticate!
        
        deliver_info_id = params[:deliver_info_id]
        params[:order_info].delete(:deliver_info_id)
        
        @order = Order.new
        @order.note = params[:order_info][:note]
        @order.total_price = params[:order_info][:total_price]
        @order.discount_price = params[:order_info][:discount_price]
        @order.user_id = user.id
        @order.add_line_items_from_cart(@cart)
        
        if @order.save(validate: false)
          # 清空购物车
          Cart.find_by(user_id: user.id).destroy
          score = params[:score].to_i
          
          user.update_score(-score, '提交订单') if score > 0
          # @product.add_order_count
          # @apartment = Apartment.find_by_id(@order.apartment_id)
          # @apartment.add_order_count if @apartment

          @order.update_orders_count
      
          { code: 0, message: "ok",
             data:     {
                 id: @order.id,
                 order_no: @order.order_no || "",
                 state: @order.state || "",
                 ordered_at: @order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                 total_price: format("%.2f", @order.total_price),
                 delivered_at: @order.deliver_info,
               }
           }
        else
          { code: 115, message: @order.errors.full_messages.join(",") }
        end
      end # end 4
      
      # 5.取消订单
      params do
        requires :token, type: String, desc: "Token"
      end
      post '/orders/:id/cancel' do
        user = authenticate!
        order = Order.where('user_id = ? and id = ?', user.id, params[:id].to_i).first
        if order.blank?
          return { code: 404, message: "没找到订单" }
        end
        order.state = "canceled"
        if order.save(validate:false)
          { code: 0, message: "ok" }
        else
          { code: -1, message: "取消订单失败" }
        end
      end
      
    end # end user resource
    
  end
end