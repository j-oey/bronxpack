-- iw6x/s1x compatibility utils
function gamename()
    if (gamename_) then
        return gamename_
    end

    gamename_ = nil
    local version = game:getdvar("version")

    if (version:match("IW6x")) then
        gamename_ = "iw6x"
    elseif (version:match("S1x")) then
        gamename_ = "s1x"
    end

    return gamename_
end

function select(iw6x, s1x)
    if (gamename() == "iw6x") then
        return iw6x
    elseif (gamename() == "s1x") then
        return s1x
    end
end

function select_func(iw6x, s1x)
    if (gamename() == "iw6x") then
        return iw6x()
    elseif (gamename() == "s1x") then
        return s1x()
    end
end

-- custom iprintln to support both games
function entity:_iprintln(string)
    if (gamename() == "iw6x") then
        self:iprintln(string)
    elseif (gamename() == "s1x") then
        self:iclientprintln(string)
    end
end

function entity:_iprintlnbold(string)
    if (gamename() == "iw6x") then
        self:iprintlnbold(string)
    elseif (gamename() == "s1x") then
        self:iclientprintlnbold(string)
    end
end

-- iw6x give killstreak func
function entity:givekillstreak(killstreak, val)
    self:scriptcall("maps/mp/killstreaks/_killstreaks", "_ID15602", killstreak, false, true, self)
    self:scriptcall("maps/mp/gametypes/_hud_message", "_ID19270", killstreak, val)
end
