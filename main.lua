
push = require 'push'
WINDOW_WIDTH = 1270
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[ This Funcion only gets executed at the start of Love ]]
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    --[[setup screen takes a virtual WIDTH and a Virtual Height to rendering in a fixed screen of 1270 x 720 ]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit();
    end
end

function love.draw()
    -- start aplying the virtual resolution 432 x 243
    push:apply('start')
    --[[ PrintF (name, limit, x, y, width, align) ]]
    love.graphics.printf(
        "PONG!",
        '0',
        VIRTUAL_HEIGHT / 2 - 6,
        VIRTUAL_WIDTH,
        'center'
    )
    -- end rendering the virtual resolution
    push:finish()
end

