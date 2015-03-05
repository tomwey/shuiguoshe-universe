class Sale < ActiveRecord::Base
  has_many :products
  
  validates :cover_image, :title, presence: true
  
  mount_uploader :cover_image, CoverImageUploader
  mount_uploader :ad_image, SaleAdImageUploader
  mount_uploader :logo, SaleLogoUploader
  
  scope :recent, -> { order('created_at DESC') }
  
  def as_json(options = {})
    {
      id: self.id,
      title: self.title || "",
      subtitle: self.subtitle || "",
      closed_at: closed_time,
      logo_url: logo_url,
      cover_image_url: cover_image_url
    }
  end
  
  def closed_time
    if self.closed_at
      self.closed_at.strftime("%Y-%m-%d %H:%M:%S")
    else
      ""
    end
  end
  
  def logo_url
    if self.logo
      self.logo.url(:logo_small) || ""
    else
      ""
    end
  end
  
  def ad_image_url
    if self.ad_image
      self.ad_image.url(:ad_small) || ""
    else
      ""
    end
  end
  
  def cover_image_url
    if self.cover_image
      self.cover_image.url(:small) || ""
    else
      ""
    end
  end
end

# == Schema Information
#
# Table name: sales
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  cover_image :string(255)
#  ad_image    :string(255)
#  subtitle    :string(255)
#  logo        :string(255)
#  background_color :string(255) 卖场背景颜色
#  closed_at   :datetime  卖场活动截止日期, 默认为空，表示不截止
#  created_at  :datetime
#  updated_at  :datetime
#
