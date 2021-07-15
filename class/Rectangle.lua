---
--- Generated by Luanalysis
--- Created by Administrator.
--- DateTime: 2021/7/15 9:34
---
--[[
使用demo
require("class.Rectangle")
-- 创建对象
r = Rectangle:new(nil,10,20)
r:printArea ()
--]]


-- 元类
Rectangle = {area = 0, length = 0, breadth = 0}

-- 派生类的方法 new
function Rectangle:new (o,length,breadth)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.length = length or 0
    self.breadth = breadth or 0
    self.area = length*breadth;
    return o
end

-- 派生类的方法 printArea
function Rectangle:printArea ()
    print("矩形面积为 ",self.area)
end

return Rectangle