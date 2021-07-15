--增加common,config目录
package.path = "/usr/local/openresty/lualib/vevor-lua/?.lua;" .. package.path
--ngx.say(package.cpath)
--ngx.say(package.path)

--引入配置文件
require("config.conf")
require("class.RestyRedisClass")
--测试类
local aredis=RestyRedisClass:new(nil,conf_arr.resty_redis['hostname'],conf_arr.resty_redis['port'])
aredis:setName('1111',os.date("%Y-%m-%d %H:%M:%S"))


--引入单机版redis模块
require("common.resty-redis")
local dredis = resty_redis.init(conf_arr.resty_redis['hostname'],conf_arr.resty_redis['port']);

--获取独立站配置数据
local site_data = resty_redis.getName(conf_arr.site_data_key)
--判断redis的null
if site_data == ngx.null  then
    ngx.say('{"code":"204","msg":"请设置独立站数据"}')
	ngx.exit(ngx.HTTP_OK)
end

--设置数据
resty_redis.hsetName("keys","code,code31",os.date("%Y-%m-%d %H:%M:%S")..",111")


--处理ip返回国家编码
local cjson = require 'cjson'
local geo = require 'resty.maxminddb'
local arg_ip = ngx.var.arg_ip
--local arg_node=ngx.var.arg_node
--ngx.say("IP:",arg_ip,", node:",arg_node,"<br>")


--没有传递ip
if not arg_ip then
    arg_ip = ngx.var.remote_addr
end

if not geo.initted() then
    geo.init("/usr/local/openresty/lualib/vevor-lua/geoip/GeoLite2-Country.mmdb")
end

--当前服务部署的ip
--ngx.say("当前服务部署ip:",ngx.var.remote_addr)

local res, err = geo.lookup(arg_ip or ngx.var.remote_addr)

if not res then
    --获取不到ip，默认返回参数
    local result = '{"msg": "success","code": 200,"country": {    "name_cn": "United States",    "name_en": "美国",    "code": "US"},"remote_ip": "' .. ngx.var.remote_addr .. '","continent": {    "name_cn": "北美洲",    "name_en": "North America",    "code": "NA"},"default":1}';
    ngx.say(result)
    ngx.log(ngx.ERR, ' failed to lookup by ip , reason :', err)
else
    --原始数据
    --[[
    ngx.say(cjson.encode(res))
    ngx.exit(200)
    --]]

    --提取数据
    local result = {
        code = 200,
        country = {
            code = res['country']['iso_code'], --国家编码
            name_en = res['country']['names']['en'],
            name_cn = res['country']['names']['zh-CN']
        },
        continent = {
            code = res['continent']['code'], --大陆编码
            name_en = res['continent']['names']['en'],
            name_cn = res['continent']['names']['zh-CN']
        },
        remote_ip = ngx.var.remote_addr,
        msg = "success",
        default = 0
    }
    ngx.say(cjson.encode(result))

    --ngx.say("Result:",cjson.encode(res))

    if arg_node then
        ngx.say("node name:", ngx.var.arg_node, " , value:", cjson.encode(res[ngx.var.arg_node] or {}))
    end

end

ngx.exit(ngx.HTTP_OK)
