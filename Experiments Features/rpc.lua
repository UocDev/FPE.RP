local app = {
    APIoc = "${data}"
}

local presence = {
    state = "Playing Solo",
    details = "Competitive",
    startTimestamp = 1507665886,
    endTimestamp = 150766588699,  -- Note: This might be an unusually large timestamp value
    largeImageText = "Numbani",
    smallImageText = "Rogue - Level 100",
    partyId = "ae488379-351d-4a4f-ad32-2b9b01c91657",
    partySize = 1,
    partyMax = 5,
    joinSecret = "MTI4NzM0OjFpMmhuZToxMjMxMjM= "
}

Roblox.UpdatePresence(presence)
