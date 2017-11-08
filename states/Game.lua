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
local mx, my = 0,0

local collisions = {}
local movements = {}

local Ball = require("lib.Ball")
local balls = {}

local pulling = false
local pullX, pullY = 0,0
local pullStartX, pullStartY = 0,0

function Game:init()
    self.em = EntityMgr()

    self.label = Label(0, 20, sw, 40, "Collision")
    self.em:add(self.label)
    self.balls = {}
    self.b1 = Ball(1, 600, 300, Utils.color(255))
    self.b2 = Ball(2, 200, 300, Utils.color(255, 0, 0))
    self.b3 = Ball(3, 230, 300, Utils.color(255, 0, 0))
    self.b4 = Ball(4, 260, 300, Utils.color(255, 0, 0))
    self.balls[#self.balls + 1] = self.b1
    self.balls[#self.balls + 1] = self.b2
    self.balls[#self.balls + 1] = self.b3
    self.balls[#self.balls + 1] = self.b4
    self.em:add(self.b1)
    self.em:add(self.b2)
    self.em:add(self.b3)
    self.em:add(self.b4)
end

function Game:enter()
    self.em:onEnter()
end

function Game:leave()
    self.em:onExit()
end

local function handleCollisions(b1, b2, b1Pos, b2Pos, b1Vel, b2Vel)
    print("handling collision")
    if not b2Vel then return end
    local angle1 = (b1Pos - b2Pos):trimInplace(b1.r)
    local angle2 = (b2Pos - b1Pos):trimInplace(b2.r)
    local b1NewVel = b1Vel + angle1:normalized() * ((b1Vel:len()+b2Vel:len()) / 2)
    local b2NewVel = b2Vel + angle2:normalized() * ((b2Vel:len()+b1Vel:len()) / 2)
    -- b1.hit, b2.hit = false,false

    movements[#movements+1] = {b1, b2, b1NewVel, b2NewVel}
    return true
end

function Game:update(dt)
    self.em:update(dt)

    mx, my = love.mouse.getPosition()

    for i = 1, #self.balls do
        for b = 1, #self.balls do
            if self.balls[i] ~= self.balls[b] then
                if Utils.circleCol(self.balls[i], self.balls[b]) then
                    if not self.balls[i].hit and not self.balls[b].hit then
                        self.balls[i].hit, self.balls[b].hit = true, true
                        print(string.format("balls %d and %d collided", self.balls[i].id, self.balls[b].id))
                        collisions[#collisions + 1] = {self.balls[i], self.balls[b], self.balls[i].pos, self.balls[b].pos, self.balls[i].velocity, self.balls[b].velocity}
                    end
                end
            end
        end
    end

    for i = 1, #collisions do
        if handleCollisions(unpack(collisions[i])) then
            print("done")
        end
    end
    collisions = {}

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
        pullStartX, pullStartY = x, y
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
