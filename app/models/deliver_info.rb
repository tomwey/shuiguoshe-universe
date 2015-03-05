class DeliverInfo < ActiveRecord::Base
  
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 },
            :presence => true
            
  validates :apartment_id, inclusion: { in: Apartment.opened.map { |a| a.id }, message: "%{value} 不是一个有效的值" }
  
  belongs_to :user
  
  def as_json(opts = {})
    {
      id: self.id,
      mobile: self.mobile || "",
      address: user_address,
    }
  end
  
  def user_address
    if self.address
      self.address
    else
      a = Apartment.find_by(id: apartment_id)
      if a.blank?
        ""
      else
        a.deliver_address(nil)
      end
    end
  end
end
