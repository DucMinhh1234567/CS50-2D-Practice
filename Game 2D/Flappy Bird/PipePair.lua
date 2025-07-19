PipePair = Class{}

local GAP_HEIGHT =  90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH

    -- y value for the top pipe
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Param to decide if this pair is ready to be remove
    -- Don't really need to do removal this way
    self.remove = false
end

function PipePair:update(dt)
    -- Remove the pipe from the scene
    -- And move it right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for i, pipe in pairs(self.pipes) do
        pipe:render()
    end
end