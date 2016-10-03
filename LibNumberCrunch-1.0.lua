local MAJOR, MINOR = "LibNumberCrunch-1.0", 1
assert(LibStub, MAJOR.." requires LibStub")
local lib, minor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local PLAYER_LEVEL_MAX = 110

local function round(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end


--- Shorten values.
-- Abbriviates numbers by using "k" and "m" suffixes.
-- ex. 9001->9001, 10500->10.5k, 555555->556k, 1234567->1.23m
-- @param value (number) the value to shorten.
-- @return (string) the shortened value.
function lib:ShortenValue(value)
    if (value < 1e4) then
        return value
    elseif (value < 1e5) then
        return ("%sk"):format(round(value / 1e3, 1))
    elseif (value < 1e6) then
        return ("%sk"):format(round(value / 1e3))
    elseif (value < 1e7) then
        return ("%sm"):format(round(value / 1e6, 2))
    elseif (value < 1e8) then
        return ("%sm"):format(round(value / 1e6, 1))
    else
        return ("%sm"):format(round(value / 1e6))
    end
end

--- Crunches hit point values.
-- @param value (number) the health value to crunch.
-- @param playerLevel (number) level to which you want the health values to be scaled to (usually UnitLevel("player")).
-- If left blank player max level will be used.
-- @return (number) the crunched health value, rounded to the nearest integer.
function lib:CrunchHealth(value, playerLevel)
    if value == 0 then return 0 end

    if not playerLevel then playerLevel = PLAYER_LEVEL_MAX end
    local crunchedValue
    if (playerLevel == 110) then
        crunchedValue = value / 400
    elseif (playerLevel >= 100) then
        crunchedValue = value / (((playerLevel - 100) * 25) + 110)
    elseif (playerLevel >= 90) then
        crunchedValue = value / (((playerLevel - 90) * 4) + 25)
    elseif (playerLevel >= 80) then
        crunchedValue = value / (((playerLevel - 80) * 0.8) + 13)
    elseif (playerLevel >= 60) then
        crunchedValue = value / (((playerLevel - 60) * 0.25) + 9)
    elseif (playerLevel >= 25) then
        crunchedValue = value / (((playerLevel - 25) * 0.2) + 5)
    else
        crunchedValue = value / ((playerLevel * 0.01) + 4)
    end

    return math.max(1, round(crunchedValue))
end

--- Crunches mana values.
-- @param value (number) the mana value to crunch.
-- @param playerLevel (number) level to which you want the mana values to be scaled to (usually UnitLevel("player")). If left blank player max level will be used.
-- @return (number) the crunched mana value, rounded to the nearest integer.
function lib:CrunchMana(...)
    return self:CrunchHealth(...)
end

--- Crunches damage values.
-- @see lib:CrunchHealth
function lib:CrunchDamage(...)
    return self:CrunchHealth(...)
end

--- Crunches healing values.
-- @see CrunchHealth
function lib:CrunchHealing(...)
    return self:CrunchHealth(...)
end
