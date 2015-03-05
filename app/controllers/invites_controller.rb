class InvitesController < ApplicationController
  before_action :require_user
  layout 'user_layout'
  
  def new
    @invite = Invite.new
    @current = "user_invite_new"
    set_seo_meta('邀请朋友')
  end
  
  def create
    
    @invite = Invite.new(invite_params)
    
    if @invite.invitee_mobile == current_user.mobile
      flash[:error] = "不能邀请自己"
      redirect_to new_invite_path
      return 
    end
    
    if User.find_by(mobile: @invite.invitee_mobile)
      flash[:error] = "该用户已经注册过了,不能被邀请"
      redirect_to new_invite_path
      return
    end
    
    invite = Invite.where('invitee_mobile = ? and user_id = ?', @invite.invitee_mobile, current_user.id).first
    if invite and invite.verified == false
      flash[:error] = "用户已经被邀请过"
      redirect_to new_invite_path
      return
    end
    
    if invite
      if invite.send_sms == true
        flash[:success] = "成功发出邀请"
      else
        flash[:error] = "发送邀请码失败"
      end
      redirect_to new_invite_path
      return 
    end
    
    @invite.user_id = current_user.id
    @invite.code = SecureRandom.hex(3)
    if @invite.save 
      if @invite.send_sms == true
        flash[:success] = "成功发出邀请"
      else
        flash[:error] = "发送邀请码失败"
      end
      redirect_to new_invite_path
    else
      render :new
    end
  end
  
  def active
    @invite = Invite.new
    @current = "user_invite_active"
    set_seo_meta('激活邀请')
  end
  
  def update
    invite = Invite.where(invitee_mobile: current_user.mobile, code: invite_params[:code]).first
    if invite.blank?
      flash[:error] = "不正确的邀请码"
      redirect_to active_invite_path
      return
    end
    
    if invite.verified == false
      flash[:error] = "邀请码已经被激活"
      redirect_to active_invite_path
      return
    end
    
    if invite.update_attribute(:verified, false)
      current_user.update_score(SiteConfig.invite_score.to_i, '激活邀请码')
      invite.user.update_score(SiteConfig.invite_score.to_i, "邀请用户#{current_user.mobile}")
      flash[:error] = "邀请码已经被激活"
      redirect_to active_invite_path
    else
      render :active
    end
  end
  
  private
  def invite_params
    params.require(:invite).permit(:invitee_mobile, :code)
  end
end