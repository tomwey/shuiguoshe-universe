class HomeController < ApplicationController
  layout 'help_layout', only: [:order_help, :pay_help, :deliver_help]
  def index
    
    discount_size = mobile? ? 2 : 3
    
    @banners = Banner.sorted.limit(4)
    @products = Product.hot.saled.no_discount.order("sort ASC, id DESC").limit(6)
    # @suggest_products = Product.suggest.limit(6)
    
    # @sales = Sale.recent
    
    @pages = Page.sorted.recent.limit(5)
    
    @newsblasts = Newsblast.sorted.limit(5)
    @ads = SidebarAd.sorted.limit(4)
    @discounted_products = Product.saled.discounted.order("sort ASC, id DESC").limit(discount_size)
    @current = 'home_index'
    fresh_when(etag: [@banners, @sales, @newsblasts, @ads, @products,@pages,@discounted_products, @current, SiteConfig.home_title, SiteConfig.home_meta_keywords, SiteConfig.home_meta_description])
    set_seo_meta(SiteConfig.home_title, SiteConfig.home_meta_keywords, SiteConfig.home_meta_description)
  end
  
  def about
    @current = 'home_about'
    fresh_when(etag: [@current, SiteConfig.about_html])
    set_seo_meta('关于水果社')
  end
  
  def order_help
    @current = 'order_help'
    fresh_when(etag: [@current])
    set_seo_meta('帮助中心')
  end
  
  def pay_help
    @current = 'pay_help'
    fresh_when(etag: [@current])
    set_seo_meta('帮助中心')
  end
  
  def deliver_help
    @current = 'deliver_help'
    fresh_when(etag: [@current])
    set_seo_meta('帮助中心')
  end
  
  def error_404
    render_404
  end
  
end
