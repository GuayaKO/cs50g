Play = class { __includes = State }


function Play:init()
    -- Instantiate bird object
    self.bird = Bird()

    -- Table and timer for spawning pipes
    self.pipes = {}
    self.timer = 0

    -- Score counter
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    math.randomseed(os.time())
    self.last_y = math.random(
        VIRTUAL_HEIGHT / 6 * 4,
        VIRTUAL_HEIGHT / 6 * 2
    )
end

function Play:update(dt)
    -- Update timer for pipe spawning
    self.timer = self.timer + dt

    -- Spawn a new pipe pair every 2 seconds
    if self.timer > 2.5 then
        -- Add new pipe pair
        table.insert(self.pipes, Pair(self.last_y))

        -- Modify last Y coordinate
        self.last_y = math.random(
            VIRTUAL_HEIGHT / 6 * 2,
            VIRTUAL_HEIGHT / 6 * 4
        )

        -- Reset spawn timer
        self.timer = 0
    end

    -- Update position of pipes
    for _, pair in pairs(self.pipes) do

        -- Keep score count
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end
        pair:update(dt)
    end

    -- Remove pipes that go off screen
    for p, pair in pairs(self.pipes) do
        if pair.remove then
            table.remove(self.pipes, p)
        end
    end

    -- Update bird
    self.bird:update(dt)

    -- Check if bird collided with any pipe
    for _, pair in pairs(self.pipes) do
        for _, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                game_state:change(
                    'score',
                    {
                        score = self.score
                    }
                )
            end
        end
    end

    -- Reset if we hit screen margins
    if self.bird.y < 0 or self.bird.y > VIRTUAL_HEIGHT - self.bird.height then
        game_state:change(
            'score',
            {
                score = self.score
            }
        )
    end
end

function Play:render()
    -- Draw all pipes
    for _, pair in pairs(self.pipes) do
        pair:render()
    end

    -- Draw bird on top
    self.bird:render()
end
