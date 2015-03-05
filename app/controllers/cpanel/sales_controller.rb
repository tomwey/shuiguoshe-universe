# coding: utf-8
class Cpanel::SalesController < Cpanel::ApplicationController
  before_action :check_is_super_manager
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :open, :close]

  def index
    @sales = Sale.order('created_at desc').paginate page: params[:page], per_page: 20
  end

  def show
    
  end

  def new
    @sale = Sale.new
  end

  def edit
  end

  def create
    @sale = Sale.new(sale_params)
    if @sale.save
      flash[:notice] = "创建成功"
      redirect_to cpanel_sales_path
    else
      render :new
    end
  end

  def update
    if @sale.update(sale_params)
      flash[:notice] = "修改成功"
      redirect_to cpanel_sales_path
    else
      render :edit
    end
  end

  def destroy
    @sale.destroy
    redirect_to cpanel_sales_url
  end

  private
    def set_sale
      @sale = Sale.find(params[:id])
    end

    def sale_params
      params.require(:sale).permit(:title, :subtitle, :cover_image, :cover_image_cache, :ad_image, :ad_image_cache, :logo, :logo_cache, :closed_at, :background_color)
    end
end
