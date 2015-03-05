class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user
  
  scope :recent, -> { order('id desc') }
  scope :products, -> { where(likeable_type: "Product") }
  
  def as_json(opts = {})
    {
      id: self.id,
      item_id: self.likeable_id,
      item_icon_url: self.likeable.image.url(:thumb) || "",
      item_title: self.likeable.title,
      item_price: self.likeable.low_price,
    }
  end
end
