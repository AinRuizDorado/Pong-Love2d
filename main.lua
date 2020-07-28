
push = require 'push'
WINDOW_WIDTH = 1270
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[ This Funcion only gets executed at the start of Love ]]
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- I don't want to use Arial default font so i downloaded a custom one from google front
    -- https://fonts.google.com/specimen/Red+Rose?preview.text=PONG&preview.text_type=custom&preview.size=43
    Font = love.graphics.newFont('RedRose-Bold.ttf', 13)
    -- set to active font
    love.graphics.setFont(Font)
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
    -- wipes the screen to a RGB color, 255 means that is totally opaque and it will not have transparency
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    --[[ PrintF (name, limit, x, y, width, align) ]]
    love.graphics.printf(
        "PONG!",
        '0',
        20,
        VIRTUAL_WIDTH,
        'center'
    )

    --[[ The paddles will be a simple Rectangle affected by the virtual resolution as the ball that we draw on the screen at certain points ]]
    -- render the first paddle (left)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- render the second one (right)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- ball render
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- end rendering the virtual resolution
    push:finish()
end

