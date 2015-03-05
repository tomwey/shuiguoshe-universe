class Cpanel::SidebarAdsController < Cpanel::ApplicationController
  before_action :check_destroy_authorize, except: [:destroy]
  before_action :set_sidebar_ad, only: [:show, :edit, :update, :destroy]

  def index
    @sidebar_ads = SidebarAd.sorted
  end

  def show
  end

  def new
    @sidebar_ad = SidebarAd.new
  end

  def edit
  end

  def create
    @sidebar_ad = SidebarAd.new(sidebar_ad_params)
    if @sidebar_ad.save
      redirect_to cpanel_sidebar_ads_path
    else
      render :new
    end
  end

  def update
    if @sidebar_ad.update(sidebar_ad_params)
      redirect_to cpanel_sidebar_ads_path
    else
      render :edit
    end
  end

  def destroy
    @sidebar_ad.destroy
    redirect_to cpanel_sidebar_ads_url
  end

  private
    def set_sidebar_ad
      @sidebar_ad = SidebarAd.find(params[:id])
    end

    def sidebar_ad_params
      params.require(:sidebar_ad).permit(:image, :url, :summary, :sort)
    end
end
