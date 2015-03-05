# coding: utf-8
class UsersController < ApplicationController
  before_action :require_user
  before_action :check_user
  layout 'user_layout'
  
  def home
    @orders = current_user.orders.normal.order("created_at DESC").paginate page: params[:page], per_page: 10
    
    if mobile? 
      @incompleted_count = current_user.orders.normal.count
      @completed_count = current_user.orders.completed.count
      @canceled_count = current_user.orders.canceled.count
      fresh_when(etag: [@orders, @incompleted_count, @completed_count, @canceled_count])
    else
      fresh_when(etag: [@orders])
      set_seo_meta("个人主页")
    end
    
  end
  
  def edit
    @user = current_user
    @current = 'user_edit_other'
    set_seo_meta("配送设置")
  end
  
  def update
    user_params = params.require(:user).permit(:deliver_time,:apartment_id)
    if current_user.update(user_params)
      flash[:success] = "修改成功"
      redirect_to edit_user_path
    else
      render :edit
    end
  end
  
  def update_address
    @success = true
    @user = current_user #User.find_by_id(params[:user_id])
    @user.apartment_id = params[:address].to_i
    if @user.apartment_id.blank?
      return
    end
    
    if @user.save
      render text: "1"
    else
      render text: "-1"
    end
    
  end
  
  def likes
    @likes = current_user.likes.recent.products#.paginate page: params[:page], per_page: 20
    @current = 'user_likes'
    fresh_when(etag: [@likes, @current])
    set_seo_meta("我的收藏")
  end
  
  def points
    @traces = ScoreTrace.where(user_id: current_user.id).order("created_at DESC").paginate page: params[:page], per_page: 30
    @current = 'user_points'
    fresh_when(etag: [@traces, @current])
    set_seo_meta("我的积分")
  end
  
  def orders
    @orders = current_user.orders.order("created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders'   
    @tag = 'all'
    @cache_prefix = "user_#{current_user.mobile}-#{@current}" 
    fresh_when(etag: [@orders, @current])
    @mobile_title = "全部订单"
    set_seo_meta("我的订单")
  end
end