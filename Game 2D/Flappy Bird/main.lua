
push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
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
local GROUND_SPEED = 60

-- Background looping point
local BACKGROUND_LOOPING_POINT = 288

-- Table of spawning pipes
local pipes = {}

-- Timer for spawning pipes
local spawnTimer = 0

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

    -- Create bird instance
    bird = Bird()

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
    -- Update background and ground scrolling
    backgroundScroll = (backgroundScroll + BACKGROUND_SPEED * dt) % background:getWidth()

    -- Update ground scrolling
    groundScroll = (groundScroll + GROUND_SPEED * dt) % ground:getWidth()

    -- Set the timer
    spawnTimer = spawnTimer + dt

    -- Spawn a new pipe every 3 seconds
    if spawnTimer > 2.5 then
        -- Add Pipe() to table pipes
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    -- For every pipe in scene
    -- In other word, for key 'i' and value 'pipe' in table 'pipes'
    for i, pipe in pairs(pipes) do
        pipe:update(dt)

        -- If pipe past the left edge, remove pipe
        -- Like destroy object in GameMaker
        if pipe.x < 0 - pipe.width then
            -- remove element with key i in pipes
            table.remove(pipes, i)
        end
    end

    bird:update(dt)

    -- Put this table here so that it can be reset every frame
    -- to make the key only pressed on that frame not hold
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- Draw background to fit the entire virtual screen and scroll
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(background, -backgroundScroll + background:getWidth(), 0)

    -- Draw the pipes in scene
    -- Put this above the ground so the pipes don't appear above the ground
    for i, pipe in pairs(pipes) do
        pipe:render()
    end

    -- Draw ground at the bottom, covering the entire width and scroll
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())
    love.graphics.draw(ground, -groundScroll + ground:getWidth(), VIRTUAL_HEIGHT - ground:getHeight())

    -- Draw the bird
    bird:render()
    push:finish()
end