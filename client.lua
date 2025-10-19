local RSGCore = exports['rsg-core']:GetCoreObject()
local spawnedOwl = nil
local owlCoords = nil
local watching = false
local currentLocationIndex = nil

------------------------------------------------
-- Notifications
------------------------------------------------
local function Notify(text)
    lib.notify({
        title = 'The Night Watcher',
        description = text,
        type = 'inform'
    })
end

------------------------------------------------
-- Particle FX
------------------------------------------------
local function SpawnFX(dict, name, entity)
    local dictName = dict or "scr_net_target_races"
    local fxName = name or "scr_net_target_fire_ring_burst_mp"
    local targetEntity = entity or PlayerPedId()

    if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(dictName)) then
        Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(dictName))
        local counter = 0
        while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(dictName)) and counter <= 300 do
            Wait(0)
            counter += 1
        end
    end

    if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(dictName)) then
        Citizen.InvokeNative(0xA10DB07FC234DD12, dictName)
        Citizen.InvokeNative(0xE6CFE43937061143, fxName, targetEntity, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 0, 0, 0)
    end
end

------------------------------------------------
-- Time utilities
------------------------------------------------
local function IsNight()
    local hour = GetClockHours()
    if Config.NightStart > Config.NightEnd then
        return hour >= Config.NightStart or hour < Config.NightEnd
    else
        return hour >= Config.NightStart and hour < Config.NightEnd
    end
end
------------------------------------------------
-- Owl vanish
------------------------------------------------
local function VanishOwl()
    if not spawnedOwl then return end

    local msg = Config.Messages[math.random(#Config.Messages)]
    Notify(msg)

    SpawnFX("scr_net_target_races", "scr_net_target_fire_ring_burst_mp", spawnedOwl)
	TriggerEvent('InteractSound_CL:Stop', 'owl')
    Wait(1500)

    DeletePed(spawnedOwl)
    spawnedOwl = nil
    watching = false

    if currentLocationIndex then
        TriggerServerEvent('nightwatcher:owlVanish', currentLocationIndex)
        currentLocationIndex = nil
    end
end
------------------------------------------------
-- Owl spawn
------------------------------------------------
local function SpawnOwlAt(spawnPos, locationIndex)
    if spawnedOwl then return end

    local model = GetHashKey('A_C_OWL_01')
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    spawnedOwl = CreatePed(model, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true, true, true)
    owlCoords = spawnPos
    watching = true
    currentLocationIndex = locationIndex

    SetEntityInvincible(spawnedOwl, true)
    FreezeEntityPosition(spawnedOwl, true)
    SetBlockingOfNonTemporaryEvents(spawnedOwl, true)
    TaskStandStill(spawnedOwl, -1)
    Citizen.InvokeNative(0x283978A15512B2FE, spawnedOwl, true)
	

    SpawnFX("scr_net_target_races", "scr_net_target_fire_ring_burst_mp", spawnedOwl)

    exports.ox_target:addLocalEntity(spawnedOwl, { {
        name = 'owl_wisdom',
        icon = 'feather',
        label = 'Consult the Night Watcher',
        onSelect = function()
            lib.notify({
                title = 'The Night Watcher',
                description = Config.OwlQuotes[math.random(#Config.OwlQuotes)],
                type = 'inform',
                duration = 10000
            })
            TriggerServerEvent('nightwatcher:giveReward')
        end,
        distance = 2.5
    } })

    Notify("You feel a chill... something watches from the shadows.")
	
	TriggerEvent('InteractSound_CL:PlayOnOne', 'owl', 0.5) -- volume = 0.5

end



------------------------------------------------
-- Main loop: spawn/vanish based on distance & night
------------------------------------------------
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        if not watching and IsNight() then
            for i, loc in ipairs(Config.Locations) do
                local locCoords = vector3(loc.x, loc.y, loc.z)
                if #(pCoords - locCoords) <= (Config.SpawnDistance or 5.0) and math.random() < Config.SpawnChance then
                    TriggerServerEvent('nightwatcher:requestOwl', i, locCoords)
                    break
                end
            end
        elseif watching and spawnedOwl then
            local distance = #(pCoords - owlCoords)
            if distance > 10.0 then
                VanishOwl()
            end
        end
    end
end)

------------------------------------------------
-- Receive spawn instruction from server
------------------------------------------------
RegisterNetEvent('nightwatcher:spawnOwl', function(locationIndex, coords)
    SpawnOwlAt(coords, locationIndex)
end)
