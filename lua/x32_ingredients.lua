-- CONFIGURATION ---------------------------------------------------------------

local modem_side = "left"

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

function send(color)
	pulse_color("bottom", color)
end

function pulse_color(side, color)
	rs.setBundledOutput(side, color)
	sleep(0.05) -- Crucial
	rs.setBundledOutput(side, 0)
end

-- RUN -------------------------------------------------------------------------

functions = {
	send = send,
}

main()
