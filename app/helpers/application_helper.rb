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
  
end
