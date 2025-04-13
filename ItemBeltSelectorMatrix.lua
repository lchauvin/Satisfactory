output_belt = {
	"Iron Rod",
	"Wire",
	"Copper Ingot",
	"Quickwire",
	"Iron Plate",
	"Concrete",
	"Cable",
	"Screw"
}

while true do
	for s=1,8 do
		selectors = component.proxy(component.findComponent("OutputBelt" .. s))
		for _, sp in pairs(selectors) do
			item = sp:getInput().type
			if item then
				--print("Input Item: ", item.name)
				if item.name == output_belt[s] then
					--print("Send to belt ", s)
					--print("Splitter: ", sp.nick)
					if string.find(sp.nick, "Bottom") then
						-- Bottom Layer, send right
						--print("From bottom layer (send right)")
						sp:transferItem(2)
					else
						-- Top Layer, send left
						--print("From top layer (send left)")
						sp:transferItem(0)
					end
				else
					sp:transferItem(1)
				end
			end
		end
	end
	sleep(0.1)
end
