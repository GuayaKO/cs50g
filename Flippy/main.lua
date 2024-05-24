-- FLIPPY

-- Based on code by Colton Ogden
-- Modifications by Manuel Velarde


-- Virtual resolution handling library
push = require 'push'

-- Screen resolution
SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions(1)

-- Virtual resolution
VIRTUAL_WIDTH = SCREEN_WIDTH / 4
VIRTUAL_HEIGHT = SCREEN_HEIGHT / 4

-- Load images into memory
local BACKGROUND = love.graphics.newImage('images/background.png')
local FOREGROUND = love.graphics.newImage('images/foreground.png')


-- Initialize the game
function love.load()

    -- Prevent blurring of text and graphics
    -- with nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set app window title
    love.window.setTitle('Flippy Bird')

    -- Initialize virtual resolution
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        SCREEN_WIDTH,
        SCREEN_HEIGHT,
        {
            vsync = true,
            fullscreen = true,
            resizable = true
        }
    )
end


-- Handle window resizing
function love.resize(width, height)
    push:resize(width, height)
end


-- Handle keyboard input
function love.keypressed(key)

    -- Fast way to close the app
    if key == 'escape' then
        love.event.quit()
    end

    -- Toggle fullscreen mode
    if key == "f11" then
        local is_fullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not is_fullscreen, 'desktop')
    end
end


-- Draw to the screen
function love.draw()
    push:start()

    -- Draw background starting at
    -- the top left
    love.graphics.draw(BACKGROUND, 0, 0)

    -- Draw foreground towards the
    -- bottom of the screen
    love.graphics.draw(FOREGROUND, 0, VIRTUAL_HEIGHT - 16)

    push:finish()
end