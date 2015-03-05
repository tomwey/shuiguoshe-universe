# coding: utf-8
module ProductsHelper
  def render_product_icon(product, size = :small)
    return "" if product.blank?
    return "" if product.image.blank?
    
    image_tag product.image.url(size)
  end
  
  def render_product_summary(product)
    return "" if product.blank?
    
    return product.subtitle if product.subtitle.present?
    return truncate(product.intro, length: 15) if product.intro.present?
    return ""
  end
  
  def product_price_tag(price)
    number_with_precision(price, precision: 2)
  end
  
  def render_deliver_info(product)
    return '' if product.blank?
    
    weeks = %w(星期日 星期一 星期二 星期三 星期四 星期五 星期六)
    
    order_time_line = SiteConfig.order_time_line || '12:00'
    if product.delivered_at.blank?
      if Time.zone.now.strftime('%H:%M:%S') < order_time_line
        week_index = Time.zone.now.wday
        order_time_line + "前完成下单，今天（#{Time.zone.now.strftime("%Y-%m-%d")} #{weeks[week_index]}）18:00至21:00之间配送"
      else
        week_index = (Time.zone.now + 1.day).wday
        order_time_line + "后完成下单，明天（#{(Time.zone.now + 1.day).strftime("%Y-%m-%d")} #{weeks[week_index]}）18:00至21:00之间配送"
      end
    else
      date = product.delivered_at.strftime('%Y-%m-%d')
      week_index = product.delivered_at.wday
      date + ' ' + order_time_line + "前完成下单，当天（#{date} #{weeks[week_index]}）18:00至21:00之间配送"
    end
    
  end
  
  def render_product_subtitle(product)
    return '' if product.blank?
    
    if product.subtitle.present?
      %(<div class="subtitle">#{product.subtitle}</div>).html_safe
    elsif product.discount_score > 0
      %(<div class="subtitle">赠送#{product.discount_score}积分，抵扣#{format('%.2f', product.discount_score/100.0)}元</div>).html_safe
    else
      ''
    end
    
  end
  
  def render_discount_score(product)
    return '' if product.blank?
    return '' if product.discount_score == 0
    
    "赠送#{product.discount_score}积分，抵扣#{format('%.2f', product.discount_score/100.0)}元"
  end
  
end
