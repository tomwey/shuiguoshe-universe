class Photo < ActiveRecord::Base
  belongs_to :product
  
  mount_uploader :image, PhotoUploader
  
  attr_accessor :image_cache
  
  validates :image, presence: true
  
  def as_json(opts = {})
    {
      url: self.image.url(:normal),
      width: self.width || 0,
      height: self.height || 0,
    }
  end
end
