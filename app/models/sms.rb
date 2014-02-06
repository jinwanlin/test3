# encoding: utf-8
class SMS
  
  def self.send_sms(phone, content)
    path = "http://utf8.sms.webchinese.cn/?Uid=wanlinjin&Key=caa74871061793420615&smsMob=#{phone}&smsText=#{content}"
    
    @conn = Faraday.new(url: "http://utf8.sms.webchinese.cn") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    response = @conn.get do |req|
      # req.url path
      req.params['Uid'] = "wanlinjin_"
      req.params['Key'] = "caa74871061793420615"
      req.params['smsMob'] = phone
      req.params['smsText'] = content
      req.params.merge! params
    end
    json = JSON.parse response.body
    
    p json
  end
  
  
  def self.aa
    conn = Faraday.new(:url => 'http://sushi.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
  end
  
end
