module SidebarAdsHelper
  def render_sidebar_ad_icon(sidebar_ad)
    return "" if sidebar_ad.blank?
    return "" if sidebar_ad.image.blank?
    
    image_tag sidebar_ad.image.url(:small)
  end
  
  def render_sidebar_ad_image(sidebar_ad)
    return "" if sidebar_ad.blank?
    return "" if sidebar_ad.image.blank?
    
    img = image_tag sidebar_ad.image.url(:normal), class: "img-responsive"
    
    if sidebar_ad.url.blank?
      img
    else
      raw %(<a href="#{sidebar_ad.url}">#{img}</a>)
    end
    
  end
end
