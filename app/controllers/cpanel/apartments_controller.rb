# coding: utf-8
class Cpanel::ApartmentsController < Cpanel::ApplicationController
  before_action :check_is_admin, except: [:destroy]
  # before_action :check_is_super_manager
  before_action :set_apartment, only: [:show, :edit, :update, :destroy, :open, :close]

  def index
    @apartments = Apartment.order('created_at desc').paginate page: params[:page], per_page: 20
  end

  def show
    
  end

  def new
    @apartment = Apartment.new
  end

  def edit
  end

  def create
    @apartment = Apartment.new(apartment_params)
    if @apartment.save
      flash[:notice] = "创建成功"
      redirect_to cpanel_apartments_path
    else
      render :new
    end
  end
  
  def open
    @apartment.is_open = true
    if @apartment.save
      render text: "1"
    else
      render text: "-1"
    end
  end
  
  def close
    @apartment.is_open = false
    if @apartment.save
      render text: "1"
    else
      render text: "-1"
    end
  end

  def update
    if @apartment.update(apartment_params)
      flash[:notice] = "修改成功"
      redirect_to cpanel_apartments_path
    else
      render :edit
    end
  end

  def destroy
    @apartment.destroy
    redirect_to cpanel_apartments_url
  end

  private
    def set_apartment
      @apartment = Apartment.find(params[:id])
    end

    def apartment_params
      params.require(:apartment).permit(:name, :address, :image, :image_cache, :sort)
    end
end
