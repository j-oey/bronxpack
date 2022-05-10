include("config")
game:setdvar("sv_cheats",0)
game:setdvar("pm_bouncing",1)
game:setdvar("scr_player_healthregentime",5)
game:setdvar("g_playercollision",0)
game:setdvar("g_playerejection",0)
game:setdvar("perk_bulletpenetrationmultiplier",40)
game:setdvar("jump_enablefalldamage",1)
game:setdvarifuninitialized("botx","no")
game:setdvarifuninitialized("boty","no")
game:setdvarifuninitialized("botz","no")
game:setdvarifuninitialized("savemap","no")
game:setdvarifuninitialized("unsetup","1")
damap = tostring(game:getdvar("mapname"))
players = {}

function setup(player)
    if tostring(game:getdvar("g_gametype")) == "sr" then
        player:setclientomnvar( "ui_round_end_match_bonus", math.random(300,1800) )
        if player:ishost() == 1 then
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
                    player:scriptcall("maps/mp/gametypes/_hud_message","_ID19270", "deployable_ammo" , 6 )
                end
            end)
            player:freezecontrols(false)
            player:setrank(59,hostprestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Host")
            end
            if game:getteamscore("axis") == 3 and game:getteamscore("allies") == 3 then
                player.pers["kills"] = 25
                player.kills = 25
                player.pers["score"] = 2350
                player.score = 2200
                player:scriptcall("maps/mp/killstreaks/_killstreaks","_ID15602", "nuke", false, true, player)
                player:scriptcall("maps/mp/gametypes/_hud_message","_ID19270", "nuke" , 25 )
                game:executecommand("g_enableelevators 1")
            end
        elseif player.team == "allies" then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("dropbind", "+actionslot 1")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:onnotify("dropbind", function ()
                if player:getstance() == "crouch" then
                    player:giveweapon("iw6_arx160_mp_acog_grip_silencer")
                    player:dropitem("iw6_arx160_mp_acog_grip_silencer")
                end
            end)
            if player.name == guest1 then
                player:setrank(59,g1prestige)
            elseif player.name == guest2 then
                player:setrank(59,g2prestige)
            elseif player.name == guest3 then
                player:setrank(59,g3prestige)
            elseif player.name == guest4 then
                player:setrank(59,g4prestige)
            elseif player.name == guest5 then
                player:setrank(59,g5prestige)
            elseif player.name == guest6 then
                player:setrank(59,g6prestige)
            elseif player.name == guest7 then
                player:setrank(59,g7prestige)
            elseif player.name == guest8 then
                player:setrank(59,g8prestige)
            elseif player.name == guest9 then
                player:setrank(59,g9prestige)
            elseif player.name == guest10 then
                player:setrank(59,g10prestige)
            elseif player.name == "joey" then
                player:setrank(59,8)
            else
                player:setrank(59,10)
            end
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iprintlnbold("Player status ^:Verified")
            end
            if game:getteamscore("axis") == 3 and game:getteamscore("allies") == 3 then
                player:iprintlnbold("Host has ^:KEM Strike ^7Available")
            end
        elseif player.team == "axis" then
	if game:isbot(player) == 1 then
            player.playercardpatch = 121
            game:oninterval(function ()
            player:disableusability(true)
            player:setrank(59,0)
            if game:getdvar("unsetup") == "0" then
                if tostring(game:getdvar("savemap")) == damap then
                    if tostring(game:getdvar("botx")) == "no" then
                    else
                        local manx = tonumber(game:getdvar("botx"))
                        local many = tonumber(game:getdvar("boty"))
                        local manz = tonumber(game:getdvar("botz"))
                        local savep = vector:new(manx, many, manz)
                        player:setorigin(savep)
                        player:setstance("stand")
                    end
                end
            end
            end,5)
            player:takeallweapons()
            player:giveweapon("iw6_microtar_mp")
            player:givemaxammo("iw6_microtar_mp")
            player:setspawnweapon("iw6_microtar_mp")
            player:iprintlnbold("Player status ^1Unknown")
	end
        end
        if game:getdvar("unsetup") == "0" then
            player:iprintln("IW6x Setup S&D by ^:@plugwalker47")
            game:setdvar("sv_hostname","Bronx, NY [Setup]")
        else
            player:iprintln("IW6x Unsetup S&D by ^:@plugwalker47")
            game:setdvar("sv_hostname","Bronx, NY [Unsetup]")
            player:scriptcall("maps/mp/killstreaks/_uplink","_ID28830",player,4)
        end
    else
        player:iprintlnbold("Bronx Pack does not support ^:" .. game:getdvar("party_gametype"))
        player:iclientprintln("Use ^:Search & Rescue ^7instead")
    end
end

function savepos(player)
    if game:getdvar("unsetup") == "0" then
        player:iprintlnbold("Bot Mode ^:Unsetup")
        game:executecommand("unsetup 1")
        game:executecommand("sv_hostname Bronx, NY [Unsetup]")
        for i, player in ipairs(players) do
            if player.team == "allies" then
                player:scriptcall("maps/mp/killstreaks/_uplink","_ID28830",player,4)
                if player:ishost() == 0 then
                    player:iprintln("Bot is now ^:Unsetup")
                end
            elseif player.team == "axis" then
                player:setstance("stand")
                player:freezecontrols(false)
                player:unsetperk("specialty_gpsjammer",true)
            end
        end
    else
        game:executecommand("unsetup 0")
        local forward = player:gettagorigin("j_head")
        local endvec = game:anglestoforward(player:getplayerangles())
        local endd = endvec:scale(1000000)
        local cross = game:bullettrace(forward, endd, 0, player)["position"]
        game:executecommand("botx " .. cross.x)
        game:executecommand("boty " .. cross.y)
        game:executecommand("botz " .. cross.z)
        game:executecommand("savemap " .. damap)
        player:iprintlnbold("Bot Mode ^:Setup")
        game:executecommand("sv_hostname Bronx, NY [Setup]")
        for i, player in ipairs(players) do
            if player.team == "allies" then
                player:scriptcall("maps/mp/killstreaks/_uplink","_ID28830",player,0)
                if player:ishost() == 0 then
                    player:iprintln("Bot is now ^:Setup")
                end
            elseif player.team == "axis" then
                player:setstance("stand")
                player:freezecontrols(true)
                player:unsetperk("specialty_gpsjammer",true)
            end
        end
    end
end

function vector:scale(scale)
    self.x = self.x * scale
    self.y = self.y * scale
    self.z = self.z * scale
    return self
end

function refill(player)
    player:givemaxammo(player:getcurrentweapon())
    player:givestartammo(player:getcurrentoffhand())
    player:givemaxammo(player:getoffhandsecondaryclass())
    player:setperk("specialty_bulletaccuracy",true)
    player:setperk("specialty_quickswap",true)
    player:setperk("specialty_fastoffhand",true)
    player:setperk("specialty_marathon",true)
    player:setperk("specialty_bulletpenetration",true)
    if player:getcurrentweapon() == "iw6_p226_mp_flashsuppress02" then
        player:takeweapon("iw6_p226_mp_flashsuppress02")
        player:giveweapon("iw6_gm6_mp_barrelbored_fmj_gm6scope")
        player:switchtoweapon("iw6_gm6_mp_barrelbored_fmj_gm6scope")
    elseif player:getcurrentweapon() == "iw6_m9a1_mp_flashsuppress02" then
        player:takeweapon("iw6_m9a1_mp_flashsuppress02")
        player:giveweapon("iw6_usr_mp_barrelbored_fmj_usrscope")
        player:switchtoweapon("iw6_usr_mp_barrelbored_fmj_usrscope")
    elseif player:getcurrentweapon() == "iw6_pdw_mp_flashsuppress02" then
        player:giveweapon("briefcase_bomb_defuse_mp")
        player:switchtoweapon("briefcase_bomb_defuse_mp")
        player:notifyonplayercommand("bomba","weapnext")
        player:onnotify("bomba",function ()
            if player:getcurrentweapon() == "briefcase_bomb_defuse_mp" then
                player:takeweapon("briefcase_bomb_defuse_mp")
                player:switchtoweapon("iw6_pdw_mp_flashsuppress02")
            end
            end)
    elseif player:getcurrentweapon() == "iw6_mp443_mp_flashsuppress02" then
        player:giveweapon("killstreak_guard_dog_mp")
        player:switchtoweapon("killstreak_guard_dog_mp")
    elseif player:getcurrentweapon() == "iw6_magnum_mp_flashsuppress02" then
        player:giveweapon("killstreak_odin_support_mp")
        player:switchtoweapon("killstreak_odin_support_mp")
    end
end

function init(player)
    game:oninterval(function()
        player.struct.hasdonecombat = 0
    end, 5)
	game:oninterval(function()
        local playerstruct = player:getstruct()
    	level.struct[17628] = 1
    end, 5)
    game:onplayerdamage(function(_self, inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc)
        if game:weaponclass(weapon) == "sniper" then
            damage = 999
            game:executecommand("jump_enablefalldamage 0")
        elseif weapon == "throwingknife_mp"  then
            damage = 999
        elseif mod == "MOD_UNKNOWN" and weapon == "none"  then
            damage = 0
        elseif mod == "MOD_FALLING" and weapon == "none"  then
            damage = 0
        end
        if attacker.team == "axis" then
            damage = 1
        end
        return damage
    end)
    game:onplayerkilled(function(_self, inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc)
        level.struct[17628] = 0
    end)
    table.insert(players, player)
	player:onnotifyonce("disconnect", function ()
        for i, p in ipairs(players) do
            if p == player then
                table.remove(players, i)
                break
            end
        end
    end)
end

level:onnotify("connected", init)
level:onnotify("player_spawned", setup)
