Pipe = Class{}

-- Because the image only needs to be loaded once
-- not per pipe, we can define it externally
local PIPE_IMAGE = love.graphics.newImage('assets/sprites/pipe-green.png')

-- The scroll speed should be the same as the ground
local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH

    -- Random value from halfway of the screen to bottom
    self.y = math.random((VIRTUAL_HEIGHT - ground:getHeight()) - PIPE_IMAGE:getHeight(), 
                        VIRTUAL_HEIGHT - ground:getHeight())

    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw (PIPE_IMAGE, self.x, self.y)
end