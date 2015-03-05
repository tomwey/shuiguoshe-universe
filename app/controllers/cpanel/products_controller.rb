# coding: utf-8
class Cpanel::ProductsController < Cpanel::ApplicationController
  before_action :check_is_site_editor, except: [:destroy, :unsuggest, :suggest, :upshelf, :downshelf]
  before_action :check_is_admin, except: [:destroy]
  # before_action :check_is_super_manager
  before_action :set_product, only: [:show, :edit, :update, :destroy, :upshelf, :downshelf, :unsuggest, :suggest]

  def index
    @products = Product.order('created_at desc').paginate page: params[:page], per_page: 30
  end

  def show
    
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "创建成功"
      redirect_to cpanel_products_path
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "修改成功"
      @type = ProductType.find_by(id: @product.type_id)
      if @type.blank?
        render_404
      else
        redirect_to [:cpanel, @type]
      end
    else
      render :edit
    end
  end
  
  def unsuggest
    @product.suggested_at = nil
    if @product.save
      render text: "1"
    else
      render text: "-1"
    end
  end
  
  def suggest
    @product.suggested_at = Time.zone.now
    if @product.save
      render text: "1"
    else
      render text: "-1"
    end
  end
  
  # 上架
  def upshelf
    @product.on_sale = true
    if @product.save
      render text: "1"
    else
      render text: "-1"
    end
  end
  
  # 下架
  def downshelf
    @product.on_sale = false
    if @product.save
      render text: "1"
    else
      render text: "-1"
    end
  end

  def destroy
    @type = ProductType.find_by(id: @product.type_id)
    @product.destroy
    if @type.blank?
      render_404
    else
      redirect_to [:cpanel, @type]
    end
    # redirect_to cpanel_products_url
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:type_id, :title, :subtitle, :intro, :discount_score, :stock_count, :delivered_at, :image, :is_discount, :units, :image_cache, :low_price, :sale_id,:summary_image, :note, :origin_price, :discounted_at,:sort, photos_attributes: [:image, :image_cache, :sort, :_destroy, :id])
    end
end
