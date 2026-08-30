Config = {}

Config.Debug = false

-- The amount of armor to set (0-200, vanilla max is usually 100)
Config.ArmorAmount = 100

-- Jobs that can receive armor.
-- NOTE: QBCore / QBox / ESX do not ship an 'admin' job by default.
--       Replace these with job names that actually exist on your server.
Config.Jobs = {
    'police',
    'leo',
}

-- Vehicles that trigger the armor effect (spawn/model names).
-- Defaults are vanilla GTA V police vehicles so the resource works out of the box.
-- Replace or extend with your own addon vehicles as needed.
Config.Vehicles = {
    'police',
    'police2',
    'police3',
    'sheriff',
    'sheriff2',
}

-- Sound effect to play when armor is equipped
Config.Sound = {
    name = 'Pick_Up_Armor',
    dict = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
}
