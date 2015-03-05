class Cpanel::MessagesController < Cpanel::ApplicationController
  def index
    @messages = Message.order('created_at desc').paginate page: params[:page], per_page: 30
  end
end