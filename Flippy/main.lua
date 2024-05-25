-- FLIPPY

-- Based on code by Colton Ogden
-- Modifications by Manuel Velarde


-- Virtual resolution handling library
push = require 'modules.push'

-- Classic OOP class library
class = require 'modules.class'

-- Local Bird class
require 'classes.Bird'

-- Screen resolution
-- SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions(1)
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

-- Virtual resolution
VIRTUAL_WIDTH = SCREEN_WIDTH / 4
VIRTUAL_HEIGHT = SCREEN_HEIGHT / 4

-- Load images into memory
local BACKGROUND = love.graphics.newImage('images/background.png')
local FOREGROUND = love.graphics.newImage('images/foreground.png')

-- Scroll speed
local BACKGROUND_SCROLL_SPEED = 30
local FOREGROUND_SCROLL_SPEED = 60

-- Looping point
local BACKGROUND_LOOPING_POINT = 413

-- Keep track of scrolling
local background_scroll = 0
local foreground_scroll = 0

-- Instantiate bird object
local bird = Bird()


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
            fullscreen = false,
            resizable = true
        }
    )

    -- Initialize input table
    love.keyboard.keysPressed = {}
end


-- Handle window resizing
function love.resize(width, height)
    push:resize(width, height)
end


-- Handle keyboard input
function love.keypressed(key)

    -- Add key to table
    love.keyboard.keysPressed[key] = true

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


-- Global input check
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


-- Update game state
function love.update(dt)

    -- Scroll background
    background_scroll = (BACKGROUND_SCROLL_SPEED * dt + background_scroll)
        % BACKGROUND_LOOPING_POINT

    -- Scroll foreground
    foreground_scroll = (FOREGROUND_SCROLL_SPEED * dt + foreground_scroll)
        % VIRTUAL_WIDTH

    bird:update(dt)

    -- Reset input table
    love.keyboard.keysPressed = {}
end

-- Draw to the screen
function love.draw()
    push:start()

    -- Draw background starting at
    -- the top left
    love.graphics.draw(
        BACKGROUND,
        -background_scroll,
        0
    )

    -- Draw foreground towards the
    -- bottom of the screen
    love.graphics.draw(
        FOREGROUND,
        -foreground_scroll,
        VIRTUAL_HEIGHT - 16
    )

    -- Draw bird on top
    bird:render()

    push:finish()
end