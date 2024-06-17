Score = class{ __includes = State }


function Score:enter(state_parameters)
    self.score = state_parameters.score
end

function Score:update(dt)
    -- Go back if enter is pressed
    if love.keyboard.pressed('enter') or love.keyboard.pressed('return') then
        game_state:change('count')
    end
end

function Score:render()
    love.graphics.setFont(large_font)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(medium_font)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end