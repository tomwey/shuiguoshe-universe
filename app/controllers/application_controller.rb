class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
 
  layout :layout_by_resource
  def layout_by_resource
    if devise_controller?
      "user_login"
    else
      "application"
    end
  end
    
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
    
    if devise_controller?
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(*User::ACCESSABLE_ATTRS) }
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(*User::ACCESSABLE_ATTRS) }
    end
  end
  
  before_action :set_active_menu
  def set_active_menu
    @current = ["/#{controller_name}"]
  end
  
  def render_404
    render_optional_error_file(404)
  end
  
  def render_403
    render_optional_error_file(403)
  end
  
  def render_optional_error_file(status_code)
    status = status_code.to_s
    fname = %W(404 403 422 500).include?(status) ? status : 'unknown'
    render template: "/errors/#{fname}", format: [:html], handler: [:erb], status: status, layout: 'application'
  end
  
  def set_seo_meta(title = '', meta_keywords = '', meta_description = '')
    @page_title = "#{title}" if title && title.length > 0
    @meta_keywords = meta_keywords
    @meta_description = meta_description
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def redirect_referrer_or_default(default)
    redirect_to(request.referrer || default)
  end
  
  def require_user
    if current_user.blank?
      respond_to do |format|
        format.html { authenticate_user! }
        format.all  { head(:unauthorized) }
      end
    end
  end
  
  def check_user
    unless current_user.verified
      flash[:error] = "您的账号已经被冻结"
      redirect_to root_path
    end
  end
  
  def fresh_when(opts = {})
    return if Rails.env.development?
    # return if Rails.env.production?
    opts[:etag] ||= []
    # 保证 etag 参数是 Array 类型
    opts[:etag] = [opts[:etag]] unless opts[:etag].is_a?(Array)
    # 加入页面上直接调用的信息用于组合 etag
    opts[:etag] << current_user
    opts[:etag] << cart.line_items_count
    # Config 的某些信息
    # opts[:etag] << SiteConfig.
    # 加入flash, 确保当前页面刷新后flash不会再出现
    opts[:etag] << flash
    # 所有 etag 保持一天
    opts[:etag] << SiteConfig.welcome_html
    opts[:etag] << SiteConfig.contact_us
    opts[:etag] << Date.current
    super(opts)
  end
  
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  
  helper_method :cart
  def cart
    @cart ||= current_cart
  end
  
  helper_method :mobile?
  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                        'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
                        
  def mobile?
    agent_str = request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad/
    agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end
  
  private
    def current_cart
      if current_user.blank?
        save_cart_to_session
      else
        cart = Cart.find_by(user_id: current_user.id)
        if cart.blank?
          cart = Cart.create(user_id: current_user.id)
        end
        
        session_cart = Cart.find_by(id: session[:cart_id])
        if session_cart and session_cart.line_items.any?
          if cart.add_cart(session_cart)
            session_cart.destroy
            session[:cart_id] = nil
          end
        end
        
        cart
      end
    end
    
    def save_cart_to_session
        Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
        cart = Cart.create
        session[:cart_id] = cart.id
        cart
    end
  
end
