-- Pair Class
Pair = class {}

local second_y = 1000


function Pair:init(y)
    -- Initialize past end of screen
    self.x = VIRTUAL_WIDTH + 32

    print(y)
    if y < VIRTUAL_HEIGHT / 2 then
        print("Y < ", VIRTUAL_HEIGHT / 6 * 2)
        self.y1 = y - PIPE_HEIGHT
        self.y2 = math.random(
            y + 90,
            VIRTUAL_HEIGHT / 6 * 5
        )
    else
        print("Y > ", VIRTUAL_HEIGHT / 6 * 4)
        self.y1 = math.random(
            VIRTUAL_HEIGHT / 6,
            y - 90
        ) - PIPE_HEIGHT
        self.y2 = y
    end

    -- Instantiate pipes
    self.pipes = {
        ['upper'] = Pipe('top', self.y1),
        -- ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + gap_length)
        ['lower'] = Pipe('bottom', self.y2)
    }

    -- True when ready to be removed
    self.remove = false

    -- Whether these pipes have been scored
    self.scored = false
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
