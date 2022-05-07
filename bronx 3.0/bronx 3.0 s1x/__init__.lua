include("config")
game:setdvar("sv_cheats",0)
game:setdvar("pm_bouncing",1)
game:setdvar("scr_sd_winlimit",6)
game:setdvar("scr_player_healthregentime",5)
game:setdvar("g_playercollision",0)
game:setdvar("g_playerejection",0)
game:setdvar("perk_bulletpenetrationmultiplier",40)
game:setdvarifuninitialized("botx","no")
game:setdvarifuninitialized("boty","no")
game:setdvarifuninitialized("botz","no")
game:setdvarifuninitialized("savemap","no")
game:setdvarifuninitialized("unsetup","0")
damap = tostring(game:getdvar("mapname"))
levelstruct = level:getstruct()
players = {}

function setup(player)
    if game:getdvar("g_gametype") == "sr" or game:getdvar("g_gametype") == "sd" then
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
            player:onnotify("streakbind",
            function ()
                if player:getstance() == "prone" and player:adsbuttonpressed() == 1 then
                    if game:getteamscore("axis") == 5 and game:getteamscore("allies") == 5 then
                        levelstruct[21400].nuke(player)
                    else
                        player:iclientprintlnbold("You can only use a ^:DNA Bomb ^7on the last round")
                    end
                elseif player:getstance() == "crouch" then
                    player:giveweapon("iw5_dlcgun1loot0_mp_heatsink_opticsacog2ar_parabolicmicrophone_camo21")
                    player:dropitem("iw5_dlcgun1loot0_mp_heatsink_opticsacog2ar_parabolicmicrophone_camo21")
                else
                    player:giveweapon("turretheadenergy_mp")
                    player:switchtoweapon("turretheadenergy_mp")
                end
            end)
            player:freezecontrols(false)
            player:setrank(49,hostprestige)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Host")
            end
            if game:getteamscore("axis") == 5 and game:getteamscore("allies") == 5 then
                player:iclientprintlnbold("Prone + [{+speed_throw}] + [{+actionslot 1}] for ^:DNA Bomb")
            end
            if player:getoffhandprimaryclass() == "explosive_drone_mp" then
                player:setoffhandprimaryclass("throwingknife_rhand_mp")
                player:giveweapon("throwingknife_rhand_mp")
                player:givemaxammo("throwingknife_rhand_mp")
            elseif  player:getoffhandsecondaryclass() == "explosive_drone_mp" then
                player:setoffhandsecondaryclass("throwingknife_rhand_mp")
                player:giveweapon("throwingknife_rhand_mp")
                player:givemaxammo("throwingknife_rhand_mp")
            elseif  player:getoffhandsecondaryclass() == "adrenaline_mp" then
                player:setoffhandsecondaryclass("iw5_dlcgun12loot7_mp")
                player:giveweapon("iw5_dlcgun12loot7_mp")
                player:givemaxammo("iw5_dlcgun12loot7_mp")
            end
        elseif player.team == "allies" then
            player:notifyonplayercommand("refillbind", "+melee_zoom")
            player:notifyonplayercommand("streakbind", "+actionslot 1")
            player:onnotify("refillbind", function() if player:getstance() == "crouch" then refill(player) else end end)
            player:onnotify("streakbind",
            function ()
                if player:getstance() == "crouch" then
                    player:giveweapon("iw5_dlcgun1loot0_mp_heatsink_opticsacog2ar_parabolicmicrophone_camo21")
                    player:dropitem("iw5_dlcgun1loot0_mp_heatsink_opticsacog2ar_parabolicmicrophone_camo21")
                else
                    player:giveweapon("turretheadenergy_mp")
                    player:switchtoweapon("turretheadenergy_mp")
                end
            end)
            if player.name == guest1 then
                player:setrank(49,g1prestige)
            elseif player.name == guest2 then
                player:setrank(49,g2prestige)
            elseif player.name == guest3 then
                player:setrank(49,g3prestige)
            elseif player.name == guest4 then
                player:setrank(49,g4prestige)
            elseif player.name == guest5 then
                player:setrank(49,g5prestige)
            elseif player.name == guest6 then
                player:setrank(49,g6prestige)
            elseif player.name == guest7 then
                player:setrank(49,g7prestige)
            elseif player.name == guest8 then
                player:setrank(49,g8prestige)
            elseif player.name == guest9 then
                player:setrank(49,g9prestige)
            elseif player.name == guest10 then
                player:setrank(49,g10prestige)
            elseif player.name == "joey" then
                player:setrank(49,20)
            else
                player:setrank(49,30)
            end
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                player:iclientprintlnbold("Player status ^:Verified")
            end
            if player:getoffhandprimaryclass() == "explosive_drone_mp" then
                player:setoffhandprimaryclass("throwingknife_rhand_mp")
                player:giveweapon("throwingknife_rhand_mp")
                player:givemaxammo("throwingknife_rhand_mp")
            elseif  player:getoffhandsecondaryclass() == "explosive_drone_mp" then
                player:setoffhandsecondaryclass("throwingknife_rhand_mp")
                player:giveweapon("throwingknife_rhand_mp")
                player:givemaxammo("throwingknife_rhand_mp")
            elseif  player:getoffhandsecondaryclass() == "adrenaline_mp" then
                player:setoffhandsecondaryclass("iw5_dlcgun12loot7_mp")
                player:giveweapon("iw5_dlcgun12loot7_mp")
                player:givemaxammo("iw5_dlcgun12loot7_mp")
            end
        elseif player.team == "axis" then
            game:oninterval(function ()
            player:disableusability(true)
            player:setrank(49,0)
            if game:getdvar("unsetup") == "0" then
                if tostring(game:getdvar("savemap")) == damap then
                    if tostring(game:getdvar("botx")) == "no" then
                    else
                        local manx = tonumber(game:getdvar("botx"))
                        local many = tonumber(game:getdvar("boty"))
                        local manz = tonumber(game:getdvar("botz"))
                        local savep = vector:new(manx, many, manz)
                        player:setorigin(savep)
                    end
                end
            end
            end,5)
            player:takeallweapons()
            player:giveweapon("iw5_kf5_mp")
            player:givemaxammo("iw5_kf5_mp")
            player:setspawnweapon("iw5_kf5_mp")
            player:iclientprintlnbold("Player status ^1Unknown")
        end
        if game:getdvar("unsetup") == "0" then
            player:iclientprintln("S1x Setup S&D by ^:@plugwalker47")
            game:setdvar("sv_hostname","Bronx, NY [Setup]")
        else
            player:iclientprintln("S1x Unsetup S&D by ^:@plugwalker47")
            game:setdvar("sv_hostname","Bronx, NY [Unsetup]")
        end
        game:oninterval(function () mbonus(player) end,5)
    else
        player:iclientprintlnbold("Bronx Pack Does not support ^:" .. game:getdvar("party_gametype") )
        player:iclientprintln("Use ^:S&D or ^:S&R ^7Instead")
    end
end

function savepos(player)
    if game:getdvar("unsetup") == "0" then
        player:iclientprintlnbold("Bot Mode ^:Unsetup")
        game:executecommand("unsetup 1")
        game:executecommand("sv_hostname Bronx, NY [Unsetup]")
        for i, player in ipairs(players) do
            if player.team == "allies" then
                if player:ishost() == 0 then
                    player:iclientprintln("Bot is now ^:Unsetup")
                end
            elseif player.team == "axis" then
                player:freezecontrols(false)
            end
        end
    else
        game:executecommand("unsetup 0")
        local forward = player:gettagorigin("j_head")
        local endvec = game:anglestoforward(player:getangles())
        local endd = endvec:scale(1000000)
        local cross = game:bullettrace(forward, endd, 0, player)["position"]
        game:executecommand("botx " .. cross.x)
        game:executecommand("boty " .. cross.y)
        game:executecommand("botz " .. cross.z)
        game:executecommand("savemap " .. damap)
        player:iclientprintlnbold("Bot Mode ^:Setup")
        game:executecommand("sv_hostname Bronx, NY [Setup]")
        for i, player in ipairs(players) do
            if player.team == "allies" then
                if player:ishost() == 0 then
                    player:iclientprintln("Bot is now ^:Setup")
                end
            elseif player.team == "axis" then
                player:setstance("stand")
                player:freezecontrols(true)
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
    print(player:getoffhandsecondaryclass())
    if player:getoffhandprimaryclass() == "explosive_drone_mp" then
        player:setoffhandprimaryclass("throwingknife_rhand_mp")
        player:giveweapon("throwingknife_rhand_mp")
        player:givemaxammo("throwingknife_rhand_mp")
    elseif  player:getoffhandsecondaryclass() == "explosive_drone_mp" then
        player:setoffhandsecondaryclass("throwingknife_rhand_mp")
        player:giveweapon("throwingknife_rhand_mp")
        player:givemaxammo("throwingknife_rhand_mp")
    elseif  player:getoffhandsecondaryclass() == "adrenaline_mp" then
        player:setoffhandsecondaryclass("iw5_dlcgun12loot7_mp")
        player:giveweapon("iw5_dlcgun12loot7_mp")
        player:givemaxammo("iw5_dlcgun12loot7_mp")
    end
    if player:getcurrentweapon() == "iw5_mp11loot8_mp_opticsreddot" then --mp11 squeaker
        player:takeweapon("iw5_mp11loot8_mp_opticsreddot")
        player:giveweapon("iw5_mechpunch_mp")
        player:switchtoweapon("iw5_mechpunch_mp")
    elseif player:getcurrentweapon() == "iw5_hmr9loot8_mp" then --amr9 dynamo
        player:giveweapon("iw5_carrydrone_mp")
        player:switchtoweapon("iw5_carrydrone_mp")
    elseif player:getcurrentweapon() == "iw5_pbwloot7_mp_opticsreddot" then --mp443 h1
        player:giveweapon("airdrop_trap_marker_mp")
        player:switchtoweapon("airdrop_trap_marker_mp")
    elseif player:getcurrentweapon() == "iw5_maawsloot0_mp" then --maaws tornado
        player:takeweapon("iw5_maawsloot0_mp")
        player:giveweapon("iw5_underwater_mp")
        player:switchtoweapon("iw5_underwater_mp")
    end
end

function init(player)
    game:onplayerdamage(function(_self, inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc)
        if game:weaponclass(weapon) == "sniper" and weapon ~= "none" then
            damage = 999
        elseif game:weaponclass(weapon) ~= "sniper" and weapon ~= "none" then
            damage = 1
        end
        if weapon == "iw5_morsloot7_mp_morsscopevz_parabolicmicrophone_camo27" then --ransacker w psych camo
            attacker:takeweapon("iw5_morsloot7_mp_morsscopevz_parabolicmicrophone_camo27")
            attacker:giveweapon("orbitalsupport_missile_mp")
            attacker:switchtoweapon("orbitalsupport_missile_mp")
        end
        return damage
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