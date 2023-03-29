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

function store_stack()
	pulse("left")
end
function store_single()
	pulse("right")
end
function recycle()
	pulse("back")
end

function pulse(side)
	rs.setOutput(side, true)
	sleep(0.05)
	rs.setOutput(side, false)
end

-- RUN -------------------------------------------------------------------------

functions = {
	store_stack = store_stack,
	store_single = store_single,
	recycle = recycle,
}

main()
