farming = {}

function place_seed(itemstack, placer, pointed_thing, plantname)
	local pt = pointed_thing
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end
	if pt.above.y ~= pt.under.y+1 then
		return
	end
	if not minetest.registered_nodes[above.name].buildable_to then
		return
	end
	if minetest.get_item_group(under.name, "soil") <= 1 then
		return
	end
	minetest.add_node(pt.above, {name=plantname})
	if not minetest.settings:get_bool("creative_mode") then
		itemstack:take_item()
	end
	return itemstack
end

function place_spore(itemstack, placer, pointed_thing, plantname)
	local pt = pointed_thing
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end
	if pt.above.y ~= pt.under.y+1 then
		return
	end
	if not minetest.registered_nodes[above.name].buildable_to then
		return
	end
	if minetest.get_item_group(under.name, "fungi") <= 1 then
		return
	end
	minetest.add_node(pt.above, {name=plantname})
	if not minetest.settings:get_bool("creative_mode") then
		itemstack:take_item()
	end
	return itemstack
end

function farming.hoe_on_use(itemstack, user, pointed_thing, uses)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end

	local under = minetest.get_node(pt.under)
	local p = {x=pt.under.x, y=pt.under.y+1, z=pt.under.z}
	local above = minetest.get_node(p)

	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end

	-- check if the node above the pointed thing is air
	if above.name ~= "air" then
		return
	end

	-- check if pointing at dirt
	if minetest.get_item_group(under.name, "soil") ~= 1 then
		return
	end

	-- turn the node into soil, wear out item and play sound
	minetest.set_node(pt.under, {name="farming:soil"})
	minetest.sound_play("default_dig_crumbly", {
		pos = pt.under,
		gain = 0.5,
	})
	itemstack:add_wear(65535/(uses-1))
	return itemstack
end

function farming:add_plant(full_grown, names, interval, chance)
	print(full_grown)
	minetest.register_abm({
		nodenames = names,
		interval = interval,
		chance = chance,
		action = function(pos, node)
			pos.y = pos.y-1
			if minetest.get_node(pos).name ~= "farming:soil_wet" then
				return
			end
			pos.y = pos.y+1
			if not minetest.get_node_light(pos) then
				return
			end
			if minetest.get_node_light(pos) < 8 then
				return
			end
			local step = nil
			for i,name in ipairs(names) do
				if name == node.name then
					step = i
					break
				end
			end
			if step == nil then
				return
			end
			local new_node = {name=names[step+1]}
			if new_node.name == nil then
				new_node.name = full_grown
			end
			minetest.set_node(pos, new_node)
		end
}	)
end

-- ========= CORN =========
dofile(minetest.get_modpath("lottfarming").."/corn.lua")

-- ========= CARROT =========
dofile(minetest.get_modpath("lottfarming").."/carrots.lua")

-- ========= CAKE =========
dofile(minetest.get_modpath("lottfarming").."/cake.lua")

-- ========= BERRIES =========
dofile(minetest.get_modpath("lottfarming").."/berries.lua")

-- ========= CABBAGE =========
dofile(minetest.get_modpath("lottfarming").."/cabbage.lua")

-- ========= ATHELAS =========
dofile(minetest.get_modpath("lottfarming").."/athelas.lua")

-- ========= POTATO =========
dofile(minetest.get_modpath("lottfarming").."/potato.lua")

-- ========= TOMATO =========
dofile(minetest.get_modpath("lottfarming").."/tomatoes.lua")

-- ========= TURNIP =========
dofile(minetest.get_modpath("lottfarming").."/turnips.lua")

-- ========= PIPEWEED =========
dofile(minetest.get_modpath("lottfarming").."/pipeweed.lua")

-- ========= MELON =========
dofile(minetest.get_modpath("lottfarming").."/melon.lua")

-- ========= BARLEY =========
dofile(minetest.get_modpath("lottfarming").."/barley.lua")

-- ========= CRAFTS =========
dofile(minetest.get_modpath("lottfarming").."/crafting.lua")

-- ========= BROWN MUSHROOM =========
dofile(minetest.get_modpath("lottfarming").."/brown.lua")

-- ========= RED MUSHROOM =========
dofile(minetest.get_modpath("lottfarming").."/red.lua")

-- ========= BLUE MUSHROOM =========
dofile(minetest.get_modpath("lottfarming").."/blue.lua")

-- ========= GREEN MUSHROOM =========
dofile(minetest.get_modpath("lottfarming").."/green.lua")

-- ========= ORC FOOD =========
dofile(minetest.get_modpath("lottfarming").."/orc_food.lua")

-- ========= OTHER =========
dofile(minetest.get_modpath("lottfarming").."/other.lua")

if minetest.settings:get_bool("msg_loading_mods") then minetest.log("action", minetest.get_current_modname().." mod LOADED") end
