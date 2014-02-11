### JSON接口目录  
  1. [注册](#注册)  
  2. [登陆](#登陆)  
  3. [商品列表](#商品列表)  
  4. [订单列表](#订单列表)  
  5. [订单明细](#订单明细)  
  6. [账单列表](#账单列表)  

==========
#注册、登陆、忘记密码、修改密码
##注册  
####1、输入手机号，系统发送验证码到客户手机上
接口：http://115.28.160.65/api/users/sign_up  
方法：POST  
参数：
```ruby
	user[phone]=18628405091  #手机号
	user[password]=11111111  #密码
```
返回值:  
```ruby
	{
		"state":true,  #成功（true），失败（false）
		"message":"\u8bf7\u8f93\u5165\u77ed\u4fe1\u6821\u9a8c\u7801",
		"user":{
			"id":3,
			"name":null,
			"phone":18628405021,
			"token":"cbc320f76a34a1db3c2e8f0b1c74386f",
			"address":"",  #完整地址
			"latitude":null,  #纬度
			"longitude":null,  #经度
			"state":"unvalidate",  #unvalidate（待输入校验码校验）actived（可用）
			"level":1,
			"desc":null
		}
	}
``` 

----
####2、输入短信验证码校验

接口：http://115.28.160.65/api/users/validate  
方法：POST  
参数：
```ruby
	user[id]=4
	user[validate_code]=2813
``` 
返回值:  
```ruby
	{
		"state":true,  #成功（true），失败（false） 
		"message":"验证成功",  #验证成功  或  验证失败 
	}
```


----

##登陆  
接口：http://115.28.160.65/api/users/sign_in  
方法：POST  
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
接口：http://115.28.160.65/api/products  
方法：GET  
参数：
```ruby
	user[id]=1
	user[level]=3
	type=Vegetable  #蔬菜
	last_update_at=2014-02-08T10:28:07+08:00  #上次更新时间
``` 
返回值:  
```ruby
{
  "user": {
    "level": 1
  },
  "now": "2014-02-11T13:26:04+08:00",
  "products": [{
    "id": 361,
    "sn": "000001",
    "name": "\u5927\u767d\u83dc",
    "type": "Vegetable",
    "amounts": [1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 20, 25, 30],
    "price": 0.0,
    "nuit": "\u5343\u514b"
  },
  {
    "id": 368,
    "sn": "000368",
    "name": "\u97ed\u83dc",
    "type": "Vegetable",
    "amounts": [1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 20, 25, 30],
    "price": 2.59,
    "nuit": "\u5343\u514b"
  },
  {
    "id": 369,
    "sn": "000369",
    "name": "\u849c\u82d7",
    "type": "Vegetable",
    "amounts": [1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 20, 25, 30],
    "price": 3.73,
    "nuit": "\u5343\u514b"
  }]
}
```

#订单
####购买
方法：POST  
接口：http://115.28.160.65/api/order_items  
参数：
```ruby
	user[id]=4
	order_item[product_id]=2813
	order_item[order_amount]=15
``` 
返回值:  
```ruby
	{
		"state":true,  #成功（true），失败（false） 
		"message":"验证成功",  #验证成功  或  验证失败 
	}
```


----

##订单列表
接口：http://115.28.160.65/api/orders  
方法：GET  
参数：
```ruby
	user[id]=1
	last_update_at=2013-03-03  #上次更新时间
``` 
返回值:  
```ruby
{
	"now":"2014-02-08T10:28:07+08:00",
	"orders":[{
		"id":1,
		"created_date":"2013-03-03",
		"amount":1.8
	}]
}
```
##订单明细
接口：http://115.28.160.65/api/orders/{id}  
方法：GET  
参数：无  
返回值:  
```ruby
	{
		"id":1,
		"created_date":"2013-03-03",
		"amount":1.8
	}
```



#账单
接口：http://115.28.160.65/api/bills  
方法：GET  
参数：
```ruby
	user[id]=1
	last_update_at=2013-03-03  #上次更新时间
``` 
返回值:  
```ruby
{
	"now":"2014-02-08T10:28:07+08:00",
	"bills":[{
		"id":1,,
		"amount":1.8
		"created_date":"2013-03-03"
	}]
}
```

