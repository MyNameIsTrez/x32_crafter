-- CONFIGURATION ---------------------------------------------------------------

local modem_side = "back"

local id_crafter = 74
local id_leftovers = 75
local id_dummy = 78
local id_intermediate = 87

-- INITIALIZATION --------------------------------------------------------------

local master = {}
local crafter = {}
local leftovers = {}
local dummy = {}
local intermediate = {}
local recipe = {}
local ingredients = {}

local recipe_item_name_computer_ids = {
	oak_planks = 79
}
local recipe_item_name_colors = {
	oak_planks = 1
}

local ingredients_item_name_module_ids = {
	oak_planks = 1
}
local ingredients_item_name_colors = {
	oak_planks = 1
}
local ingredients_module_id_computer_ids = {
	{ 88, 89, 90, 91, }, -- 67,
}

rednet.open(modem_side)

-- MASTER ----------------------------------------------------------------------

function master:main()
	-- crafter:disable_crafting()
	-- crafter:enable_crafting()
	-- crafter:clear()
	-- crafter:set_dummy()
	-- crafter:unset_dummy()
	-- leftovers:store_stack()
	-- leftovers:store_single()
	-- leftovers:recycle()
	-- dummy:send()
	-- intermediate:take(1)
	-- intermediate:send_as_recipe(1)
	-- intermediate:send_as_recipe(1)
	-- intermediate:send_as_ingredient(1)
	-- intermediate:send_as_ingredient(1)
	-- recipe:send("oak_planks")
	-- ingredients:send("oak_planks", 4)

	crafter:disable_crafting()
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	dummy:send()
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	crafter:set_dummy()
	crafter:clear()
	crafter:unset_dummy()
	crafter:enable_crafting()
	-- Sleep for long enough to craft all recipe stacks.
	sleep(0.8)
	for i = 1, 10 do
		ingredients:send("oak_planks", 8)
		sleep(0.4)
	end
	-- Sleep for long enough to craft the last ingredient stacks.
	sleep(0.8)
	crafter:disable_crafting()
	crafter:clear()
	crafter:clear()
	crafter:clear()
	crafter:clear()
	crafter:clear()
	crafter:clear()
	crafter:clear()
	crafter:clear()
	leftovers:recycle()
	leftovers:recycle()
end

-- CRAFTER ---------------------------------------------------------------------

function crafter:disable_crafting()
	run(id_crafter, "disable_crafting")
	sleep(0.05)
end
function crafter:enable_crafting()
	run(id_crafter, "enable_crafting")
	sleep(0.05)
end
function crafter:clear()
	run(id_crafter, "clear")
	sleep(0.4)
end
function crafter:set_dummy()
	run(id_crafter, "set_dummy")
	sleep(0.4)
end
function crafter:unset_dummy()
	run(id_crafter, "unset_dummy")
	sleep(0.4)
end

-- LEFTOVERS -------------------------------------------------------------------

function leftovers:store_stack()
	run(id_leftovers, "store_stack")
	sleep(0.4)
end
function leftovers:store_single()
	run(id_leftovers, "store_single")
	sleep(0.4)
end
function leftovers:recycle()
	run(id_leftovers, "recycle")
	sleep(0.4)
end

-- DUMMY -----------------------------------------------------------------------

function dummy:send()
	run(id_dummy, "send")
	sleep(0.4)
end

-- INTERMEDIATE ----------------------------------------------------------------

function intermediate:take(color)
	run_arg(id_intermediate, "take", color)
	sleep(0.4)
end
function intermediate:send_as_recipe(color)
	run_arg(id_intermediate, "send_as_recipe", color)
	sleep(0.4)
end
function intermediate:send_as_ingredient(color)
	run_arg(id_intermediate, "send_as_ingredient", color)
	sleep(0.4)
end

-- RECIPE ----------------------------------------------------------------------

function recipe:send(item_name)
	local id = recipe_item_name_computer_ids[item_name]
	local color = recipe_item_name_colors[item_name]
	run_arg(id, "send", color)
	sleep(0.4)
end

-- INGREDIENTS -----------------------------------------------------------------

function ingredients:send(item_name, stack_count)
	local module_id = ingredients_item_name_module_ids[item_name]
	local computer_ids = ingredients_module_id_computer_ids[module_id]
	-- TODO: Use stack_count
	for _, computer_id in ipairs(computer_ids) do
		local color = ingredients_item_name_colors[item_name]
		run_arg(computer_id, "send", color)
	end
end

-- UTILITIES -------------------------------------------------------------------

function run(receiver_id, fn_name)
	rednet.send(receiver_id, fn_name)
end

function run_arg(receiver_id, fn_name, arg)
	local message = textutils.serialize({fn_name = fn_name, arg = arg})
	rednet.send(receiver_id, message)
end

-- RUN -------------------------------------------------------------------------

master:main()
