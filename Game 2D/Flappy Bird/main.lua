
push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states.BaseState'
require 'states.PlayState'
require 'states.ScoreState'
require 'states.TitleScreenState'
require 'states.CountDownState'

-- Window res (portrait)
WINDOW_WIDTH = 576
WINDOW_HEIGHT = 1024

-- Virtual res (portrait)
VIRTUAL_WIDTH = 288
VIRTUAL_HEIGHT = 512

-- background and ground starting point
local backgroundScroll = 0
local groundScroll = 0

-- Background and ground scrolling speed
local BACKGROUND_SPEED = 20
local GROUND_SPEED = 120

-- Background looping point
local BACKGROUND_LOOPING_POINT = 288


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Load images for background
    background = love.graphics.newImage('assets/sprites/background-day.png')
    ground = love.graphics.newImage('assets/sprites/base.png')

    -- Title
    love.window.setTitle('Flappy Bi')

    -- Window
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     resizable = true,
    --     vsync = true,
    --     fullscreen = false
    -- })
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

    gSounds = {
        ['wing'] = love.audio.newSource('assets/sounds/wing.wav', 'static'),
        ['point'] = love.audio.newSource('assets/sounds/point.wav', 'static'),
        ['hit'] = love.audio.newSource('assets/sounds/hit.wav', 'static'),
        ['music'] = love.audio.newSource('assets/sounds/marios_way.mp3', 'static')
    }

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- Initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountDownState() end
    }

    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- Add to table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    -- Exit game
    if key == 'escape' then
        love.event.quit()
    end
end


function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- Background và ground luôn cuộn
    backgroundScroll = (backgroundScroll + BACKGROUND_SPEED * dt) % background:getWidth()
    groundScroll = (groundScroll + GROUND_SPEED * dt) % ground:getWidth()

    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    -- Vẽ background phủ toàn bộ màn hình ảo và cuộn
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(background, -backgroundScroll + background:getWidth(), 0)

    -- Vẽ state hiện tại (menu, play, v.v.)
    gStateMachine:render()

    -- Vẽ ground ở dưới cùng, phủ toàn bộ chiều ngang và cuộn
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())
    love.graphics.draw(ground, -groundScroll + ground:getWidth(), VIRTUAL_HEIGHT - ground:getHeight())
    push:finish()
end