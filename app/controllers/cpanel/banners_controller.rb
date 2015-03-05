class Cpanel::BannersController < Cpanel::ApplicationController
  before_action :check_destroy_authorize, except: [:destroy]
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  def index
    @banners = Banner.sorted
  end

  def new
    @banner = Banner.new
  end

  def edit
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      # flash[:success] = "创建成功"
      redirect_to cpanel_banners_path
    else
      render :new
    end
  end

  def update
    if @banner.update(banner_params)
      # flash[:success] = "修改成功"
      redirect_to cpanel_banners_path
    else
      render :edit
    end
  end

  def destroy
    @banner.destroy
    redirect_to cpanel_banners_url
  end

  private
    def set_banner
      @banner = Banner.find(params[:id])
    end

    def banner_params
      params.require(:banner).permit(:title, :subtitle, :intro, :image, :url, :sort)
    end
    
end
