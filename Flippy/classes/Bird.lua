-- Bird Class
Bird = class{}

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


function Bird:update(dt)
    -- Apply gravity to velocity
    self.dy = GRAVITY * dt + self.dy

    -- Apply velocity to Y position
    self.y = self.y + self.dy
end


function Bird:render()
    love.graphics.draw(
        self.image,
        self.x,
        self.y
    )
end