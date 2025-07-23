-- StateMachine kế thừa từ Class (OOP Lua)
StateMachine = Class{}

-- Hàm khởi tạo, nhận vào một bảng các state (tên → hàm khởi tạo state)
function StateMachine:init(states)
    -- State rỗng mặc định, dùng khi chưa có state nào
    self.empty = {
        render = function() end,   -- Hàm vẽ mặc định (không làm gì)
        update = function() end,   -- Hàm update mặc định (không làm gì)
        enter = function() end,    -- Hàm gọi khi vào state (không làm gì)
        exit = function() end,     -- Hàm gọi khi rời state (không làm gì)
        processAI = function() end -- Cái này mới
    }
    self.states = states or {}     -- Bảng các state, truyền vào khi khởi tạo
    self.current = self.empty      -- State hiện tại, ban đầu là empty
end

-- Chuyển sang state mới
function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])         -- Đảm bảo state tồn tại
    self.current:exit()                    -- Gọi hàm exit của state hiện tại
    self.current = self.states[stateName]()-- Tạo state mới (gọi hàm khởi tạo)
    self.current:enter(enterParams)        -- Gọi hàm enter của state mới, truyền tham số nếu có
end

-- Gọi update của state hiện tại
function StateMachine:update(dt)
    self.current:update(dt)
end

-- Gọi render của state hiện tại
function StateMachine:render()
    self.current:render()
end