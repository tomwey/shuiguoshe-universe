require 'rest_client'
class Invite < ActiveRecord::Base
  validates :code, :invitee_mobile, :user_id, presence: true
  validates :invitee_mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }
  validates_uniqueness_of :code, :invitee_mobile
  
  belongs_to :user
  
  scope :search, -> (keyword) { joins(:user).where('code like :value or invitee_mobile like :value or users.mobile like :value', { value: "%#{keyword}%" }) }
  
  before_create :generate_code
  def generate_code
    begin
      self.code = SecureRandom.hex(3)
      # puts self.code
    end while self.class.exists?(code: self.code)
  end
  
  def send_sms
    
    RestClient.post('http://yunpian.com/v1/sms/send.json', "apikey=7612167dc8177b2f66095f7bf1bca49d&mobile=#{self.invitee_mobile}&text=激活码是#{self.code}。如非本人操作，请致电18048553687【水果社】") { |response, request, result, &block|
      puts response
      resp = JSON.parse(response)
      if resp['code'].to_i == 0
        return true
      else
        return false
      end
    }
  end
  
end
