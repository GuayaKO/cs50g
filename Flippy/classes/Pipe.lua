-- Pipe Class
Pipe = class{}

-- Declare constants
local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')
local PIPE_SCROLL = -60
local SCALE_FACTOR = 0.9


function Pipe:init()
    self.x = VIRTUAL_WIDTH + 10

    -- Set random Y value
    self.y = math.random(
        VIRTUAL_HEIGHT / 3.5,
        VIRTUAL_HEIGHT - 10
    )

    self.width = PIPE_IMAGE:getWidth() * SCALE_FACTOR
end


function Pipe:update(dt)
    self.x = PIPE_SCROLL * dt + self.x
end


function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,
        math.floor(self.x + 0.5),
        math.floor(self.y),
        0,
        SCALE_FACTOR,
        SCALE_FACTOR
    )
end