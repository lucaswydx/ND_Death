-- Load core object from ND_Core export
local NDCore = exports["ND_Core"]:GetCoreObject()

-- Initialize flags and timers
local IsDead = false
local IsEMSNotified = false  -- Flag to prevent duplicate notifications
local secondsRemaining = Config.respawnTime
local isBleedingOut = false
local bleedOutTime = 0


-- Function to draw custom text on the screen
function DrawCustomText(text, x, y, scale, font)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextJustification(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


-- Function to show respawn text
function ShowRespawnText()
    local textToShow
    if secondsRemaining > 0 then
        textToShow = IsDead and Config.respawnTextWithTimer:format(secondsRemaining) or ""
    else
        textToShow = IsDead and Config.respawnText or ""
    end
    DrawCustomText(textToShow, 0.500, 0.900, 0.50, 4) -- Updated position
end


-- Function to respawn the player
function RespawnPlayer()
    local playerPos = Config.respawnPosition
    local respawnHeading = Config.respawnHeading
    local playerPed = GetPlayerPed(-1)
    
    IsDead = false
    DoScreenFadeOut(1500)
    Citizen.Wait(1500) 
    NetworkResurrectLocalPlayer(playerPos.x, playerPos.y, playerPos.z, respawnHeading, true, true, false)
    SetEntityCoordsNoOffset(playerPed, playerPos.x, playerPos.y, playerPos.z, true, true, true)
    SetEntityHeading(playerPed, respawnHeading)
    SetPlayerInvincible(playerPed, false)
    ClearPedBloodDamage(playerPed)
    DoScreenFadeIn(1500)
    secondsRemaining = Config.respawnTime
end


-- Function to respawn the player at downed position
function RespawnPlayerAtDownedPosition()
    local playerPos = GetEntityCoords(PlayerPedId())
    local respawnHeading = Config.respawnHeading
    local playerPed = PlayerPedId() -- Use PlayerPedId() directly
    
    IsDead = false
    DoScreenFadeOut(1500)
    Citizen.Wait(1500) 
    NetworkResurrectLocalPlayer(playerPos.x, playerPos.y, playerPos.z, respawnHeading, true, true, false)
    SetEntityHeading(playerPed, respawnHeading)
    SetPlayerInvincible(playerPed, false)
    ClearPedBloodDamage(playerPed)
    DoScreenFadeIn(1500)
    secondsRemaining = Config.respawnTime
end


-- Main Loop --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local health = GetEntityHealth(PlayerPedId())
        
        if health < 2 then
            IsDead = true
            if Config.AutoNotify then
                if not IsEMSNotified then
                    -- Notify medical departments when there's a downed player
                    for _, department in pairs(Config.MedDept) do
                        local character = NDCore.Functions.GetSelectedCharacter()

                        if character then
                            if character.job == department then
				                local playerCoords = GetEntityCoords(PlayerPedId())
                                local message = "A player is down and needs medical attention. Respond to the location:"
                                local blip = NotifyMedicDept(message, playerCoords) -- Pass playerCoords to the function
                                IsEMSNotified = true
                                print("Notifying medic department.")
                                break
                            end
                        end
                    end
                end
            end
        else
            IsDead = false
            IsEMSNotified = false
        end
        
        if IsDead then
            exports.spawnmanager:setAutoSpawn(false)
            ShowRespawnText()
            if IsControlJustReleased(1, 38) then
                RespawnPlayer()
            end
        end
    end
end)

-- Timer Loop --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        if secondsRemaining > 0 and IsDead then
            secondsRemaining = secondsRemaining - 1
        end
        
        if isBleedingOut and GetGameTimer() > bleedOutTime then
            RespawnPlayer() -- Respawn the player after bleed out time
        end
    end
end)


-- Code to revive player at position
RegisterNetEvent("ND_Death:AdminRevivePlayerAtPosition")
AddEventHandler("ND_Death:AdminRevivePlayerAtPosition", function()
    local playerPed = PlayerPedId()

    if IsEntityDead(playerPed) then
        RespawnPlayerAtDownedPosition() -- Call the new function
    end
end)

-- Event to notify EMS about a downed player
function NotifyMedicDept(message, coordsToBlip)
    for _, department in pairs(Config.MedDept) do
        local character = NDCore.Functions.GetSelectedCharacter()
        if character and character.job == department then
            local location = GetStreetNameFromHashKey(GetStreetNameAtCoord(coordsToBlip.x, coordsToBlip.y, coordsToBlip.z))
            local messageWithLocation = message .. " Location: " .. location
			if GetResourceState("ModernHUD") == "started" then
				exports["ModernHUD"]:AndyyyNotify({
					title = "<p style='color: #ff0000;'>EMS Call:</p>",
					message = "<p style='color: #ffffff;'>Player down and needs medical attention at:</p><br><p style='color: #ff0000;'>" .. location .. "</p>",
					icon = "fa-solid fa-ambulance",
					colorHex = "#ff0000",
					timeout = 8000
				})
			else
				TriggerEvent('chatMessage', '^3EMS Call', { 255, 255, 255 }, 'Player down and needs medical attention at: ' .. location)
			end

            -- Add a blip on the map
            local blip = AddBlipForCoord(coordsToBlip.x, coordsToBlip.y, coordsToBlip.z)
            SetBlipSprite(blip, 153) -- EMS blip sprite
            SetBlipDisplay(blip, 2)
            SetBlipColour(blip, 3) -- Red color
            SetBlipFlashes(blip, true)
            SetBlipFlashInterval(blip, 500)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("EMS Call")
            EndTextCommandSetBlipName(blip)
            
            return blip -- Return the blip ID for later use
        end
    end
end

-- Event to notify EMS about a downed player
RegisterNetEvent("ND_Death:NotifyEMS")
AddEventHandler("ND_Death:NotifyEMS", function(playerCoords)
    local location = GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
    -- Create a blip on the map
    local blip = AddBlipForCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    SetBlipSprite(blip, 153) -- EMS blip sprite
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 3) -- Red color
    SetBlipFlashes(blip, true)
    SetBlipFlashInterval(blip, 500)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("EMS Call")
    EndTextCommandSetBlipName(blip)
    if GetResourceState("ModernHUD") == "started" then
        exports["ModernHUD"]:AndyyyNotify({
            title = "<p style='color: #ff0000;'>EMS Call:</p>",
            message = "<p style='color: #ffffff;'>Player down and needs medical attention at:</p><br><p style='color: #ff0000;'>" .. location .. "</p>",
            icon = "fa-solid fa-ambulance",
            colorHex = "#ff0000",
            timeout = 8000
        })
    else
        TriggerEvent('chatMessage', '^3EMS Call', { 255, 255, 255 }, 'Player down and needs medical attention at: ' .. location)
    end
end)

