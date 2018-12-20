local SL = lord.require_intllib()

grinder.grinding_recipes = { cooking = { input_size = 1, output_size = 1 } }
local function register_recipe_type(typename, origdata)
	local data = {}
	for k, v in pairs(origdata) do data[k] = v
	end
	data.input_size = data.input_size or 1
	data.output_size = data.output_size or 1
	data.recipes = {}
	grinder.grinding_recipes[typename] = data
end

local function get_recipe_index(items)
	local l
	for i, stack in ipairs(items) do
		l = stack:get_name()
	end
	return l
end

local function register_recipe(typename, data)
	-- Handle aliases
	if type(data.input) == "table" then
		for i, v in ipairs(data.input) do
			data.input[i] = ItemStack(data.input[i]):to_string()
		end
	else
		data.input = ItemStack(data.input):to_string()
	end

	if type(data.output) == "table" then
		for i, v in ipairs(data.output) do
			data.output[i] = ItemStack(data.output[i]):to_string()
		end
	else
		data.output = ItemStack(data.output):to_string()
	end

	local recipe = {time = data.time, input = data.input, output = data.output}
	local index = ItemStack(data.input):get_name()
	-- создаем таблицу рецептов, в качестве индекса имя исходного материала
	grinder.grinding_recipes[typename].recipes[index] = recipe
end


local function register_grinding_recipe(data)
	data.time = data.time or 120
	minetest.after(0.01, register_recipe, "grinding", data) -- Handle aliases
end

function grinder.get_grinding_recipe(typename, items)

	if typename == "cooking" then -- Already builtin in Minetest, so use that
		local result, new_input = minetest.get_craft_result({
			method = "cooking",
			width = 1,
			items = items})
		-- Compatibility layer
		if not result or result.time == 0 then
			return nil
		else
			return {time = result.time,	new_input = new_input.items, output = result.item}
		end
	end

	local index = get_recipe_index(items)
	local recipe = grinder.grinding_recipes[typename].recipes[index]

	if recipe then
		local new_input = {}
		local num_item = ItemStack(recipe.input):get_count() or 1
		for i, stack in ipairs(items) do
			if stack:get_count() < num_item then
				-- В стеке не хватает предметов
				return nil
			else
				-- Будет изъято num_item
				new_input = ItemStack(stack)
				new_input:take_item(num_item)
			end
		end
		return {time = recipe.time,	new_input = new_input, output = recipe.output}
	else
		return nil
	end
end

register_recipe_type("grinding", {
	description = SL("Grinding"),
	input_size = 1,
})

local recipes = {
	{"default:stone", "default:cobble", 5},
	{"default:desert_stone", "default:desert_cobble", 5},
	{"default:cobble", "default:gravel", 5},
	{"default:desert_cobble", "default:gravel", 5},
	{"default:mossycobble", "default:gravel", 5},
	{"default:snowycobble", "default:gravel", 5},
	{"default:gravel", "default:sand", 5},
	{"default:sand", "default:clay", 5},
	{"default:coal_lump", "grinder:coal_dust 2", 5},
	{"default:glass", "default:sand", 5},
	{"vessels:glass_bottle 5", "default:sand", 8},
	{"vessels:drinking_glass 3", "default:sand", 6},
	{"vessels:glass_fragments 3", "default:sand", 6},
}

for _, data in pairs(recipes) do
	register_grinding_recipe({input = data[1], output = data[2], time = data[3]})
end
