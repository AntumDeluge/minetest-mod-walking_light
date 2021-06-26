
--- wlight Chat Commands
--
--  @topic commands


local S = core.get_translator(wlight.modname)


--- Manages lighted nodes and debugging.
--
--  **Parameters:**
--
--  @chatcmd wlight
--  @tparam command Command action to be executed.
--  @tparam[opt] radius Area radius (default: 20).
--  @usage /wlight <command> [radius]
--
--  Commands:
--    - add:    Add lighting to current position.
--    - remove: Remove lighting from current position.
--    - debug:  Toggle illuminated nodes visible mark for debugging.
--
--  Options:
--    - radius: Area radius (default: 20).
--
--  Example:
--    /wlight add 5
core.register_chatcommand(wlight.modname, {
	params = "<" .. S("command") .. "> [" .. S("radius") .. "]",
	privs = {server=true},
	description = S("Manage lighted nodes and debugging.")
		.. "\n\n" .. S("Commands:")
		.. "\n  add:    " .. S("Add lighting to current position.")
		.. "\n  remove: " .. S("Remove lighting from current position.")
		.. "\n  debug:  " .. S("Toggle illuminated nodes visible mark for debugging.")
		.. "\n\n" .. S("Options:")
		.. "\n  " .. S("radius") .. ": " .. S("Area radius (default: 20)."),
	func = function(name, param)
		local command
		local radius
		if param:find(" ") then
			local params = param:split(" ")
			command = params[1]
			radius = tonumber(params[2])
		else
			command = param
		end

		radius = radius or 20

		if command == "" then
			core.chat_send_player(name, "\n" .. S("Missing command parameter."))
			return false
		end

		if (command == "add" or command == "remove") and not radius then
			core.chat_send_player(name, "\n" .. S("Missing radius parameter."))
			return false
		end

		local pos = vector.round(core.get_player_by_name(name):get_pos())

		if command == "debug" then
			wlight.set_debug(not wlight_debug)
			wlight.update_node()
		elseif command == "add" then
			-- FIXME: only adds one node, does not make use of "radius" parameter
			pos = vector.new(pos.x, pos.y + 1, pos.z)
			if pos then
				wlight.mt_add_node(pos, {type="node", name=wlight_node})
			end
		elseif command == "remove" then
			for _, v in ipairs({"wlight:light", "wlight:light_debug"}) do
				local point = core.find_node_near(pos, radius, v)
				while point do
					wlight.remove_light(nil, point)
					local oldpoint = point
					point = core.find_node_near(pos, radius, v)
					if wlight.poseq(oldpoint, point) then
						return false, S("Failed... infinite loop detected.")
					end
				end
			end
		else
			core.chat_send_player(name, "\n" .. S("Unknown command: @1", command))
			return false
		end

		return true, S("Done.")
	end,
})
