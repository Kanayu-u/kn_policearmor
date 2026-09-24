

-- クールダウン管理（key: source, value: 最終使用時刻）
local cooldowns = {}
local COOLDOWN_SECS = 5

AddEventHandler('playerDropped', function()
    cooldowns[source] = nil
end)

RegisterNetEvent('kn_policearmor:attemptArmor', function()
    local src = source

    -- 0a. クールダウン（イベント連打によるスパム防止）
    local now = os.time()
    if cooldowns[src] and (now - cooldowns[src]) < COOLDOWN_SECS then return end
    cooldowns[src] = now

    -- 0b. 対象車両に実際に乗っているかをサーバー側で検証
    --     （クライアント申告を信用せず、イベント直接発火による不正取得を防止）
    local srcPed = GetPlayerPed(src)
    local vehicle = GetVehiclePedIsIn(srcPed, false)
    if vehicle == 0 then return end
    local vehModel = GetEntityModel(vehicle)
    local isConfiguredVehicle = false
    for _, vehicleName in ipairs(Config.Vehicles) do
        if vehModel == GetHashKey(vehicleName) then
            isConfiguredVehicle = true
            break
        end
    end
    if not isConfiguredVehicle then return end

    local job = nil

    -- 1. Identify Framework and Get Job
    if GetResourceState('qbx_core') == 'started' then
        local player = exports.qbx_core:GetPlayer(src)
        if player then job = player.PlayerData.job.name end
    elseif GetResourceState('es_extended') == 'started' then
        local player = exports.es_extended:getSharedObject().GetPlayerFromId(src)
        if player then job = player.job.name end
    elseif GetResourceState('qb-core') == 'started' then
        local player = exports['qb-core']:GetCoreObject().Functions.GetPlayer(src)
        if player then job = player.PlayerData.job.name end
    end

    if not job then return end

    -- 2. Check Configuration
    local isAllowed = false
    for _, allowedJob in ipairs(Config.Jobs) do
        if job == allowedJob then
            isAllowed = true
            break
        end
    end

    if not isAllowed then return end

    -- 3. Apply Armor Logic
    local ped = GetPlayerPed(src)
    if DoesEntityExist(ped) then
        -- 一旦0にリセットし、短い待機で確実に再同期させる
        SetPedArmour(ped, 0)
        Wait(100)
        
        -- Set to Configured Amount
        SetPedArmour(ped, Config.ArmorAmount)
        
        -- Play Sound on Client
        TriggerClientEvent('kn_policearmor:playSound', src, Config.ArmorAmount)
    end
end)

-- Dynamic Armor Adjustment Command
-- Usage: /knarmor [amount]
RegisterCommand('knarmor', function(source, args, rawCommand)
    -- Check permissions (Console or Ace: command.knarmor)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'command.knarmor') then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient permissions.' } })
        return
    end

    local newAmount = tonumber(args[1])
    if newAmount then
        -- 0〜200 にクランプ（GTA のアーマー上限を超える異常値を拒否）
        newAmount = math.floor(math.max(0, math.min(200, newAmount)))
        Config.ArmorAmount = newAmount
        -- Notify source
        if source == 0 then
            print(('^2[kn_policearmor] Armor amount updated to: %d^0'):format(newAmount))
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', ('Armor amount updated to: %d'):format(newAmount) } })
        end
    else
        if source == 0 then
            print('^1[kn_policearmor] Usage: knarmor [amount]^0')
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /knarmor [amount]' } })
        end
    end
end, true) -- restricted = true (requires ace in server.cfg)
