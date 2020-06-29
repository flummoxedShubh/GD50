--[[
    Pong
    by Shubh Sharma
]]

--[[
    ERRORS FIXED
    
    Error:push.lua 101 attempt to call field 'getPixelScale' (a nil value)
    
    Fix:
    yes because in love 0.11.1 'love.window.getPixelScale()' is replaced with 'love.window.getDPIScale()'.
    so open up push.lua in IDE and replace 'love.window.getPixelScale()' with 'love.window.getDPIScale()'.
]]

--push library allows us to draw our game at a virtual resolution, instead of however large our window is. (Retro Aesthetic)
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
    Used to intialize the game.
]]
function love.load()
    --Nearest Neighbour filtering min max
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false, resizable = false, vsync = true})
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    Used after update to draw anything to the screen, updated or otherwise
]]
function love.draw()
    push:apply('start')
    love.graphics.printf('Hello Pong', 0, (VIRTUAL_HEIGHT / 2) - 6, VIRTUAL_WIDTH, 'center')
    push:apply('end')
end