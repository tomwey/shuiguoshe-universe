module SalesHelper
  def render_distance_days(sale)
    return 0 if sale.blank?
    return 0 if sale.closed_at.blank?
    
    return 0 if sale.closed_at < Time.zone.now
    
    return (sale.closed_at.to_date - Time.zone.now.to_date).to_i
  end
end