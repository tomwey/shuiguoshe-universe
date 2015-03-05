class Newsblast < ActiveRecord::Base
  scope :sorted, -> { order("sort ASC, created_at DESC") }
end

# == Schema Information
#
# Table name: newsblasts
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  sort       :integer          default(0)
#