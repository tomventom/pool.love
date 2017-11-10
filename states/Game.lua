local Game = {}

local Camera = require("hump.camera")

ScreenWidth = love.graphics.getWidth()
ScreenHeight = love.graphics.getHeight()

local EntityMgr = require("lib.EntityMgr")
local vector = require("hump.vector")

local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local Slider = require("lib.ui.Slider")
local TextField = require("lib.ui.TextField")

local kb = love.keyboard
local mx, my = 0, 0

local Table = require("lib.Table")
local Ball = require("lib.Ball")
local balls = {}

local pulling = false
local pullX, pullY = 0, 0
local pullStartX, pullStartY = 0, 0

function Game:init()
    self.em = EntityMgr()

    self.label = Label(0, 20, ScreenWidth, 40, "Collision")
    self.em:add(self.label)
    self.table = Table(800, 400)
    self.em:add(self.table)
    self.table.layer = 0
    self.b0 = Ball(0, self.table.pos.x + self.table.width - self.table.width / 4, self.table.ballPoint.y, self.table, Utils.color(255))
    self.b1 = Ball(1, self.table.ballPoint.x, self.table.ballPoint.y - 25, self.table, Utils.color(255, 255, 0))
    self.b2 = Ball(2, self.table.ballPoint.x - 20, self.table.ballPoint.y - 12.5, self.table, Utils.color(0, 0, 255))
    self.b3 = Ball(3, self.table.ballPoint.x, self.table.ballPoint.y, self.table, Utils.color(0, 0, 0))
    self.b4 = Ball(4, self.table.ballPoint.x, self.table.ballPoint.y + 25, self.table, Utils.color(128, 0, 128))
    self.b5 = Ball(5, self.table.ballPoint.x - 20, self.table.ballPoint.y + 12.5, self.table, Utils.color(255, 69, 0))
    self.b6 = Ball(6, self.table.ballPoint.x + 20, self.table.ballPoint.y + 12.5, self.table, Utils.color(0, 255, 0))
    self.b7 = Ball(7, self.table.ballPoint.x + 20, self.table.ballPoint.y - 12.5, self.table, Utils.color(165, 42, 42))
    self.b8 = Ball(8, self.table.ballPoint.x + 40, self.table.ballPoint.y, self.table, Utils.color(255, 0, 0))
    self.em:add(self.b0)
    self.em:add(self.b1)
    self.em:add(self.b2)
    self.em:add(self.b3)
    self.em:add(self.b4)
    self.em:add(self.b5)
    self.em:add(self.b6)
    self.em:add(self.b7)
    self.em:add(self.b8)
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
    for i = 1, #self.em.entities do
        if self.em.entities[i]:is(Ball) then
            for b = i + 1, #self.em.entities do
                if self.em.entities[b]:is(Ball) then
                    if Utils.circleCol(self.em.entities[i], self.em.entities[b]) then
                        self.em.entities[i].hit, self.em.entities[b].hit = true, true
                        table.insert(self.em.entities[i].collisions, self.em.entities[b])
                        table.insert(self.em.entities[b].collisions, self.em.entities[i])
                        print(string.format("%d cols: %d  %d cols: %d", self.em.entities[i].id, #self.em.entities[i].collisions, self.em.entities[b].id, #self.em.entities[b].collisions))
                    else
                        self.em.entities[i].hit, self.em.entities[b].hit = false, false
                    end
                end
            end
        end
    end

    -- Calculate Accumulators
    for i = 1, #self.em.entities do
        if self.em.entities[i]:is(Ball) then
            for c = 1, #self.em.entities[i].collisions do
                self.em.entities[i].hit, self.em.entities[i].collisions[c].hit = true, true

                local angle1 = (self.em.entities[i].pos - self.em.entities[i].collisions[c].pos):normalized()
                local angle2 = (self.em.entities[i].collisions[c].pos - self.em.entities[i].pos):normalized()
                local b1Vel, b2Vel = self.em.entities[i].velocity, self.em.entities[i].collisions[c].velocity

                self.em.entities[i].accumulator = self.em.entities[i].accumulator + (angle1 * ((b2Vel + b1Vel) / 4 / #self.em.entities[i].collisions[c].collisions):len())
                self.em.entities[i].collisions[c].accumulator = self.em.entities[i].collisions[c].accumulator + (angle2 * ((b1Vel + b2Vel) / 4 / #self.em.entities[i].collisions):len())
            end
        end
    end

    -- Add Accumulators to Velocity, reset values
    for i = 1, #self.em.entities do
        if self.em.entities[i]:is(Ball) then
            if self.em.entities[i].hit then
                self.em.entities[i].velocity = self.em.entities[i].velocity + self.em.entities[i].accumulator
                self.em.entities[i].collisions = {}
                self.em.entities[i].accumulator = vector(0, 0)
            end
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
        pullStartX, pullStartY = self.b0.pos.x, self.b0.pos.y
    end
end

function Game:mousereleased(x, y, key)
    if key == 1 then
        if pulling then
            pulling = false
            self.b0:shoot(vector(x, y), vector(pullX, pullY))
        end
    end
end

function Game:draw()
    love.graphics.clear(200, 200, 200)
    self.em:draw()
    if pulling then
        love.graphics.line(pullStartX, pullStartY, mx, my)
    end
end

return Game
