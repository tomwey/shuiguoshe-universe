class NewsblastsController < ApplicationController
  before_action :set_newsblast, only: [:show]

  def show
    fresh_when(etag: [@newsblast])
    set_seo_meta(@newsblast.title)
  end

  private
    def set_newsblast
      @newsblast = Newsblast.find(params[:id])
    end
    
end
