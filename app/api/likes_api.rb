module Shuiguoshe
  class LikesAPI < Grape::API
    resource :likes do
      
      params do
        requires :token, type: String
        requires :id, type: Integer
        requires :type, type: String
      end
      post '/' do
        user = authenticate!
        
        klass = eval(params[:type])
        @item = klass.find_by_id(params[:id])
        if @item.blank?
          return { code: 404, message: "没有该记录" }
        end
        
        if user.like(@item)
          { code: 0, message: "ok" }
        else
          { code: -1, message: "收藏失败" }
        end
        
      end
      
      params do
        requires :token, type: String
        requires :type, type: String
        requires :id, type: Integer
      end
      post '/:id' do
        user = authenticate!
        
        klass = eval(params[:type])
        @item = klass.find_by_id(params[:id])
        if @item.blank?
          return { code: 404, message: "没有该记录" }
        end
        
        if user.unlike(@item)
          { code: 0, message: "ok" }
        else
          { code: -1, message: "收藏失败" }
        end
        
      end
      
    end
    
  end
end