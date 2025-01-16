local activeTagTracker = {}
local prefixes = {}
local hidePrefix = {}
local hideAll = {}
local hideTags = {}

function HideUserTag(src)
	local playerName = GetPlayerName(src)
	if playerName and GetIndex(hideTags, playerName) == nil then 
		table.insert(hideTags, playerName)
		TriggerClientEvent('jd-gangtags:HideTag', -1, hideTags, false)
	end
end

function ShowUserTag(src)
	local playerName = GetPlayerName(src)
	if playerName and GetIndex(hideTags, playerName) ~= nil then
		table.remove(hideTags, GetIndex(hideTags, playerName))
		TriggerClientEvent('jd-gangtags:HideTag', -1, hideTags, false)
	end
end

function GetTagNameByIndex(source, index)
    local tags = GetUserTags(source)
    if tags and tags[index] then
        return tags[index]
    end
    return nil
end

function ToggleTag(source)
    local name = GetPlayerName(source)
    if HasValue(hidePrefix, name) then
        table.remove(hidePrefix, GetIndex(hidePrefix, name))
        TriggerClientEvent("jd-gangtags:client:toggleTag", -1, hidePrefix, false)
		lib.notify(source, {
			title = 'Gangtag',
			description = 'Your Gangtag has been toggled on',
			type = 'success',
			position = 'center-right',
			duration = 5000,
		})
    else
        table.insert(hidePrefix, name)
        TriggerClientEvent("jd-gangtags:client:toggleTag", -1, hidePrefix, true)
		lib.notify(source, {
			title = 'Gangtag',
			description = 'Your Gangtag has been toggled off',
			type = 'error',
			position = 'center-right',
			duration = 5000,
		})
    end
end

function ToggleTagsAll(source)
    local name = GetPlayerName(source)
    if HasValue(hideAll, name) then
        table.remove(hideAll, GetIndex(hideAll, name))
        TriggerClientEvent("jd-gangtags:client:toggleAllTags", source, false, false)
		lib.notify(source, {
			title = 'Gangtag',
			description = 'All Gangtags have been toggled on',
			type = 'success',
			position = 'center-right',
			duration = 5000,
		})
    else
        table.insert(hideAll, name)
        TriggerClientEvent("jd-gangtags:client:toggleAllTags", source, true, false)
		lib.notify(source, {
			title = 'Gangtag',
			description = 'All Gangtags have been toggled off',
			type = 'error',
			position = 'center-right',
			duration = 5000,
		})
    end
end

function GetActiveUserTag(src)
	if activeTagTracker[tonumber(src)] ~= nil then
		return activeTagTracker[tonumber(src)]
	end
	return nil
end

function GetUserTags(src)
	if prefixes[tonumber(src)] ~= nil then
		return prefixes[tonumber(src)]
	end
	return nil
end

function SetUserTag(source, ind)
	if prefixes[source] ~= nil and prefixes[source][ind] ~= nil then
		activeTagTracker[source] = prefixes[source][ind]
		TriggerClientEvent("jd-gangtags:client:updateTags", -1, prefixes, activeTagTracker, false)
		return true
	end
	return false
end


AddEventHandler('playerDropped', function (reason)
	activeTagTracker[source] = nil
	prefixes[source] = nil
end)


RegisterNetEvent('jd-gangtags:server:getTags')
AddEventHandler('jd-gangtags:server:getTags', function()
    local roleAccess = {}
    local defaultRole = (Config.roleList[1].label ~= nil and Config.roleList[1].label or "")
    local highestRole = defaultRole
    local hasAnyPermission = false

    for i = 1, #Config.roleList do
        local role = Config.roleList[i]
		---@diagnostic disable-next-line: param-type-mismatch
        if IsPlayerAceAllowed(source, role.ace) or IsPlayerAceAllowed(source, Config.allTags) then
            Debug(GetPlayerName(source) .. " has tag for: " .. role.label)
            table.insert(roleAccess, role.label)
            highestRole = role.label
            hasAnyPermission = true
        end
    end

    if #roleAccess == 0 then
        table.insert(roleAccess, defaultRole)
    end

    prefixes[source] = roleAccess

    if Config.AutoSetHighestRole then
        activeTagTracker[source] = highestRole
    else
        activeTagTracker[source] = hasAnyPermission and defaultRole or ""
    end

    TriggerClientEvent("jd-gangtags:client:updateTags", -1, prefixes, activeTagTracker, false)
end)

AddEventHandler('playerDropped', function()
    if prefixes[source] then
        prefixes[source] = nil
    end
    if activeTagTracker[source] then
        activeTagTracker[source] = nil
    end
end)

RegisterNetEvent('jd-gangtags:server:setTag')
AddEventHandler('jd-gangtags:server:setTag', function(index)
	local ped = source
	local success = SetUserTag(ped, index)

	if success then
		local tagName = GetTagNameByIndex(ped, index)
		lib.notify(ped, {
			title = 'GangTag',
			description = 'Set your GangTag to ' .. RemovePrefixes(tagName),
			type = 'success',
			position = 'center-right',
			duration = 5000,
		})
	else
		lib.notify(ped, {
			title = 'GangTag',
			description = 'Failed to set GangTag',
			type = 'error',
			position = 'center-right',
			duration = 5000,
		})
	end
end)

RegisterNetEvent('jd-gangtags:server:toggleTag')
AddEventHandler('jd-gangtags:server:toggleTag', function()
    ToggleTag(source)
end)

RegisterNetEvent('jd-gangtags:server:toggleAllTags')
AddEventHandler('jd-gangtags:server:toggleAllTags', function()
    ToggleTagsAll(source)
end)

lib.callback.register('jd-gangtags:return-tags', function(source)
    local tags = GetUserTags(source)
    return tags
end)

RegisterNetEvent('jd-gangtags:server:noclip')
AddEventHandler('jd-gangtags:server:noclip', function()
    local source = source
	if not IsPlayerAceAllowed(source, Config.noclip.ace) then return end
    TriggerClientEvent("jd-gangtags:client:noclip", -1, source)
end)
