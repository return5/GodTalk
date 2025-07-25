local setmetatable <const> = setmetatable

local ApiRequest <const> = {}
ApiRequest.__index = ApiRequest

_ENV = ApiRequest

local id = 1

local function getId()
	local currentId <const> = id
	id = id + 1
	return currentId
end

function ApiRequest:new(quantity,min,max,apiKey)
	return setmetatable({params = {min = min,max = max,n = quantity,apiKey = apiKey},jsonrpc = "2.0",method = "generateIntegers",id = getId() },self)

end

return ApiRequest
