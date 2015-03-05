class Order < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :apartment, touch: true
  
  has_many :line_items, dependent: :destroy
  
  validates :apartment_id, :total_price, presence: true, on: :create
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 },
            :presence => true, on: :create
            
  validates :apartment_id, inclusion: { in: Apartment.opened.map { |a| a.id }, message: "%{value} 不是一个有效的值" }, on: :create
  
  before_create :create_order_no
  def create_order_no
    self.order_no = Time.now.to_s(:number) + Time.now.nsec.to_s
  end
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  
  # def apartment
  #   @apartment ||= Apartment.find_by_id(self.apartment_id).try(:name)
  # end
  
  def user_mobile
    if self.mobile
      self.mobile
    else
      info = DeliverInfo.where(user_id: self.user.id, id: self.user.current_deliver_info_id).first
      info.mobile
    end
  end
  
  def user_apartment_name
    if self.apartment_id
      self.apartment.name
    else
      info = DeliverInfo.where(user_id: self.user.id, id: self.user.current_deliver_info_id).first
      Apartment.find_by(id: info.apartment_id).try(:name)
    end
  end
  
  def update_orders_count(oper = 1)
    Product.transaction do
      line_items.each do |item|
        item.update_sales_count(oper)
      end
    end
  end
  
  def self.today_count
    self.today.count
  end
  
  def total_discount_score
    sum = 0
    line_items.each do |item|
      sum += item.product.discount_score
    end
    sum
  end
  
  state_machine initial: :normal do
    state :prepare_delivering
    state :delivering
    state :canceled
    state :completed
    
    after_transition :delivering => :completed, :do => :update_product_infos
    
    event :prepare_deliver do
      transition :normal => :prepare_delivering
    end
    
    event :deliver do
      transition :prepare_delivering => :delivering
    end
    
    event :cancel do
      transition :normal => :canceled
    end
    
    event :complete do
      transition :delivering => :completed
    end
  end
  
  scope :today, -> { where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day) }
  scope :normal, -> { without_state(:completed, :canceled) }
  scope :canceled, -> { with_state(:canceled) }
  scope :completed, -> { with_state(:completed) }
  
  # def total_price
  #   line_items.to_a.sum { |item| item.total_price }
  # end
  
  def update_product_infos
    Product.transaction do
      line_items.each do |item|
        product = item.product
        if product.present?
          # 更新库存
          product.update_attribute('stock_count', product.stock_count - item.quantity) if product.stock_count > 0
          # 更新用户的积分
          user.update_score(product.discount_score * item.quantity, "购买产品") if ( product.discount_score > 0 and user )
        end
      end # each end
    end # transaction
  end
  
  def self.search(keyword)
    if keyword.gsub(/\s+/, "").present?
      joins(:user, :product).where('orders.order_no like :keyword or users.mobile like :keyword or orders.deliver_address like :keyword or products.title like :keyword',{ keyword: "%#{keyword}%"})
    else
      all
    end
      
  end
  
  def as_json(opts = {})    
    {
      id: self.id,
      order_no: self.order_no || "",
      state: order_state,
      ordered_at: self.created_at.strftime("%Y-%m-%d %H:%M:%S"),
      total_price: format("%.2f", self.total_price),
      delivered_at: deliver_info,
      can_cancel: (self.can_cancel? and self.state?(:normal)),
      items: self.line_items,
    }
  end
  
  def order_state
    if self.normal?
      "待配送"
    elsif self.prepare_delivering?
      "配送准备"
    elsif self.delivering?
      "配送中"
    elsif self.canceled?
      "已取消"
    elsif self.completed?
      "已完成"
    else
      ""
    end
  end
  
  def deliver_info
    order_time_line = SiteConfig.order_time_line || '12:00:00'
    if self.created_at.strftime("%H:%M:%S") < order_time_line
      "#{Time.zone.now.strftime("%Y-%m-%d")}（今天）18:00-21:00"
    else
      "#{(Time.zone.now + 1.day).strftime("%Y-%m-%d")}（明天）18:00-21:00"
    end
  end
  
  def apartment_name
    if self.apartment
      self.apartment.name || ""
    else
      ""
    end
  end
  
end

# coding: utf-8
# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  order_no       :string(255)
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  note           :string(255)
#  deliver_time   :string(255)
#  state          :string(255)
#  apartment_id   :integer
#  mobile         :string(255)
#  total_price    :decimal(8, 2)    default(0.0)
#  discount_price :decimal(8, 2)    default(0.0)
#
