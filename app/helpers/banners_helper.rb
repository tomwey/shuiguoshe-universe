module BannersHelper
  def render_banner_icon(banner)
    return "" if banner.blank?
    return "" if banner.image.blank?
    
    image_tag banner.image.url(:small)
  end
  
  def render_banner_image(banner)
    return "" if banner.blank?
    return "" if banner.image.blank?
    
    img = image_tag banner.image.url(:normal), class: "img-responsive", alt: banner.title
    
    if banner.url.blank?
      img
    else
      raw %(<a href="#{banner.url}">#{img}</a>)
    end
    
  end
  
  
end
