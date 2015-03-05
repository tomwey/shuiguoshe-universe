class Cpanel::SiteConfigsController < Cpanel::ApplicationController
  before_action :check_is_super_manager, only: [:index]
  before_action :set_site_config, only: [:show, :edit, :update, :destroy]
  
  respond_to :html

  def index
    @site_configs = SiteConfig.all
    respond_with(@site_configs)
  end

  def new
    @site_config = SiteConfig.new
    respond_with(@site_config)
  end

  def edit
  end

  def create
    @site_config = SiteConfig.new(site_config_params)
    @site_config.save
    redirect_to cpanel_site_configs_path
  end

  def update
    @site_config.update(site_config_params)
    redirect_to cpanel_site_configs_path
  end

  def destroy
    @site_config.destroy
    redirect_to cpanel_site_configs_url
  end

  private
    def set_site_config
      @site_config = SiteConfig.find(params[:id])
    end

    def site_config_params
      params.require(:site_config).permit(:key, :value, :description)
    end
    
end
