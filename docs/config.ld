project = "Walking Light"
title = "Walking Light"
format = "markdown"
not_luadoc = true
boilerplate = false
readme = "README.md"
icon = "textures/walking_light_underlay.png"

file = {"settings.lua", "api.lua", "chat.lua"}

new_type("setting", "Settings")
new_type("chatcmd", "Chat Commands")

custom_tags = {
	{
		"settype",
		title = "Type",
	},
	{
		"default",
		title = "Default Value",
	},
}

custom_see_handler("ObjectRef", function(name, section)
	return name, "https://minetest.gitlab.io/minetest/class-reference.html#objectref"
end)
