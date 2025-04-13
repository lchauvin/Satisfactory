splitter_matrix = component.proxy(component.findComponent("SplitterMatrix_Row"))

sorting_list = {
	-- Left, Right
	{"Iron Rod", "Iron Plate"},
	{"Wire", "Cable"},
	{"Concrete", "Silica"},
	{"", "Wire"},
	{"Coal", "Wire"},
	{"Coal", "Wire"},
	{"Coal", "Wire"},
	{"Coal", "Wire"},
}

while true do
	for i=1,8 do
		splitter_matrix_last_row = component.proxy(component.findComponent("SplitterMatrix_Row " .. i))
		for _, sp in pairs(splitter_matrix_last_row) do
			item = sp:getInput().type
			if item then
				if item.name == sorting_list[i][1] then
					sp:transferItem(2)
				elseif item.name == sorting_list[i][2] then
					sp:transferItem(0)
				else
					sp:transferItem(1)
				end
			end
		end
	end
	sleep(0.1)
end
