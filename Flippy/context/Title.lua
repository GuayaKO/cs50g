Title = class{__includes = State}

function Title:update(dt)
    if love.keyboard.pressed('enter') or love.keyboard.pressed('return') then
        game_state:change('play')
    end
end

function Title:render()
    love.graphics.setFont(large_font)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(medium_font)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end