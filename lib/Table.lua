local Class = require("lib.Class")
local vector = require("hump.vector")

local Table = Class:derive("Table")

function Table:new(width, height)
    self.width, self.height = width, height
    self.pos = vector(ScreenWidth/2 - width/2, ScreenHeight/2 - height/2)
    self.ballPoint = vector(self.pos.x + (width/4), (self.pos.y + height/2))
end

function Table:draw()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(10, 108, 3)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height, 10, 10)
    love.graphics.setColor(r,g,b,a)
end

return Table
