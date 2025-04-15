output_item = {
	{"Iron Rod", "Iron Plate"},
	{"Wire", "Concrete"},
	{"Bauxite", "Cable"},
	{"Quickwire", "Screw"},
	{"Steel Beam", "Steel Pipe"},
	{"Iron Ingot", "Copper Ingot"},
	{"Iron Ore", "Copper Ore"},
	{"Rubber", "Plastic"}
}

function process(sender, item)
	-- Find current output belt number
	output = tonumber(string.match(sender.nick, 'SplitterMatrix_Row%s*(%S+)'))
	
	--print("Sender: ", sender.nick)
	-- Try to find item name
	item_name = ""
	if item ~= nil then
		item_name = item.type.name
	elseif sender:getInput().type ~= nil then
		item_name = sender:getInput().type.name
	end
	
	if item_name ~= "" then
		if item_name == output_item[output][1] then
			-- Current item correspond to the current belt
			--print("Right")
			sender:transferItem(0)
		elseif item_name == output_item[output][2] then
			-- Send right if top layer
			--print("Left")
			sender:transferItem(2)
		else
			--print("Next")
			-- Item not correponding to the output belt item. Move it to the next.
			sender:transferItem(1)
		end
	else
		--print("Unknown")
		-- Unknown item. Move it forward. Should be send to sink.
		sender:transferItem(1)
	end
end


function bootstrap()
	--print("Bootstrap")
	for s=8,1,-1 do
		splitter = component.proxy(component.findComponent("SplitterMatrix_Row" .. s))
		for _, sp in pairs(splitter) do
			process(sp, nil)
		end
	end
end

function addListeners()
	for s=1,8 do
		splitter = component.proxy(component.findComponent("SplitterMatrix_Row" .. s))
		for _, sp in pairs(splitter) do
			event.registerListener({sender=sp, event="ItemRequest"}, function(event, sender, item)
				--print("Process")
				process(sender, item)
				end)
			event.listen(sp)
		end
	end
end

function run()
	local ltime = computer.millis()
 	while true do
		--print("Pull")
 		local event = {event.pull(0.2)}
 		--print("Run")
 		future.run()
 		--print("Time")
 		local time = computer.millis()
 		if time - ltime > 200 then
 			bootstrap()
 		else
 			--print("Less than 200")
 		end
 		ltime = time
 	end
 end
 
 event.ignoreAll()
 event.clear()
 
 addListeners()
 bootstrap()
 run()
