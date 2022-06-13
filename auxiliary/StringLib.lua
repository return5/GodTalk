local match  = string.match
local gmatch = string.gmatch
local gsub   = string.gsub
local rand   = math.random
local type   = type

local StringLib  = {}
StringLib.__index = StringLib

--pattern of a word
local wordsMatch = "[^_,.;:\"\'?!%s\n\r/]+"

--pattern to match word surrounded by punctuation or space characters.
local wordPat    = "[_.,:;\"\'?!%s/]*(" .. wordsMatch .. ")[/_.,:;\"\'?!%s\n\r]+"

_ENV = StringLib


--get a random word from a string or table of words.
--if param is a string it is first converted to a table of words.
--each time it is called it grabs a word at random from the table, so repeated values are expected.
function StringLib.getRandom(str)
    local words = (type(str) == "string" and StringLib.getWords(str)) or (type(str) == "table" and str)
    return function()
        return words[rand(1,#words)]
    end
end

--get a table which has been randomly shuffled.
local function randShuffle(words)
    local shuff = {}
    local prevI = {}
    for i=1,#words,1 do
        local j
        repeat
            j = rand(1,#words)
        until(not prevI[j])
        prevI[j] = true
        shuff[j] = words[i]
    end
    return shuff
end

--get a unique random word from a string or a table of words
--if param is string then first convert it to a table of words.
--if rollOver is true then once all the words in the original table of words have been used, the word table is reshuffled and is used again.
--if rollOver is false or nil then after all words have been used up all subsequent calls will return an empty string.
function StringLib.getUniqueRandom(str,rollOver)
    local words   = (type(str) == "string" and StringLib.getWords(str)) or (type(str) == "table" and str)
    local shuffle = randShuffle(words)
    return function()
        if #shuffle == 0 then
            if rollOver then
                shuffle = randShuffle(words)
            else
                return ""
            end
        end
        local word = shuffle[#shuffle]
        shuffle[#shuffle] = nil
        return word
    end
end

--return table containing all words from the string.
-- word is defined as group of any non space or non punctuation characters, except hypen, which is surrounded by space or punctuation characters.
function StringLib.getWords(str)
    local words = {}
    for m in gmatch(str,wordsMatch) do
        words[#words + 1] = m
    end
    return words
end

--grab the first word in the string.
--word is defined as group of any non space and non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.
function StringLib.word(str)
    return match(str,wordPat)
end

--function to replace all multi-spaces with a single space.
function StringLib.squishSpaces(str)
    return gsub(str,"  +"," ")
end

--trim space from front and rear of string.
function StringLib.trim(str)
    return StringLib.trimSpaceRear(StringLib.trimSpaceFront(str))
end

--trim space from the rear of a string.
function StringLib.trimSpaceRear(str)
    return match(str,"^(.-)%s*$")
end

--trim space from the front of a string.
function StringLib.trimSpaceFront(str)
    return match(str,"^%s*(.+)$")
end

return StringLib
