include("utils")
if (not gamename()) then
    print("Unsupported game for bronxpack")
    return
end

include("config")

-- dvars
game:setdvar("sv_hostname", "The Bronx Pack")
game:setdvar("sv_cheats", 1)
game:setdvar("scr_sd_roundswitch", 0)
game:setdvar("scr_sd_timelimit", select(2.5, 1.5))
game:setdvar("scr_sd_planttime", 1)
game:setdvar("scr_sr_roundswitch", 0)
game:setdvar("scr_sr_timelimit", select(2.5, 1.5))
game:setdvar("scr_sr_planttime", 1)
game:setdvar("pm_bouncing", 1)
game:setdvarifuninitialized("wtfx", "no")
game:setdvarifuninitialized("wtfy", "no")
game:setdvarifuninitialized("wtfz", "no")
game:setdvarifuninitialized("savemap", "no")
game:setdvarifuninitialized("botsetup", "on")

function entity:player_spawned()
    if tostring(game:getdvar("g_gametype")) ~= select("sr", "sd") then
        self:iprintlnbold("Please switch game mode to ^:" .. select("Search & Rescue", "Search & Destroy"))
        return
    end

    self:setclientomnvar("ui_round_end_match_bonus", math.random(230, 1800))
    self:setclientomnvar("ui_disable_team_change", 1)
    self:iprintln("Welcome to The Bronx Pack by ^:@plugwalker47")

    -- binds
    self:notifyonplayercommand("refillbind", "+melee_zoom")
    self:onnotify("refillbind", function()
        if self:getstance() == "crouch" then
            self:givemaxammo(self:getcurrentweapon())
            self:givestartammo(self:getcurrentoffhand())
        end
    end)

    self:notifyonplayercommand("streakbind", "+actionslot 1")
    self:onnotify("streakbind", function()
        if self:getstance() == "crouch" then
            select_func(function()
                self:givekillstreak("deployable_ammo", 0)
            end, function()
                -- questionable streak giving, its from bronx 2.0 so i'll leave here as im lazy - mikey
                self:giveweapon("turretheadenergy_mp")
                self:switchtoweapon("turretheadenergy_mp")
            end)
        end
    end)

    -- do player-specific stuff here
    if self:ishost() then
        -- code for the game's scores
        if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
            self:iclientprintlnbold("Player status ^:Host")
        elseif gamename() == "iw6x" and game:getteamscore("axis") == 3 and game:getteamscore("allies") == 3 then
            self.pers["kills"] = 25
            self.kills = 25
            self.pers["score"] = 2350
            self.score = 2200
            self:givekillstreak("nuke", 25)
            game:executecommand("g_enableElevators 1")
        end

        self:notifyonplayercommand("savebind", "+actionslot 3")
        self:onnotify("savebind", function()
            if self:getstance() == "crouch" then
                game:setdvar("wtfx", self.origin.x)
                game:setdvar("wtfy", self.origin.y)
                game:setdvar("wtfz", self.origin.z)
                self:iprintln("Starts Next Round")
                self:iprintln("Bot Spawn ^:Saved")
            elseif self:getstance() == "prone" then
                if (game:getdvar("wtfx") ~= "no") then
                    game:setdvar("wtfx", "no")
                    game:setdvar("wtfy", "no")
                    game:setdvar("wtfz", "no")
                    self:iprintln("Starts Next Round")
                    self:iprintln("Bot Spawn ^:Cleared")
                end
            end
        end)

        self:freezecontrols(false)
        self:setrank(select(59, 49), hostprestige)
        return
    end

    -- the host doesn't see this cuz we return in his code
    if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
        self:iclientprintlnbold("Player status ^:Verified")
    end
end

-- connected/player spawned listener
level:onnotify("connected", function(player)
    player:onnotifyonce("player_spawned", function()
        player:player_spawned()
    end)
end)

-- damage override
game:onplayerdamage(function(_self, inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc)
    if game:weaponclass(weapon) == "sniper" then
        damage = 999
    elseif game:weaponclass(weapon) == "suicide" then
        damage = 999
    else
        damage = 1
    end
    return damage
end)
