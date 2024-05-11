Ball = class{}

-- Initialize ball object
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = math.random(-50, 50)
    self.dy = 100
    self.left = self.x
    self.right = self.x + self.width
    self.top = self.y
    self.bottom = self.y + self.height
end

-- Collision detection
function Ball:collides(other)

    -- Calculate ball sides
    self.left = self.x
    self.right = self.x + self.width
    self.top = self.y
    self.bottom = self.y + self.height

    -- Check for collision
    if self.left > other.right or other.left > self.right then
        return nil
    end
    if self.top > other.bottom or other.top > self.bottom then
        return nil
    end
    
    -- Find direction
    left_overlap = math.abs(self.left - other.right)
    right_overlap = math.abs(other.left - self.right)
    top_overlap = math.abs(self.top - other.bottom)
    bottom_overlap = math.abs(other.top - self.bottom)
    smallest_overlap = math.min(
        left_overlap,
        right_overlap,
        top_overlap,
        bottom_overlap
    )

    -- Return direction code
    if smallest_overlap == top_overlap then
        return "top"
    elseif smallest_overlap == right_overlap then
        return "right"
    elseif smallest_overlap == bottom_overlap then
        return "bottom"
    else
        return "left"
    end
end

-- Calculate bounce
function Ball:bounce(other, direction)
    if direction == "top" then
        self.dy = -ball.dy * 1.03
        self.y = other.y + other.height
        if ball.dx < 0 then
            ball.dx = -math.random(10, 150)
        else
            ball.dx = math.random(10, 150)
        end
    elseif direction == "right" then
        self.dx = -ball.dx * 1.03
        self.x = other.x - self.width
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    elseif direction == "bottom" then
        self.dy = -ball.dy * 1.03
        self.y = other.y - self.height
        if ball.dx < 0 then
            ball.dx = -math.random(10, 150)
        else
            ball.dx = math.random(10, 150)
        end
    else
        self.dx = -ball.dx * 1.03
        self.x = other.x + other.width
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

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
    self.left = self.x
    self.right = self.x + self.width
    self.top = self.y
    self.bottom = self.y + self.height
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