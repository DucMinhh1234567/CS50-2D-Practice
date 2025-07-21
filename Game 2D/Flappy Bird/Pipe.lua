Pipe = Class{}

-- Because the image only needs to be loaded once
-- not per pipe, we can define it externally
local PIPE_IMAGE = love.graphics.newImage('assets/sprites/pipe-green.png')

-- The scroll speed should be the same as the ground
PIPE_SPEED = 120

PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

function Pipe:init(place, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.place = place
end

function Pipe:update(dt)
    
end

function Pipe:render()
    love.graphics.draw (PIPE_IMAGE, self.x,
                        (self.place == 'top' and self.y + PIPE_HEIGHT or self.y),
                        0, 1, self.place == 'top' and - 1 or 1)
end