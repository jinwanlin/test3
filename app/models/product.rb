class Product < ActiveRecord::Base
  attr_accessible :des, :name
  
  
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
    total = 0
    (607..814).each do |index| 
      url = "http://www.xinfadi.com.cn/marketanalysis/1/list/#{index}.shtml"
      doc = Nokogiri::HTML(open(url))
      doc.css('table.hq_table').to_s
    
      data = doc.css('table.hq_table tr').each_with_index.map do |row, index|
        next if index == 0
        tds = row.xpath('./td').map(&:text)
        # p "#{tds[0]}, #{tds[1]}, #{tds[2]}, #{tds[3]}, #{tds[4]}, #{tds[5]}, #{tds[6]}"
        # 香葱, 3.00, 4.00, 5.00, 普通, 斤, 2013-11-15"
        
        product = Product.find_by_name(tds[0]) || Product.create(name: tds[0])
        if Price.where(product_id: product).where(date: tds[6].to_date).empty?
          Price.create product: product, purchase_low_price: tds[1].to_f, purchase_price: tds[2].to_f, purchase_heigh_price: tds[3].to_f, date: tds[6].to_date
        end
      end
    end
    p total
  end
  
end
