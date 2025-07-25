local setmetatable <const> = setmetatable

local ApiResponse <const> = {}
ApiResponse.__index = ApiResponse

_ENV = ApiResponse


function ApiResponse:new(response)
	return setmetatable({data = response.result.random.data},self)
end

return ApiResponse
