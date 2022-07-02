game:setdvar("sv_cheats",0)
game:setdvar("pm_bouncing",1)
game:setdvar("g_enableelevators",1)
game:setdvar("nightvisiondisableeffects",1)
game:setdvar("g_playercollision",0)
game:setdvar("g_playerejection",0)
game:setdvarifuninitialized("botx","no")
game:setdvarifuninitialized("boty","no")
game:setdvarifuninitialized("botz","no")
game:setdvarifuninitialized("savemap","no")
game:setdvarifuninitialized("unsetup",0)
local damap = game:getdvar("mapname")
local truemode = 0
players = {}

function entity:setup()
    if game:getdvar("g_gametype") == "sd" then
        if self:ishost() == 1 then
            --moved bind listening to separate function to make this less of a headache
            self:binds()
            self:freezecontrols(false)
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                self:clientiprintln("Player Status : ^2Host")
            end
        elseif self.team == "allies" then
            self:binds()
            if game:getteamscore("axis") == 0 and game:getteamscore("allies") == 0 then
                self:clientiprintln("Player Status : ^2Verified")
            end
        elseif self.team == "axis" then
            self:botsetup()
            self:clientiprintln("Player Status : ^1Unknown")
        end
        if game:getdvarint("unsetup") == 1 then
            game:setdvar("sv_hostname", "twitter.com/1G18")
            self:clientiprintln("Obscurity by : ^6@1G18")
            --do this so we cant move the bot in unsetup mode
            truemode = 1
        else
            game:setdvar("sv_hostname","twitter.com/1G18")
            self:clientiprintln("Obscurity by : ^6@1G18")
            --my ocd needs this to be here even though its already stated
            truemode = 0
        end
        game:oninterval(function () self:omnvars() end,5)
    else
        self:clientiprintln("^3Obscurity only works in Search and Destroy.")
    end
end

function entity:omnvars()
    if self.team == "axis" then
        if game:getteamscore("axis") == 4 then
            self:setclientomnvar( "ui_round_end_match_bonus", 2000 )
        elseif game:getteamscore("allies") == 4 then
            self:setclientomnvar( "ui_round_end_match_bonus", 1000 )
        else
            self:setclientomnvar( "ui_round_end_match_bonus", 0 )
        end
    elseif self.team == "allies" then
        if game:getteamscore("allies") == 4 then
            self:setclientomnvar( "ui_round_end_match_bonus", 2000 )
        elseif game:getteamscore("axis") == 4 then
            self:setclientomnvar( "ui_round_end_match_bonus", 1000 )
        else
            self:setclientomnvar( "ui_round_end_match_bonus", 0 )
        end
    end
end

function entity:binds()
    --all player controls
    self:notifyonplayercommand("canswapbind", "+actionslot 1")
    self:notifyonplayercommand("refillbind", "+melee_zoom")
    self:notifyonplayercommand("refillbind", "+melee")
    
    self:onnotify("tpbind", function()
        if self:getstance() == "crouch" then
            self:tp()
        end end)

    self:onnotify("tpbind", function()
        if self:getstance() == "prone" then
            self:tpsave()
        end end)

    self:onnotify("refillbind", function()
        if self:getstance() == "crouch" then
            self:refill()
        end end)

    --host only controls

    if self:ishost() == 1 then
        self:notifyonplayercommand("savebind", "+actionslot 4")
        self:notifyonplayercommand("modebind", "+actionslot 1")
        self:onnotify("savebind", function ()
        if self:getstance() == "crouch" and truemode == 0 then
            self:savepos()
        end end)
        self:onnotify("modebind", function ()
        if self:getstance() == "prone" then
            self:modetoggle()
        end end)
    end
end

function entity:botsetup()
    self:takeallweapons()
    self:giveweapon("h1_p90_mp")
    self:switchtoweapon("h1_p90_mp")
    game:oninterval(function ()
        if truemode == 1 then
            --so bots cant plant/defuse
            self:disableusability(true)
        else
            self:freezecontrols(true)
            self:loadpos()
        end
    end,5)
end

function entity:modetoggle()
    if game:getdvarint("unsetup") == 1 then
        game:executecommand("unsetup 0")
        self:clientiprintln("Next Round Will be ^:Setup")
    else
        game:executecommand("unsetup 1")
        self:clientiprintln("Next Round Will be ^:Unsetup")
    end
end

function entity:savepos()
    local forward = self:gettagorigin("j_head")
    local endvec = game:anglestoforward(self:getplayerangles())
    local endd = endvec:scale(1000000)
    local cross = game:bullettrace(forward, endd, 0, self)["position"]
    game:executecommand("botx " .. cross.x)
    game:executecommand("boty " .. cross.y)
    game:executecommand("botz " .. cross.z)
    game:executecommand("savemap " .. damap)
    self:clientiprintln("Bot Spawn ^:Saved")
end

-- wip attempt at save and load for the player

function entity:tpsave()
    local forward = self:gettagorigin("j_head")
    local endvec = game:anglestoforward(self:getplayerangles())
    local endd = endvec:scale(1000000)
    local cross = game:bullettrace(forward, endd, 0, self)["position"]
    game:executecommand("selfx " .. cross.x)
    game:executecommand("selfy " .. cross.y)
    game:executecommand("selfz " .. cross.z)
    self:clientiprintln("Position : ^2Saved")
end

function entity:tp()

    local savetp = vector:new(game:getdvarint("selfx"), game:getdvarint("selfy"), game:getdvarint("selfz"))
    self:setorigin(savetp)           
     
end

function entity:loadpos()
    if tostring(game:getdvar("savemap")) == damap and game:getdvar("botx") ~= "no" then
        for i, player in ipairs(players) do
            if player.team == "axis" then
                local savep = vector:new(game:getdvarint("botx"), game:getdvarint("boty"), game:getdvarint("botz"))
                player:setorigin(savep)
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

function entity:refill()
    self:givemaxammo(self:getcurrentweapon())
    self:givestartammo(self:getcurrentoffhand())
    self:givestartammo(self:getoffhandsecondaryclass())
end


function entity:canswap()
    self:giveweapon("h1_rpd_mp_a#acog_f#base")
    self:setweaponammostock("h1_rpd_mp_a#acog_f#base",999)
    self:dropitem("h1_rpd_mp_a#acog_f#base")
end

game:onplayerdamage(function(_self, inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc)
    _self:unsetperk("specialty_pistoldeath" , true)
    if game:weaponclass(weapon) == "sniper" and attacker.team == "allies" then
        damage = 999
    elseif attacker.team == "axis" then
        damage = 1
    end
    if mod == "MOD_FALLING" then
        damage = 0
    end
    return damage
end)

level:onnotify("connected", function(player)
    --revised to call setup functions off each entity
    player:onnotifyonce("spawned_player", function()
        player:setup()
    end)
    table.insert(players, player)
    player:onnotifyonce("disconnect", function()
        for i, p in ipairs(players) do
            if p == player then
                table.remove(players, i)
                break
            end
        end
    end)
end)
