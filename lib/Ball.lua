local Class = require("lib.Class")
local vector = require("hump.vector")

local Ball = Class:derive("Ball")

local maxForce = 100

function Ball:new(id, x, y, gameTable, color, r)
    self.id = id
    self.pos = vector(x, y)
    self.color = color or Utils.color(255)
    self.r = r or 10
    self.table = gameTable
    self.velocity = vector(0,0)
    self.hit = false

    self.accumulator = vector(0,0)
    self.collisions = {}
end

function Ball:shoot(target, forceVec)
    local dir = (target - self.pos):normalized()
    print(forceVec:trimInplace(300):len())
    self.velocity = (dir * (forceVec:trimInplace(300):len()*1.5)) * -1
    -- print(self.velocity)

end

function Ball:update(dt)
    if self.pos.x <= self.table.pos.x + self.r/2 then
        self.pos.x = self.table.pos.x + self.r/2+1
        -- self.velocity.x = self.velocity.x * -1
        self.velocity = .8 * (-2 * (self.velocity * vector(1, 0)) * vector(1, 0) + self.velocity)

    elseif self.pos.x >= self.table.pos.x + self.table.width - self.r/2 then
        self.pos.x = self.table.pos.x + self.table.width - self.r-1
        self.velocity = .8 * (-2 * (self.velocity * vector(-1, 0)) * vector(-1, 0) + self.velocity)

    elseif self.pos.y <= self.table.pos.y + self.r/2 then
        self.pos.y = self.table.pos.y + self.r/2+1
        self.velocity = .8 * (-2 * (self.velocity * vector(0, 1)) * vector(0, 1) + self.velocity)

    elseif self.pos.y >= self.table.pos.y + self.table.height - self.r/2 then
        self.pos.y = self.table.pos.y + self.table.height - self.r/2-1
        self.velocity = .8 * (-2 * (self.velocity * vector(0, -1)) * vector(0, -1) + self.velocity)
    end

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
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.r)
    love.graphics.setColor(r,g,b,a)
end

return Ball
