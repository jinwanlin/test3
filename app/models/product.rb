# encoding: utf-8
class Product < ActiveRecord::Base
  serialize :amounts, Array
  attr_accessible :des, :name, :series, :cost, :sn, :aliases, :amounts
  
  PRODUCT_TYPES = ['Vegetable', 'Fruit', 'Meat', 'Fish', 'Agri']
  AMOUNTS = [1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 20, 25, 30]
  
  has_many :prices, :order => 'date'
  
  validates :series, :cost, :name, :presence => true
  validates :name, uniqueness: true
  validates :aliases, uniqueness: true, :if => :aliases_present?
  before_create :generate_product_sn
  
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
    # return if !level.present? || !cost.present?
    # profit_1 = (level-1)/3
    # remainder = level%3 == 0 ? 3 : level%3
    # profit_2 = remainder >= series ? 1 : 0
    # 
    # profit = (profit_1+profit_2)*0.1
    # price = cost * (1+profit)
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
    ["Fruit"].each_with_index do |food_type, index|
      index = 1;
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
  # def self.set_cost
  #   Product.all.each do |product|
  #     product.update_attributes cost: (product.last_purchase_price * 100).round/100.0
  #   end
  # end
  
  def self.b
    
    page=2
    while page<3 do
      url = "http://fr.97xzc.tv/bbs/forum-10-#{page}.html"
      p "url------#{url}"
      
      doc = Nokogiri::HTML(open(url))
      doc.css('a').map do |link| 
        href = link.attribute('href').to_s
        next unless href.include?('thread-')
        next unless href.include?('-1-1.html')
        p "href------#{href}-----#{link.content}"

        href = "http://fr.97xzc.tv/bbs/#{href}"
        
        style = link.attribute('style').to_s
        p "style: #{style}"
        next unless style==""
        
        target = link.attribute('target').to_s
        p target
        next unless target == ""
        
        next unless link.content.include?('[')
        
        
        open_show href
        
      end
      page+=1
    end
  end
  
  def self.open_show href
    begin
      show = Nokogiri::HTML(open(href))
      show.css('div.t_msgfont img').each_with_index.map do |img, index| 
        src = img.attribute('src').to_s
        p "src------#{src}"
        type = src[src.rindex(".")..src.length]
      
        download src, index, type

      end
    rescue => err  
      p "网页打不开#{href}"
    end   
  end
  
  def self.download(src, index, type)
    Thread.new do  
      begin
        tmpfile = open(src)
        FileUtils.copy tmpfile.path, "/Users/jinwanlin/s/#{Time.now.to_i}-#{index}#{type}"
        tmpfile.close(true)
      rescue => err  
        p "timeout"
        break;  
      end   
    end 
  end
  
  def self.c
    href = "http://himg2.huanqiu.com/attachment2010/2012/0427/20120427110724849.jpg"
    show = Nokogiri::HTML(open(href))
    show.css('div.t_msgfont img').each_with_index.map do |img, index| 
      src = img.attribute('src').to_s
      p src
      type = src[src.rindex(".")..src.length]
      
      # Net::HTTP.start(domain) { |http|
      #   resp = http.get(dir)
      #   open("/Users/jinwanlin/workspace/test3/public/#{page}-#{index}#{type}", "wb") { |file|
      #     file.write(resp.body)
      #    }
      # }
      tmpfile = open(src)
      FileUtils.copy tmpfile.path, "/Users/jinwanlin/s/#{page}-#{index}#{type}"
      tmpfile.close(true)
    end
    
  end
  
  
  def self.d
    
    # page = "1"
    # index = "2"
    # src = "www.huanqiu.com/attachment2010/2012/0427/20120427110713918.jpg"
    # domain = src[0...src.index("/")]
    # dir = src[src.index("/")..src.length]
    # type = src[src.rindex(".")..src.length]
    # 
    # p domain
    # p dir
    # p type
    # 
    # Net::HTTP.start(domain) { |http|
    #   resp = http.get(dir)
    #   resp = open(src)
    #   open("/Users/jinwanlin/workspace/test3/public/#{page}-#{index}#{type}", "wb") do |file|
    #     file.write(resp.body)
    #   end
    # }
    
    # url = 'http://www.google.com.hk/images/srpr/logo11w.png'
    url = "http://himg2.huanqiu.com/attachment2010/2012/0427/20120427110721202.jpg"
    # url = "http://mimg.127.net/logo/163logo.gif"
    
    tmpfile = open(url)
    FileUtils.copy tmpfile.path, "/Users/jinwanlin/s/a.jpg"
    tmpfile.close(true)
    
    # FileUtils.cp "/var/folders/c7/lthglljn62b3s7jc3fnbk42w0000gn/T/open-uri20140216-5304-14krykj", "1.gif"
    
    # open("/Users/jinwanlin/workspace/test3/public/#{page}-#{index}#{type}", "wb") do |file|
    #   file.write(file2)
    # end
        
    
    # File.open(File.basename(uri),'wb'){ |f| f.write(open(uri).read) }
    
    # Net::HTTP.start("http://www.google.com.hk") { |http|
    #   resp = http.get("/images/srpr/logo11w.png")
    #   open("/Users/jinwanlin/workspace/test3/public/11.png", "wb") do |file|
    #     file.write(resp.body)
    #   end
    # }
    
    # Net::HTTP.start("www.google.com.hk") { |http|
    #   resp = http.get("/images/srpr/nav_logo27.png")
    #   open("/Users/jinwanlin/workspace/test3/public/11.png", "wb") { |file|
    #     file.write(resp.body)
    #    }
    # }
    # puts "OK"
  end
  
  
  
  def state_
    case self.state
      when "up" then "已上架"
      when "down" then "已下架"
      when "file" then "已归档"
    end
  end
  

  
  private
  def generate_product_sn
    previous_product=Product.last
    previous_id = previous_product.present? ? previous_product.id : 0
    self.sn = (previous_id+1).to_s.rjust(6, '0') unless self.sn 
  end  
  
end
