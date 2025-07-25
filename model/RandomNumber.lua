local remove <const> = table.remove
local setmetatable <const> = setmetatable

local ApiHandler <const> = require('model.ApiHandler')

local RandomNumber <const> = {}
RandomNumber.__index = RandomNumber

_ENV = RandomNumber

local data = {}

local function getNumberFromData()
	return remove(data)
end

local function resetData(upperLimit)
	local response <const> = ApiHandler.SendRequest(10,1,upperLimit)
	data = response.data
end

function RandomNumber:getNumber()
	if not data or #data < 1 then
		resetData(self.upperLimit)
	end
	return getNumberFromData()
end

function RandomNumber:new(file)
	return setmetatable({upperLimit = #file - 10},self)
end

return RandomNumber
