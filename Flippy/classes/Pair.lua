-- Pair Class
Pair = class{}

local second_y = 1000


function Pair:init(y)
    -- Initialize past end of screen
    self.x = VIRTUAL_WIDTH + 32

    print(y)
    if y < VIRTUAL_HEIGHT / 6 * 2 then
        print("Y < ", VIRTUAL_HEIGHT / 6 * 2)
        self.y1 = -1000
        self.y2 = y
    elseif y > VIRTUAL_HEIGHT / 6 * 4 then
        print("Y > ", VIRTUAL_HEIGHT / 6 * 4)
        self.y1 = y - PIPE_HEIGHT
        self.y2 = VIRTUAL_HEIGHT + 1000
    else
        print(
            VIRTUAL_HEIGHT / 6 * 2,
            " > Y >",
            VIRTUAL_HEIGHT / 6 * 4
        )
        self.y1 = y - PIPE_HEIGHT
        self.y2 = math.random(
            y + 90,
            VIRTUAL_HEIGHT / 6 * 5.5
        )
    end

    -- print(y)
    -- self.y = y

    -- if self.y + PIPE_HEIGHT + 90 > VIRTUAL_HEIGHT - 50 then
    --     lower_y = VIRTUAL_HEIGHT + 10
    -- else
    --     lower_y = math.random(self.y + PIPE_HEIGHT + 90, VIRTUAL_HEIGHT - 50)
    -- end

    -- Instantiate pipes
    self.pipes = {
        ['upper'] = Pipe('top', self.y1),
        -- ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + gap_length)
        ['lower'] = Pipe('bottom', self.y2)
    }

    -- True when out of the screen and
    -- ready to be removed from scene
    self.remove = false
end


function Pair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = -PIPE_SPEED * dt + self.x
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end


function Pair:render()
    for _, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

