-- CONFIGURATION ---------------------------------------------------------------

local modem_side = "bottom"

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

function disable_crafting()
	rs.setOutput("front", true)
end
function enable_crafting()
	rs.setOutput("front", false)
end

function clear()
	pulse("back")
end
function set_dummy()
	pulse("right")
end
function unset_dummy()
	pulse("left")
end

function pulse(side)
	rs.setOutput(side, true)
	sleep(0.05)
	rs.setOutput(side, false)
end

-- RUN -------------------------------------------------------------------------

functions = {
	disable_crafting = disable_crafting,
	enable_crafting = enable_crafting,
	clear = clear,
	set_dummy = set_dummy,
	unset_dummy = unset_dummy,
}

main()
