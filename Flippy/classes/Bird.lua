-- Bird Class
Bird = class {}

local GRAVITY = 20


function Bird:init()
    -- Load image and record width and height
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity
    self.dy = 0
end

function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x then
        if self.x + 2 <= pipe.x + PIPE_WIDTH then
            if (self.y + 2) + (self.height - 4) >= pipe.y then
                if self.y + 2 <= pipe.y + PIPE_HEIGHT then
                    return true
                end
            end
        end
    end
    return false
end

function Bird:update(dt)
    -- Apply gravity to velocity
    self.dy = GRAVITY * dt + self.dy

    -- Add lift to bird
    if love.keyboard.wasPressed('space') then
        self.dy = -3
    end

    -- Apply velocity to Y position
    self.y = self.y + self.dy

    if self.y < 0 or self.y + self.height > VIRTUAL_HEIGHT then
        return true
    end
    return false
end

function Bird:render()
    love.graphics.draw(
        self.image,
        self.x,
        self.y
    )
end
