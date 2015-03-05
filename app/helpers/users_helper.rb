# coding: utf-8
module UsersHelper
  def user_avatar_tag(user,size = :normal, opts = {})
    return "" if user.blank?
    
    link = opts[:link] || false
    width = user_avatar_width_for_size(size)
    
    if user.avatar.blank?
      default_url = "avatar/#{size}.png"
      img = image_tag(default_url, alt: "用户头像", class: "img-circle")
    else
      img = image_tag(user.avatar.url(size), alt: "用户头像", class: "img-circle")
    end
    
    if link
      raw %(<a href="#{user_path(user)}">#{img}</a>)
    else
      raw img
    end
    
  end
  
  def user_avatar_width_for_size(size)
    case size
    when :normal then 48
    when :small then 16
    when :large then 64
    when :big then 120
    else 48
    end
  end
  
  def deliver_select_tag(f)
    return "" if current_user.blank?
    
    # if current_user.apartment_id.present?
    #   # edit_html = %(<a onclick="updateApartment()" class="btn btn-sm btn-success">修改</a>)
    #   select_html = f.select :apartment_id, Apartment.opened.map { |a| [a.deliver_address(current_user), a.id, 'user-apartment-id' => @order.apartment_id ] }, { prompt: "选择小区", selected: @order.apartment_id}, { class: "form-control", 'data-current' => @order.apartment_id }
    #   # hide_html = %(<div id="hide_order_apartment_input"><input type="hidden" name="order[apartment_id]" value="#{current_user.apartment_id}" /></div>)
    # else
      # edit_html = %(<a class="btn btn-sm btn-warning" data-user-id="#{current_user.id}" onclick="App.doSaveAddress(this)" id="save_address" disabled>保存到配送设置</a>)
      select_html = f.select :apartment_id, Apartment.opened.map { |a| [a.deliver_address(current_user), a.id, 'user-apartment-id' => f.object.apartment_id ] }, { prompt: "选择小区", selected: f.object.apartment_id }, { class: "form-control" }
      # hide_html = '<div id="hide_order_apartment_input"></div>'
    # end
    
    html = <<-HTML
    <div class="col-sm-4 col-xs-6">
       #{select_html}
    </div>
    HTML
    
    html.html_safe
  end
  
  # def deliver_select_tag(f)
  #   return "" if current_user.blank?
  #
  #   if current_user.apartment_id.present?
  #     edit_html = %(<a onclick="updateApartment()" class="btn btn-sm btn-success">修改</a>)
  #     select_html = f.select :apartment_id, Apartment.opened.map { |a| ["#{a.name}（#{a.address}）", a.id, 'user-apartment-id' => current_user.apartment_id ] }, { prompt: "选择小区", selected: current_user.apartment_id}, { class: "form-control", disabled: true, 'data-current' => current_user.apartment_id }
  #     hide_html = %(<div id="hide_order_apartment_input"><input type="hidden" name="order[apartment_id]" value="#{current_user.apartment_id}" /></div>)
  #   else
  #     edit_html = %(<a class="btn btn-sm btn-warning" data-user-id="#{current_user.id}" onclick="App.doSaveAddress(this)" id="save_address" disabled>保存到配送设置</a>)
  #     select_html = f.select :apartment_id, Apartment.opened.map { |a| ["#{a.name}（#{a.address}）", a.id, 'user-apartment-id' => current_user.apartment_id ] }, { prompt: "选择小区", selected: current_user.apartment_id }, { class: "form-control" }
  #     hide_html = '<div id="hide_order_apartment_input"></div>'
  #   end
  #
  #   html = <<-HTML
  #   <div class="col-sm-4 col-xs-6">
  #      #{select_html}
  #      #{hide_html}
  #   </div>
  #   <div class="col-sm-2 col-xs-6">
  #     <div id="edit-user-apartment">
  #       #{edit_html}
  #     </div>
  #   </div>
  #   HTML
  #
  #   html.html_safe
  # end
  
  def user_discount_score(total_price)
    return 0 if current_user.blank?
    return (total_price * 50).to_i if total_price * 100 < current_user.score * 2
    return current_user.score
  end
  
end