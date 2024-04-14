Config = {
	Prefix = '^9[^1DEV-GangTags^9] ^3',
	TagsForStaffOnly = false, -- "DiscordTagIDs.Use.Tag-Toggle"
	ShowOwnTag = true, -- Should the tag also be shown for own user?
	UseDiscordName = false,
	ShowDiscordDescrim = false, -- Should it show Badger#0002 ?
	RequiresLineOfSight = true, -- Requires the player be in their line of sight for tags to be shown
	FormatDisplayName = "",
    FortmatHiddenName = "",
	roleList = { 
		{'0', ''},
		{'1147775268577087549', "~b~OnlyFans"}, -- -- 		done 
		{'1147775268577087549', "~p~Joe Development "}, -- -- 		done
		{'1147775268577087549', "~r~O Block "}, -- -- 		done 
		{'1147775268577087549', "~g~Hunters "}, -- -- 		done
		{'1147775268577087549', "~y~Muraders "}, -- -- done
	},

	-- Gangtag Menu Stuff
	useGangTagMenuImage = true,
	GangTagMenuImage = 'https://cdn.discordapp.com/attachments/1161069645827166304/1227568593613488178/3015735403_preview_ezgif-5-3483880367.gif?ex=6628e157&is=66166c57&hm=c75633abd2eaa47ae76ee3b7b2ae5ec37116a65e3f0b3bba54b85c66bd0cf4e3&', -- [Custom banner IMGUR or GIPHY URLs go here (Includes Discord Image URLS) ]
	playerNameTitle = false,
	headTagMenuTitle = "", -- only work if [ playerNameTitle ] is set to false
	MenuPos = {
		x = 1450,
		y = 200
	},
	commandInfo = {
		command = 'gangtags',
	},

	-- type 0 = Defult chat notifications
	-- type 1 = okokNotification
	-- type 2 = codem Notify
	-- type 3 = mythic Notify
	-- type 4 = atlas Notify
	notify_settings_gangtags = {
		duration = 5000,
		type = 4
	},


	
	gangtag_hud = {
		enabled = true,
		x = 1.400,
		y = 0.525,
		fontSize = 0.35,
		defaultText = "~t~Gangtag: ~b~{GANGTAG}",
		
	}
} 
