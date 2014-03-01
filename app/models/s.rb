# encoding: utf-8
class S < ActiveRecord::Base
  
  URL = "http://fr.xxxzc.com/bbs/"
  
  def self.a(href) 
    uri = URL+href 
    p "uri------#{uri}"
    doc = Nokogiri::HTML(open(uri))
    doc.css('a').map do |link| 
      
      open_show link
      
      if link.content == " ‹‹ 上一主题"
        b link.attribute('href').to_s
      end
      
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
  
  # def self.c
  #   href = "http://himg2.huanqiu.com/attachment2010/2012/0427/20120427110724849.jpg"
  #   show = Nokogiri::HTML(open(href))
  #   show.css('div.t_msgfont img').each_with_index.map do |img, index| 
  #     src = img.attribute('src').to_s
  #     p src
  #     type = src[src.rindex(".")..src.length]
  #     
  #     # Net::HTTP.start(domain) { |http|
  #     #   resp = http.get(dir)
  #     #   open("/Users/jinwanlin/workspace/test3/public/#{page}-#{index}#{type}", "wb") { |file|
  #     #     file.write(resp.body)
  #     #    }
  #     # }
  #     tmpfile = open(src)
  #     FileUtils.copy tmpfile.path, "/Users/jinwanlin/s/#{page}-#{index}#{type}"
  #     tmpfile.close(true)
  #   end
  #   
  # end
  
   #  
  # def self.d
  #   
  #   # page = "1"
  #   # index = "2"
  #   # src = "www.huanqiu.com/attachment2010/2012/0427/20120427110713918.jpg"
  #   # domain = src[0...src.index("/")]
  #   # dir = src[src.index("/")..src.length]
  #   # type = src[src.rindex(".")..src.length]
  #   # 
  #   # p domain
  #   # p dir
  #   # p type
  #   # 
  #   # Net::HTTP.start(domain) { |http|
  #   #   resp = http.get(dir)
  #   #   resp = open(src)
  #   #   open("/Users/jinwanlin/workspace/test3/public/#{page}-#{index}#{type}", "wb") do |file|
  #   #     file.write(resp.body)
  #   #   end
  #   # }
  #   
  #   # url = 'http://www.google.com.hk/images/srpr/logo11w.png'
  #   url = "http://himg2.huanqiu.com/attachment2010/2012/0427/20120427110721202.jpg"
  #   # url = "http://mimg.127.net/logo/163logo.gif"
  #   
  #   tmpfile = open(url)
  #   FileUtils.copy tmpfile.path, "/Users/jinwanlin/s/a.jpg"
  #   tmpfile.close(true)
  #   
  #   # FileUtils.cp "/var/folders/c7/lthglljn62b3s7jc3fnbk42w0000gn/T/open-uri20140216-5304-14krykj", "1.gif"
  #   
  #   # open("/Users/jinwanlin/workspace/test3/public/#{page}-#{index}#{type}", "wb") do |file|
  #   #   file.write(file2)
  #   # end
  #       
  #   
  #   # File.open(File.basename(uri),'wb'){ |f| f.write(open(uri).read) }
  #   
  #   # Net::HTTP.start("http://www.google.com.hk") { |http|
  #   #   resp = http.get("/images/srpr/logo11w.png")
  #   #   open("/Users/jinwanlin/workspace/test3/public/11.png", "wb") do |file|
  #   #     file.write(resp.body)
  #   #   end
  #   # }
  #   
  #   # Net::HTTP.start("www.google.com.hk") { |http|
  #   #   resp = http.get("/images/srpr/nav_logo27.png")
  #   #   open("/Users/jinwanlin/workspace/test3/public/11.png", "wb") { |file|
  #   #     file.write(resp.body)
  #   #    }
  #   # }
  #   # puts "OK"
  # end
  
  
end
