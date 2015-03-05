# coding: utf-8
class Cpanel::UsersController < Cpanel::ApplicationController
  before_action :check_is_admin, except: [:destroy]
  def index
    @users = User.where('id != ?',current_user.id).order('created_at desc').paginate page: params[:page], per_page: 30
  end
  
  def block
    @user = User.find(params[:id])
    @user.verified = false
    
    if @user.save
      render text: "1"
    else
      render text: "-1"
    end
  end
  
  def unblock
    @user = User.find(params[:id])
    @user.verified = true
    
    if @user.save
      render text: "1"
    else
      render text: "-1"
    end
  end
  
end