-- Pipe Class
Pipe = class{}

-- Declare constants
local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')

PIPE_SPEED = 60

PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()


function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    -- Set random Y value
    -- self.y = math.random(
    --     VIRTUAL_HEIGHT / 3.5,
    --     VIRTUAL_HEIGHT - 10
    -- )

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end


function Pipe:update(dt)
    -- self.x = PIPE_SCROLL * dt + self.x
end


function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,
        math.floor(self.x + 0.5),
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0,
        1,
        (self.orientation == 'top' and -1 or 1)
    )
end