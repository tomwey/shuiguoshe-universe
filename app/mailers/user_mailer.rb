# coding: utf-8
class UserMailer < BaseMailer
  def welcome(user_id)
    @user = User.find_by_id(user_id)
    return false if @user.blank?
    mail to: @user.email, subject: "欢迎您加入水果社"
  end
end
