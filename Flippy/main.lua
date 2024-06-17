-- FLIPPY

-- Based on code by Colton Ogden
-- Modifications by Manuel Velarde


-- Virtual resolution handling library
push = require 'modules.push'

-- Classic OOP class library
class = require 'modules.class'

-- Import local classes
require 'classes/Bird'
require 'classes/Pipe'
require 'classes/Pair'

-- Import state machine context
require 'classes/Machine'
require 'context/State'
require 'context/Play'
require 'context/Title'
require 'context/Score'
require 'context/Count'

-- Screen resolution
SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions(1)
-- SCREEN_WIDTH = 1280
-- SCREEN_HEIGHT = 720

-- Virtual resolution
VIRTUAL_WIDTH = SCREEN_WIDTH / 3
VIRTUAL_HEIGHT = SCREEN_HEIGHT / 3

-- Load images into memory
local BACKGROUND = love.graphics.newImage('images/background.png')
local FOREGROUND = love.graphics.newImage('images/foreground.png')

-- Set scroll speed
local BACKGROUND_SCROLL_SPEED = 25
FOREGROUND_SCROLL_SPEED = 60

-- Looping point
local BACKGROUND_LOOPING_POINT = 413
local FOREGROUND_LOOPING_POINT = 104

-- Keep track of scrolling
local background_scroll = 0
local foreground_scroll = 0

-- Background scaling factor
local scale_factor = VIRTUAL_HEIGHT / BACKGROUND:getHeight()


-- Initialize the game
function love.load()
    -- Initialize nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set window title
    love.window.setTitle('Flippy Bird')

    -- Initialize retro fonts
    small_font = love.graphics.newFont('fonts/font.ttf', 8)
    medium_font = love.graphics.newFont('fonts/flappy.ttf', 14)
    large_font = love.graphics.newFont('fonts/flappy.ttf', 28)
    huge_font = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(large_font)

    -- Initialize sound table
    sound_effect = {
        ['jump'] = love.audio.newSource('audio/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('audio/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('audio/score.wav', 'static'),
        ['music'] = love.audio.newSource('audio/marios_way.mp3', 'static')
    }
    sound_effect['music']:setLooping(true)
    sound_effect['music']:play()

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

    -- Initialize state machine
    game_state = Machine {
        ['title'] = function() return Title() end,
        ['play'] = function() return Play() end,
        ['score'] = function() return Score() end,
        ['count'] = function() return Count() end
    }
    game_state:change('title')

    -- Initialize input table
    love.keyboard.keys = {}
end

-- Handle window resizing
function love.resize(width, height)
    push:resize(width, height)
end

-- Handle keyboard input
function love.keypressed(key)
    -- Add key to table
    love.keyboard.keys[key] = true

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
function love.keyboard.pressed(key)
    return love.keyboard.keys[key]
end

-- Update game state
function love.update(dt)
    -- Scroll background
    background_scroll = (BACKGROUND_SCROLL_SPEED * dt + background_scroll)
        % BACKGROUND_LOOPING_POINT

    -- Scroll foreground
    foreground_scroll = (FOREGROUND_SCROLL_SPEED * dt + foreground_scroll)
        % FOREGROUND_LOOPING_POINT

    game_state:update(dt)

    -- Reset input table
    love.keyboard.keys = {}
end

-- Draw to the screen
function love.draw()
    push:start()

    -- Draw background starting at the top left
    love.graphics.draw(
        BACKGROUND,
        -background_scroll,
        0,
        0,
        1,
        scale_factor
    )

    game_state:render()

    -- Draw foreground towards bottom of the screen
    love.graphics.draw(
        FOREGROUND,
        -foreground_scroll,
        VIRTUAL_HEIGHT - 16
    )

    push:finish()
end
