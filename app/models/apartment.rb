class Apartment < ActiveRecord::Base
  validates :name, :address, :image, presence: true
  
  mount_uploader :image, PictureUploader
  
  # scope :opened, -> { where(:is_open => true) }
  scope :hot, -> { where('orders_count > 0').order('orders_count desc') }
  
  def add_order_count
    self.class.increment_counter(:orders_count, self.id)
  end
  
  def self.opened
    # Rails.cache.fetch("apartment:apartment_collection:#{CacheVersion.last_apartment_updated_at}") do
      where(:is_open => true).order('sort ASC, orders_count DESC')
    # end
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
      address: self.address || "",
      orders_count: self.orders_count,
      image: image_url
    }
  end
  
  def image_url
    if self.image
      self.image.url(:small) || ""
    else
      ""
    end
  end
  
  def deliver_address(user)
    # if self.name == '其他'
    #   if user and user.deliver_address.present?
    #     "#{self.name} (#{user.deliver_address})"
    #   else
    #     "#{self.name}（#{self.address}）"
    #   end
    # else
      "#{self.name}（#{self.address}）"
    # end
  end
  
end

# == Schema Information
#
# Table name: apartments
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  address      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  image        :string(255)
#  is_open      :boolean          default(FALSE)
#  orders_count :integer          default(0)
#
