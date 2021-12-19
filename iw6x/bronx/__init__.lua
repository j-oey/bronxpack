include("config")
game:setdvar("sv_hostname","The Bronx Pack")
game:setdvar("sv_cheats",1)
game:setdvar("scr_sd_roundswitch",0)
game:setdvar("scr_sd_timelimit",2.5)
game:setdvar("scr_sd_planttime",1)
game:setdvar("scr_sr_roundswitch",0)
game:setdvar("scr_sr_timelimit",2.5)
game:setdvar("scr_sr_planttime",1)
game:setdvar("pm_bouncing",1)
game:setdvarifuninitialized("wtfx","no")
game:setdvarifuninitialized("wtfy","no")
game:setdvarifuninitialized("wtfz","no")

function setup(player)
    if player.name == gamehost then
        player:notifyonplayercommand("savebind", "+actionslot 3")
        player:notifyonplayercommand("refillbind", "+melee_zoom")
        player:onnotify("refillbind",
        function() if player:getstance() == "crouch" then
            refill(player)
        elseif player:getstance() == "prone" then
            clearpos(player)
        end end)
        player:onnotify("savebind",
        function () if player:getstance() == "crouch" then
            savepos(player)
        end end)
        player:freezecontrols(false)
        player:setrank(59,hostprestige)
    elseif player.name == guest1 then
        player:notifyonplayercommand("refillbind", "+melee_zoom")
        player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
        player:setrank(59,g1prestige)
    elseif player.name == guest2 then
        player:notifyonplayercommand("refillbind", "+melee_zoom")
        player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
        player:setrank(59,g2prestige)
    elseif player.name == guest3 then
        player:notifyonplayercommand("refillbind", "+melee_zoom")
        player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
        player:setrank(59,g3prestige)
    elseif player.name == guest4 then
        player:notifyonplayercommand("refillbind", "+melee_zoom")
        player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
        player:setrank(59,g4prestige)
    elseif player.name == guest5 then
        player:iclientprintln("^:" .. gamehost .. "^1 is Host")
        player:notifyonplayercommand("refillbind", "+melee_zoom")
        player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
        player:setrank(59,g5prestige)
    else
        if tostring(game:getdvar("wtfx")) == "no" then
        else
            local manx = tonumber(game:getdvar("wtfx"))
            local many = tonumber(game:getdvar("wtfy"))
            local manz = tonumber(game:getdvar("wtfz"))
            local savep = vector:new(manx, many, manz)
            game:oninterval(function() player:freezecontrols(true) end, 5)
            player:setorigin(savep)
        end
        game:ontimeout(function() player:setrank(59,0) end, 1000)
    end
    player:iprintln("Welcome to The Bronx Pack by ^:@plugwalker47")
end

function clearpos(player)
    if tostring(game:getdvar("wtfx")) == "no" then
    else
        game:executecommand("wtfx no")
        player:iprintln("Starts Next Round")
        player:iprintln("Bot Spawn ^:Cleared")
    end
end

function savepos(player)
    game:executecommand("wtfx " .. player.origin.x)
	game:executecommand("wtfy " .. player.origin.y)
	game:executecommand("wtfz " .. player.origin.z)
    player:iprintln("Starts Next Round")
    player:iprintln("Bot Spawn ^:Saved")
end

function refill(player)
    player:givemaxammo(player:getcurrentweapon())
    player:givestartammo(player:getcurrentoffhand())
end

function init(player)
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
end

level:onnotify("connected", init)
level:onnotify("player_spawned", setup)
