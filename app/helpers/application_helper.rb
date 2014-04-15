# encoding: utf-8
module ApplicationHelper
  
  def price_format(price)
    # sprintf('%.2f', price) if price
    sprintf('%.2f', (price * 100).round / 100.0) if price
  end
  
  # 冒泡排序
  def getSort(arr)
    len = arr.length
    for i in 0...len-1
      for j in 0...len-i-1
        if arr[j].pinyin > arr[j+1].pinyin
          temp = arr[j]
          arr[j] = arr[j+1]
          arr[j+1] = temp
        end
      end
    end
    arr
  end
  
  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end
  
  def date_str(date)
    days = Date.today - date
    case days
      when 0 then "今天"
      when 1 then "昨天"
      when 2 then "前天"
      else date.to_s
    end
    
  end
  
end
