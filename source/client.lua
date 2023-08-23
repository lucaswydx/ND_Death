local IsDead = false
local secondsRemaining = Config.respawnTime
local isBleedingOut = false
local bleedOutTime = 0

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

function ShowRespawnText()
    local textToShow = IsDead and (secondsRemaining > 0 and Config.respawnTextWithTimer:format(secondsRemaining) or Config.respawnText) or ""
    DrawCustomText(textToShow, 0.450, 0.800, 0.50, 4)
end

function RespawnPlayer()
    local playerPos = Config.respawnPosition
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
        
        local health = GetEntityHealth(GetPlayerPed(-1))
        
        if health < 2 then
            IsDead = true
        else
            IsDead = false
        end
        
        if IsDead then
            exports.spawnmanager:setAutoSpawn(false)
            ShowRespawnText()
            
            if IsControlJustReleased(1, Config.respawnKey) and secondsRemaining <= 0 then
                RespawnPlayer()
            end
            
            if IsControlJustReleased(1, 47) and isBleedingOut then -- Check if 'G' key is pressed (47 is the control code for 'G')
                RespawnPlayer() -- Respawn the player immediately if 'G' is pressed during bleed out
            end
        end
    end
end)


function CallEMS()
    local health = GetEntityHealth(PlayerPedId())
    local isPlayerDowned = health < 2
    
    if isPlayerDowned then
        TriggerEvent("chatMessage", "EMC", "normal", "EMS has been called to your location.")
        
        isBleedingOut = true
        bleedOutTime = GetGameTimer() + Config.bleedoutTime
    end
end

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

RegisterNetEvent("admin:revivePlayerAtPosition")
AddEventHandler("admin:revivePlayerAtPosition", function()
    local playerPed = PlayerPedId()

    if IsEntityDead(playerPed) then
        RespawnPlayerAtDownedPosition() -- Call the new function
    end
end)
