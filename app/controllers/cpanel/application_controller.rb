class Cpanel::ApplicationController < ApplicationController
  
  before_filter :require_user
  before_filter :require_admin
  
  layout 'cpanel'
  
  def require_admin
    unless current_user.admin?
      render_404
    end
  end
  
  protected
    def check_is_admin
      unless current_user.admin?
        render_404
      end
    end
  
    def check_is_super_manager
      unless current_user.super_manager?
        render_404
      end
    end
    
    def check_is_site_editor
      unless current_user.site_editor?
        render_404
      end
    end
    
    def check_is_marketer
      unless current_user.marketer?
        render_404
      end
    end
    
    def check_destroy_authorize
      unless current_user.admin?
        render_404
      end
    end
end