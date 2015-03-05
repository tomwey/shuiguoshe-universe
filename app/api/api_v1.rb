# coding: utf-8
require "helpers"
require "entities"

require "users_api"
require "banners_api"
require "messages_api"
require "carts_api"
require "products_api"
require "apartments_api"
require "orders_api"
require "likes_api"
require "deliver_infos_api"
require "home_api"

module Shuiguoshe
  
  # order
  # submit order
  
  ####################################################################
  # code状态码
  # 0: 表示成功
  # -1: 表示参数错误
  # 100: 不正确的手机号
  # 101: 用户已经注册
  # 102: 用户未注册，用于获取重置验证码，修改密码验证码，用户登录
  # 103: 获取验证码失败
  # 104: 验证码无效
  # 105: 密码太短
  # 106: 用户注册失败
  # 107: 用户登录密码不正确
  # 108: 重置密码失败
  # 109: 旧密码不正确
  # 110: 修改密码失败
  # 111: 购物车是空的
  # 112: 产品已售完
  # 113: 加入购物车失败
  # 114: 更新购买项数量失败
  # 115: 下单失败
  # 116: 修改用户资料失败
  # 117: 用户已经被邀请
  # 118: 发送邀请失败
  # 119: 邀请错误
  # 120: 邀请码已经失效
  # 121: 激活邀请码失败
  ####################################################################
  class APIV1 < Grape::API
    prefix :api
    version 'v1'
    format :json
    
    rescue_from :all do |e|
      case e
      when ActiveRecord::RecordNotFound
        Rack::Response.new(['not found'], 404, {}).finish
      else
        Rails.logger.error "APIv1 Error: #{e}\n#{e.backtrace.join("\n")}"
        Rack::Response.new(['error'], 500, {}).finish
      end
    end
    
    helpers APIHelpers
    
    mount Shuiguoshe::UsersAPI
    mount Shuiguoshe::BannersAPI
    mount Shuiguoshe::MessagesAPI
    mount Shuiguoshe::CartsAPI
    mount Shuiguoshe::ProductsAPI
    mount Shuiguoshe::ApartmentsAPI
    mount Shuiguoshe::OrdersAPI
    mount Shuiguoshe::LikesAPI
    mount Shuiguoshe::DeliverInfosAPI
    mount Shuiguoshe::HomeAPI
  end
end