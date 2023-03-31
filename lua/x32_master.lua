-- CONFIGURATION ---------------------------------------------------------------

local MODEM_SIDE = "back"

local ID_CRAFTER = 74
local ID_LEFTOVERS = 75
local ID_DUMMY = 78
local ID_INTERMEDIATE = 87

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

-- TODO: Calculate the maximum amount of time needed, instead of hardcoding.
local CRAFT_LAST_RECIPE_STACKS_TIME = 1.25
-- TODO: Calculate the maximum amount of time needed, instead of hardcoding.
local CRAFT_LAST_INGREDIENT_STACKS_TIME = 0.15

rednet.open(MODEM_SIDE)

-- MASTER ----------------------------------------------------------------------

function master:main()
	-- crafter:disable_crafting()
	-- crafter:enable_crafting()
	-- crafter:clear()
	-- crafter:set_dummy_filtering()
	-- crafter:unset_dummy_filtering()
	-- leftovers:store_stack()
	-- leftovers:store_single()
	-- leftovers:recycle()
	-- dummy:send()
	-- intermediate:take(1)
	-- intermediate:send_as_recipe(1)
	-- intermediate:send_as_ingredient(1)
	-- recipe:send("oak_planks")
	-- ingredients:send("oak_planks", 4)

	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	dummy:send()
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	recipe:send("oak_planks")
	crafter:set_dummy_filtering()
	crafter:clear()
	crafter:unset_dummy_filtering()
	crafter:enable_crafting()
	sleep(CRAFT_LAST_RECIPE_STACKS_TIME)
	for i = 1, 10 do
		ingredients:send("oak_planks", 8)
		sleep(0.4) -- Crucial
	end
	sleep(CRAFT_LAST_INGREDIENT_STACKS_TIME)
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
	run(ID_CRAFTER, "disable_crafting")
	-- sleep(0.05)
end
function crafter:enable_crafting()
	run(ID_CRAFTER, "enable_crafting")
	-- sleep(0.05)
end
function crafter:clear()
	run(ID_CRAFTER, "clear")
	sleep(0.4) -- Crucial
end
function crafter:set_dummy_filtering()
	run(ID_CRAFTER, "set_dummy_filtering")
	sleep(0.05) -- Crucial
end
function crafter:unset_dummy_filtering()
	run(ID_CRAFTER, "unset_dummy_filtering")
	sleep(0.05) -- Crucial
end

-- LEFTOVERS -------------------------------------------------------------------

function leftovers:store_stack()
	run(ID_LEFTOVERS, "store_stack")
	-- sleep(0.4)
end
function leftovers:store_single()
	run(ID_LEFTOVERS, "store_single")
	-- sleep(0.4)
end
function leftovers:recycle()
	run(ID_LEFTOVERS, "recycle")
	-- sleep(0.4)
end

-- DUMMY -----------------------------------------------------------------------

function dummy:send()
	run(ID_DUMMY, "send")
	-- sleep(0.4)
end

-- INTERMEDIATE ----------------------------------------------------------------

function intermediate:take(color)
	run_arg(ID_INTERMEDIATE, "take", color)
	-- sleep(0.4)
end
function intermediate:send_as_recipe(color)
	run_arg(ID_INTERMEDIATE, "send_as_recipe", color)
	-- sleep(0.4)
end
function intermediate:send_as_ingredient(color)
	run_arg(ID_INTERMEDIATE, "send_as_ingredient", color)
	-- sleep(0.4)
end

-- RECIPE ----------------------------------------------------------------------

function recipe:send(item_name)
	local id = recipe_item_name_computer_ids[item_name]
	local color = recipe_item_name_colors[item_name]
	run_arg(id, "send", color)
	sleep(0.4) -- Crucial
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
