local Config <const> = require('auxiliary.Config')
local Json <const> = require('auxiliary.json')
local ApiResponse <const> = require('model.ApiResponse')
local ApiRequest <const> = require('model.ApiRequest')
local popen <const> = io.popen

local ApiHandler <const> = {}
ApiHandler.__index = ApiHandler

_ENV = ApiHandler

local url = 'https://api.random.org/json-rpc/4/invoke'
local curl = [[curl -H "Content-Type: application/json" -d ']]

local function send(request)
	local jsonRequest <const> = Json.encode(request)
	local pipe <const> = popen(curl .. jsonRequest .. "' " .. url)
	local results <const> = pipe:read("a")
	pipe:close()
	return ApiResponse:new(Json.decode(results))
end

function ApiHandler.SendRequest(quantity,lowerLimit,upperLimit)
	local request <const> = ApiRequest:new(quantity,lowerLimit,upperLimit,Config.apiKey)
	return send(request)
end

return ApiHandler
