class ApartmentsController < ApplicationController
  respond_to :html, :json
  def index
    @apartments = Apartment.opened.paginate page: params[:page], per_page: 30
    # @hot_apartments = Apartment.hot.limit(10)
    set_seo_meta('服务小区', @apartments.map(&:name).join('、'), "水果社SHUIGUOSHE.COM专注于各种当季水果、干果的预订配送服务，保证质优价廉，目前我们开通的小区有如下：“#{@apartments.map(&:name).join('、')}”")
    fresh_when(etag: @apartments)
  end
end
