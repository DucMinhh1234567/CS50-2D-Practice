CountDownState = Class{__includes = BaseState}

COUNTDOWN = 0.65

function CountDownState:init()
    self.count = 3
    self.timer = 0

    self.bird = Bird()
    self.bird.x = VIRTUAL_WIDTH / 2 - self.bird.width / 2 - 60
    self.bird.y = VIRTUAL_HEIGHT / 2 - self.bird.height / 2 + 5
end

function CountDownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN then
        self.timer = self.timer % COUNTDOWN
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountDownState:render()
    -- Vẽ điểm số ở góc trên giữa màn hình, dùng sprite số
    local countStr = tostring(self.count or 0)
    local digitWidth = 24
    local digitHeight = 36
    local totalWidth = #countStr * digitWidth
    local startX = VIRTUAL_WIDTH / 2 - totalWidth / 2
    local y = (VIRTUAL_HEIGHT - ground:getHeight()) / 2

    for i = 1, #countStr do
        local digit = countStr:sub(i, i)
        local img = love.graphics.newImage('assets/sprites/numbers/' .. digit .. '.png')
        love.graphics.draw(img, startX + (i - 1) * digitWidth, y)
    end
    self.bird:render()
end