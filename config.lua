Config = {}

-- Possible spawn distance from players (in meters)
Config.SpawnDistance = 5.0

-- Time window (only active between these hours)
Config.NightStart = 22   -- 9 PM
Config.NightEnd = 5      -- 5 AM

-- Chance for the event to trigger (1 = always, 0.1 = 10%)
Config.SpawnChance = 1

-- How long the owl stays before vanishing (in seconds)
Config.StayDuration = 20
  -- Radius (meters) around player for slow mo effect
Config.UseGlobalTimeScale = true    -- true = Slows entire world (with player compensation); false = Local peds only
Config.SpawnDistance = 5
Config.Messages = {
    "You feel a chill down your spine...",
    "The owl disappears into the mist.",
    "Its eyes pierce through your soul, then fade away.",
    "A whisper echoes: 'It watches... always.'"
}

Config.Locations = {
    { x = -233.61, y = 822.36, z = 124.48 },-- Valentine Graveyard
    
}

Config.OwlQuotes = {
    "The night holds many secrets.",
    "Patience is the key to understanding.",
    "Not all who wander are lost.",
    "Even the smallest creature has a purpose.",
    "Watch, listen, and the truth will reveal itself.",
    "Fear is only the shadow of your mind.",
    "Wisdom comes to those who seek it quietly.",
    "The shadows reveal what the light hides.",
    "A single choice can change many paths.",
    "Time moves differently for those who watch.",
    "Silence often speaks louder than words.",
    "Courage is not the absence of fear, but the triumph over it.",
    "The moon guides those who are lost.",
    "Every ending is the beginning of something new.",
    "Observe closely, for the truth is often hidden.",
    "Knowledge without action is like a bird that never flies.",
    "Even in darkness, hope can be found.",
    "What you fear may hold the lesson you need.",
    "Listen to the wind; it carries forgotten tales.",
    "The wise see beyond what the eyes reveal."
}



-- Chance of dropping an item or note
Config.DropChance = 0.25

-- Item name to give on drop (make sure it's in your inventory system)
Config.DropItem = "feather"
