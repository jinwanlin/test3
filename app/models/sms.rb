# encoding: utf-8
class SMS
  
   MSG={"-1" => "没有该用户账户", "-2" => "密钥不正确 [查看密钥]", "-3" => "短信数量不足", "-11" => "该用户被禁用", "-14" => "短信内容出现非法字符", "-4" => "手机号格式不正确", "-41" => "手机号码为空", "-42" => "短信内容为空", "-51" => "短信签名格式不正确, 接口签名格式为：【签名内容】", "大于0" => "短信发送数量"}
  
  def self.send(phone, content)
    return unless phone || content
    url = URI.escape("http://utf8.sms.webchinese.cn/?Uid=wanlinjin&Key=caa74871061793420615&smsMob=#{phone}&smsText=#{content}")
    code = open(url).read.to_i
    if code > 0
      #短信发送数量
      code
    else
      MSG[code]
    end  
  end
  
end
