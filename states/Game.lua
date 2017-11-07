local Game = {}

local Camera = require("hump.camera")

local sw = love.graphics.getWidth()
local sh = love.graphics.getHeight()

local EntityMgr = require("lib.EntityMgr")
local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local Slider = require("lib.ui.Slider")
local TextField = require("lib.ui.TextField")


function Game:init()
    self.em = EntityMgr()
end

function Game:enter()
    self.em:onEnter()
end

function Game:leave()
    self.em:onExit()
end

function Game:update(dt)
    self.em:update(dt)
end

function Game:keypressed(key)
    if key == "escape" then
        Gamestate.switch(Menu)
    end
end

function Game:mousepressed(x, y, key)

end

function Game:mousereleased(x, y, key)

end

function Game:draw()
    love.graphics.clear(0, 0, 0)
    self.em:draw()
end

return Game