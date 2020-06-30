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

--speed at which paddle moves
PADDLE_SPEED = 200

--[[
    Used to intialize the game.
]]
function love.load()
    --Nearest Neighbour filtering min max
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --"seed" the RNG so that calls to random are always random
    --use the current time at it will always vary on startup
    math.randomseed(os.time())

    --retro font
    smallFont = love.graphics.newFont('font.ttf', 8)

    --score font
    scoreFont = love.graphics.newFont('font.ttf', 32)

    --set active font
    love.graphics.setFont(smallFont)

    --Initialize window with virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, 
        resizable = false,
        vsync = true
    })

    --Initialize score variables
    player1Score = 0 
    player2Score = 0

    --paddle positions on the Y axis
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50;

    --position variables for ball
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    --math.random returns a random value between the left and right number
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    --game state variable 
    gameState = 'start'

end

function love.update(dt)
    --player 1 movement
    if love.keyboard.isDown('w') then
        --add paddle speed to current Y scaled by deltaTime
        --clamping our position between bounds of the screen
        --math.max returns the greater of the two values; 0 and player Y
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        --math.min returns the lesser of the two
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end
    
    --player 2 movement
    if love.keyboard.isDown('up') then
        --add paddle speed to current Y scaled by deltaTime
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end 

    --update the ball based on its DX and DY only if we're in play state
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end

--[[
    Keyboard handling, called by Love2D each frame
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else 
            gameState = 'start'
            -- start ball's position in the middle of the screen
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            -- given ball's x and y velocity a random starting value
            -- the and/or pattern here is Lua's way of accomplishing a ternary operation
            -- in other programming languages like C
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

--[[
    Used after update to draw anything to the screen, updated or otherwise
]]
function love.draw()
    --begin rendering at virtual resolution
    push:apply('start')

    --clear screen with specific color
    --errors out when 0-255 values used
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    --draw score
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

--paddles
    --render first paddle
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    --render second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

--ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    --end rendering at virtual resolution
    push:apply('end')
end