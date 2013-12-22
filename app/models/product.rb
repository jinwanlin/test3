# encoding: utf-8
class Product < ActiveRecord::Base
  attr_accessible :des, :name
  
  PRODUCT_TYPES = ['Vegetable', 'Fruit', 'Meat', 'Fish', 'Agri']
  
  has_many :prices, :order => 'date'
  
  def last_purchase_low_price
    prices.last.try(:purchase_low_price) unless prices.empty?
  end
  
  def last_purchase_price
    prices.last.try(:purchase_price) unless prices.empty?
  end
  
  def last_purchase_heigh_price
    prices.last.try(:purchase_heigh_price) unless prices.empty?
  end
  
  def last_selling_price
    prices.last.try(:selling_price) unless prices.empty?
  end
  
  def rofit
    last_selling_price - last_purchase_price unless last_selling_price.nil? || last_purchase_price.nil?
  end
  
  def previous
    Product.find(id - 1) if self != Product.first
  end 
  
  def next
    Product.find(id + 1) if self != Product.last
  end
    
  

  # 蔬菜
  def self.a(_index, _page)
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
            # find_history = true
          end
        end
        
        break if doc.css('.manu span')[-1].text == " 尾页 " || find_history
        
        page += 1
      end
    end
  end

end
