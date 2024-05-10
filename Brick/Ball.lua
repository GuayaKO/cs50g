Ball = class{}

-- Initialize ball object
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = math.random(-50, 50)
    self.dy = 100
end

-- Collision detection
function Ball:collides(player)
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end
    if self.y > player.y + player.height or player.y > self.y + self.height then
        return false
    end
    return true
end

-- Reset ball position
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = math.random(-50, 50)
    self.dy = 100
end

-- Update ball position
function Ball:update(dt)
    self.x = self.dx * dt + self.x
    self.y = self.dy * dt + self.y
end

-- Render ball on screen
function Ball:render()
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.width,
        self.height
    )
end