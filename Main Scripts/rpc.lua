local presence = {
    state = "YOUR_STATE",
    details = "YOUR_DETAILS",
    startTimestamp = YOUR_TIME,
    endTimestamp = YOUR_TIME,  -- Note: This might be an unusually large timestamp value
    largeImageText = "YOUR_TEXT",
    smallImageText = "YOUR_TEXT - YOUR_TEXT",
    partyId = "YOUR_PARTYID",
    partySize = SIZE_PARTY,
    partyMax = MAX_PARTY,
    joinSecret = "YOUR_TOKEN= "
}

Roblox.UpdatePresence(presence)
