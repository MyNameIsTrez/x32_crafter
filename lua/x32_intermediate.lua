-- CONFIGURATION ---------------------------------------------------------------

local modem_side = "top"

local id_master = 76

-- INITIALIZATION --------------------------------------------------------------

rednet.open(modem_side)

-- CODE ------------------------------------------------------------------------

function main()
	while true do
		local sender_id, message = rednet.receive()
		-- print(message)

		if sender_id == id_master then
			local tab = textutils.unserialize(message)
			local fn_name = tab["fn_name"]
			local color = tab["arg"]
			functions[fn_name](color)
		end
	end
end

function take(color)
	pulse_color("back", color)
end
function send_as_recipe(color)
	pulse_color("right", color)
end
function send_as_ingredient(color)
	pulse_color("left", color)
end

function pulse_color(side, color)
	rs.setBundledOutput(side, color)
	-- sleep(0.05)
	rs.setBundledOutput(side, 0)
end

-- RUN -------------------------------------------------------------------------

functions = {
	take = take,
	send_as_recipe = send_as_recipe,
	send_as_ingredient = send_as_ingredient,
}

main()
