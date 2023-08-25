NDCore = exports["ND_Core"]:GetCoreObject()

-- Admin revive command
RegisterCommand("adrev", function(source, args, rawCommand)
    local player = source -- Store the source (player) ID

    -- Check if the player is an admin
    if not NDCore.Functions.IsPlayerAdmin(player) then
        TriggerClientEvent("chatMessage", player, "^1Error: ^7You don't have permission to use this command.") -- Permission check failed
        return
    end

    local targetPlayerId = tonumber(args[1])

    if targetPlayerId then
        TriggerClientEvent("ND_Death:AdminRevivePlayerAtPosition", -1, targetPlayerId) -- Pass targetPlayerId to the client event
        TriggerClientEvent("chatMessage", player, "^2Admin: ^7You have revived player " .. targetPlayerId)
    else
        TriggerClientEvent("chatMessage", player, "^1Error: ^7Invalid player ID.")
    end
end, false)

-- CPR Command
RegisterCommand("cpr", function(source, args, rawCommand)
    local player = source -- Store the source (player) ID
    local character = NDCore.Functions.GetPlayer(player) -- Fix the variable name from 'src' to 'player'

    if character then
        local hasPermission = false
        for _, department in pairs(Config.MedDept) do
            if character.job == department then
                hasPermission = true
                break
            end
        end

        if not hasPermission then
            TriggerClientEvent("chatMessage", player, "^1Error: ^7You don't have permission to use this command.")
            return
        end

        local targetPlayerId = tonumber(args[1])
        if targetPlayerId then
            TriggerClientEvent("startCPRAnimation", source) -- Trigger the client event to start CPR animation for everyone

            Citizen.Wait(5000) -- Wait for the CPR animation to finish (adjust timing as needed)

            local playerName = GetPlayerName(targetPlayerId) -- Get the target player's name
            local cprMessage = ("You have initiated CPR on player %s."):format(playerName)
            TriggerClientEvent("SendMedicalNotifications", player, cprMessage)
            
            TriggerClientEvent("ND_Death:AdminRevivePlayerAtPosition", -1, targetPlayerId) -- Pass targetPlayerId to the client event

            local reviveMessage = ("You have revived player %s."):format(playerName)
            TriggerClientEvent("SendMedicalNotifications", player, reviveMessage)
        else
            TriggerClientEvent("chatMessage", player, "^1Error: ^7Character data not found.")
        end
    end
end)

-- This event is triggered from the client to revive a player at their downed position
RegisterServerEvent("ND_Death:AdminRevivePlayerAtPosition")
AddEventHandler("ND_Death:AdminRevivePlayerAtPosition", function(targetPlayerId)
    local targetPlayer = tonumber(targetPlayerId)

    if targetPlayer then
        local targetPlayerPed = GetPlayerPed(targetPlayer)

        if IsEntityDead(targetPlayerPed) then -- Check if the player is dead
            RespawnPlayerAtDownedPosition() -- Call the new function to revive at downed position
            TriggerClientEvent("chatMessage", -1, "^2Server: ^7Player " .. targetPlayer .. " revived by an admin.")
        else
            TriggerClientEvent("chatMessage", -1, "^1Error: ^7Player is not dead.")
        end
    end
end)

