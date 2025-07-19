Bird = Class{}

local GRAVITY = 980

function Bird:init()
    -- Load in bird image
    self.image = love.graphics.newImage('assets/sprites/bluebird-midflap.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Bird position
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2 + 40

    self.dy = 0
end

function Bird:collides(pipe)
    -- AABB collision
    if self.x + self.width - 2 >= pipe.x and self.x + 2 < pipe.x + pipe.width then
        if self.y + self.height - 1 >= pipe.y and self.y + 1 < pipe.y + pipe.height then
            return true
        end
    end
    return false
end

function Bird:update(dt)
    -- Apply gravity and velocity
    self.dy = self.dy + GRAVITY * dt

    -- Add a sudden busrt of negative gravity 
    -- and then let the gravity do its job
    if love.keyboard.wasPressed('space') or
       love.keyboard.wasPressed('enter') or
       love.keyboard.wasPressed('return') or
       love.keyboard.wasPressed('up') then
        self.dy = -300
    end

    -- Apply current velocity to Y position
    self.y = self.y + self.dy * dt
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end