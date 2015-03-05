class UserStepsController < ApplicationController
  
  layout 'user_login'
  
  def new
    @user = User.new
    @step = 1
    set_seo_meta('填写账号')
  end
  
  def create
    user = User.find_by(mobile: params[:user][:mobile])
    if user.blank?
      @user = User.new
      @user.errors.add(:mobile, "用户未注册")
      @step = 1
      set_seo_meta('填写账号')
      render :new
    else
      user.update_attribute(:reset_password_token, SecureRandom.uuid.gsub(/-/, "")) if user.reset_password_token.blank?
      redirect_to find_password_path(key: user.reset_password_token)
    end
  end
  
  def find
    @user = User.find_by(reset_password_token: params[:key])
    if @user.blank?
      render_404
    end
    @step = 2
    set_seo_meta('验证用户')
  end
  
  def check_code
    ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:user][:mobile],params[:user][:code],true).first
    if ac.blank?
      @user = User.find_by(reset_password_token: params[:user][:reset_password_token])
      @user.errors.add(:code, "手机验证码无效")
      @step = 2
      set_seo_meta('验证用户')
      render :find
    else
      ac.update_attribute(:verified, false)
      redirect_to edit_password_path(key: params[:user][:reset_password_token])
    end
  end
  
  def edit
    @user = User.find_by(reset_password_token: params[:key])
    if @user.blank?
      render_404
    end
    
     @step = 3
     set_seo_meta('重置密码')
  end
  
  def update
    @user = User.find_by(reset_password_token: params[:user][:reset_password_token])
    if @user.blank?
      render_404
      return
    end
    
    if params[:user][:password].length < 6
      @user.errors.add(:password, "密码至少为6位")
      @step = 3
      set_seo_meta('重置密码')
      render :edit
    else
      if params[:user][:password] != params[:user][:password_confirmation]
        @user.errors.add(:password_confirmation, "两次密码输入不一致")
        @step = 3
        set_seo_meta('重置密码')
        render :edit
      else
        if @user.update_attribute(:password, params[:user][:password])
          @user.reset_password_token = nil
          @user.reset_password_sent_at = Time.zone.now
          @user.save!
          redirect_to complete_password_path
        else
          puts @user.errors.full_messages
          @step = 3
          set_seo_meta('重置密码')
          render :edit
        end
      end
    end
  end
  
  def complete
     @step = 4
     set_seo_meta('完成重置密码')
  end
  
end