Config = {
	Prefix = '^9[^1DEV-headtags^9] ^3',
	TagsForStaffOnly = false, -- "DiscordTagIDs.Use.Tag-Toggle"
	ShowOwnTag = true, -- Should the tag also be shown for own user?
	UseDiscordName = false,
	ShowDiscordDescrim = false, -- Should it show Badger#0002 ?
	RequiresLineOfSight = true, -- Requires the player be in their line of sight for tags to be shown
	FormatDisplayName = "[{SERVER_ID}]",
    FortmatHiddenName = "",
	UseKeyBind = false, -- It will only show on keybind press
	KeyBind = 289, -- F2 -- USE https://docs.fivem.net/docs/game-references/controls/ for keycodes
	roleList = { 
		{'0', '~w~Civillian '},
		{'1147775268577087549', "~p~Owner "}, -- -- done
	},

	-- Headtag Menu Stuff
	customMenuTexture = false,
	menutexture_fileName = 'custommenu', -- will only work if [ customMenuTexture ] is set to true
	playerNameTitle = false,
	headTagMenuTitle = "~b~HeadTag ~y~Menu", -- only work if [ playerNameTitle ] is set to false
	MenuPos = {
		x = 1400,
		y = 100
	},
	commandInfo = {
		command = 'headtags',
	},

	-- type 0 = Defult chat notifications
	-- type 1 = okokNotification
	-- type 2 = codem Notify
	-- type 3 = mythic Notify
	-- type 4 = atlas Notify
	notify_settings = {
		duration = 5000,
		type = 4
	}
} 