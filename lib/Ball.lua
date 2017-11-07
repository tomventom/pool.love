local Class = require("lib.Class")
local vector = require("hump.vector")

local Ball = Class:derive("Ball")

function Ball:new(id, color, x, y)
    self.id = id
    self.color = color
    self.pos = vector(x, y)
end

function Ball:update(dt)

end

function Ball:draw()
    love.graphics.circle("fill", self.pos.x, self.pos.y, 10, 30)
end

return Ball
