class Cpanel::HomeController < Cpanel::ApplicationController
  def index
    @today_orders = Order.includes(:line_items).normal.order("created_at DESC")
  end
end