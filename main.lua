
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

-- set the player's score to 0
player1Score = 0
player2Score = 0

--[[ This Funcion only gets executed at the start of Love ]]
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of the app menu
    love.window.setTitle('pong')
    
    -- seed the RNG so that calls to random
    -- use the current time
    math.randomseed(os.time())


    -- I don't want to use Arial default font so i downloaded a custom one from google front
    -- https://fonts.google.com/specimen/Red+Rose?preview.text=PONG&preview.text_type=custom&preview.size=43
    textFont = love.graphics.newFont('RedRose-Bold.ttf', 13)
    scoreFont = love.graphics.newFont('RedRose-Bold.ttf', 32)
    framesPerSecondFont = love.graphics.newFont('RedRose-Bold.ttf', 8)

    -- set up the table for ur sounds
    -- all sounds was made by me using BFXR pls check this out for making sounds, its very easy https://www.bfxr.net/
    sounds = {
        ['paddle_hit'] = love.audio.newSource('Sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('Sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('Sounds/score.wav', 'static')

    }

    -- set to active font
    love.graphics.setFont(textFont)
    --[[setup screen takes a virtual WIDTH and a Virtual Height to rendering in a fixed screen of 1270 x 720 ]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    servingPlayer = math.random(2)

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    
    gameState = 'start'

end


function love.resize(w, h)
    push:resize(w, h)
end

-- love.update will execute at every frame, it takes a delta time witch is going to be executed a fraccion of a second
function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random( -50, 50 )
        if servingPlayer == 1 then
            ball.dx = math.random( 140, 200 )
        else 
            ball.dx = -math.random( 140, 200 )
        end
    
    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end

        -- detect upper and lower screen boundary collision and reverse it
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT -4 then
            ball.y = VIRTUAL_HEIGHT -4
            ball.dy = -ball.dy 
            sounds['wall_hit']:play()
        end


        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end 

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            ball:reset()
        
            -- reset scores to 0
            player1Score = 0
            player2Score = 0
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
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
    displayScore()
    if gameState == 'start' then
        love.graphics.setFont(textFont)
        love.graphics.printf(
            "GET READY!",
            '0',
            10,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf(
            "Press Enter To Begin!",
            '0',
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    elseif gameState == 'serve' then
        love.graphics.setFont(textFont)
        love.graphics.printf(
            "Player  " .. tostring(servingPlayer) .. "'s serve!",
            '0',
            10,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf(
            "Press Enter To Serve!",
            '0',
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    elseif gameState == 'play' then
        love.graphics.setFont(textFont)
        love.graphics.printf(
            "PONG!",
            '0',
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    elseif gameState == 'done' then
        love.graphics.setFont(textFont)
        love.graphics.printf(
            "Player " .. winningPlayer .. 'WONS!',
            '0',
            10,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf(
            'Press Enter to Restart!',
            '0',
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    end

    --[[ The paddles will be a simple Rectangle affected by the virtual resolution as the ball that we draw on the screen at certain points ]]
    -- render the first paddle (left)
    player1:render()

    -- render the second one (right)
    player2:render()

    -- ball render
    ball:render()

    -- funciont that renders the fps
    showFPS()

    -- end rendering the virtual resolution
    push:finish()
end

function showFPS()
    love.graphics.setFont(framesPerSecondFont)
    love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    -- draw score and switch to font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)
end