module Shuiguoshe
  class HomeAPI < Grape::API
    resource :sections do
      get '/' do
        @banners = Banner.sorted
        @catalogs = ProductType.all_types
        @items = Product.hot.saled.no_discount.order("sort ASC, id DESC").limit(6)
        
        sections = []
        if @banners.any?
          sections << { name: "", identifier: "banners", data_type: "Banner", height: 120, data: @banners }
        end
        
        if @catalogs.any?
          sections << { name: "分类选购",identifier: "catalogs", data_type: "Catalog", height: (@catalogs.count + 1) / 2 * 68 + 30, data: @catalogs }
        end
        
        if @items.any?
          sections << { name: "热门订购",identifier: "hot_items", data_type: "Item", height: ( ( @items.count + 1 ) / 2 * 250 + 30 + 20), data: @items }
        end
        
        { code: 0, message: "ok", data: sections }
      end
    end
  end
end