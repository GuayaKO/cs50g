Machine = class{}

function Machine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {}
	self.current = self.empty
end

function Machine:change(state_name, state_parameters)
	assert(self.states[state_name])
	self.current:exit()
	self.current = self.states[state_name]()
	self.current:enter(state_parameters)
end

function Machine:update(dt)
	self.current:update(dt)
end

function Machine:render()
	self.current:render()
end