-- Admin revive command
RegisterCommand("adrev", function(source, args, rawCommand)
    local targetPlayerId = tonumber(args[1])

    if targetPlayerId then
        local sourcePlayer = source
        local hasPermission = IsPlayerAceAllowed(sourcePlayer, Config.adrevCommand) -- Using the adrevCommand from config

        if hasPermission then
            TriggerClientEvent("admin:revivePlayerAtPosition", -1, targetPlayerId) -- Pass targetPlayerId to the client event
            TriggerClientEvent("chatMessage", source, "^*^5[System]: ^7You have revived ID #" .. targetPlayerId)
        else
            TriggerClientEvent("chatMessage", source, "^*^5[System]: ^7You don't have permission to use this command.") -- Permission check failed
        end
    else
        TriggerClientEvent("chatMessage", source, "^*^5[System]: ^7Invalid player ID.")
    end
end, false)

-- This event is triggered from the client to revive a player
RegisterServerEvent("admin:revivePlayerAtPosition")
AddEventHandler("admin:revivePlayerAtPosition", function(targetPlayerId)
    local targetPlayer = tonumber(targetPlayerId)

    if targetPlayer then
        TriggerClientEvent("admin:revivePlayerAtPosition", targetPlayer) -- Trigger event to revive at downed position
        TriggerClientEvent("chatMessage", -1, "^*^5[System]: ^7Player " .. targetPlayer .. " revived by an admin.")
    end
end)
