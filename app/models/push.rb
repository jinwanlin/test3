# encoding: utf-8
# 百度推送
# API： http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/api/list#query_app_ioscert
class Push
  include HTTParty
  
  API_KEY="mCqu3uWG1zp8tAoAaG9s8kyg"
  SECRET_KEY="5iDdYfmQ4buOUYWvouityAMPjdSNaX1x"
  BASE_PARAMS={apikey: API_KEY, device_type: 3}
  
  # message_type 0：消息 1：通知
  # msg_keys
  def push_msg(user_id, message_type, content)
    url = "http://channel.api.duapp.com/rest/2.0/channel/channel"
    msg_keys = Time.now.to_i.to_s + (0...6).map{ ('0'..'9').to_a[rand(10)] }.join
    
    params = {user_id: user_id, message_type: message_type, messages: content, method: "push_msg", msg_keys: msg_keys, push_type: 1, timestamp: Time.now.to_i}
    params = params.merge(BASE_PARAMS)
    
    sign = get_sign("POST", url, params)
    params = params.merge(sign: sign)
    p get_str(params)
    options = { :body => params }
    response = self.class.post(url, options)
    puts response.body
    
  end
  

  def query_user_tags  
    params = {}
  end
  
  def verify_bind  
    channel_id="124343-32323-12323"
    url = "https://channel.api.duapp.com/rest/2.0/channel/#{channel_id}"
    params = {method: "verify_bind", user_id: '2303154', timestamp: Time.now.to_i}
    params = params.merge(BASE_PARAMS)
    sign = get_sign("GET", url, params)
    params = params.merge(sign: sign)
    
    url = "#{url}?#{get_str(params)}"
    p url
    response = self.class.get(url)
    puts response.body, response.code, response.message, response.headers.inspect
    
  end
  
  def query_bindlist
    channel_id="channel"
    url = "https://channel.api.duapp.com/rest/2.0/channel/#{channel_id}"
    params = {method: "query_bindlist", user_id: '2303154', timestamp: Time.now.to_i}
    params = params.merge(BASE_PARAMS)
    sign = get_sign("GET", url, params)
    params = params.merge(sign: sign)
    
    response = self.class.get("#{url}?#{get_str(params)}")
    puts response.body
  end
  
  
  def get_sign_up_validate_code
    url = "http://lvh.me:3000/api/v2/users/get_sign_up_validate_code"
    
    params = {:"user[phone]" => "15657715363"}
    
    options = { :body => params }
    response = self.class.post(url, options)
    puts response.body
    
  end
  
  private
  # 生成签名
  def get_sign(method, url, params)
    str = ""
    str << method
    str << url
    str << array_to_s(sorted_hash(params))
    str << SECRET_KEY
    str = Rack::Utils.escape str
    Digest::MD5::hexdigest(str)
  end
  
  # 哈希排序
  def sorted_hash(aHash)
     return aHash.sort{|a,b| a.to_s <=> b.to_s  }
  end
  
  # 数组转字符串，用于计算sign
  def array_to_s(arr)
    str = ""
    arr.each do |a|
      str << "#{a[0]}=#{a[1]}"
    end
    str
  end

  def get_str(params)
    str = ""
    params.each do |k, v|
      str << "&#{k}=#{v}"
    end
    str[1..str.length]
  end

  
end
