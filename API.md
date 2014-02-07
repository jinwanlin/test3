caicai-api
==========
#注册、登陆、忘记密码、修改密码
##注册  
####1、输入手机号，系统发送验证码到客户手机上
接口：code/api/users/sign_up  
参数：
```ruby
	user[phone]=18628405091  #手机号
```
返回值:  
```ruby
	{
		"state":false,  #成功（true），失败（false） 
		"message":"手机号已注册过，请登录或找回密码。"  #失败原因  
	}  
``` 

----
####2、输入短信验证码校验

接口：/api/users/validate  
参数：
```ruby
	user[phone]=18628405091  
	user[validate_code]=2813
``` 
返回值:  
```ruby
	{
		"state":true,  #成功（true），失败（false） 
		"message":null,  #失败原因  
		"user":{  #若成功，则返回用户信息;若失败则无用户信息返回
			"id":3,
			"phone":18628405091
		}
	}
```

----
####3、设置密码
接口：/api/users/set_password  
参数：
```ruby
	user[id]=3  
	user[password]=abc123  #密码明码
```
返回值:  
```ruby
	{
		"state":true  #成功（true），失败（false）
	}
``` 

----

##登陆  
接口：/api/users/sign_in  
参数：
```ruby
	user[phone]=15657715360  
	user[password]=abc123  #密码明码
``` 
返回值:  
```ruby
	{
		"state":true,  #成功（true），失败（false） 
		"user":{  
			"id":1,  
			"name":"成都小吃",  
			"phone":15657715360,  
			"token":"66a26195a3aec740ca2274a16d1c6bd0",  
			"address":"",  #完整地址
			"latitude":null,  #纬度
			"longitude":"",  #经度
			"state":"actived",  #actived（可用）
			"desc":""  
		}
	}
```


##忘记密码
  
##修改密码

#商品列表
##蔬菜列表

#订单
##订单列表
##订单明细
##最后一条订单明细

#账单
##账单列表

