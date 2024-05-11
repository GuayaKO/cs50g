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
function Ball:collides(object)

    -- Calculate ball sides
    self.left = self.x
    self.right = self.x + self.width
    self.top = self.y
    self.bottom = self.y + self.height

    -- Check for collision
    if self.left > object.right or object.left > self.right then
        return nil
    end
    if self.top > object.bottom or object.top > self.bottom then
        return nil
    end
    
    -- Find direction
    left_overlap = math.abs(self.left - object.right)
    right_overlap = math.abs(object.left - self.right)
    top_overlap = math.abs(self.top - object.bottom)
    bottom_overlap = math.abs(object.top - self.bottom)
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
function Ball:bounce(object, direction)
    if direction == "top" then
        self.dy = -ball.dy * 1.03
        self.y = object.y + object.height
        if ball.dx < 0 then
            ball.dx = -math.random(10, 150)
        else
            ball.dx = math.random(10, 150)
        end
    elseif direction == "right" then
        self.dx = -ball.dx * 1.03
        self.x = object.x - self.width
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    elseif direction == "bottom" then
        self.dy = -ball.dy * 1.03
        self.y = object.y - self.height
        if ball.dx < 0 then
            ball.dx = -math.random(10, 150)
        else
            ball.dx = math.random(10, 150)
        end
    else
        self.dx = -ball.dx * 1.03
        self.x = object.x + object.width
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