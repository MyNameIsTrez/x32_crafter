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

		if sender_id == id_master and functions[message] ~= nil then
			functions[message]()
		end
	end
end

function send()
	pulse("left")
end

function pulse(side)
	rs.setOutput(side, true)
	sleep(0.05) -- Crucial
	rs.setOutput(side, false)
end

-- RUN -------------------------------------------------------------------------

functions = {
	send = send,
}

main()
