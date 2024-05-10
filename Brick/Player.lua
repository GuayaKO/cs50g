Player = class{}

-- Initialize player object
function Player:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = 0
    self.lives = 3
end

-- Update player position
function Player:update(dt)
    if self.dx < 0 then
        self.x = math.max(
            0,
            self.dx * dt + self.x
        )
    else
        self.x = math.min(
            VIRTUAL_WIDTH - self.width,
            self.dx * dt + self.x
        )
    end
end

-- Render player on screen
function Player:render()
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.width,
        self.height
    )
end

-- Reduce player life counter
function Player:reduce()
    self.lives = self.lives - 1
end

-- Increase player life counter
function Player:increase()
    self.lives = self.lives + 1
end