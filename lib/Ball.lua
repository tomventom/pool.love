local Class = require("lib.Class")
local vector = require("hump.vector")

local Ball = Class:derive("Ball")

local maxForce = 100

function Ball:new(id, x, y, color, r)
    self.id = id
    self.pos = vector(x, y)
    self.color = color or Utils.color(255)
    self.r = r or 10

    self.velocity = vector(0,0)
    self.hit = false

    self.accumulator = vector(0,0)
    self.collisions = 0
end

function Ball:shoot(target, forceVec)
    local dir = (target - self.pos):normalized()
    print(forceVec:trimInplace(300):len())
    self.velocity = (dir * (forceVec:trimInplace(300):len()*2)) * -1
    -- print(self.velocity)

end

function Ball:update(dt)
    local friction = self.velocity:clone()
    friction = friction * -1
    friction:normalizeInplace()
    friction = friction * .5
    self.pos = self.pos + (self.velocity * dt)
    self.velocity = self.velocity + friction
end

function Ball:draw()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(self.color)
    love.graphics.circle("line", self.pos.x, self.pos.y, self.r)
    love.graphics.setColor(r,g,b,a)
end

return Ball
