Gamestate = require("hump.gamestate")
Utils = require("lib.Utils")
local Events = require("lib.Events")
Menu = require("states.Menu")
Game = require("states.Game")

Timer = require("hump.timer")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    _G.events = Events(false)

    Gamestate.registerEvents()
    Gamestate.switch(Menu)
end

function love.update(dt)
    if not love.window.hasMouseFocus() then return end
    Timer.update(dt)

end

function love.draw()

end
