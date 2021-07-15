---
--- 根据ip识别国家编码 返回国家支持的国家编码，显示对应的币种
--- Created by Administrator.
--- DateTime: 2021/7/15 10:28
---
--增加common,config目录
package.path = "/usr/local/openresty/lualib/vevor-lua/?.lua;" .. package.path

--引入配置文件
require("config.conf")
require("class.RestyRedisClass")
require("common.common_func")

--单机版
local redisObj=RestyRedisClass:new(nil,conf_arr.resty_redis['hostname'],conf_arr.resty_redis['port'],conf_arr.resty_redis['passwd'],conf_arr.resty_redis['database'])

--获取支持的语言种类
local seriailzestr  = redisObj:getName(conf_arr.site_language_code)
local sertab  = common_func.unserialize(seriailzestr)
--ngx.say(type(sertab))

for k,v in pairs(sertab) do
    ngx.say(k,"=",v)
end