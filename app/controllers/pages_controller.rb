class PagesController < ApplicationController
  def show
    @page = Page.find_by(slug: params[:id])
    if @page.blank?
      render_404
      return
    end
    fresh_when(etag: [@page])
    set_seo_meta(@page.title)
  end
end