Gamestate = require("hump.gamestate")
Utils = require("lib.Utils")
local Events = require("lib.Events")
Menu = require("states.Menu")
Game = require("states.Game")

local TICKRATE = 1/60

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    _G.events = Events(false)

    Gamestate.registerEvents()
    Gamestate.switch(Game)
end

function love.update(dt)
    if not love.window.hasMouseFocus() then return end
end

function love.draw(dt)

end

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end

    if love.load then love.load(arg) end

    local previous = love.timer.getTime()
    local lag = 0.0
    while true do
        local current = love.timer.getTime()
        local elapsed = current - previous
        previous = current
        lag = lag + elapsed

        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        while lag >= TICKRATE do
            if love.update then love.update(TICKRATE) end
            lag = lag - TICKRATE
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw(lag / TICKRATE) end
            love.graphics.present()
        end
    end
end
