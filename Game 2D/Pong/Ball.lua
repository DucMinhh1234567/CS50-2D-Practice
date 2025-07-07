-- it's syntax and requirements, don't question it ...
Ball = Class{}

-- Constructor
function Ball:init(x, y, width, height)
    -- Ball position
    self.x = x
    self.y = y
    -- Lưu lại vị trí khởi tạo
    self.initX = x
    self.initY = y
    -- Ball size
    self.width = width
    self.height = height
    -- Ball velocity
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

-- Check Collision
function Ball:collides(pad)
    -- Reverse condition: if there is a gap then not collide
    -- Check right and left edges
    if self.x > pad.x + pad.width or pad.x > self.x + self.width then
        return false
    end
    -- Check top and bottom edges
    if self.y > pad.y + pad.height or pad.y > self.y + self.height then
        return false
    end
    
    return true
end

-- Reset Ball
function Ball:reset()
    self.x = self.initX
    self.y = self.initY
    self.dx = math.random(2) == 1 and 150 or -150
    self.dy = math.random(-50, 50)
end

-- Gameloop update
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- Ball render
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end