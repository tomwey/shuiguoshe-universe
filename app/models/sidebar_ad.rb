class SidebarAd < ActiveRecord::Base
  validates :image, presence: true
  scope :sorted, -> { order('sort ASC, created_at DESC') }
  
  mount_uploader :image, SidebarAdUploader
end

# == Schema Information
#
# Table name: sidebar_ads
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  url        :string(255)
#  summary    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  sort       :integer          default(0)
#
