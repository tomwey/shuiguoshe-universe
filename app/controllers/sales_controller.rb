class SalesController < ApplicationController

  def show
    begin
      @sale = Sale.includes(:products).find(params[:id])
      @products = @sale.products.saled
    rescue ActiveRecord::RecordNotFound
      render_404
    else
      set_seo_meta(@sale.title, @products.map { |p| p.title }.join(', '))
      fresh_when(etag: [@sale, @products])
    end
    
  end
  
end
