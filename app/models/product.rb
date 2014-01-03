# encoding: utf-8
class Product < ActiveRecord::Base
  attr_accessible :des, :name, :series, :price
  
  PRODUCT_TYPES = ['Vegetable', 'Fruit', 'Meat', 'Fish', 'Agri']
  AMOUNTS = [0, 1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 20, 25, 30]
  
  has_many :prices, :order => 'date'
  
  # 最后最低价
  def last_purchase_low_price
    prices.last.try(:purchase_low_price) unless prices.empty?
  end
  
  # 最后平均价
  def last_purchase_price
    prices.last.try(:purchase_price) unless prices.empty?
  end
  
  # 最后最高价
  def last_purchase_heigh_price
    prices.last.try(:purchase_heigh_price) unless prices.empty?
  end
  
  # 
  # def last_selling_price
  #   prices.last.try(:selling_price) unless prices.empty?
  # end
  
  def rofit
    last_selling_price - last_purchase_price unless last_selling_price.nil? || last_purchase_price.nil?
  end
  
  def previous
    Product.find(id - 1) if self != Product.first
  end 
  
  def next
    Product.find(id + 1) if self != Product.last
  end
  
  # 卖价，不同的人看到不同的卖价
  def sales_price(level)
    return if !level.present? || !price.present?
    profit_1 = (level-1)/3
    remainder = level%3 == 0 ? 3 : level%3
    profit_2 = remainder >= series ? 1 : 0
    
    profit = (profit_1+profit_2)*0.1
    price * (1+profit)
  end
  

  # 蔬菜
  # Product.a index: 1, page: 2
  def self.a(args={})#(_index, _page)
    _index = args[:index] || 0
    _page = args[:page] || 1
    
    ["Vegetable", "Fruit", "Meat", "Fish", "Agri"].each_with_index do |food_type, index|
      page = 1
      find_history = false
      
      if _index-1 > index
        next
      elsif _index-1 == index
        page = _page
      end
      
      while true do
        p "page:----#{food_type}---#{index+1}----#{page}-------"
        url = "http://www.xinfadi.com.cn/marketanalysis/#{index+1}/list/#{page}.shtml"
        p url
        doc = Nokogiri::HTML(open(url))
        data = doc.css('table.hq_table tr').each_with_index.map do |row, index|
          next if index == 0
          tds = row.xpath('./td').map(&:text)
          product = Product.find_by_name(tds[0]) || food_type.constantize.create(name: tds[0])
          if Price.where(product_id: product).where(date: tds[6].to_date).empty?
            Price.create product: product, purchase_low_price: tds[1].to_f, purchase_price: tds[2].to_f, purchase_heigh_price: tds[3].to_f, date: tds[6].to_date
          else
            # break # 找到价格历史记录就 break
            find_history = true
          end
        end
        
        break if doc.css('.manu span')[-1].text == " 尾页 " || find_history
        
        page += 1
      end
    end
  end

  def b
    client = SmsClient.create
    response = client.sendsms("jinwanlin123@gmail.com", Digest::MD5::hexdigest('jinwanlin123@'), '测试短消息内容', '15657715360')
    puts response.resultCode    #“1”
    puts response.resultMsg     #“success”
    puts response.id            #“6b77dfa5-765a-4f38-38c5-eo9d364e000”
  end
  
  def self.c
    password = Digest::MD5::hexdigest('jinwanlin')
    url = "http://www.smslinkapi.com/api/index.php/sendsms?username=jinwanlin123@gmail.com&password=#{password}&message=to_jin_wanlin&target=15657715360"
    p url
    p open(url)
    
  end
  
end
