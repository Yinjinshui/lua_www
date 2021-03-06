---
--- Generated by Luanalysis
--- Created by Administrator.
--- DateTime: 2021/7/15 10:03
---
---
local redis = require "resty.redis"
RestyRedisClass={redisObj={}}

-- 派生类的方法 new
function RestyRedisClass:new (o,hostname,port)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.redisObj = redis:new()
    self.redisObj:set_timeouts(1000, 1000, 1000) -- 1 sec
    --lua 连接redis
    local ok,err = self.redisObj:connect(hostname, port)

    if not ok then
        ngx.say('{"code":"203","msg":'..err..'}')
        ngx.exit(200)
    end
    return o
end


--设置数据
function RestyRedisClass:setName(key,value)
    local ok,err = self.redisObj:set(key,value)
    if not ok then
        ngx.say('{"code":"203","msg":'..err..'}')
        ngx.exit(200)
    end
    return true
end

return RestyRedisClass