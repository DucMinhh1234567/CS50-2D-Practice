TitleScreenState = Class{__includes = BaseState}

local TITLE_IMAGE = love.graphics.newImage('assets/sprites/message.png')

function TitleScreenState:init()
    self.bird = Bird()
    -- Đặt chim ở giữa màn hình
    self.bird.x = VIRTUAL_WIDTH / 2 - self.bird.width / 2 - 60
    self.bird.y = VIRTUAL_HEIGHT / 2 - self.bird.height / 2 + 5
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    -- Vẽ title image ở giữa phía trên
    love.graphics.draw(TITLE_IMAGE, VIRTUAL_WIDTH/2 - TITLE_IMAGE:getWidth()/2, 80)
    -- Vẽ chim ở giữa màn hình
    self.bird:render()
end
