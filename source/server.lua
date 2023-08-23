-- Admin revive command
RegisterCommand("adrev", function(source, args, rawCommand)
    local targetPlayerId = tonumber(args[1])

    if targetPlayerId then
        local sourcePlayer = source
        local hasPermission = IsPlayerAceAllowed(sourcePlayer, Config.adrevCommand)

        if hasPermission then
            TriggerClientEvent("admin:revivePlayerAtPosition", -1, targetPlayerId)
            TriggerClientEvent("chatMessage", source, "^*^5[System]: ^7You have revived ID #" .. targetPlayerId)
        else
            TriggerClientEvent("chatMessage", source, "^*^5[System]: ^7You don't have permission to use this command.")
        end
    else
        TriggerClientEvent("chatMessage", source, "^*^5[System]: ^7Invalid player ID.")
    end
end, false)

RegisterServerEvent("admin:revivePlayerAtPosition")
AddEventHandler("admin:revivePlayerAtPosition", function(targetPlayerId)
    local targetPlayer = tonumber(targetPlayerId)

    if targetPlayerId then
        TriggerClientEvent("admin:revivePlayerAtPosition", targetPlayer)
        TriggerClientEvent("chatMessage", -1, "^*^5[System]: You have been revived by an admin.")
    end
end)
