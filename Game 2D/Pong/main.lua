-- Try to change the setting of gamestate i.e pause if esc and exit if exit again

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Pixel / second
SPEED = 200

push = require 'push'
Class = require 'class'
require 'Pad'
require 'Ball'

-- Load data, like ready function in Godot
function love.load()
    -- Should listen again about this
    -- Understood but still a bit confused
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Pass in time for random function
    math.randomseed(os.time())
    -- Set title for game window
    love.window.setTitle('Ra gì chưa')
    -- Font
    largeFont = love.graphics.newFont('font.ttf', 32)
    smallFont = love.graphics.newFont('font.ttf', 8)

    sounds = {
        ['pad'] = love.audio.newSource('sound/pad.wav', 'static'),
        ['score'] = love.audio.newSource('sound/score.wav', 'static'),
        ['wall'] = love.audio.newSource('sound/wall2.wav', 'static')
    }

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })
    -- Setup Screen with virtual size to give the vibe of retro game
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

    -- Player pads
    local padY = (VIRTUAL_HEIGHT - 25) / 2
    p1 = Pad(20, padY, 5, 25)
    p2 = Pad(VIRTUAL_WIDTH - 15, padY, 5, 25)
    -- Player score
    p1Score = 0
    p2Score = 0

    -- Ball postion
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- Exit game
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f11' then
        local isFullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not isFullscreen)
    elseif key == 'enter' or key == 'return' then
        -- When haven't start yet
        if gameState == 'start' then
            gameState = 'play'
        -- If started or a point is gained I assume
        -- So basically whenever hit Enter then reset gamestate
        elseif gameState == 'play' then
            gameState = 'start'
            -- Reset ball position and velocity
            ball:reset()
        elseif gameState == 'finished' then
            gameState = 'start'
            -- Reset ball position and velocity
            ball:reset()
            p1Score = 0
            p2Score = 0
        end
    end
end

function love.update(dt)
    -- Check collision and returns to opponent
    if gameState == 'play' then
        -- Check with pads
        if ball:collides(p1) then
            ball.dx = -ball.dx * 1.03
            ball.x = p1.x + 5

            -- Randomized the angle
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end

            sounds['pad']:play()
        end

        if ball:collides(p2) then
            ball.dx = -ball.dx * 1.03
            ball.x = p2.x - 4

            -- Randomized the angle
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end

            sounds['pad']:play()

        end

        -- Check with top and bottom walls
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds['wall']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall']:play()
        end
    end

    -- Check Scoring
    if ball.x <= 0 then
        p2Score = p2Score + 1
        ball:reset()
        -- gameState = 'start'
        sounds['score']:play()
    end
    if ball.x > VIRTUAL_WIDTH - 4 then
        p1Score = p1Score + 1
        ball:reset()
        -- gameState = 'start'
        sounds['score']:play()
    end

    -- Check wining condition
    if p1Score == 10 or p2Score == 10 then
        ball:reset()
        gameState = 'finished'
    end

    -- Moving Pads
    if love.keyboard.isDown("w") then
        p1.speed = -SPEED
    elseif love.keyboard.isDown("s") then
        p1.speed = SPEED
    else
        p1.speed = 0
    end

    if love.keyboard.isDown("up") then
        p2.speed = -SPEED
    elseif love.keyboard.isDown("down") then
        p2.speed = SPEED
    else
        p2.speed = 0
    end

    if gameState == "play" then
        ball:update(dt)
    end

    p1:update(dt)
    p2:update(dt)
end

function love.draw()
    push:start()
    -- Background color
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    -- Display state
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf("Ready", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == 'play' then
        love.graphics.printf("Play", 0, 20, VIRTUAL_WIDTH, "center")
    else
        love.graphics.setFont(largeFont)
        if p1Score == 10 then
            love.graphics.printf("Player 1 wins", 0, 50, VIRTUAL_WIDTH, "center")
        else
            love.graphics.printf("Player 2 wins", 0, 50, VIRTUAL_WIDTH, "center")
        end
    end

    -- Call font
    love.graphics.setFont(largeFont)
    -- Display point
    love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH / 2 + 80, VIRTUAL_HEIGHT / 2 - 16)

    -- Render pads and ball
    p1:render()
    p2:render()
    ball:render()

    displayFPS()

    push:finish()
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 20, 10)
end