Bird = Class{}

local GRAVITY = 980

function Bird:init()
    -- Load in bird image
    self.frames = {
        love.graphics.newImage('assets/sprites/bluebird-upflap.png'),
        love.graphics.newImage('assets/sprites/bluebird-midflap.png'),
        love.graphics.newImage('assets/sprites/bluebird-downflap.png')
    }
    self.frame = 2 -- midflap mặc định
    self.image = self.frames[self.frame]
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.animationTimer = 0
    self.animationInterval = 0.05 -- thời gian đổi frame khi bay lên

    -- Bird position
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2 - 60
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2 + 5

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

    -- Animation khi bay lên
    if self.dy <= 0 then
        self.animationTimer = self.animationTimer + dt
        if self.animationTimer > self.animationInterval then
            self.frame = self.frame + 1
            if self.frame > 3 then self.frame = 1 end
            self.animationTimer = 0
        end
    else
        self.frame = 2 -- midflap khi rơi
        self.animationTimer = 0
    end

    -- Add a sudden burst of negative gravity 
    -- and then let the gravity do its job
    if love.keyboard.wasPressed('space') or
       love.keyboard.wasPressed('enter') or
       love.keyboard.wasPressed('return') or
       love.keyboard.wasPressed('up') then
        self.dy = -300
        gSounds['wing']:play()
    end

    -- Apply current velocity to Y position
    self.y = self.y + self.dy * dt
end

function Bird:render()
    -- Tính góc xoay dựa vào vận tốc dy
    -- self.dy < 0: chim bay lên, góc âm; self.dy > 0: chim rơi xuống, góc dương
    local rotation = math.min(math.max(self.dy * 0.002, -math.pi/6), math.pi/4)

    -- Lấy sprite hiện tại theo frame (1: upflap, 2: midflap, 3: downflap)
    local image = self.frames[self.frame]

    -- Vẽ chim lên màn hình với các tham số:
    -- image: sprite của chim
    -- self.x + self.width/2, self.y + self.height/2: vị trí vẽ (tâm chim)
    -- rotation: góc xoay (radian)
    -- 1, 1: scale X, scale Y (giữ nguyên kích thước)
    -- self.width/2, self.height/2: gốc xoay (tâm sprite)
    love.graphics.draw(
        image,                  -- sprite của chim
        self.x + self.width/2,  -- vị trí X (tâm chim)
        self.y + self.height/2, -- vị trí Y (tâm chim)
        rotation,               -- góc xoay (radian)
        1,                      -- scale X
        1,                      -- scale Y
        self.width/2,           -- gốc xoay X (tâm sprite)
        self.height/2           -- gốc xoay Y (tâm sprite)
    )
end