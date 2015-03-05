module Shuiguoshe
  class ApartmentsAPI < Grape::API
    resource :apartments do
      get '/' do
        @apartments = Apartment.opened
        if @apartments.empty?
          return { code: 404, message: "没有记录" }
        end
        
        { code: 0, message: "ok", data: @apartments }
      end # end get
    end
  end
end