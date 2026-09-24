

-- Function to play sound
RegisterNetEvent('kn_policearmor:playSound', function(amount)
    PlaySoundFrontend(-1, Config.Sound.name, Config.Sound.dict, true)
    KnNotify(Config.Text.Title, Config.Text.Equipped:format(tonumber(amount) or Config.ArmorAmount), 'success')
end)

-- Main logic using lib.onCache for vehicle seat changes
lib.onCache('vehicle', function(value)
    -- 'value' is the vehicle handle when entering, or false/nil when leaving
    if not value then return end 

    local vehicle = value
    local model = GetEntityModel(vehicle)

    -- Check if model matches Config
    local isConfiguredVehicle = false
    for _, vehicleName in ipairs(Config.Vehicles) do
        if model == GetHashKey(vehicleName) then
            isConfiguredVehicle = true
            break
        end
    end

    if not isConfiguredVehicle then return end

    -- Trigger server to check job and apply armor
    -- We do not check job client side to prevent exploiters from just calling the event
    -- Server will validate the job source.
    TriggerServerEvent('kn_policearmor:attemptArmor')
end)
