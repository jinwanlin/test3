# encoding: utf-8
class Product < ActiveRecord::Base
  store :order_detail, coder: JSON
  store :order_spid, coder: JSON
  
  serialize :amounts, Array
  attr_accessible :des, :name, :series, :cost, :sn, :aliases, :amounts, :classify, :no, :type, :state, :unit, :market_sort, :market_area, :order_total, :order_detail, :order_spid, :market_area, :market_sort, :pinyin, :optional_amounts
  
  PRODUCT_TYPES = ['', 'Vegetable', 'Fruit', 'Meat', 'Fish', 'Agri']
  UNIT= '斤'
  AMOUNTS1 = [0, 1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 20, 25, 30]
  AMOUNTS2 = [0, 2, 5, 7, 10, 12, 15, 20, 25, 30, 35, 40]
  AMOUNTS3 = [0, 5, 10, 15, 20, 25, 30, 35, 40]
  MARKET_AREA = {"xiaocai"=>"小菜豆芽区", 
                 "nangua"=>"南瓜西芹区", 
                 "yangcong"=>"洋葱山药区", 
                 "tudou"=>"土豆大葱区", 
                 "huanggua"=>"黄瓜番茄区", 
                 "jiangsuan"=>"姜蒜区", 
                 "hongsu"=>"萝卜红薯区", 
                 "lajiao"=>"辣椒区", 
                 "zhenjun"=>"真菌区"}
  
  has_many :prices, :order => 'date'
  has_many :attachments, :as => :owner, :dependent => :destroy
  
  validates :series, :cost, :name, :presence => true
  validates :name, uniqueness: true
  validates :aliases, uniqueness: true, :if => :aliases_present?
  # before_update :generate_product_sn
  
  validate :validate_name_aliases
  
  before_update :update_pinyin
  

  
  def validate_name_aliases
    if aliases.present? && Product.find_by_name(aliases)
      errors.add(:aliases, "#{aliases}已存在")
    end
    if name.present? && Product.find_by_aliases(name)
      errors.add(:name, "#{name}已存在")
    end
  end
  
  state_machine initial: :down do
    #before_transition :pending => :open, do: :do_done
    event :to_up do # 上架
      transition [:file, :down] => :up
    end
    event :to_down do # 下架
      transition :up => :down
    end
    event :to_file do # 归档
      transition [:up, :down] => :file
    end
  end
  
  def aliases_present?
    aliases.present?
  end
  
  def product_name
    aliases.present? ? aliases : name
  end
  
  def get_amounts
    if amounts.present?
      amounts
    else
      case optional_amounts
        when 1 then AMOUNTS1
        when 2 then AMOUNTS2
        when 3 then AMOUNTS3
        else AMOUNTS1
      end
    end
  end
  
  # # 最后最低价
  # def last_purchase_low_price
  #   prices.last.try(:purchase_low_price) unless prices.empty?
  # end
  # 
  # # 最后平均价
  # def last_purchase_price
  #   prices.last.try(:purchase_price) unless prices.empty?
  # end
  # 
  # # 最后最高价
  # def last_purchase_heigh_price
  #   prices.last.try(:purchase_heigh_price) unless prices.empty?
  # end
  
  # 
  # def last_selling_price
  #   prices.last.try(:selling_price) unless prices.empty?
  # end
  # 
  # def profit
  #   last_selling_price - last_purchase_price unless last_selling_price.nil? || last_purchase_price.nil?
  # end
  
  def previous
    # Product.find(id - 1) if self != Product.first
    Product.where("id < ?", id).where(state: 'up').order("id desc").first
  end 
  
  def next
    # Product.find(id + 1) if self != Product.last
    Product.where("id > ?", id).where(state: 'up').first
  end
  
  # 卖价，不同的人看到不同的卖价
  def sales_price(level=4)
    # return nil if prices.empty?
    return nil unless cost.present?
    return nil if cost < 0.01
    
    # profit_1 = (level-1)/3
    # remainder = level%3 == 0 ? 3 : level%3
    # profit_2 = remainder >= series ? 1 : 0
    # 
    # profit = (profit_1+profit_2)*0.1
    # price = cost * (1+profit)
    # cost = prices.last.forecast_cost
    if cost<1
      level = level + 2
    elsif 1 <= cost && cost <2
      
    elsif 2 <= cost && cost <3
      level = level - 1
    elsif 3 <= cost
      level = level - 2
    end
      
    
    price = cost*(level * 0.05 + 1)
    
    price = price*10
    price = price.round # 四舍五入取整
    price = price/10.0
    # (price * 100).round/100.0
  end
  

  # 蔬菜
  # Product.a index: 1, page: 2
  def self.a(args={})#(_index, _page)
    _index = args[:index] || 0
    _page = args[:page] || 1
    
    # "Vegetable", "Fruit", "Meat", "Fish", "Agri"
    ["Vegetable"].each_with_index do |food_type, index|
      page = 1
      find_history = false
      
      if _index-1 > index
        next
      elsif _index-1 == index
        page = _page
      end
      
      while true do
        p "page:----#{food_type}---#{index+1}----#{page}-------"
        url = "http://42.96.188.146/marketanalysis/#{index+1}/list/#{page}.shtml"
        # p url
        doc = Nokogiri::HTML(open(url))
        data = doc.css('table.hq_table tr').each_with_index.map do |row, index|
          next if index == 0
          tds = row.xpath('./td').map(&:text)
          
          date = tds[6].to_date
          actual_cost = tds[2].to_f
          next if actual_cost == 0
          
          product = Product.find_by_name(tds[0]) || food_type.constantize.create(name: tds[0], unit: tds[5], market_area: "hongsu")
          price = Price.where(product_id: product, date: date).first
          unless price 
              price = Price.create(product: product, date: date, actual_cost: actual_cost)
          else
            # find_history = true
            # break # 找到价格历史记录就 break
          end
        end
        
        break if doc.css('.manu span')[-1].text == " 尾页 " || find_history
        
        page += 1
      end
    end
  end

  


  
  def state_
    case self.state
      when "up" then "已上架"
      when "down" then "已下架"
      when "file" then "已归档"
    end
  end
  
  
  def generate_product_sn(no, classify)
    # previous_product=Product.last
    # previous_id = previous_product.present? ? previous_product.id : 0
    if classify == 'nil'
      ""
    else
      # type_id = PRODUCT_TYPES.index type
      type_id = ""
      sn = "#{type_id}#{type.constantize.classify_index classify}#{no.to_s.rjust(2, '0')}"
      # p sn
      sn
    end
    
    
    # self.sn = (previous_id+1).to_s.rjust(6, '0') unless self.sn 
  end  
  
  def self.type_ type
    case type
      when "Vegetable" then "蔬菜"
      when "Fruit" then "水果"
      when "Meat" then "肉"
      when "Fish" then "鱼"
      when "Agri" then "粮油"
    end
  end
  
  


  # 统计未分拣货物
  def self.do_order_total
    Product.all.each do |product|
      product.reset_order_detail_and_order_spid
      
      orderItems = OrderItem.where(product_id: p)
      orderItems = orderItems.joins(:order).where("orders.state = 'shiping' ")
      unless orderItems.empty?
        orderItems.each do |item|
          product.update_order_spid(item.order_amount)
          product.update_order_detail(item.order_amount)
        end
      end
      
      product.order_total = product.order_detail.values.inject{|sum,x| sum + x }
      product.save
    end
  end
  
  # 重置两个字段
  def reset_order_detail_and_order_spid
    self.order_detail = Hash.new
    self.order_detail[1] = 0
    self.order_detail[2] = 0
    self.order_detail[3] = 0
    self.order_detail[4] = 0
    self.order_detail[5] = 0
    self.order_detail[6] = 0
    self.order_detail[7] = 0
    self.order_detail[10] = 0
    self.order_detail[12] = 0
    self.order_detail[15] = 0
    self.order_detail[20] = 0
    self.order_detail[25] = 0

    self.order_spid = Hash.new
    self.order_spid[1] = 0
    self.order_spid[2] = 0
    self.order_spid[5] = 0
    self.order_spid[10] = 0
    self.order_spid[20] = 0
  end
  
  def update_order_detail(order_amount)
    case order_amount
      when 1
        self.order_detail[1] += 1
      when 2
        self.order_detail[2] += 1
      when 3 
        self.order_detail[3] += 1
      when 4
        self.order_detail[2] += 1
      when 5
        self.order_detail[5] += 1
      when 6
        self.order_detail[6] += 1
      when 7
        self.order_detail[7] += 1
      when 10
        self.order_detail[10] += 1
      when 12
        self.order_detail[12] += 1
      when 15
        self.order_detail[15] += 1
      when 20
        self.order_detail[20] += 1
      when 25
        self.order_detail[5] += 1
    end
  end
  
  def update_order_spid(order_amount)
    case order_amount
      when 1
        self.order_spid[1] += 1
      when 2
        self.order_spid[2] += 1
      when 3 
        self.order_spid[1] += 1
        self.order_spid[2] += 1
      when 4
        self.order_spid[2] += 2
      when 5
        self.order_spid[5] += 1
      when 6
        self.order_spid[1] += 1
        self.order_spid[5] += 1
      when 7
        self.order_spid[2] += 1
        self.order_spid[5] += 1
      when 10
        self.order_spid[10] += 1
      when 12
        self.order_spid[10] += 1
        self.order_spid[2] += 1
      when 15
        self.order_spid[10] += 1
        self.order_spid[5] += 1
      when 20
        self.order_spid[20] += 1
      when 25
        self.order_spid[5] += 1
    end
  end
  
  def update_pinyin
      self.pinyin = Pinyin.t(self.product_name)
  end
  
end
