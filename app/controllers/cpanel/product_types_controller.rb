# coding: utf-8
class Cpanel::ProductTypesController < Cpanel::ApplicationController
  before_action :check_is_admin, except: [:destroy]
  before_action :set_product_type, only: [:show, :edit, :update, :destroy]
  # before_action :check_is_super_manager
  
  def index
    @product_types = ProductType.order('created_at desc').paginate page: params[:page], per_page: 30
  end

  def show
    @products = Product.where(type_id: params[:id]).saled.order('sort ASC, id DESC').paginate page: params[:page], per_page: 20
  end

  def new
    @product_type = ProductType.new
  end

  def edit
  end

  def create
    @product_type = ProductType.new(product_type_params)
    if @product_type.save
      flash[:notice] = "创建成功"
      redirect_to cpanel_product_types_path
    else
      render :new
    end
  end

  def update
    if @product_type.update(product_type_params)
      flash[:notice] = "修改成功"
      redirect_to cpanel_product_types_path
    else
      render :edit
    end
  end

  def destroy
    @product_type.destroy
    redirect_to cpanel_product_types_url
  end

  private
    def set_product_type
      @product_type = ProductType.find(params[:id])
    end

    def product_type_params
      params.require(:product_type).permit(:name, :sort)
    end
end
