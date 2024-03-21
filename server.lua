roleList = Config.roleList

prefixes = {}
hasPrefix = {}

local tagEnabled = {}



function SendNoti(recipient, message, type)
    if Config.notify_settings.type == 0 then 
        if type == "success" then 
            local type = "SUCCESS"
            local message = "~g~[ " .. type .. " ] ~w~" .. message
            TriggerClientEvent('chat:addMessage', recipient, message)
        elseif type == "error" then 
			local type = "ERROR"
            local message = "~r~[ " .. type .. "] ~w~" .. message
            TriggerClientEvent('chat:addMessage', recipient, message)
        end
    elseif Config.notify_settings.type == 1 then 
        if type == "success" then 
            TriggerClientEvent('okokNotify:Alert', recipient, 'SUCCESS', message, Config.notify_settings.duration, 'success', true)
        elseif type == "error" then 
            TriggerClientEvent('okokNotify:Alert', recipient, 'ERROR', message, Config.notify_settings.duration, 'error', true)
        end
    elseif Config.notify_settings.type == 2 then 
        if type == "success" then 
            TriggerClientEvent ('codem-notification:Create', recipient, message, 'success', 'success', Config.notify_settings.duration)
        elseif type == "error" then 
            TriggerClientEvent ('codem-notification:Create', recipient, message, 'error', 'error', Config.notify_settings.duration)

        end
    elseif Config.notify_settings.type == 3 then 
        if type == "success" then 
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'success', text = message, style = { ['background-color'] = '#000000', ['color'] = '#ffff' } })
        elseif type == "error" then 
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'error', text = message, style = { ['background-color'] = '#000000', ['color'] = '#ffff' } })
        end
	elseif Config.notify_settings.type == 4 then 
		if type == "success" then 
			TriggerClientEvent('AtlasNotify:Notify', recipient, message, Config.notify_settings.duration, "success")
		elseif type == "error" then 
			TriggerClientEvent('AtlasNotify:Notify', recipient, message, Config.notify_settings.duration, "error")
		end
    end
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        for _, playerId in ipairs(GetPlayers()) do
            local player = playerId
            local ped = GetPlayerPed(player)

            if not IsEntityVisible(ped) then
                if tagEnabled[player] then
                    HideUserTag(player)
					SendNoti(player, "Your HeadTag is disabled", "error")
                    tagEnabled[player] = false 
                end
            else 
                if not tagEnabled[player] then
                    ShowUserTag(player)
					SendNoti(player, "Your HeadTag is enabled", "success")
                    tagEnabled[player] = true
                end
            end
        end
    end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
hidePrefix = {}
hideAll = {}

local function get_index (tab, val)
	local counter = 1
    for index, value in ipairs(tab) do
        if value == val then
            return counter
        end
		counter = counter + 1
    end

    return nil
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
hideTags = {}



function HideUserTag(src)
	if get_index(hideTags, GetPlayerName(src)) == nil then 
		table.insert(hideTags, GetPlayerName(src))
		TriggerClientEvent('ID:HideTag', -1, hideTags, false)
	end
end
function ShowUserTag(src)
	if get_index(hideTags, GetPlayerName(src)) ~= nil then 
		table.remove(hideTags, get_index(hideTags, GetPlayerName(src)))
		TriggerClientEvent('ID:HideTag', -1, hideTags, false)
	end 	
end

RegisterCommand("tag-toggle", function(source, args, rawCommand)
	local name = GetPlayerName(source) 
	if (has_value(hidePrefix, name)) then
		-- Turn on their tag-prefix and remove them
		table.remove(hidePrefix, get_index(hidePrefix, name))
		TriggerClientEvent("ID:Tag-Toggle:HeadTags", -1, hidePrefix, false)
		type = Config.notify_settings.type
		SendNoti(source, "Your HeadTags Has Been Enabled", "success")
	else
		-- Turn off their tag-prefix and add them
		table.insert(hidePrefix, name)
		TriggerClientEvent("ID:Tag-Toggle:HeadTags", -1, hidePrefix, false)
		type = Config.notify_settings.type
		SendNoti(source, "Your Headtag Has Been Disabled", "error")
	end 
end, false) 


RegisterCommand("tags-toggle", function(source, args, rawCommand)
	local name = GetPlayerName(source)
	if not Config.TagsForStaffOnly then
		if (has_value(hideAll, name)) then
			-- Have them not hide all tags
			table.remove(hideAll, get_index(hideAll, name))
			TriggerClientEvent("ID:Tags-Toggle:HeadTags", source, false, false)
			TriggerClientEvent("GetStaffID:StaffStr:ReturnHeadTags", -1, prefixes, activeTagTracker, false)
			type = Config.notify_settings.type
			SendNoti(source, "HeadTags of players are Active", "success")
		else
			-- Have them hide all tags
			table.insert(hideAll, name)
			TriggerClientEvent("GetStaffID:StaffStr:ReturnHeadTags", -1, prefixes, activeTagTracker, false)
			TriggerClientEvent("ID:Tags-Toggle:HeadTags", source, true, false)
			type = Config.notify_settings.type
			SendNoti(source, "HeadTags of players are no longer active", "error")
		end
	else 
		-- Only for staff 
		if IsPlayerAceAllowed(source, "HeadTagsIDs.Use.Tag-Toggle") then 
			if not (has_value(hideAll, name)) then
				-- Have them not hide all tags
				table.insert(hideAll, name)
				TriggerClientEvent("ID:Tags-Toggle:HeadTags", source, false, false)
				TriggerClientEvent("GetStaffID:StaffStr:ReturnHeadTags", -1, prefixes, activeTagTracker, false)
				type = Config.notify_settings.type
				SendNoti(source, "HeadTags of players are no longer active", "error")
			else
				-- Have them hide all tags
				table.remove(hideAll, get_index(hideAll, name))
				TriggerClientEvent("GetStaffID:StaffStr:ReturnHeadTags", -1, prefixes, activeTagTracker, false)
				TriggerClientEvent("ID:Tags-Toggle:HeadTags", source, true, false)
				type = Config.notify_settings.type
				SendNoti(source, "HeadTags of players are no longer active", "error")
			end
		else 
			print('idk what to do here')
		end
	end 
end, false)
prefix = Config.Prefix;



RegisterNetEvent("JoeV2:HeadTags:setTag")
AddEventHandler("JoeV2:HeadTags:setTag", function(selectedTag)
    local source = source
    if prefixes[source] then
        local index = nil
        for i, tag in ipairs(prefixes[source]) do
            if tag == selectedTag then
                index = i
                break
            end
        end

        if index then
            activeTagTracker[source] = prefixes[source][index]
            TriggerClientEvent("GetStaffID:StaffStr:ReturnHeadTags", -1, prefixes, activeTagTracker, false)
			TriggerClientEvent('headtag:SetToHUD', source, prefixes[source][index])
			SendNoti(source, "Your HeadTag has been changed to: " .. prefixes[source][index] .. " ", "success")
        else
            print("[ERROR] Selected headtag not found for player " .. source)
        end
    else
        print("[ERROR] Player " .. source .. " does not have any HeadTags")
    end
end)


RegisterCommand(Config.commandInfo.command, function(source, args, rawCommand)
	local tags = prefixes[source]
	if tags ~= nil then
		local tagData = {}
		for i, tag in ipairs(tags) do
			table.insert(tagData, {id = i, tag = tag})
		end
		TriggerClientEvent("JoeV2:HeadTags:receiveData", source, tagData)
	else
		type = Config.notify_settings.type
		SendNoti(source, "No HeadTags", "error")
	end
end, false)		

alreadyGotRoles = {}
activeTagTracker = {}


AddEventHandler('playerDropped', function (reason) 
	activeTagTracker[source] = nil 
	prefixes[source] = nil 
end)

RegisterNetEvent('HeadTags:Server:GetDiscordName')
AddEventHandler('HeadTags:Server:GetDiscordName', function() 
	local src = source;
	local discordName = exports.Badger_Discord_API:GetDiscordName(src);
	if (not Config.ShowDiscordDescrim and discordName ~= nil) then
		discordName = stringsplit(discordName, "#")[1];
	end
	TriggerClientEvent('HeadTags:Server:GetDiscordName:Return', -1, src, discordName, Config.FormatDisplayName, Config.UseDiscordName);
end)

RegisterNetEvent('HeadTags:Server:GetTag')
AddEventHandler('HeadTags:Server:GetTag', function()
--AddEventHandler('chatMessage', function(source, name, msg)
	TriggerClientEvent("GetStaffID:StaffStr:ReturnHeadTags", -1, prefixes, activeTagTracker, false)
	if Config.TagsForStaffOnly then
		if IsPlayerAceAllowed(source, "HeadTagsIDs.Use.Tag-Toggle") then 
			TriggerClientEvent("ID:Tags-Toggle:HeadTags", source, false, false)
		end
	end
	local src = source
	for k, v in ipairs(GetPlayerIdentifiers(src)) do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				identifierDiscord = v
			end
	end
	local roleAccess = {}
	local defaultRole = roleList[1][2]
	if identifierDiscord then
		local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
		if not (roleIDs == false) then
			table.insert(roleAccess, defaultRole)
			activeTagTracker[src] = roleAccess[1];
			for i = 1, #roleList do
				for j = 1, #roleIDs do
					if exports.Badger_Discord_API:CheckEqual(roleList[i][1], roleIDs[j]) then
						local roleGive = roleList[i][2]
						print(GetPlayerName(src) .. " has ID tag for: " .. roleList[i][2])
						table.insert(roleAccess, roleGive)
						activeTagTracker[src] = roleGive;
					end
				end
			end
			prefixes[src] = roleAccess; 
		else
			table.insert(roleAccess, defaultRole)
			prefixes[src] = roleAccess;
			activeTagTracker[src] = roleAccess[1];
			-- print(GetPlayerName(src) .. " has not gotten their permissions cause roleIDs == false")
		end
	else
		table.insert(roleAccess, defaultRole)
		prefixes[src] = roleAccess;
		activeTagTracker[src] = roleAccess[1];
	end
end)