--set a table to be read only.
local ReadOnlyTable = {}

local setmetatable = setmetatable
local error = error

_ENV = ReadOnlyTable

function ReadOnlyTable:readOnly(t)
    return setmetatable({},{
        __index    = t,
        --custom method for inserting new items/updating existing items.
        __newindex = function(_,k,v)
                    error("attempt to update read only table",2)
                end,
        __len = function() return #t end,
        __metatable = false
        })
end

return setmetatable(ReadOnlyTable,{__index = ReadOnlyTable,__call = ReadOnlyTable.readOnly})



