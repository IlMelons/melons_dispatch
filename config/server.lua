return {
    WhitelistedJobs = {
        "police",
        "ambulance"
    },
    Alerts = {
        ["npcrobbery"] = {
            jobs = {"police"},      -- jobs to send alert too
            title = "Civilians Robbed",
            message = "They reported some robberies that occurred to citizens.",
            code = "10-0",
            icon = "user-secret",   -- Fontawesome Icon: [https://fontawesome.com/icons]
            priority = "normal",    -- "normal", "medium", "high"
            blip = 126,             -- Blip ID [https://docs.fivem.net/docs/game-references/blips/]
        },
        ["storerobbery"] = {
            jobs = {"police", "ambulance"},
            title = "24/7 Robbery",
            message = "A robbery has been reported.",
            code = "10-1",
            icon = "cart-shopping",
            priority = "normal",
            blip = 59,
        },
        ["fleecarobbery"] = {
            jobs = {"police"},
            title = "Fleeca Robbery",
            message = "A robbery has been reported.",
            code = "10-2",
            icon = "dollar-sign",
            priority = "medium",
            blip = 276,
        },
        ["pacificrobbery"] = {
            jobs = {"police"},
            title = "Pacific Robbery",
            message = "A robbery has been reported.",
            code = "10-2",
            icon = "building-columns",
            priority = "high",
            blip = 84,
        },
    }
}