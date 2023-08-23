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

-- Handle EMSNotify event
RegisterCommand("callems", function(source, args, rawCommand)
    local player = source
    TriggerClientEvent("ND_Death:NotifyEMS", -1, GetEntityCoords(GetPlayerPed(player)))
end, false)
