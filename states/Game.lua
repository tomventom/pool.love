local Game = {}

local Camera = require("hump.camera")

local sw = love.graphics.getWidth()
local sh = love.graphics.getHeight()

local EntityMgr = require("lib.EntityMgr")
local vector = require("hump.vector")

local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local Slider = require("lib.ui.Slider")
local TextField = require("lib.ui.TextField")

local kb = love.keyboard
local mx, my = 0, 0

local Ball = require("lib.Ball")
local balls = {}

local pulling = false
local pullX, pullY = 0, 0
local pullStartX, pullStartY = 0, 0

function Game:init()
    self.em = EntityMgr()

    self.label = Label(0, 20, sw, 40, "Collision")
    self.em:add(self.label)
    self.balls = {}
    self.b1 = Ball(1, 600, 300, Utils.color(255))
    self.b2 = Ball(2, 200, 275, Utils.color(255, 0, 0))
    self.b3 = Ball(3, 200, 300, Utils.color(255, 0, 0))
    self.b4 = Ball(4, 200, 325, Utils.color(255, 0, 0))
    self.b5 = Ball(5, 220, 312.5, Utils.color(255, 0, 0))
    self.b6 = Ball(6, 220, 287.5, Utils.color(255, 0, 0))
    self.b7 = Ball(7, 240, 300, Utils.color(255, 0, 0))
    self.balls[#self.balls + 1] = self.b1
    self.balls[#self.balls + 1] = self.b2
    self.balls[#self.balls + 1] = self.b3
    self.balls[#self.balls + 1] = self.b4
    self.balls[#self.balls + 1] = self.b5
    self.balls[#self.balls + 1] = self.b6
    self.balls[#self.balls + 1] = self.b7
    self.em:add(self.b1)
    self.em:add(self.b2)
    self.em:add(self.b3)
    self.em:add(self.b4)
    self.em:add(self.b5)
    self.em:add(self.b6)
    self.em:add(self.b7)
end

function Game:enter()
    self.em:onEnter()
end

function Game:leave()
    self.em:onExit()
end

function Game:update(dt)
    self.em:update(dt)

    mx, my = love.mouse.getPosition()

    -- Calculate Collisions
    for i = 1, #self.balls do
        for b = i, #self.balls do
            if Utils.circleCol(self.balls[i], self.balls[b]) then
                print(string.format("balls %d and %d collided", self.balls[i].id, self.balls[b].id))
                self.balls[i].hit, self.balls[b].hit = true, true
                self.balls[i].collisions = self.balls[i].collisions + 1
                self.balls[b].collisions = self.balls[b].collisions + 1
            else
                self.balls[i].hit, self.balls[b].hit = false, false
            end
        end
    end

    -- Calculate Accumulators
    for i = 1, #self.balls do
        for b = i, #self.balls do
            if Utils.circleCol(self.balls[i], self.balls[b]) then
                self.balls[i].hit, self.balls[b].hit = true, true

                local angle1 = (self.balls[i].pos - self.balls[b].pos):trimmed(self.balls[i].r)
                local angle2 = (self.balls[b].pos - self.balls[i].pos):trimmed(self.balls[b].r)
                local b1Vel, b2Vel = self.balls[i].velocity, self.balls[b].velocity

                self.balls[i].accumulator = self.balls[i].accumulator + (angle1:normalized() * (b1Vel:len() + b2Vel:len()) / self.balls[i].collisions)
                self.balls[b].accumulator = self.balls[b].accumulator + (angle2:normalized() * (b1Vel:len() + b2Vel:len()) / self.balls[b].collisions)
            end
        end
    end

    -- Add Accumulators to Velocity, reset values
    for i = 1, #self.balls do
        if self.balls[i].hit then
            self.balls[i].velocity = self.balls[i].velocity + self.balls[i].accumulator
            self.balls[i].collisions = 0
            self.balls[i].accumulator = vector(0, 0)
            self.balls[i].hit = false
        end
    end

    if pulling then
        pullX = mx - pullStartX
        pullY = my - pullStartY
    end

end

function Game:keypressed(key)
    if key == "escape" then
        -- Gamestate.switch(Menu)
        love.event.quit()
    end
end

function Game:mousepressed(x, y, key)
    if key == 1 then
        pulling = true
        pullStartX, pullStartY = self.b1.pos.x, self.b1.pos.y
    end
end

function Game:mousereleased(x, y, key)
    if key == 1 then
        if pulling then
            pulling = false
            self.b1:shoot(vector(x, y), vector(pullX, pullY))
        end
    end
end

function Game:draw()
    love.graphics.clear(128, 128, 128)
    self.em:draw()
    if pulling then
        love.graphics.line(pullStartX, pullStartY, mx, my)
    end
end

return Game
