Count = class{ __includes = State }


COUNTDOWN_TIME = 0.75


function Count:init()
    self.count = 3
    self.timer = 0
end

function Count:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            game_state:change('play')
        end
    end
end

function Count:render()
    love.graphics.setFont(huge_font)
    love.graphics.printf(
        tostring(self.count),
        0,
        120,
        VIRTUAL_WIDTH,
        'center'
    )
end