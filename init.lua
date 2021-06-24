
walking_light = {}
walking_light.modname = core.get_current_modname()
walking_light.modpath = core.get_modpath(walking_light.modname)

function walking_light.log(lvl, msg)
	if not msg then
		msg = lvl
		lvl = nil
	end

	msg = "[" .. walking_light.modname .. "] " .. msg
	if not lvl then
		core.log(msg)
	else
		core.log(lvl, msg)
	end
end


dofile(walking_light.modpath .. "/api.lua")
