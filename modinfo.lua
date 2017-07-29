-- This information tells other players more about the mod
name = "Creeps in the Deeps"
author = "the CitD Team"

version = "1.02"

description =
[[Explore the ocean's depths!

Internal version 17_07_26 ]]
--description = description .."\n\nVersion: ".. version

-- In-game link to a thread or file download on the Klei Entertainment Forums
-- Example:
-- http://forums.kleientertainment.com/index.php?/files/file/202-sample-mods/
-- becomes
-- /files/file/202-sample-mods/
forumthread = ""

-- This lets other players know if the mod is out of date, update it to match the current version in the game
api_version = 6
api_version_dst = 10

-- Priority of which the mod will be loaded
-- Below 0 means other mods will override the mod by default.
-- Above 0 means the mod will override other mods by default.
--priority = 3

-- Compatibility
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = false
dst_compatible = false

client_only_mod = false
all_clients_require_mod = true

server_filter_tags =
{
    "creeps_in_the_deeps",
}

-- Preview image
icon_atlas = "citd_icon.xml"
icon = "citd_icon.tex"

-- Configuration
configuration_options = {
	{
		name = "debug_mode",
		label = "Debug mode",
		hover = "DST-exclusive hovertext info.",
		options = {
					{description = "Enabled", data = true},
					{description = "Disabled", data = false},
				  },
		default = false,	
	},
	{
		name = "oxygenmetermode",
		label = "Breath Badge Position",
		hover = "Where the oxygen meter is located.",
		options = {
					{description = "Next to wetness", data = true},
					{description = "Below wetness", data = false},
				  },
		default = true,	
	},
}