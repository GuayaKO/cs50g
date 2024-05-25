-- Bird Class
Bird = class{}


function Bird:init()

    -- Load image and record width and height
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end


function Bird:render()
    love.graphics.draw(
        self.image,
        self.x,
        self.y
    )
end