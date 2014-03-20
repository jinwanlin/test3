# encoding: utf-8
class Product < ActiveRecord::Base
  serialize :amounts, Array
  attr_accessible :des, :name, :series, :cost, :sn, :aliases, :amounts, :classify, :no, :type, :state, :unit, :market_sort, :market_area
  
  PRODUCT_TYPES = ['', 'Vegetable', 'Fruit', 'Meat', 'Fish', 'Agri']
  UNIT= '斤'
  AMOUNTS = [0, 1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 20, 25, 30]
  MARKET_AREA = {"xiaocai"=>"小菜豆芽区", "bailuobo"=>"白萝卜区", "nangua"=>"南瓜西芹区", "yangcong"=>"洋葱山药区", "tudou"=>"土豆大葱区", "huanggua"=>"黄瓜番茄区", "jiangsuan"=>"姜蒜区", "hongsu"=>"红薯区"}
  
  has_many :prices, :order => 'date'
  has_many :attachments, :as => :owner, :dependent => :destroy
  
  validates :series, :cost, :name, :presence => true
  validates :name, uniqueness: true
  validates :aliases, uniqueness: true, :if => :aliases_present?
  # before_update :generate_product_sn
  
  validate :validate_name_aliases
  

  
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
  
  def unit
    "斤"
  end
  
  def aliases_present?
    aliases.present?
  end
  
  def product_name
    aliases.present? ? aliases : name
  end
  
  def get_amounts
    amounts.present? ? amounts : AMOUNTS
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
    Product.find(id - 1) if self != Product.first
  end 
  
  def next
    Product.find(id + 1) if self != Product.last
  end
  
  # 卖价，不同的人看到不同的卖价
  def sales_price(level)
    return nil if prices.empty?
    # return if !level.present? || !cost.present?
    # profit_1 = (level-1)/3
    # remainder = level%3 == 0 ? 3 : level%3
    # profit_2 = remainder >= series ? 1 : 0
    # 
    # profit = (profit_1+profit_2)*0.1
    # price = cost * (1+profit)
    cost = prices.last.forecast_cost
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
          
          product = Product.find_by_name(tds[0]) || food_type.constantize.create(name: tds[0])
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

  
  # 设置成本价
  def self.set_cost
    Product.all.each do |product|
      product.update_attributes cost: (product.prices.last.forecast_cost * 100).round/100.0
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
      p sn
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
  
  

  
end
