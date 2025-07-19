PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 2.5 then
        local y = math.max(-PIPE_HEIGHT + 30,
            math.min(self.lastY + math.random(-100, 100), VIRTUAL_HEIGHT - 100 - PIPE_HEIGHT))
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))
        self.spawnTimer = 0
    end

    for i, pair in pairs(self.pipePairs) do
        pair:update(dt)
        for k, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('title')
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - ground:getHeight() then
        gStateMachine:change('title')
    end

    for i, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, i)
        end
    end

    self.bird:update(dt)
end

function PlayState:render()
    for i, pair in pairs(self.pipePairs) do
        pair:render()
    end
    self.bird:render()
end
