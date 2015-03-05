# coding: utf-8
class Cpanel::OrdersController < Cpanel::ApplicationController
  before_action :check_is_admin, except: [:destroy]
  before_action :set_order, only: [:cancel, :complete, :prepare_deliver, :deliver, :show]
  
  def index
    @orders = Order.includes(:user).order('created_at DESC').paginate page: params[:page], per_page: 30
  end
  
  def show
    
  end
  
  def search
    @orders = Order.search(params[:q]).order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end
  
  def today_normal
    @orders = Order.normal.today.includes(:user).order('created_at DESC').paginate page: params[:page], per_page: 30
    
    render :index
  end
  
  def completed
    @orders = Order.completed.includes(:user).order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end
  
  def canceled
    @orders = Order.canceled.includes(:user).order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end

  def cancel
    @order.cancel
    redirect_to cpanel_orders_path
  end
  
  def prepare_deliver
    @order.prepare_deliver!
    if params[:for] == 'home'
      redirect_to cpanel_root_path
    else
      redirect_to cpanel_orders_path
    end
    
  end
  
  def deliver
    @order.deliver
    # redirect_to cpanel_orders_path
    if params[:for] == 'home'
      redirect_to cpanel_root_path
    else
      redirect_to cpanel_orders_path
    end
  end
  
  def complete
    @order.complete
    # redirect_to cpanel_orders_path
    if params[:for] == 'home'
      redirect_to cpanel_root_path
    else
      redirect_to cpanel_orders_path
    end
  end
  
  private
    def set_order
      @order = Order.find(params[:id])
    end
  
end
