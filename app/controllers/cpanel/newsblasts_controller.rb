class Cpanel::NewsblastsController < Cpanel::ApplicationController
  before_action :check_destroy_authorize, except: [:destroy]
  before_action :set_newsblast, only: [:show, :edit, :update, :destroy]
  
  def index
    @newsblasts = Newsblast.sorted
  end

  def show
    
  end

  def new
    @newsblast = Newsblast.new
  end

  def edit
  end

  def create
    @newsblast = Newsblast.new(newsblast_params)
    if @newsblast.save
      redirect_to cpanel_newsblasts_path
    else
      render :new
    end
  end

  def update
    if @newsblast.update(newsblast_params)
      redirect_to cpanel_newsblasts_path
    else
      render :edit
    end
  end

  def destroy
    @newsblast.destroy
    redirect_to cpanel_newsblasts_url
  end

  private
    def set_newsblast
      @newsblast = Newsblast.find(params[:id])
    end

    def newsblast_params
      params.require(:newsblast).permit(:title, :body, :sort)
    end
end
