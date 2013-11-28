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
    
  def self.a
    PRODUCT_TYPES.each_with_index do |product_type, type_index|
      page = 1
      has_next_item = true
      while has_next_item do
        url = "http://www.xinfadi.com.cn/marketanalysis/#{type_index+1}/list/#{page}.shtml"
        doc = Nokogiri::HTML(open(url))
        doc.css('table.hq_table').to_s
        data = doc.css('table.hq_table tr').each_with_index.map do |row, index|
          next if index == 0
          tds = row.xpath('./td').map(&:text)
          product = Product.find_by_name(tds[0]) || product_type.constantize.create(name: tds[0])
          if Price.where(product_id: product).where(date: tds[6].to_date).empty?
            Price.create product: product, purchase_low_price: tds[1].to_f, purchase_price: tds[2].to_f, purchase_heigh_price: tds[3].to_f, date: tds[6].to_date
          else
            has_next_item = false
            break;
          end
        end
        page += 1
      end
    end
  end
  
end
