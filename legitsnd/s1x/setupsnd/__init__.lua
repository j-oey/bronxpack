include("config")
game:setdvar("sv_hostname","the bronx pack 2")
game:setdvar("sv_cheats",0)
game:setdvar("pm_bouncing",1)
game:setdvar("scr_sd_winlimit",6)
game:setdvarifuninitialized("wtfx","no")
game:setdvarifuninitialized("wtfy","no")
game:setdvarifuninitialized("wtfz","no")
game:setdvarifuninitialized("savemap","no")
damap = tostring(game:getdvar("mapname"))

function setup(player)
    if tostring(game:getdvar("g_gametype")) ~= "sd" then
        player:iclientprintlnbold("Please switch game mode to ^:Search & Destroy")
    else
        player:setclientomnvar("ui_disable_team_change",1)
        if player.name == gamehost then
            player:notifyonplayercommand("savebind", "+actionslot 3")
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 4")
            player:onnotify("refillbind",
            function() if player:getstance() == "crouch" then
                refill(player)
            end end)
            player:onnotify("savebind",
            function () if player:getstance() == "crouch" then
                savepos(player)
            end end)
            player:onnotify("streakbind",
            function ()
                player:giveweapon("turretheadenergy_mp")
                player:switchtoweapon("turretheadenergy_mp")
            end)
            player:freezecontrols(false)
            player:setrank(49,hostprestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Host")
            end
        elseif player.name == guest1 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 4")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:onnotify("streakbind",
            function ()
                player:giveweapon("turretheadenergy_mp")
                player:switchtoweapon("turretheadenergy_mp")
            end)
            player:setrank(49,g1prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest2 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 4")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:onnotify("streakbind",
            function ()
                player:giveweapon("turretheadenergy_mp")
                player:switchtoweapon("turretheadenergy_mp")
            end)
            player:setrank(49,g2prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest3 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 4")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:onnotify("streakbind",
            function ()
                player:giveweapon("turretheadenergy_mp")
                player:switchtoweapon("turretheadenergy_mp")
            end)
            player:setrank(49,g3prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest4 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 4")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:onnotify("streakbind",
            function ()
                player:giveweapon("turretheadenergy_mp")
                player:switchtoweapon("turretheadenergy_mp")
            end)
            player:setrank(49,g4prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest5 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 4")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:onnotify("streakbind",
            function ()
                player:giveweapon("turretheadenergy_mp")
                player:switchtoweapon("turretheadenergy_mp")
            end)
            player:setrank(49,g5prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Verified")
            end
        else
            game:oninterval(function ()
            player:freezecontrols(true)
            player:setrank(49,0)
                if tostring(game:getdvar("savemap")) == damap then
                    if tostring(game:getdvar("wtfx")) == "no" then
                    else
                        local manx = tonumber(game:getdvar("wtfx"))
                        local many = tonumber(game:getdvar("wtfy"))
                        local manz = tonumber(game:getdvar("wtfz"))
                        local savep = vector:new(manx, many, manz)
                        player:setorigin(savep)
                    end
                end
            end,5)
            player:iclientprintlnbold("Player status ^1Unknown")
        end
        player:iclientprintln("Use [{+stance}] and [{+melee_zoom}] to refill ammo")
        player:iclientprintln("S1x Setup S&D by ^:@plugwalker47")
        game:oninterval(function () mbonus(player) end,5)
    end
end

function savepos(player)
    game:executecommand("wtfx " .. player.origin.x)
	game:executecommand("wtfy " .. player.origin.y)
	game:executecommand("wtfz " .. player.origin.z)
	game:executecommand("savemap " .. damap)
    player:iclientprintlnbold("Bot Spawn ^:Saved")
end

function mbonus(player)
    if player.team == "axis" then
        if game:getteamscore("axis") == 6 then
            player:setclientomnvar( "ui_round_end_match_bonus", 2000 )
        elseif game:getteamscore("allies") == 6 then
            player:setclientomnvar( "ui_round_end_match_bonus", 1000 )
        else
            player:setclientomnvar( "ui_round_end_match_bonus", 0 )
        end
    elseif player.team == "allies" then
        if game:getteamscore("allies") == 6 then
            player:setclientomnvar( "ui_round_end_match_bonus", 2000 )
        elseif game:getteamscore("axis") == 6 then
            player:setclientomnvar( "ui_round_end_match_bonus", 1000 )
        else
            player:setclientomnvar( "ui_round_end_match_bonus", 0 )
        end
    end
end

function refill(player)
    player:givemaxammo(player:getcurrentweapon())
    player:givestartammo(player:getcurrentoffhand())
    player:batteryfullrecharge(player:getoffhandsecondaryclass())
end

function init(player)
    game:onplayerdamage(function(_self, inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc)
        if game:weaponclass(weapon) == "sniper" then
            damage = 999
        end
        return damage
    end)
end

level:onnotify("connected", init)
level:onnotify("player_spawned", setup)