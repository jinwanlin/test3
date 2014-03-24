# encoding: utf-8
class SMS
  
   MSG={"-1" => "没有该用户账户", "-2" => "密钥不正确", "-3" => "短信数量不足", "-11" => "该用户被禁用", "-14" => "短信内容出现非法字符", "-4" => "手机号格式不正确", "-41" => "手机号码为空", "-42" => "短信内容为空", "-51" => "短信签名格式不正确, 接口签名格式为：【签名内容】"}
  
  def self.send(phone, content)
    p Socket.gethostname
    if Socket.gethostname == "AY131203213614306c1aZ_" #只有服务器才发送短信
      url = URI.escape("http://utf8.sms.webchinese.cn/?Uid=wanlinjin&Key=caa74871061793420615&smsMob=#{phone}&smsText=#{content}")
      code = open(url).read.to_i
    else
      1 #假设发送成功
    end
  end
  
end
