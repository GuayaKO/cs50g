Brick = class{}

-- Initialize brick object
function Brick:init(others)
    repeat
        self.x = math.random(0, VIRTUAL_WIDTH - 30)
        self.y = math.random(0, VIRTUAL_HEIGHT - 80)
        self.width = math.random(10, 30)
        self.height = math.random(10, 30)
        self.left = self.x
        self.right = self.x + self.width
        self.top = self.y
        self.bottom = self.y + self.height
    until not intersects(self, others)
    self.lifes = 3
end

-- Detect overlap
function Brick:overlaps(other)
    if self.left > other.right or other.left > self.right then
        return false
    end
    if self.top > other.bottom or other.top > self.bottom then
        return false
    end
    return true
end

-- Comparing over list
function intersects(this, others)
    for _, that in ipairs(others) do
        if this:overlaps(that) then
            return true
        end
    end
    return false
end

-- Erode brick when hit
function Brick:erode()
    self.lifes = self.lifes - 1
end

-- Render brick on screen
function Brick:render()
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.width,
        self.height
    )
end