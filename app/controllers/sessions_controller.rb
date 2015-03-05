# coding: utf-8
class SessionsController < Devise::SessionsController
  layout 'user_login'
  
  def new
    set_seo_meta('会员登录')
    super
  end
end