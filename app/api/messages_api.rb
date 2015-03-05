module Shuiguoshe
  class MessagesAPI < Grape::API
    resource :messages do
      params do
        requires :token, type: String
        requires :title, type: String
        requires :body, type: String
      end
      post '/' do
        user = authenticate!
        
        Message.create!(title: params[:title], body: params[:body], user_id: user.id)
        { code: 0, message: "ok" }
      end
    end
  end
end