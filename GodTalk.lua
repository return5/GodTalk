--[[
GodTalk - program which grabs a random line and the following 9 lines from the bible and displays them.
    Copyright (C) <2022>  <return5>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

local ReadFile <const> = require("auxiliary.ReadFile")
local RandomNumber <const> = require('model.RandomNumber')
local Config <const> = require('auxiliary.Config')


local function readLines(n,bible)
	local quote <const> = {}
	for i=n,n + 9,1 do
		quote[#quote + 1] = bible[i]
	end
	return table.concat(quote,"")
end

local function prompt()
	io.write("\n would you like another verse? (y/n) or would you like to save this verse to a txt file? (s)\n")
	local response = ""
	repeat
		response = io.read("*l")
	until(response == "Y" or response == "y" or response == "n" or response == "N" or response == "s" or response == "S")
	return response
end

local function saveQuote(quote)
	io.write("\n please enter name of file to save to. (existing files will be appended to, not over-written.) \n")
	local fileName <const> = io.read("*l"):match("[^\n\r]+")
	local file <const> = io.open(fileName ,"a")
	file:write(quote .. "\n\n")
	io.write("successfully saved quote to " .. fileName)
	file:close()
end

local function clearScreen()
	io.write("\x1B[2J")
	io.write("\r")
	io.write("\x1B[H")
end

local function printQuote(quote)
	clearScreen()
	io.write("God says: \n")
	io.write(quote)
end

local function clearPropmptLine()
	io.write("\x1B[3A")
	io.write("\x1B[0J")
end

local function loopRead(bible)
	local rand <const> = RandomNumber:new(bible)
	repeat
		local n <const> = rand:getNumber()
		clearScreen()
		local quote <const> = readLines(n,bible)
		printQuote(quote)
		local response = prompt()
		if response == "s"  or response == "S" then
			clearPropmptLine()
			saveQuote(quote)
			response = prompt()
		end
		io.write("\n")
	until(response == "n" or response == "N")
end

local function main()
	if not Config.apiKey or Config.apiKey == "" then
		io.write("please put you Api Key into 'auxiliary/Config\n")
		os.exit()
	end
	local bible <const> = ReadFile("./auxiliary/bible.txt","[^\n\r]-[\n\r]+",true)
	loopRead(bible)
end


main()