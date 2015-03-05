class Cpanel::PagesController < Cpanel::ApplicationController
  before_action :check_destroy_authorize, except: [:destroy]
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  
  def index
    @pages = Page.recent.paginate page: params[:page], per_page: 20
  end

  def show
    
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to cpanel_pages_path
    else
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to cpanel_pages_path
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to cpanel_pages_url
  end

  private
    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :body, :slug, :body_html)
    end
end
