
-- Include the library push to create a virtual resolution that match with the old atari systems
push = require 'push'
Class = require 'class'
require("Ball")
require("Paddle")

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

    -- seed the RNG so that calls to random
    -- use the current time
    math.randomseed(os.time())


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

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    
    gameState = 'start'

end

-- love.update will execute at every frame, it takes a delta time witch is going to be executed a fraccion of a second
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end


function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit();
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ball:reset()
        end
    end
end

function love.draw()
    -- start aplying the virtual resolution 432 x 243
    push:apply('start')
    -- wipes the screen to a RGB color, 255 means that is totally opaque and it will not have transparency
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setFont(textFont)
    --[[ PrintF (name, limit, x, y, width, align) ]]
    if gameState == 'start' then
        love.graphics.printf(
            "GET READY!",
            '0',
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    else
        love.graphics.printf(
            "PONG!",
            '0',
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    end

    -- draw score and switch to font to draw before actually printing
--[[     love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3) ]]

    --[[ The paddles will be a simple Rectangle affected by the virtual resolution as the ball that we draw on the screen at certain points ]]
    -- render the first paddle (left)
    player1:render()

    -- render the second one (right)
    player2:render()

    -- ball render
    ball:render()

    -- end rendering the virtual resolution
    push:finish()
end