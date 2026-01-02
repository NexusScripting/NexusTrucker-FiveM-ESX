Config = {}
Config.Language = "English" -- "Deutsch" or "English"

Config.DepotLocation = vector3(1183.53, -3288.43, 5.52) 
Config.NPCHeading = 90.0
Config.ReturnLocation = vector3(1173.18, -3309.83, 5.90) 

Config.SpawnPoints = {
    { coords = vector3(1151.8, -3304.8, 5.9), heading = 87.4 },
    { coords = vector3(1154.7, -3295.9, 5.9), heading = 85.6 },
    { coords = vector3(1155.4, -3285.8, 5.9), heading = 93.0 }
}

Config.Translate = {
    ["Deutsch"] = {
        -- UI Texte (Das behebt das "undefined")
        ui_title = "Frachtbörse",
        ui_earned = "Verdient",
        ui_finished = "Fahrten",
        ui_rank = "Rang",
        ui_level = "Level",
        ui_exit = "VERLASSEN",
        ui_accept = "Wählen",
        ui_locked = "Gesperrt",
        -- Ränge
        rank_1 = "Lehrling",
        rank_2 = "Profi",
        rank_3 = "Logistik-Legende",
        -- Benachrichtigungen
        help_open = "Drücke ~INPUT_CONTEXT~",
        n_start = "Auftrag gestartet! Fahre zum Ziel.",
        n_error_trailer = "Anhänger verloren! Koppel ihn wieder an.",
        n_error_parking = "Kein Parkplatz frei!",
        n_delivered = "Fracht abgegeben! Bring den LKW zurück.",
        n_finished = "Job erledigt. Feierabend!",
        n_damaged = "Lohn gekürzt wegen Schäden!",
        n_perfect = "Volle Auszahlung erhalten!"
    },
    ["English"] = {
        ui_title = "Freight Exchange",
        ui_earned = "Earned",
        ui_finished = "Finished",
        ui_rank = "Rank",
        ui_level = "Level",
        ui_exit = "EXIT",
        ui_accept = "Select",
        ui_locked = "Locked",
        rank_1 = "Rookie",
        rank_2 = "Professional",
        rank_3 = "Logistics Legend",
        help_open = "Press ~INPUT_CONTEXT~",
        n_start = "Job started! Drive to the destination.",
        n_error_trailer = "Trailer lost! Hook it back up.",
        n_error_parking = "No parking spot available!",
        n_delivered = "Cargo delivered! Return the truck.",
        n_finished = "Job finished!",
        n_damaged = "Payout docked due to damages!",
        n_perfect = "Full payout received!"
    }
}

Config.Jobs = {
    { category = "standard", label = "iFruit Store Lieferung", model = "phantom", trailer = "trailers2", basePrice = 1200, minLevel = 1, xpReward = 200 },
    { category = "standard", label = "GoPostal Logistik-Express", model = "phantom3", trailer = "trailers", basePrice = 1500, minLevel = 2, xpReward = 250 },
    { category = "heavy", label = "YouTool Industrieteile", model = "packer", trailer = "trailerlogs", basePrice = 2500, minLevel = 3, xpReward = 450 },
    { category = "hazmat", label = "Humane Labs Forschungsmaterial", model = "hauler", trailer = "tanker", basePrice = 5000, minLevel = 5, xpReward = 800 }
}

Config.DeliveryPoints = {
    vector3(540.4, 2658.6, 42.2),
    vector3(-1673.7, 3084.5, 31.5),
    vector3(1721.7, 6425.9, 33.5),
    vector3(1713.1, 4940.8, 42.0)
}