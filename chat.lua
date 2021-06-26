
--- wlight Chat Commands
--
--  @topic commands


local S = core.get_translator(wlight.modname)


--- Removes light added with wlight from nearby nodes.
--
--  @chatcmd wlight_clear_light
--  @param size Diameter of which light should be removed.
core.register_chatcommand("wlight_clear_light", {
	params = "<size>",
	description = S("Remove light nodes from the area."),
	func = function(name, param)
		if not core.check_player_privs(name, {server=true}) then
			return false, S("You need the server privilege to use @1", "wlight_clear_light")
		end

		local pos = vector.round(core.get_player_by_name(name):get_pos())
		local size = tonumber(param) or 40

		for i, v in ipairs({"wlight:light", "wlight:light_debug"}) do
			local point = core.find_node_near(pos, size/2, v)
			while point do
				wlight.remove_light(nil, point)
				local oldpoint = point
				point = core.find_node_near(pos, size/2, v)
				if wlight.poseq(oldpoint, point) then
					return false, S("Failed... infinite loop detected")
				end
			end
		end
		return true, S("Done.")
	end,
})

--- Adds light to nearby nodes.
--
--  FIXME: only adds one node, does not make use of "size" parameter
--
--  @chatcmd wlight_add_light
--  @param size Diameter of which light should be added.
core.register_chatcommand("wlight_add_light", {
	params = "<size>",
	description = S("Add wlight:light to a position, without a player owning it."),
	func = function(name, param)
		if not core.check_player_privs(name, {server=true}) then
			return false, S("You need the server privilege to use @1", "wlight_add_light")
		end

		local pos = vector.round(core.get_player_by_name(name):get_pos())
		pos = vector.new(pos.x, pos.y + 1, pos.z)

		if pos then
			wlight.mt_add_node(pos, {type="node", name=wlight_node})
		end

		return true, S("Done.")
	end,
})

--- Toggles debugging mode.
--
--  If enabled, nodes with added light will be visibly marked.
--
--  @chatcmd wlight_debug
core.register_chatcommand("wlight_debug", {
	description = S("Change to debug mode, so light blocks are visible."),
	func = function(name, param)
		if not core.check_player_privs(name, {server=true}) then
			return false, S("You need the server privilege to use @1", "wlight_debug")
		end

		-- toggle debug mode
		wlight.set_debug(not wlight_debug)
		wlight.update_node()

		return true, S("Done.")
	end,
})
