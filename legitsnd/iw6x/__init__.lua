include("config")
game:setdvar("sv_hostname","the bronx pack 2")
game:setdvar("sv_cheats",0)
game:setdvar("pm_bouncing",1)
game:setdvarifuninitialized("wtfx","no")
game:setdvarifuninitialized("wtfy","no")
game:setdvarifuninitialized("wtfz","no")
game:setdvarifuninitialized("savemap","no")
damap = tostring(game:getdvar("mapname"))

function setup(player)
    if tostring(game:getdvar("g_gametype")) ~= "sr" then
        player:iprintlnbold("Please switch game mode to ^:Search & Rescue")
    else
        player:setclientomnvar("ui_round_end_match_bonus",math.random(230,1800))
        if player.name == gamehost then
            player:notifyonplayercommand("savebind", "+actionslot 3")
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 1")
            player:onnotify("refillbind",
            function() if player:getstance() == "crouch" then
                refill(player)
            end end)
            player:onnotify("savebind",
            function () if player:getstance() == "crouch" then
                savepos(player)
            end end)
            player:onnotify("streakbind", function ()
                if player:getstance() == "crouch" then
                    player:scriptcall("maps/mp/killstreaks/_killstreaks","_ID15602", "deployable_ammo", false, true, player)
                    player:scriptcall("maps/mp/gametypes/_hud_message","_ID19270", "deployable_ammo" , 0 )
                end
            end)
            player:freezecontrols(false)
            player:setrank(59,hostprestige)
            if game:getteamscore("axis") == 3 and game:getteamscore("allies") == 3 then
                player:scriptcall("maps/mp/killstreaks/_killstreaks","_ID15602", "nuke", false, true, player)
                player:scriptcall("maps/mp/gametypes/_hud_message","_ID19270", "nuke" , 0 )
            end
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Host")
            end
        elseif player.name == guest1 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:setrank(59,g1prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest2 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:setrank(59,g2prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest3 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:setrank(59,g3prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest4 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:setrank(59,g4prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Verified")
            end
        elseif player.name == guest5 then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:setrank(59,g5prestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Verified")
            end
        else
            game:oninterval(function ()
            player:freezecontrols(true)
            player.playercardpatch = 309
            player:setrank(59,0)
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
            player:iprintlnbold("Player status ^1Unknown")
        end
        player:iprintln("Use [{+stance}] and [{+melee_zoom}] to refill ammo")
        player:iprintln("IW6x Setup S&R by ^:@plugwalker47")
    end
end

function savepos(player)
    game:executecommand("wtfx " .. player.origin.x)
	game:executecommand("wtfy " .. player.origin.y)
	game:executecommand("wtfz " .. player.origin.z)
	game:executecommand("savemap " .. damap)
    player:iprintlnbold("Bot Spawn ^:Saved")
end

function refill(player)
    player:givemaxammo(player:getcurrentweapon())
    player:givestartammo(player:getcurrentoffhand())
    player:givestartammo(player:getoffhandsecondaryclass())
end

function init(player)
    game:onplayerdamage(function(_self, inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc)
        if game:weaponclass(weapon) == "sniper" then
            damage = 999
        elseif mod == "MOD_UNKNOWN" and weapon == "none"  then
            damage = 0
        end
        return damage
    end)
end

level:onnotify("connected", init)
level:onnotify("player_spawned", setup)