output_belt = {
	"Iron Rod",
	"Screw",
	"Copper Ingot",
	"Quickwire",
	"Iron Plate",
	"Concrete",
	"Cable",
	"Wire"
}

function process(sender, item)
	-- Find current output belt number
	belt = tonumber(string.match(sender.nick, 'OutputBelt%s*(%S+)'))
	
	-- Try to find item name
	item_name = ""
	if item ~= nil then
		item_name = item.type.name
	else
		if sender:getInput().type ~= nil then
			item_name = sender:getInput().type.name
		end
	end
	
	if item_name ~= "" then
		if item_name == output_belt[belt] then
			-- Current item correspond to the current belt
			if string.find(sender.nick, "Bottom") then
				-- Send left if bottom layer
				sender:transferItem(2)
			else
				-- Send right if top layer
				sender:transferItem(0)
			end
		else
			-- Item not correponding to the output belt item. Move it to the next.
			sender:transferItem(1)
		end
	else
		-- Unknown item. Move it forward. Should be send to sink.
		sender:transferItem(1)
	end
end

function bootstrap()
	for s=8,1,-1 do
		selectors = component.proxy(component.findComponent("OutputBelt" .. s))
		for _, sp in pairs(selectors) do
			process(sp, nil)
		end
	end
end

function addListeners()
	for s=1,8 do
		selectors = component.proxy(component.findComponent("OutputBelt" .. s))
		for _, sp in pairs(selectors) do
			event.registerListener({sender=sp, event="ItemRequest"}, function(event, sender, item)
				process(sender, item)
				end)
			event.listen(sp)
		end
	end
end

function run()
	local ltime = computer.millis()
	while true do
		local event = {event.pull(0.2)}
		future.run()
		local time = computer.millis()
		if time - ltime > 200 then
			bootstrap()
			ltime = time
		end
	end
end

event.ignoreAll()
event.clear()

addListeners()
bootstrap()
run()
