local formatDisplayedName = Config.FormatDisplayName;
local playerNamesDist = Config.PlayerNamesDist * Config.PlayerNamesDist
local displayIDHeight = Config.DisplayHeight
local isMenuOpen = false
local searchQuery = ""
local showTags = true;
Prefixes = {}
local hidePrefix = {}
local hideTags = {}
local activeTagTracker = {}
local hideAll = false
local noclip = {}

function DrawText3D(x,  y, z, text, size, font)
    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vec(x, y, z) - camCoords)

    size = size or 1
    font = font or 0

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0, 0.55 * scale)
    SetTextFont(font)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent("jd-gangtags:client:hideTag")
AddEventHandler("jd-gangtags:client:hideTag", function(arr, error)
	hideTags = arr
end)

RegisterNetEvent("jd-gangtags:client:toggleAllTags")
AddEventHandler("jd-gangtags:client:toggleAllTags", function(val, error)
	hideAll = val
end)

RegisterNetEvent("jd-gangtags:client:toggleTag")
AddEventHandler("jd-gangtags:client:toggleTag", function(arr, error)
	hidePrefix = arr
end)

RegisterNetEvent("jd-gangtags:client:updateTags")
AddEventHandler("jd-gangtags:client:updateTags", function(arr, activeTagTrack, error)
	Prefixes = arr
	activeTagTracker = activeTagTrack
end)

RegisterNetEvent("jd-gangtags:client:noclip")
AddEventHandler("jd-gangtags:client:noclip", function(player)
    noclip[player] = not noclip[player]
    Debug("Noclip toggled for player " .. player .. ": " .. tostring(noclip[player]))
end)


Citizen.CreateThread(function()
	Wait(1000);
	TriggerServerEvent('jd-gangtags:server:getTags');
end)

local function TriggerTagUpdate()
    if hideAll then return end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local activePlayers = GetActivePlayers()

    for i = 0, #activePlayers do
        local targetPed = GetPlayerPed(activePlayers[i])
        if NetworkIsPlayerActive(activePlayers[i]) then
            local serverId = GetPlayerServerId(activePlayers[i])
            if noclip[serverId] then goto continue end

            local activeTag = activeTagTracker[GetPlayerServerId(activePlayers[i])] or ''
            local targetCoords = GetEntityCoords(targetPed)
            local dx, dy, dz = playerCoords.x - targetCoords.x, playerCoords.y - targetCoords.y, playerCoords.z - targetCoords.z
            local distance2 = dx*dx + dy*dy + dz*dz

            if distance2 < playerNamesDist then
                local playName = GetPlayerName(activePlayers[i])

                if targetPed == playerPed and not Config.ShowOwnTag then
                    goto continue
                end

                if HasValue(hideTags, playName) then goto continue end

                if HasValue(hidePrefix, playName) then
                    if targetPed ~= playerPed or Config.ShowOwnTag then
                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + displayIDHeight, "", 1, 0)
                    end
                    goto continue
                end

                if targetPed ~= playerPed and not HasEntityClearLosToEntity(playerPed, targetPed, 17) then
                    goto continue
                end

                local displayName = formatDisplayedName
                local color = NetworkIsPlayerTalking(activePlayers[i]) and "~b~" or "~w~"

                displayName = displayName:gsub("{GANGTAG}", activeTag)

                DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + displayIDHeight, color .. displayName, 1, 0)
            end
            ::continue::
        end
    end
end

Citizen.CreateThread(function()
    local Wait = Citizen.Wait

    while true do
        if showTags then
            TriggerTagUpdate()
        end
        Wait(0)
    end
end)


CreateThread(function()
    if not Config.Custombanner.enabled then return end

    local RuntimeTXD = CreateRuntimeTxd('gangtag:banner')
    local Object = CreateDui(Config.Custombanner.url, 512, 128)

    local dui = GetDuiHandle(Object)
    CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'gangtag:banner', dui)
end)

local mainMenu = RageUI.CreateMenu("Gangtag Menu", "~b~Gangtag Menu | By JoeV2", 1400, 100, (Config.Custombanner.enabled and 'gangtag:banner' or nil), (Config.Custombanner.enabled and 'gangtag:banner' or nil), 255, 255, 255, 255)
mainMenu:SetTotalItemsPerPage(8)
mainMenu:DisplayGlare(Config.Menu.glare)


mainMenu.Closed = function()
    isMenuOpen = false
end

RegisterCommand('gangtags', function()
    if isMenuOpen then
        isMenuOpen = false
        RageUI.CloseAll()
    else
        OpenGangtagMenu()
    end
end, false)

function OpenGangtagMenu()
    if isMenuOpen then return end


    local headtags = Prefixes[GetPlayerServerId(PlayerId())]

    if not headtags or #headtags == 0 then
        lib.notify({
            title = 'Gangtag Menu',
            description = 'You don\'t have access to any gangtags',
            type = 'error',
            position = 'center-right',
            duration = 5000
        })
        return
    end

    isMenuOpen = true
    searchQuery = ""
    RageUI.Visible(mainMenu, true)

    Citizen.CreateThread(function()
        while isMenuOpen do
            Wait(1)
            RageUI.IsVisible(mainMenu, function()
                RageUI.Button("Toggle Gangtag", "Toggle gangtag", { RightLabel = "→→→" }, true, {
                    onSelected = function()
                        TriggerServerEvent('jd-gangtags:server:toggleTag')
                    end
                }, nil)

                RageUI.Button("Toggle All Gangtags", "Toggle all gangtags", { RightLabel = "→→→" }, true, {
                    onSelected = function()
                        TriggerServerEvent('jd-gangtags:server:toggleAllTags')
                    end
                }, nil)

                if Config.EnableSearch then
                    RageUI.Button("Search Tags", searchQuery == "" and "Click to search tags" or "Current search: " .. searchQuery, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            local input = lib.inputDialog('Gangtag Search', {
                                { type = 'input', label = 'Search Query', description = 'Enter text to filter tags' }
                            })
                            if input then
                                searchQuery = input[1]:lower()
                            end
                        end
                    }, nil)
                end

                RageUI.Separator("")


                local foundMatch = false
                for i = 1, #headtags do
                    local tag = headtags[i]
                    if not Config.EnableSearch or searchQuery == "" or string.find(string.lower(tag), searchQuery) then
                        foundMatch = true
                        RageUI.Button('~y~[' .. i .. ']~s~ ' .. tag, "Select headtag " .. tag, { --[[ RightLabel = "→→→" ]]}, true, {
                            onSelected = function()
                                TriggerServerEvent('jd-gangtags:server:setTag', i)
                            end
                        }, nil)
                    end
                end

                if Config.EnableSearch and not foundMatch and searchQuery ~= "" then
                    lib.notify({
                        title = 'Gangtag Search',
                        description = 'No gangtags found matching: ' .. searchQuery,
                        type = 'error',
                        position = 'center-right',
                        duration = 5000
                    })
                    searchQuery = ""
                end

                if Config.EnableSearch and searchQuery ~= "" then
                    RageUI.Button("Clear Search", "Clear current search filter", { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            searchQuery = ""
                        end
                    }, nil)
                end
            end)

            if not RageUI.Visible(mainMenu) then
                isMenuOpen = false
                break
            end
        end
    end)
end

