--||||||||||||||||||
--|| Fishing Trap ||
--||||||||||||||||||

local S = minetest.get_translator(minetest.get_current_modname())
local C = minetest.colorize
local F = minetest.formspec_escape

-- Inventory Init
local drop_content = mcl_util.drop_items_from_meta_container("main")

local function on_blast(pos)
	local node = minetest.get_node(pos)
	drop_content(pos, node)
	minetest.remove_node(pos)
end

-- Simple protection checking functions
local function protection_check_move(pos, from_list, from_index, to_list, to_index, count, player)
	local name = player:get_player_name()
	if minetest.is_protected(pos, name) then
		minetest.record_protection_violation(pos, name)
		return 0
	else
		return count
	end
end

local function protection_check_put_take(pos, listname, index, stack, player)
	local name = player:get_player_name()
	if minetest.is_protected(pos, name) then
		minetest.record_protection_violation(pos, name)
		return 0
	else
		return stack:get_count()
	end
end

-- Trap GUI
local gui = function(pos, node, clicker, itemstack, pointed_thing)
	local name = minetest.get_meta(pos):get_string("name")

	if name == "" then
		name = S("Fishing Trap")
	end

	local playername = clicker:get_player_name()

	minetest.show_formspec(playername,
		"mcl_fishing_trap:fishing_trap_"..pos.x.."_"..pos.y.."_"..pos.z,
		table.concat({
			"size[9,8.75]",
			"label[0,0;"..F(C("#313131", name)).."]",
			"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0.5;9,3;]",
			mcl_formspec.get_itemslot_bg(0, 0.5, 9, 3),
			"label[0,4.0;"..F(C("#313131", S("Inventory"))).."]",
			"list[current_player;main;0,4.5;9,3;9]",
			mcl_formspec.get_itemslot_bg(0, 4.5, 9, 3),
			"list[current_player;main;0,7.74;9,1;]",
			mcl_formspec.get_itemslot_bg(0, 7.74, 9, 1),
			"listring[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main]",
			"listring[current_player;main]",
		})
	)
end

-- Register Fish Trap Node
minetest.register_node("mcl_fish_traps:fishing_trap", {
	description = S("Fishing Trap"),
	_tt_help = S("Used to automatically fish."),
	_doc_items_longdesc = S("Used to automatically fish when placed in water."),
	tiles = {
		"mob_spawner.png", "mob_spawner.png",
		"mob_spawner.png", "mob_spawner.png",
		"mob_spawner.png", "mob_spawner.png"
	},
	use_texture_alpha = "clip",
	is_ground_content = false,
	paramtype2 = "facedir",
	drawtype = "allfaces_optional",
	groups = { axey = 1, punchy = 2, container = 2 },
	_mcl_blast_resistance = 2.5,
	_mcl_hardness = 2.5,
	on_place = function(itemstack, placer, pointed_thing)
		minetest.rotate_and_place(itemstack, placer, pointed_thing, minetest.is_creative_enabled(placer:get_player_name()), {}, false)
		return itemstack
	end,
	on_rightclick = gui,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 9*3)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minetest.get_meta(pos):set_string("name", itemstack:get_meta():get_string("name"))
	end,
	allow_metadata_inventory_move = protection_check_move,
	allow_metadata_inventory_take = protection_check_put_take,
	allow_metadata_inventory_put = protection_check_put_take,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff in fishing trap at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff to fishing trap at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" takes stuff from fishing trap at "..minetest.pos_to_string(pos))
	end,
	after_dig_node = drop_content,
	on_blast = on_blast,
})

-- Register Waterlogged Fish Trap Nodes
local trap_w = {
	description = S("Fishing Trap"),
	_tt_help = S("Used to automatically fish."),
	_doc_items_longdesc = S("Used to automatically fish when placed in water."),
	use_texture_alpha = "clip",
	is_ground_content = false,
	paramtype2 = "facedir",
	drawtype = "allfaces_optional",
	groups = { axey = 1, punchy = 2, container = 2, not_in_creative_inventory = 1 },
	_mcl_blast_resistance = 2.5,
	_mcl_hardness = 2.5,
	on_place = function(itemstack, placer, pointed_thing)
		minetest.rotate_and_place(itemstack, placer, pointed_thing, minetest.is_creative_enabled(placer:get_player_name()), {}, false)
		return itemstack
	end,
	on_rightclick = gui,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 9*3)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minetest.get_meta(pos):set_string("name", itemstack:get_meta():get_string("name"))
	end,
	allow_metadata_inventory_move = protection_check_move,
	allow_metadata_inventory_take = protection_check_put_take,
	allow_metadata_inventory_put = protection_check_put_take,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff in fishing trap at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff to fishing trap at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" takes stuff from fishing trap at "..minetest.pos_to_string(pos))
	end,
	drop = "mcl_fish_traps:fishing_trap",
	on_blast = on_blast,
	after_dig_node = drop_content
}

water_tex = "default_water_source_animated.png^[verticalframe:16:0"
trap_w.tiles = {
	"("..water_tex..")^mob_spawner.png",
	"("..water_tex..")^mob_spawner.png",
	"("..water_tex..")^mob_spawner.png",
}

local trap_rw = table.copy(trap_w)
water_tex_river = "default_river_water_source_animated.png^[verticalframe:16:0"
trap_rw.tiles = {
	"("..water_tex_river..")^mob_spawner.png",
	"("..water_tex_river..")^mob_spawner.png",
	"("..water_tex_river..")^mob_spawner.png",
}

minetest.register_node("mcl_fish_traps:fishing_trap_water", trap_w)
minetest.register_node("mcl_fish_traps:fishing_trap_river_water", trap_rw)

-- Register Fish Trap Crafting Recipe
minetest.register_craft({
	output = "mcl_fish_traps:fishing_trap",
	recipe = {
		{ "mcl_mobitems:string", "mcl_core:stick", "mcl_mobitems:string" },
		{ "mcl_core:stick", "mcl_fishing:fishing_rod", "mcl_core:stick" },
		{ "mcl_mobitems:string", "mcl_core:stick", "mcl_mobitems:string" },
	}
})

-- Register Water Logging Fish Trap ABM
local adjacents = {
	vector.new(1,0,0),
	vector.new(-1,0,0),
	vector.new(0,0,1),
	vector.new(0,0,-1),
}

minetest.register_abm({
	label = "Waterlog fish trap",
	nodenames = {"mcl_fish_traps:fishing_trap"},
	neighbors = {"group:water"},
	interval = 5,
	chance = 5,
	action = function(pos,value)
		for _,v in pairs(adjacents) do
			local n = minetest.get_node(vector.add(pos,v)).name
			if minetest.get_item_group(n,"water") > 0 then
				if n:find("river") then
					minetest.swap_node(pos,{name="mcl_fish_traps:fishing_trap_river_water"})
					return
				else
					minetest.swap_node(pos,{name="mcl_fish_traps:fishing_trap_water"})
					return
				end
			end
		end
	end
})

-- Register Fishing ABM
minetest.register_abm({
	label = "Waterlog fish trap",
	nodenames = {"mcl_fish_traps:fishing_trap_water", "mcl_fish_traps:fishing_trap_river_water"},
	neighbors = {"group:water"},
	interval = 30,
	chance = 5,
	action = function(pos,value)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local itemname
		local items
		local itemcount = 1
		local pr = PseudoRandom(os.time() * math.random(1, 100))
		local r = pr:next(1, 100)
		local fish_values = {85, 84.8, 84.7, 84.5}
		local junk_values = {10, 8.1, 6.1, 4.2}
		for _, fish_v in ipairs(fish_values) do
			for _, junk_v in ipairs(junk_values) do
				if r <= fish_v then
					-- Fish
					items = mcl_loot.get_loot({
						items = {
						{ itemstring = "mcl_fishing:fish_raw", weight = 60 },
						{ itemstring = "mcl_fishing:salmon_raw", weight = 25 },
						{ itemstring = "mcl_fishing:clownfish_raw", weight = 2 },
						{ itemstring = "mcl_fishing:pufferfish_raw", weight = 13 },
					},
					stacks_min = 1,
					stacks_max = 1,
					}, pr)
				elseif r <= junk_v then
				-- Junk
					items = mcl_loot.get_loot({
						items = {
							{ itemstring = "mcl_core:bowl", weight = 10 },
							{ itemstring = "mcl_fishing:fishing_rod", weight = 2, wear_min = 6554, wear_max = 65535 }, -- 10%-100% damage
							{ itemstring = "mcl_mobitems:leather", weight = 10 },
							{ itemstring = "mcl_armor:boots_leather", weight = 10, wear_min = 6554, wear_max = 65535 }, -- 10%-100% damage
							{ itemstring = "mcl_mobitems:rotten_flesh", weight = 10 },
							{ itemstring = "mcl_core:stick", weight = 5 },
							{ itemstring = "mcl_mobitems:string", weight = 5 },
							{ itemstring = "mcl_potions:water", weight = 10 },
							{ itemstring = "mcl_mobitems:bone", weight = 10 },
							{ itemstring = "mcl_dye:black", weight = 1, amount_min = 10, amount_max = 10 },
							{ itemstring = "mcl_mobitems:string", weight = 10 }, -- TODO: Tripwire Hook
						},
						stacks_min = 1,
						stacks_max = 1,
					}, pr)
				else
					-- Treasure
					items = mcl_loot.get_loot({
						items = {
							{ itemstring = "mcl_bows:bow", wear_min = 49144, wear_max = 65535, func = function(stack, pr)
								mcl_enchanting.enchant_randomly(stack, 30, true, false, false, pr)
							end }, -- 75%-100% damage
							{ itemstring = "mcl_books:book", func = function(stack, pr)
								mcl_enchanting.enchant_randomly(stack, 30, true, true, false, pr)
							end },
							{ itemstring = "mcl_fishing:fishing_rod", wear_min = 49144, wear_max = 65535, func = function(stack, pr)
								mcl_enchanting.enchant_randomly(stack, 30, true, false, false, pr)
							end }, -- 75%-100% damage
							{ itemstring = "mcl_mobs:nametag", },
							{ itemstring = "mcl_mobitems:saddle", },
							{ itemstring = "mcl_flowers:waterlily", },
							{ itemstring = "mcl_mobitems:nautilus_shell", },
						},
						stacks_min = 1,
						stacks_max = 1,
					}, pr)
				end
			end
		end
		local item
		if #items >= 1 then
			item = ItemStack(items[1])
		else
			item = ItemStack()
		end
		if inv:room_for_item("main", item) then
			inv:add_item("main", item)
		else
			minetest.add_item(pos, item)
		end
	end
})
