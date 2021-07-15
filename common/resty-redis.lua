--[[
git 地址：https://github.com/openresty/lua-resty-redis#installation
des:单机版
author:yjs
since:210714
]]--
resty_redis = {}

--redis初始化
function resty_redis.init(hostname,port)
    local redis = require "resty.redis"
    red = redis:new()
    red:set_timeouts(1000, 1000, 1000) -- 1 sec
    --lua 连接redis
    local ok,err = red:connect(hostname, port)

    if not ok then
        ngx.say('{"code":"203","msg":'..err..'}')
        ngx.exit(200)
    end
    return red
end

--设置数据
function resty_redis.setName(key,value)
    local ok,err = red:set(key,value)
    if not ok then
        ngx.say('{"code":"203","msg":'..err..'}')
        ngx.exit(200)
    end
    return true
end

--获取数据
function resty_redis.getName(key)
    local res,_=red:get(key)
    return res
end

--设置hash数据
function resty_redis.hsetName(key,field,value)
    local ok,err = red:hset(key,field,value)
    if not ok then
        ngx.say('{"code":"203","msg":'..err..'}')
        ngx.exit(200)
    end
    return true
end


--设置hash数据
function resty_redis.hgetName(key,field,value)
    local res,_ = red:hget(key,field,value)
    return res
end



return resty_redis
