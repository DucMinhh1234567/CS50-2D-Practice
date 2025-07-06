-- Try to change the setting of gamestate i.e pause if esc and exit if exit again

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Pixel / second
SPEED = 200

push = require 'push'

function love.load()
    -- Should listen again about this
    -- Understood but still a bit confused
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())
    -- Font
    largeFont = love.graphics.newFont('font.ttf', 32)
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- Score
    p1Score = 10
    p2Score = 0

    -- Player position to manipulate
    p1Y = 10
    p2Y = VIRTUAL_HEIGHT - 35

    -- Ball postion and velocity
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and 150 or -150
    ballDY = math.random(-50, 50)

    gameState = 'start'
    
    -- Setup Window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false
    })
    -- Setup Screen with virtual size to give the vibe of retro game
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false
    })
end

function love.keypressed(key)
    -- Exit game
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        -- When haven't start yet
        if gameState == 'start' then
            gameState = 'play'
        -- If started or a point is gained I assume
        -- So basically whenever hit Enter then reset gamestate
        else
            gameState = 'start'
            
            -- Reset ball position and velocity
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2
            ballDX = math.random(2) == 1 and 150 or -150
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

-- Moving Pads
function love.update(dt)
    if love.keyboard.isDown("w") then 
        p1Y = math.max(0, p1Y + -SPEED * dt)
    elseif love.keyboard.isDown("s") then
        p1Y = math.min(p1Y + SPEED * dt, VIRTUAL_HEIGHT - 25)
    end

    if love.keyboard.isDown("up") then 
        p2Y = math.max(0, p2Y + -SPEED * dt)
    elseif love.keyboard.isDown("down") then
        p2Y = math.min(p2Y + SPEED * dt, VIRTUAL_HEIGHT - 25)
    end

    if gameState == "play" then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

function love.draw()
    push:start()
    -- Background color
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    -- Call font
    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH / 2 + 80, VIRTUAL_HEIGHT / 2 - 16)

    -- Left pad
    love.graphics.rectangle('fill', 10, p1Y, 3, 25)
    -- Right pad
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, p2Y, 3, 25)
    -- Ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    push:finish()
end