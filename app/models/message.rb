class Message < ActiveRecord::Base
  validates :title, :body, presence: true
  
  def user_mobile
    @mobile ||= User.find_by(id: self.user_id).try(:mobile)
  end
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#