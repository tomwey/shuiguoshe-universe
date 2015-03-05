class Page < ActiveRecord::Base
  validates :title, :slug, :body, presence: true
  validates_uniqueness_of :slug
  
  scope :recent, -> { order('id desc') }
  scope :sorted, -> { order('sort asc') }
end
