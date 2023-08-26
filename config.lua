-- Configuration settings
Config = {
    respawnKey = 38,  -- Change this to your desired keybind (E by default)
    respawnTime = 10, -- Change this to the desired respawn time in seconds
    respawnText = "You are dead, press ~c~[E]~w~ to respawn.",
    respawnTextWithTimer = "You are dead, you can respawn in ~c~%d~w~ seconds.",
    respawnLocations = {
        { x = 298.29, y = -584.26, z = 43.26, h = 61.98 }, -- Example respawn location
        { x = 1839.21, y = 3673.5, z = 34.26, h = 198.93 },    -- Another example respawn location
        -- Add more respawn locations here
    },
    bleedoutTime = 120, -- Bleed out time in seconds
	AutoNotify = false,
    --DeptCheck = false,--Soon
    -- Define medical departments for EMS call
    MedDept = {
        "LSPD",
        "LSFD",
    },
}

