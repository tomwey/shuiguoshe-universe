module Shuiguoshe
  class ProductsAPI < Grape::API
    
    # 产品类别
    resource :catalogs do
      # 获取所有卖场信息
      get '/' do
        @catalogs = ProductType.all_types
        if @catalogs.empty?
          return { code: 404, message: "数据为空" }
        end
        { code: 0, message: "ok", data: @catalogs }
      end
    end
    
    # 卖场
    resource :sales do
      # 获取所有卖场信息
      get '/' do
        @sales = Sale.recent
        if @sales.empty?
          return { code: 404, message: "数据为空" }
        end
        
        { code: 0, message:"ok", data: @sales }
      end # end get '/'
      
      # 获取卖场详细信息
      get '/:id' do
        @sale = Sale.includes(:products).find_by(id: params[:id])
        if @sale.blank?
          return { code: 404, message: "没有记录" }
        end
        
        @items = @sale.products
        # if @items.empty?
        #   return { code: 404, message: "没有记录" }
        # end
        
        { code: 0, message: "ok", 
          data: { 
            ad_image_url: @sale.ad_image_url,
            items: @items
          } 
        }
      end # end get '/:id'
      
    end # end sale
    
    resource :items do
      
      # 获取每日特惠商品
      get '/discounted' do
        @items = Product.saled.discounted
        if @items.empty?
          return { code: 404, message: "没有记录" }
        end
        { code: 0, message: "ok", data: @items }
      end # end
      
      # 获取热门订购商品
      get '/hot' do
        @items = Product.hot.saled.no_discount.order("sort ASC, id DESC").limit(6)
        if @items.empty?
          return { code: 404, message: "没有记录" }
        end
          
        { code: 0, message: "ok", data: @items }
        
      end # end hot
      
      # 根据类别获取商品
      get '/type-:id' do
        @type = ProductType.find_by(id: params[:id])
        if @type.blank?
          return { code: 404, message: "没有该类别" }
        end
    
        @products = Product.saled.where(type_id: @type.id)
        if @type.name == "限时抢购"
          @products = @products.discounted
        else
          @products = @products.no_discount
        end
    
        @products = @products.order("sort ASC, id DESC")
        
        if @products.empty?
          return { code: 404, message: "没有记录" }
        end
        
        { code: 0, message: "ok", data: @products }
      end
      
      get '/:id' do
        @product = Product.find_by(id: params[:id])
        if @product.blank?
          return { code: 404, message: "没有找到记录" }
        end
        
        { code: 0, message: "ok",
          data: {
            id: @product.id,
            title: @product.title,
            low_price: @product.low_price,
            origin_price: @product.origin_price,
            units: @product.units,
            orders_count: @product.orders_count,
            discount_score: @product.discount_score,
            large_image: @product.large_image_url,
            note: @product.note || "",
            delivered_at: @product.delivered_time,
            deliver_info: deliver_info_for(@product),
            intro_images: @product.photos,
            likes_count: @product.likes_count,
            discounted_at: @product.end_discount_time
          } 
        }
      end # end
      
    end # end resource
    
  end
end