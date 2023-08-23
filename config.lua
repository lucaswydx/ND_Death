-- Configuration settings
Config = {
    respawnKey = 38,  -- Change this to your desired keybind (E by default)
    respawnTime = 10, -- Change this to the desired respawn time in seconds
    respawnText = "You are dead, press ~c~[E]~w~ to respawn.",
    respawnTextWithTimer = "You are dead, you can respawn in ~c~%d~w~ seconds.",
    respawnPosition = vector3(298.29, -584.26, 43.26), -- Change to desired respawn position (Pillbox by default)
    respawnHeading = 0, -- Change to desired respawn heading (0 by default)
    bleedoutTime = 120, -- Bleed out time in seconds
    adrevCommand = "command.adrev", -- The Ace permission for /adrev command
    
    -- Define medical departments for EMS call
    MedDept = {
        "LSPD",
        "LSFD",
    },
}
