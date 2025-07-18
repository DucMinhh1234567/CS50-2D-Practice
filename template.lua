WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

    -- Use if need to create Virtual Screen
    -- push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     resizable = true,
    --     vsync = true,
    --     fullscreen = false
    -- })
end

function love.keypressed(key)
    -- Exit game
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

end

function love.draw()
    push:start()
    love.graphics.print("Hello lua!", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    push:finish()
end