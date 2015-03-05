class ProductType < ActiveRecord::Base
  
  def self.all_types
    @product_types = ProductType.order('sort ASC, id ASC')
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
    }
  end
  
end

# == Schema Information
#
# Table name: product_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
