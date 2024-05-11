-- BRICKS

-- Based on code by Colton Ogden
-- Modifications by Manuel Velarde


-- To draw game at virtual resolution
push = require 'push'

-- To use the OOP paradigm
class = require 'class'
require 'Player'
require 'Ball'
require 'Brick'

-- Capture display dimensions
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions(1)

-- Set vitual resolution
VIRTUAL_WIDTH = WINDOW_WIDTH / 4
VIRTUAL_HEIGHT = WINDOW_HEIGHT / 4

-- Player movement speed
PLAYER_SPEED = 200


-- Initialize the game
function love.load()
    -- Hide pointer
    love.mouse.setVisible(false)

    -- Prevent blurring of text and graphics
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set window title
    love.window.setTitle('Bricks')

    -- Seed calls to random
    math.randomseed(os.time())

    -- Load and set retro-looking font objects
    small_font = love.graphics.newFont('font.ttf', 8)
    medium_font = love.graphics.newFont('font.ttf', 16)
    large_font = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(small_font)

    -- Set up sound effects
    sound_effect = {
        ['paddle_hit'] = love.audio.newSource(
            'sounds/paddle_hit.wav',
            'static'
        ),
        ['score_tone'] = love.audio.newSource(
            'sounds/score_tone.wav',
            'static'
        ),
        ['border_hit'] = love.audio.newSource(
            'sounds/border_hit.wav',
            'static'
        )
    }

    -- Initialize virtual resolution
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = true,
            resizable = false,
            vsync = true
        }
    )

    -- Initialize player object
    player = Player(
        10,
        VIRTUAL_HEIGHT - 20,
        25,
        20
    )

    -- Initialize ball object
    ball = Ball(
        VIRTUAL_WIDTH / 2 - 2,
        VIRTUAL_HEIGHT / 2 - 2,
        4,
        4
    )

    -- Initialize brick objects
    field = {}
    field[0] = ball
    for i = 1, 10 do
        field[i] = Brick(field)
    end

    -- Set initial game state
    game_state = 'start'
end

function love.update(dt)
    -- Detect collisions
    if game_state == 'play' then
        -- Ball against player
        direction = ball:collides(player)

        -- Bounce
        if direction then
            ball:bounce(player, direction)
            sound_effect.paddle_hit:play()
        else
            for i = 1, 10 do
                brick = field[i]
                direction = ball:collides(brick)
                if direction then
                    ball:bounce(brick, direction)
                    brick:erode()
                end
            end
        end

        for i = 1, 10 do
            brick = field[i]
            if brick.lifes == 0 then
                field[i] = Brick(field)
            end
        end

        -- Ball boundary collision
        -- Hit upper border
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            -- Play border hit sound
            sound_effect.border_hit:play()
        end

        -- Hit left border
        if ball.x <= 0 then
            ball.x = 0
            ball.dx = -ball.dx

            -- Play border hit sound
            sound_effect.border_hit:play()
        end

        -- Hit right border
        if ball.x >= VIRTUAL_WIDTH - 4 then
            ball.x = VIRTUAL_WIDTH - 4
            ball.dx = -ball.dx

            -- Play border hit sound
            sound_effect.border_hit:play()
        end
    end

    -- Reset when life is lost
    if ball.y > VIRTUAL_HEIGHT then
        -- Play score tone
        sound_effect.score_tone:play()

        player:reduce()
        if player.lives == 0 then
            game_state = 'end'
        else
            game_state = 'pause'
        end

        -- Reset ball state
        ball:reset()
    end

    -- Capture player movement
    if love.keyboard.isDown('left') and game_state ~= 'pause' then
        player.dx = -PLAYER_SPEED
    elseif love.keyboard.isDown('right') and game_state ~= 'pause' then
        player.dx = PLAYER_SPEED
    else
        player.dx = 0
    end

    -- Update ball position
    if game_state == 'play' then
        ball:update(dt)
    end

    -- Update player position
    player:update(dt)
end

-- Keyboard handling
function love.keypressed(key)
    --Terminate application
    if key == 'escape' then
        love.mouse.setVisible(true)
        love.event.quit()

        -- Change game state
    elseif key == 'enter' or key == 'return' then
        -- Start or resume game
        if game_state == 'start' or game_state == 'pause' then
            game_state = 'play'

            -- Restart game
        elseif game_state == 'end' then
            -- Reset player life counter
            player.lives = 3

            -- Reset ball
            ball:reset()

            game_state = 'play'
        else
            game_state = 'pause'
        end
    end
end

-- Draw to the screen
function love.draw()
    -- Begin rendering at virtual resolution
    push:apply('start')

    -- Set background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)

    -- Draw user greeting
    love.graphics.setFont(small_font)
    if game_state == 'start' then
        love.graphics.printf(
            'Welcome to Bricks!',
            0,
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    end

    -- Draw pause message
    if game_state == 'pause' then
        love.graphics.printf(
            'Paused',
            0,
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    end

    -- Draw end of game message
    love.graphics.setFont(medium_font)
    if game_state == 'end' then
        love.graphics.printf(
            'You lost :(',
            0,
            20,
            VIRTUAL_WIDTH,
            'center'
        )
    end

    -- Draw life counter
    love.graphics.setFont(large_font)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print(
        tostring(player.lives),
        VIRTUAL_WIDTH * 9 / 10,
        VIRTUAL_HEIGHT / 10
    )
    love.graphics.setColor(1, 1, 1, 1)

    -- Render player object
    player:render()

    -- Render ball object
    ball:render()

    for i = 1, 10 do
        field[i]:render()
    end

    -- Display FPS counter
    displayFPS()

    -- End rendering at virtual resolution
    push:apply('end')
end

-- Render current FPS
function displayFPS()
    love.graphics.setFont(small_font)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print(
        'FPS: ' .. tostring(love.timer.getFPS()),
        10,
        10
    )
end
