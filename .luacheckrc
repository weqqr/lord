unused_args = false
allow_defined_top = true

globals = {
	"minetest",
}

read_globals = {
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Builtin
	"vector", "ItemStack",
	"dump", "DIR_DELIM", "VoxelArea", "Settings",

	-- MTG
	"default", "sfinv", "creative",
}

exclude_files = {
	-- External mods
	"mods/areas",
	"mods/intllib",
	"mods/mobs",
	"mods/lottmapgen",
	"mods/mp_world_edit",
}
