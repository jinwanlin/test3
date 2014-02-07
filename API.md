caicai-api
==========
##注册  
####1、输入手机号，系统发送验证码到客户手机上
接口：/api/users/sign_up  
参数：
<pre>
	user[phone]=18628405091
</pre>  

返回值:  
<pre>
	{"state":false,"message":"手机号已注册过，请登录或找回密码。"}  
	或  
	{"state":true}
</pre>  
返回值说明：  
state：成功（true），失败（false）  
message：失败原因  


----
####2、输入短信验证码校验

接口：/api/users/validate  
参数：
<pre>
	user[phone]=18628405091  
	user[validate_code]=2813
</pre>  
返回值:  
<pre>
	{"state":true,"message":null,"user":{"id":3,"phone":18628405091}}
</pre>  
返回值说明：  
state：成功（true），失败（false）  
message：失败原因  
user：若成功，则返回用户信息;若失败则无用户信息返回

----
####3、设置密码
接口：/api/users/set_password  
参数：
<pre>
	user[id]=3  
	user[password]=密码明码
</pre>  
返回值:  
<pre>
	{"state":true}
</pre>  
返回值说明：  
state：成功（true），失败（false）  

----

