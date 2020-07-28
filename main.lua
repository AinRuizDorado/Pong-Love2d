
-- Include the library push to create a virtual resolution that match with the old atari systems
push = require 'push'
-- sets the true resolution that the player will be seeing in a screen 16:9
WINDOW_WIDTH = 1270
WINDOW_HEIGHT = 720

-- set a virtual resolution (Atari System) that will render inside of the window resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- set a local speed to the paddles
PADDLE_SPEED = 200


--[[ This Funcion only gets executed at the start of Love ]]
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- I don't want to use Arial default font so i downloaded a custom one from google front
    -- https://fonts.google.com/specimen/Red+Rose?preview.text=PONG&preview.text_type=custom&preview.size=43
    textFont = love.graphics.newFont('RedRose-Bold.ttf', 13)
    scoreFont = love.graphics.newFont('RedRose-Bold.ttf', 32)
    -- set to active font
    love.graphics.setFont(textFont)
    --[[setup screen takes a virtual WIDTH and a Virtual Height to rendering in a fixed screen of 1270 x 720 ]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- initialize score variables, used for rendering on the screen and keeping tracking of the winner
    player1Score = 0
    player2Score = 0

    -- paddle positions on the Y axis
    player1Y = 25
    player2Y = VIRTUAL_HEIGHT - 50

end

-- love.update will execute at every frame, it takes a delta time witch is going to be executed a fraccion of a second
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- going up, player1Y plus negative paddle speed witch is going to decrese in the Y axis so it moves UP multiply by delta time
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        -- body
        player1Y = player1Y + PADDLE_SPEED * dt
    end

        -- player 2 movement
    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        -- body
        player2Y = player2Y + PADDLE_SPEED * dt
    end
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
    love.graphics.setFont(textFont)
    --[[ PrintF (name, limit, x, y, width, align) ]]
    love.graphics.printf(
        "PONG!",
        '0',
        20,
        VIRTUAL_WIDTH,
        'center'
    )

    -- draw score and switch to font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)

    --[[ The paddles will be a simple Rectangle affected by the virtual resolution as the ball that we draw on the screen at certain points ]]
    -- render the first paddle (left)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- render the second one (right)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- ball render
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- end rendering the virtual resolution
    push:finish()
end