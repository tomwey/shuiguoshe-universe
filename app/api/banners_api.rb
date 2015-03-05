module Shuiguoshe
  class BannersAPI < Grape::API
    resource :banners do
      get '/' do
        @banners = Banner.sorted.limit(4)
        if @banners.empty? 
          return { code: 404, message: "没有记录" }
        end
        
        { code: 0, message: "ok", data: @banners }
        
      end
    end
  end
end