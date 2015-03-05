# coding: utf-8
module ApplicationHelper
  def render_page_title
    site_name = "水果社"
    title = @page_title ? "#{site_name} - #{@page_title}" : site_name rescue "SITE_NAME"
    content_tag("title", title, nil, false)
  end
  
  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = :success if type.to_s == "notice"
      type = :warning if type.to_s == "alert"
      type = :danger if type.to_s == "error"
      text = content_tag(:div, link_to("×", "#", class: "close", 'data-dismiss' => "alert") + message, class: "alert alert-#{type}", style: "margin-top: 20px;")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end
  
  def owner?(item)
    return false if item.blank?
    return item.user == current_user
  end
  
  def cache_key_for(prefix = '', array = [])
    return [prefix, "empty"] if array.empty?
    #[prefix, array.map(&:updated_at).max.strftime("%Y%m%d%H%M%S")]
    [prefix, array]
  end
  
  # state: true, yes_uri: "/cpanel/users/1/block", yes_text: "禁用", no_uri: "/cpanel/users/1/unblock", no_text: "启用"
  def state_link_to(opts = {})
    state = opts[:state]

    message = if state 
      opts[:yes_text]
    else
      opts[:no_text]
    end
    
    html = <<-HTML
    <a href="#" data-remote="true" 
                data-yes-uri="#{opts[:yes_uri]}" 
                data-yes-text="#{opts[:yes_text]}" 
                data-no-uri="#{opts[:no_uri]}" 
                data-no-text="#{opts[:no_text]}"
                data-state="#{state}"
                onclick="App.updateState(this);" 
                class="btn btn-danger btn-xs" >
                #{message}
    </a>
    HTML
    
    html.html_safe
  end
  
  def render_grid_for(collection, cell_count = 3)
    html = ""
    collection.each_with_index do |item, index|
      if index % cell_count == 0
        html += '<div class="row">'
      end
      
      html += render item
      
      if index % cell_count == cell_count -1 or index == collection.size - 1
        html += '</div>'
      end
    end
    html.html_safe
  end
  
  def render_mobile_grid_for(collection, partial, cell_count = 2)
    html = ""
    collection.each_with_index do |item, index|
      if index % cell_count == 0
        html += '<div class="row">'
      end
      
      html += render partial, item: item, index: index
      
      if index % cell_count == cell_count -1 or index == collection.size - 1
        html += '</div>'
      end
    end
    html.html_safe
  end
  
  def link_to_add_fields(name, f, association)
    new_object  = f.object.class.reflect_on_association(association).klass.new
    fields = f.simple_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("/cpanel/#{association}/form_fields", :f => builder)
    end
    link_to name, "#", onclick: h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), class: "btn btn-default", remote: true
  end
  
  # MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
  #                       'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
  #                       'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
  #                       'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
  #                       'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
  # def mobile?
  #   agent_str = request.user_agent.to_s.downcase
  #   return false if agent_str =~ /ipad/
  #   agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  # end
  
end
