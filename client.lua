local playerDiscordNames = nil;
local formatDisplayedName = "";
local ignorePlayerNameDistance = false
local playerNamesDist = 15
local displayIDHeigheadtag = 1.2 --Heigheadtag of ID above players head(starts at center body mass)
--Set Default Values for Colors
local red = 255
local green = 255
local blue = 255

function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	local ShowHud = true

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if ShowHud then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(true)
        SetTextColour(red, green, blue, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

prefixes = {}
hidePrefix = {}
hideTags = {}
hideAll = false
if Config.TagsForStaffOnly then 
	hideAll = true;
end
prefixStr = ""









_menuPool = NativeUI.CreatePool()

if Config.playerNameTitle then
	local playerName = GetPlayerName(PlayerId())
	headtagsMenu = NativeUI.CreateMenu(playerName, "Select a ~b~HeadTag ", Config.MenuPos.x, Config.MenuPos.y)
	if Config.customMenuTexture then
		local background = Sprite.New(Config.menutexture_fileName, "banner", 0, 0, 512, 128)
    	headtagsMenu:SetBannerSprite(background, true)		
	end
else
	headtagsMenu = NativeUI.CreateMenu(Config.headTagMenuTitle, "Select a ~b~HeadTag ", Config.MenuPos.x, Config.MenuPos.y)	
	if Config.customMenuTexture then
		local background = Sprite.New(Config.menutexture_fileName, "banner", 0, 0, 512, 128)
    	headtagsMenu:SetBannerSprite(background, true)		
	end
end


_menuPool:Add(headtagsMenu)

local tagData = {} 


function AddHeadtagMenuItem(menu, data)
    local headtagItem = NativeUI.CreateItem("~y~[" .. data.id .. "] " .. data.tag, "Select HeadTag: " .. data.tag)
    menu:AddItem(headtagItem)

    headtagsMenu.OnItemSelect = function(sender, item, index)
        local selectedTag = tagData[index].tag
		TriggerServerEvent("JoeV2:HeadTags:setTag", selectedTag)  
		print("Selected Tag: " .. selectedTag)
    end
end

RegisterNetEvent("JoeV2:HeadTags:receiveData")
AddEventHandler("JoeV2:HeadTags:receiveData", function(receivedTagData)
    tagData = receivedTagData or {}
    if #tagData > 0 then
        headtagsMenu:Clear()
        for _, data in ipairs(tagData) do
            AddHeadtagMenuItem(headtagsMenu, data)
        end
		headtagsMenu:Visible(not headtagsMenu:Visible())
    else
		print("no tags available")
    end
end)

_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
    end
end)



RegisterNetEvent("ID:HideTag")
AddEventHandler("ID:HideTag", function(arr, error)
	hideTags = arr; 
end)

RegisterNetEvent("headtag:SetToHUD")
AddEventHandler("headtag:SetToHUD", function (headtag)
	exports['Badssentials']:setPlayerHeadTagGui(headtag)
end)



RegisterNetEvent("ID:Tags-Toggle:HeadTags")
AddEventHandler("ID:Tags-Toggle:HeadTags", function(val, error)
	if val then
		hideAll = true
	else
		hideAll = false
	end
end)

RegisterNetEvent("ID:Tag-Toggle:HeadTags")
AddEventHandler("ID:Tag-Toggle:HeadTags", function(arr, error)
	hidePrefix = arr
end)

RegisterNetEvent("HeadTags:Server:GetDiscordName:Return")
AddEventHandler("HeadTags:Server:GetDiscordName:Return", function(serverId, discordUsername, format, useDiscordName)
	if (useDiscordName) then 
		if playerDiscordNames == nil then 
			playerDiscordNames = {};
		end
		playerDiscordNames[serverId] = discordUsername;
	end
	formatDisplayedName = format;
end)

RegisterNetEvent("GetStaffID:StaffStr:ReturnHeadTags")
AddEventHandler("GetStaffID:StaffStr:ReturnHeadTags", function(arr, activeTagTrack, error)
	prefixes = arr
	activeTagTracker = activeTagTrack
	for k, v in pairs(activeTagTracker) do 
		print("The key is " .. k .. " and value is: " .. v)
		print("The debug value is '".. v .."'")
	end
end)

activeTagTracker = {}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

Citizen.CreateThread(function()
	-- The player has spawned, we gotta get their tag 
	Wait(1000);
	TriggerServerEvent('HeadTags:Server:GetTag'); 
	TriggerServerEvent('HeadTags:Server:GetDiscordName');
end)

colorIndex = 1;
colors = {"~g~", "~b~", "~y~", "~o~", "~r~", "~p~", "~w~"}
timer = 500;
function triggerTagUpdate()
	if not (hideAll) then
		for _, id in ipairs(GetActivePlayers()) do
			local activeTag = activeTagTracker[GetPlayerServerId(id)]
			timer = timer - 10;
			if activeTag == nil then 
				activeTag = ''
			end
			if  ((NetworkIsPlayerActive( id )) and (GetPlayerPed( id ) ~= GetPlayerPed( -1 ) or Config.ShowOwnTag) ) then
				ped = GetPlayerPed( id )
				blip = GetBlipFromEntity( ped ) 

				x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
				x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
				distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
				local displayName = formatDisplayedName;
				local name = nil;
				if playerDiscordNames ~= nil then 
					name = playerDiscordNames[GetPlayerServerId(id)];
				end
				if (name == nil) then 
					displayName = displayName:gsub("{PLAYER_NAME}", GetPlayerName(id)):gsub("{SERVER_ID}", GetPlayerServerId(id));
				else
					displayName = displayName:gsub("{PLAYER_NAME}", name):gsub("{SERVER_ID}", GetPlayerServerId(id));
				end
				local playName = GetPlayerName(GetPlayerFromServerId(GetPlayerServerId(id)))
				if ((distance < playerNamesDist)) then
					if not (ignorePlayerNameDistance) then
						if (Config.RequiresLineOfSigheadtag) then 
							if (not HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(id), 17) and (GetPlayerPed( id ) ~= GetPlayerPed( -1 )) ) then 
								return; -- They cannot see this player
							end
						end
						if NetworkIsPlayerTalking(id) then
							red = 0
							green = 0
							blue = 255
							
							if not has_value(hideTags, playName) then
								if not (has_value(hidePrefix, playName)) then
									-- Show their ID tag with prefix then
									if activeTag:find("~RGB~") then 
										tag = activeTag;
										tag = tag:gsub("~RGB~", colors[colorIndex]);
										if timer <= 0 then 
											colorIndex = colorIndex + 1;
											--print("Changed color to rainbow color: " .. colors[colorIndex]);
											if colorIndex >= #colors then 
												colorIndex = 1;
											end
											timer = 3000;
										end
										DrawText3D(x2, y2, z2 + displayIDHeigheadtag, tag .. "~b~" .. displayName)
									else 
										DrawText3D(x2, y2, z2 + displayIDHeigheadtag, activeTag .. "~b~" .. displayName)
									end 
								else
									-- Don't show their ID tag with prefix then
									DrawText3D(x2, y2, z2 + displayIDHeigheadtag, "~b~" .. displayName)
								end
							end
							prefixStr = ""
						else
							red = 255
							green = 255
							blue = 255
							if not has_value(hideTags, playName) then
								if not (has_value(hidePrefix, playName)) then
									-- Show their ID tag with prefix then
									if activeTag:find("~RGB~") then 
										tag = activeTag;
										tag = tag:gsub("~RGB~", colors[colorIndex]);
										if timer <= 0 then 
											colorIndex = colorIndex + 1;
											--print("Changed color to rainbow color: " .. colors[colorIndex]);
											if colorIndex >= #colors then 
												colorIndex = 1;
											end
											timer = 3000;
										end
										DrawText3D(x2, y2, z2 + displayIDHeigheadtag, tag .. "~w~" .. displayName)
									else 
										DrawText3D(x2, y2, z2 + displayIDHeigheadtag, activeTag .. "~w~" .. displayName)
									end 
								else
									-- Don't show their ID tag with prefix then
									DrawText3D(x2, y2, z2 + displayIDHeigheadtag, "~w~" .. displayName)
								end
							end
						end
					end
				end  
			end
		end
	end
end 
Citizen.CreateThread(function()
    while true do
        for i=0,99 do
            N_0x31698aa80e0223f8(i)
        end
		if (Config.UseKeyBind) then
			if (IsControl(0, Config.KeyBind)) then 
				triggerTagUpdate();
			end
		else
			triggerTagUpdate(); 
		end
        Citizen.Wait(0);
    end
end)