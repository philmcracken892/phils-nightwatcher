local RSGCore = exports['rsg-core']:GetCoreObject()

local activeOwls = {}   
local playerCooldowns = {} 

local COOLDOWN = 120 -- seconds 

RegisterNetEvent('nightwatcher:requestOwl', function(locationIndex, coords)
    local src = source
    local now = os.time()

    playerCooldowns[src] = playerCooldowns[src] or {}

   
    if (not playerCooldowns[src][locationIndex]) or (now - playerCooldowns[src][locationIndex] >= COOLDOWN) then
        if not activeOwls[locationIndex] then
            activeOwls[locationIndex] = true
            TriggerClientEvent('nightwatcher:spawnOwl', -1, locationIndex, coords)
        end
        
        playerCooldowns[src][locationIndex] = now
    end
end)

RegisterNetEvent('nightwatcher:owlVanish', function(locationIndex)
    activeOwls[locationIndex] = nil
end)

RegisterNetEvent('nightwatcher:giveReward', function()
    local src = source
    if not src then return end

    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    local itemName = 'water'
    local itemAmount = 5
    Player.Functions.AddItem(itemName, itemAmount)

    
    TriggerClientEvent('ox_lib:notify', src, {
        title = "Night Watcher",
        description = "Wise owl gifts you  " .. itemAmount .. "x " .. itemName .. "!",
        type = "success"
    })
end)



