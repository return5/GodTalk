local ReadFile <const> = require("auxiliary.ReadFile")


local function readLines(n,bible)
	io.write("God says: \n")
	local quote <const> = {}
	for i=n,n+10,1 do
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
	local fileName = io.read("*l"):match("[^\n\r]+")
	local file = io.open(fileName ,"a")
	file:write(quote .. "\n\n")
	io.write("successfully saved quote to " .. fileName)
	file:close()
end

local function clearScreen()

end

local function loopRead(bible)
	local rand = math.random
	repeat
		local n = rand(1,#bible)
		local quote = readLines(n,bible)
		io.write(quote)
		local response = prompt()
		if response == "s"  or response == "S" then
			clearScreen()
			saveQuote(quote)
		end
	until(response == "n" or response == "N")
end

local function main()
	math.randomseed(os.time())
	local bible <const> = ReadFile("./auxiliary/bible.txt","[^\n\r]-[\n\r]+",true)
	loopRead(bible)
end


main()