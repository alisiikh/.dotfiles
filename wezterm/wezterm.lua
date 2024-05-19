local utils = require("utils")
local bar = require("bar")
local themeStyle = utils.capitalize(os.getenv("THEME_STYLE") or "Mocha")

local w = require("wezterm")
local c = w.config_builder()

c.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }
c.font_size = 14.0
c.hide_tab_bar_if_only_one_tab = true
c.use_fancy_tab_bar = false
c.color_scheme = "Catppuccin " .. themeStyle

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	local mods = resize_or_move == "resize" and "META" or "CTRL"
	return {
		key = key,
		mods = mods,
		action = w.action_callback(function(win, pane)
			if utils.is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

c.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ mods = "OPT", key = "LeftArrow", action = w.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ mods = "OPT", key = "RightArrow", action = w.action({ SendString = "\x1bf" }) },

	-- split window
	{ mods = "LEADER", key = '"', action = w.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "%", action = w.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),

	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),

	-- zoom into split
	{ mods = "LEADER", key = "z", action = w.action.TogglePaneZoomState },

	-- swap splits
	{ mods = "LEADER", key = "Space", action = w.action.PaneSelect({ mode = "SwapWithActive" }) },

	-- activate copy mode or vim mode
	{ key = "[", mods = "LEADER", action = w.action.ActivateCopyMode },

	{ key = "1", mods = "LEADER", action = w.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = w.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = w.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = w.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = w.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = w.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = w.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = w.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = w.action({ ActivateTab = 8 }) },

	{ key = "c", mods = "LEADER", action = w.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "&", mods = "LEADER|SHIFT", action = w.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "d", mods = "LEADER", action = w.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = w.action({ CloseCurrentPane = { confirm = true } }) },

	{
		key = "E",
		mods = "LEADER",
		action = w.action.PromptInputLine({
			description = "Enter new name for tab",
			action = w.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

bar.apply_to_config(c, {
	position = "top",
	max_width = 25,
	dividers = "arrows", -- or "slant_right", "slant_left", "arrows", "rounded", false
	indicator = {
		leader = {
			enabled = true,
			off = " ",
			on = " ",
		},
		mode = {
			enabled = true,
			names = {
				resize_mode = "RESIZE",
				copy_mode = "VISUAL",
				search_mode = "SEARCH",
			},
		},
	},
	tabs = {
		numerals = "arabic", -- or "roman"
		pane_count = "superscript", -- or "subscript", false
		brackets = {
			active = { "", ":" },
			inactive = { "", ":" },
		},
	},
	clock = { -- note that this overrides the whole set_right_status
		enabled = true,
		format = "%H:%M", -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
	},
})

return c
