-- FLIPPY

-- Based on code by Colton Ogden
-- Modifications by Manuel Velarde


-- Virtual resolution handling library
push = require 'modules.push'

-- Classic OOP class library
class = require 'modules.class'

-- Import local classes
require 'classes.Bird'
require 'classes.Pipe'
require 'classes.Pair'

-- Screen resolution
SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions(1)
-- SCREEN_WIDTH = 1280
-- SCREEN_HEIGHT = 720

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
local FOREGROUND_LOOPING_POINT = 512

-- Keep track of scrolling
local background_scroll = 0
local foreground_scroll = 0

-- Instantiate bird object
local bird = Bird()

-- Table for spawning pipes
local pipes = {}

-- Timer for spawning pipes
local spawn_timer = 0

-- Initial Y value
math.randomseed(os.time())
local last_y = math.random(
    VIRTUAL_HEIGHT / 6 * 4.5,
    VIRTUAL_HEIGHT / 6 * 1.5
)


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
        % FOREGROUND_LOOPING_POINT

    -- Track time till next spawn
    spawn_timer = spawn_timer + dt

    -- Spawn a pipe if times is past 2 seconds
    if spawn_timer > 2.5 then
        table.insert(pipes, Pair(last_y))
        print('Pipes created.')
        last_y = math.random(
            VIRTUAL_HEIGHT / 6 * 1.25,
            VIRTUAL_HEIGHT / 6 * 4.75
        )
        spawn_timer = 0
    end

    bird:update(dt)

    -- Iterate over pipes
    for _, pair in pairs(pipes) do
        pair:update(dt)
    end

    for p, pair in pairs(pipes) do
        -- Remove pipes that go off screen
        if pair.remove then
            table.remove(pipes, p)
        end
    end

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

    -- Draw all pipes
    for _, pair in pairs(pipes) do
        pair:render()
    end

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