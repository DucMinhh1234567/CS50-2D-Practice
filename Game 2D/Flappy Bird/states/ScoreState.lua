ScoreState = Class{__includes = BaseState}

local GAMEOVER_IMAGE = love.graphics.newImage('assets/sprites/gameover.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end
end


-- Vẽ ảnh gameover và điểm số dưới ảnh, dùng sprite số
function ScoreState:render()
    -- Vẽ ảnh gameover ở giữa màn hình, lệch lên trên một chút
    local gameoverY = VIRTUAL_HEIGHT / 2 - GAMEOVER_IMAGE:getHeight() / 2 - 100
    love.graphics.draw(GAMEOVER_IMAGE, VIRTUAL_WIDTH / 2 - GAMEOVER_IMAGE:getWidth() / 2, gameoverY)

    -- Chuyển điểm số thành chuỗi để duyệt từng ký tự (số)
    local scoreStr = tostring(self.score or 0)
    -- digitWidth, digitHeight: kích thước mỗi ảnh số (sprite)
    local digitWidth = 24
    local digitHeight = 36
    -- #scoreStr: ký tự # dùng để lấy độ dài chuỗi (số lượng chữ số)
    local totalWidth = #scoreStr * digitWidth -- tổng chiều rộng dãy số
    -- Tính vị trí bắt đầu để căn giữa dãy số
    local startX = VIRTUAL_WIDTH / 2 - totalWidth / 2
    -- Vị trí y để vẽ điểm số, nằm dưới ảnh gameover
    local y = gameoverY + GAMEOVER_IMAGE:getHeight() + 16

    -- Duyệt từng ký tự trong chuỗi điểm số
    for i = 1, #scoreStr do
        local digit = scoreStr:sub(i, i) -- lấy từng số một
        -- Tạo image cho từng số, ví dụ: assets/sprites/numbers/3.png
        local img = love.graphics.newImage('assets/sprites/numbers/' .. digit .. '.png')
        -- Vẽ số tại vị trí tương ứng, các số nằm cạnh nhau
        love.graphics.draw(img, startX + (i - 1) * digitWidth, y)
    end
end