class Banner < ActiveRecord::Base
  validates :image, presence: true
  
  mount_uploader :image, BannerUploader
  
  scope :sorted, -> { order("sort ASC, created_at DESC") }
  
  def as_json(opts = {})
    {
      id: self.id,
      title: self.title || "",
      subtitle: self.subtitle || "",
      intro: self.intro || "",
      image: image_url,#self.image.url(:small), 
      link: self.url || ""
    }
  end
  
  def image_url
    if self.image
      self.image.url(:normal) || ""
    else
      ""
    end
  end
end

# == Schema Information
#
# Table name: banners
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  intro      :string(255)
#  image      :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  sort       :integer          default(0)
#