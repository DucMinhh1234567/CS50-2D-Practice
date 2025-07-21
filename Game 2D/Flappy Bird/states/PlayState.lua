PlayState = Class{__includes = BaseState}

-- Khởi tạo state chơi, tạo bird, pipePairs, timer, lastY
function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    self.score = 0
end

function PlayState:update(dt)
    -- Tăng timer để spawn pipe mới
    self.spawnTimer = self.spawnTimer + dt

    -- Spawn pipe mới mỗi 1.35 giây
    if self.spawnTimer > 1.35 then
        -- Tính toán vị trí y cho pipe mới, không quá xa pipe trước
        local y = math.max(-PIPE_HEIGHT + 30,
            math.min(self.lastY + math.random(-100, 100), VIRTUAL_HEIGHT - 100 - PIPE_HEIGHT))
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))
        self.spawnTimer = 0
    end

    -- Cập nhật tất cả pipePairs và kiểm tra va chạm với bird
    for i, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH / 2 < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                gSounds['point']:play()
            end
        end

        pair:update(dt)
        for k, pipe in pairs(pair.pipes) do
            -- Nếu bird va chạm pipe thì chuyển về màn hình score
            if self.bird:collides(pipe) then
                gSounds['hit']:play()
                gStateMachine:change('score', { score = self.score})
            end
        end
    end

    -- Nếu bird rơi xuống đất thì chuyển về màn hình score
    if self.bird.y > VIRTUAL_HEIGHT - ground:getHeight() then
        gSounds['hit']:play()
        gStateMachine:change('score', { score = self.score})
    end

    -- Xóa các pipePairs đã ra khỏi màn hình
    for i, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, i)
        end
    end

    -- Cập nhật bird
    self.bird:update(dt)
end


-- Vẽ tất cả pipePairs, bird và điểm số
function PlayState:render()
    for i, pair in pairs(self.pipePairs) do
        pair:render()
    end
    self.bird:render()

    -- Vẽ điểm số ở góc trên giữa màn hình, dùng sprite số
    local scoreStr = tostring(self.score or 0)
    local digitWidth = 24
    local digitHeight = 36
    local totalWidth = #scoreStr * digitWidth
    local startX = VIRTUAL_WIDTH / 2 - totalWidth / 2
    local y = 32

    for i = 1, #scoreStr do
        local digit = scoreStr:sub(i, i)
        local img = love.graphics.newImage('assets/sprites/numbers/' .. digit .. '.png')
        love.graphics.draw(img, startX + (i - 1) * digitWidth, y)
    end
end
