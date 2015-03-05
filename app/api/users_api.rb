# coding: utf-8
require "rest_client"

module Shuiguoshe
  class UsersAPI < Grape::API
    # 100 用户已经注册
    # 101 发送验证码失败
    # 102 不正确的手机号
    # 103 密码太短
    
    # acts_as_easy_captcha
    
    resource :auth_codes do  
      
      # 获取验证码
      # api: domain/v1/auth_codes
      # params: { mobile:'', type:1,2,3 }
      params do
        # requires :captcha, type: String
        requires :mobile, type: String
        requires :type, type: Integer # 1 表示注册获取验证码 2 表示重置密码获取验证码 3 表示修改密码获取验证码
      end
      post '/' do
        
        unless check_mobile(params[:mobile])
          return { code: 100, message: "不正确的手机号" }
        end
        
        unless %W(1 2 3).include?(params[:type].to_s)
          return { code: -1, message: "不正确的type参数" }
        end
        
        # 检查手机是否符合获取验证码的要求
        type = params[:type].to_i
        user = User.find_by(mobile: params[:mobile])
        if type == 1    # 注册
          if user.present?
            return { code: 101, message: "#{params[:mobile]}已经注册" }
          end
        else # 重置密码和修改密码
          if user.blank?
            return { code: 102, message: "#{params[:mobile].gsub(/\s+/,"")}未注册" }
          end
        end
        
        # 1分钟内多次提交检测
        sym = "#{params[:mobile]}_#{params[:type]}".to_sym
        if session[sym] and ( Time.now.to_i - session[sym].to_i ) < 60 + rand(3)
          return { code: -5, message: "同一手机号1分钟内只能获取一次验证码，请稍后重试" }
        end

        session[sym] = Time.now.to_i
        
        # 同一手机一天最多获取5次验证码
        log = SendSmsLog.where('mobile = ? and send_type = ?', params[:mobile], params[:type]).first
        if log.blank?
          log = SendSmsLog.create!(mobile: params[:mobile], send_type: params[:type], first_sms_sent_at: Time.now)
        else
          
          dt = Time.now.to_i - log.first_sms_sent_at.to_i
          
          if dt > 24 * 3600 # 超过24小时都要重置发送记录
            log.sms_total = 0
            log.first_sms_sent_at = Time.now
            log.save!
          else 
            # 24小时以内
            if log.sms_total.to_i == 5 # 达到5次
              return { code: -10, message: "同一手机号24小时内只能获取5次验证码，请稍后再试" }
            end
          end
          
        end
              
        # 获取验证码并发送
        code = AuthCode.where('mobile = ? and verified = ? and c_type = ?', params[:mobile], true, type).first
        if code.blank?
          code = AuthCode.create!(mobile: params[:mobile], c_type: type)
        end

        if code          
          result = send_sms(params[:mobile], "您的验证码是#{code.code}【水果社】", "获取验证码失败")
          if result['code'].to_i == 103
            # 发送失败，更新每分钟发送限制
            session.delete(sym)
          end
          if result['code'].to_i == 0
            # 发送成功，更新发送日志
            log.update_attribute(:sms_total, log.sms_total + 1)
          end
          result
        else
          { code: -100, message: "验证码生成错误，请重试" }
        end
        
      end # end post create_code
      
    end # end auth_codes
    
    resource :account do
      # 用户注册
      # api: domain/v1/account/sign_up
      # params: { mobile: '', code: '', password: '' }
      params do
        requires :mobile, type: String, desc: "用户手机"
        requires :code, type: String, desc: "验证码"
        requires :password, type: String, desc: "密码"
      end
      
      post "/sign_up" do
        
        unless check_mobile(params[:mobile])
          return { code: 100, message: "不正确的手机号" }
        end
        
        user = User.find_by(mobile: params[:mobile])
        if user.present?
          return { code: 101, message: "#{params[:mobile]}已经注册" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile], params[:code], true).first
        
        if ac.blank?
          return { code: 104, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 105, message: "密码太短，至少为6位" }
        end
        
        @user = User.new(email: "#{params[:mobile].gsub(/\s+/,"")}@shuiguoshe.com", mobile: params[:mobile].gsub(/\s+/, ''), password: params[:password], password_confirmation: params[:password])
        if @user.save
          warden.set_user(@user)
          @user.ensure_private_token!
          ac.update_attribute('verified', false)
          { code: 0, message: "ok", data: { token: @user.private_token || "" } }
        else
          { code: 106, message: "用户注册失败" }
        end
        
      end # end reg
      
      # 用户登录
      # api: domain/v1/account/login
      # params: { login: '', password: '' }
      params do
        requires :login, type: String, desc: "登录名"
        requires :password, type: String, desc: "密码"
      end
      
      post '/login' do
        user = User.where(["mobile = :value OR lower(email) = :value", { value: params[:login].downcase }]).first
        unless user
          return { code: 102, message: "用户未注册" } 
        end
        
        if user.valid_password?(params[:password])
          { code: 0, message: "ok", data: { token: user.private_token || "" } }
        else
          { code: 107, message: "登录密码不正确" }
        end
        
      end # end login
      
      # 退出登录
      # api: domain/v1/account/logout
      # params: { token: '' }
      params do
        requires :token, type: String
      end
      post '/logout' do
        authenticate!
        
        warden.logout
        { code: 0, message: "ok" }
      end # end logout
      
      # 重置密码
      # api: domain/v1/account/password/reset
      # params: { code: '', mobile: '', password: '' }
      params do
        requires :code, type: String
        requires :mobile, type: String
        requires :password, type: String, desc: "new password"
      end
      post '/password/reset' do
        unless check_mobile(params[:mobile])
          return { code: 100, message: "不正确的手机号" }
        end
        @user = User.find_by(mobile: params[:mobile])
        if @user.blank?
          return { code: 102, message: "#{params[:mobile]}未注册" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile],params[:code],true).first
        if ac.blank?
          return { code: 104, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 105, message: "密码太短，至少为6位" }
        end
        
        if @user.update_attribute(:password, params[:password])
          { code: 0, message: "ok" }
        else
          { code: 108, message: "重置密码失败" } 
        end
        
      end # end reset password
      
      # 修改密码
      # api: domain/v1/account/password/update
      # params: { code: '', password: '', old_password: '' }
      params do
        # requires :code, type: String
        requires :token, type: String
        requires :password, type: String, desc: "new password"
        requires :old_password, type: String, desc: "old password"
      end
      post '/password/update' do
        user = authenticate!
        
        unless user.valid_password?(params[:old_password])
          return { code: 109, message: "旧密码不正确" }
        end
        
        # ac = AuthCode.where('mobile = ? and code = ? and verified = ?', user.mobile,params[:code],true).first
        # if ac.blank?
        #   return { code: 104, message: "验证码无效" }
        # end
        
        if params[:password].length < 6
          return { code: 105, message: "密码太短，至少为6位" }
        end
        
        if user.update_attribute(:password, params[:password])
          { code: 0, message: "ok" }
        else
          { code: 110, message: "修改密码失败" }
        end
        
      end # end update password
      
    end # end account
    
    resource :user do
      params do
        requires :token, type: String, desc: "token"
      end
      get :me do
        user = authenticate!
        
        { code: 0, message: "ok", data: user }
      end # end me
      
      # 更新用户头像
      params do
        requires :token, type: String, desc: "token"
        requires :avatar
      end
      post '/update_avatar' do
        user = authenticate!
        if params[:avatar]
          user.avatar = params[:avatar]
        end
        
        if user.save
          { code: 0, message: "ok" }
        else
          { code: 116, message: user.errors.full_messages.join(",") }
        end
      end
      
      # 更新配送信息
      params do
        requires :token, type: String, desc: "token"
        requires :apartment_id, type: Integer, desc: "配送小区"
      end
      post '/update_apartment' do
        user = authenticate!
        if params[:apartment_id]
          user.apartment_id = params[:apartment_id]
        end
        
        if user.save
          { code: 0, message: "ok" }
        else
          { code: 116, message: user.errors.full_messages.join(",") }
        end
      end
      
      # 邀请用户，送积分
      params do
        requires :token, type: String, desc: "Token"
        requires :mobile, type: String, desc: "被邀请人手机号"
      end
      post '/invite' do
        user = authenticate!
        
        if user.mobile == params[:mobile]
          return { code: 119, message: "不能邀请自己" }
        end
        
        if User.find_by(mobile: params[:mobile])
          return { code: 101, message: "该用户已经注册了" }
        end
        
        invite = Invite.where('invitee_mobile = ? and user_id = ?', params[:mobile], user.id).first
        if invite and invite.verified == false
          return { code: 117, message: "用户已经被邀请过" }
        end
        
        if invite.blank?
          invite = Invite.new(invitee_mobile: params[:mobile], user_id: user.id, code: SecureRandom.hex(3))
          unless invite.save
            return { code: 118, message: invite.errors.full_messages.join(",") }
          end
        end
        
        # 发短信
        return send_sms(invite.invitee_mobile, "激活码是#{invite.code}。如非本人操作，请致电18048553687【水果社】", "获取邀请码失败")
        
      end # end invite
      
      params do
        requires :token, type: String, desc: "Token"
        requires :code, type: String, desc: "邀请码"
      end
      post '/invite/active' do
        user = authenticate!
        
        invite = Invite.where(invitee_mobile: user.mobile, code: params[:code]).first
        if invite.blank?
          return { code: 404, message: "不正确的邀请码" }
        end
        
        if invite.verified == false
          return { code: 120, message: "邀请码已经被激活" }
        end
        
        if invite.update_attribute(:verified, false)
          user.update_score(SiteConfig.invite_score.to_i, '激活邀请码')
          invite.user.update_score(SiteConfig.invite_score.to_i, "邀请用户#{user.mobile}")
          { code: 0, message: "ok" }
        else
          { code: 121, message: "激活邀请码失败" }
        end
        
      end # end active
      
      # 更新收货信息
      params do
        requires :token, type: String, desc: "Token"
        requires :deliver_info_id, type: Integer
      end
      
      post '/update_deliver_info' do
        user = authenticate!
        if user.update_attribute(:current_deliver_info_id, params[:deliver_info_id])
          { code: 0, message: "ok" }
        else
          { code: -1, message: "更新收货信息失败" }
        end
      end # end 更新收货信息
      
      # 获取积分信息
      params do
        requires :token, type: String
      end
      get '/score_traces' do
        user = authenticate!
        items = ScoreTrace.where(user_id: user.id).order('id desc')
        { code: 0, message: "ok", data: items }
      end # end 获取积分
      
      # 我的收藏
      params do
        requires :token, type: String
      end
      get '/likes' do
        user = authenticate!
        { code: 0, messages: "ok", data: user.likes.order('id desc') }
      end # end likes
      
    end # end user
    
  end # end class
end # end module=======
