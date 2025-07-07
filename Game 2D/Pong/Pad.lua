Pad = Class{}

-- Constructor
function Pad:init(x, y, width, height)
    self.x = x 
    self.y = y 
    self.width = width
    self.height = height
    self.speed = 0
end

-- Update postion
function Pad:update(dt)
    if self.speed < 0 then
        self.y = math.max(0, self.y + self.speed * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.speed * dt)
    end
end

-- Pad render
function Pad:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end