return {
    WhitelistedJobs = {
        "police",
        "ambulance"
    },
    Alerts = {
        ["storerobbery"] = {
            title = "24/7 Robbery",
            message = "A robbery has been reported.",
            code = "10-1",
            icon = "cart-shopping",
            priority = "normal", -- "normal", "medium", "high"
            blip = 59,
        },
        ["fleecarobbery"] = {
            title = "Fleeca Robbery",
            message = "A robbery has been reported.",
            code = "10-2",
            icon = "dollar-sign",
            priority = "medium", -- "normal", "medium", "high"
            blip = 276,
        },
        ["pacificrobbery"] = {
            title = "Pacific Robbery",
            message = "A robbery has been reported.",
            code = "10-2",
            icon = "building-columns",
            priority = "high", -- "normal", "medium", "high"
            blip = 84,
        },
    }
}