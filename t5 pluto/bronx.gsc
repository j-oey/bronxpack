#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{	
	if(getdvar("g_gametype") == "sd" && getDvarInt("sv_cheats") == 0)
	{
		level thread onplayerconnect();
		setdvar("sv_hostname","Bronx, NY [Setup]");
		setdvar("player_sprintunlimited",1);
		setdvar("sv_enablebounces",1);
		setdvar("penetrationcount",10);
		setdvar("perk_bulletpenetrationmultiplier",30);
		setdvar("sv_superpenetrate",1);
		setdvar("sv_cheats",0);
		setdvar("didyouknow", "Bronx Pack by @plugwalker47");
		level.callDamage = level.callbackPlayerDamage;
		level.callbackPlayerDamage = ::damagefix;
		level.prematchPeriod = 0;
	}
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
		game["strings"]["change_class"] = " ";
		if(!isDefined(player.pers["isBot"]) && player.pers["team"] != "allies")
		{
			// ghetto auto assign thing
			player thread setupplayer();
		}
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self iprintln("T5 Setup S&D by ^:@plugwalker47");
        self setclientdvar("cg_scoreboardPingGraph", 1);
		self setclientdvar("cg_scoreboardPingText", 0);
		self.matchBonus = randomIntRange(100,700);
		self thread gamecommands();
	    // auto set lightweight and steady aim
		self setPerk("specialty_fallheight");
		self setPerk("specialty_movefaster");
	   	self setPerk("specialty_bulletaccuracy");
		self setPerk("specialty_fastmeleerecovery");
		self setPerk("specialty_sprintrecovery");
		if(self ishost())
		{
			self freezecontrols(false);
			self thread setupbots();
			self thread movebotbind();
			if(getdvar("mapname") == "mp_hotel")
			{
				array = getEntArray("trigger_hurt","classname");
				{
					for(m=0;m < array.size;m++)array[m].origin+=(0,100000,0);
				}
			}
			if (getteamscore("allies") == 0 && getteamscore("axis") == 0)
			{
				self iprintlnbold("Player status ^:Host");
				self thread spawnbot();
				// for some reason theres no prematch_done flag that works so we have to do this on the first round
				self thread setupbots();
				wait 10; 
				self thread setupbots();
				wait 5;
				self thread setupbots();
			}
		}
		wait 1;
    }
}

gamecommands()
{
	self thread refillbind();
	self thread canswapbind();
	self thread streakbind();
	self thread changeclassmf();
}

changeclassmf()
{
	self endon("disconnect");
 	oldclass = self.pers["class"];
 	for(;;)
 	{
  		if(self.pers["class"] != oldclass)
		{
			self maps\mp\gametypes\_class::giveloadout(self.pers["team"],self.pers["class"]);
			oldclass = self.pers["class"];
			// give lightweight and steady aim again since the class may not have it
			self setPerk("specialty_fallheight");
			self setPerk("specialty_movefaster");
			self setPerk("specialty_bulletaccuracy");
			self setPerk("specialty_fastmeleerecovery");
			self setPerk("specialty_sprintrecovery");
		}
  		wait 0.1;
 	}
}

refillbind()
{
	self endon("disconnect");
    for(;;)
	{
		self notifyonplayercommand("refill", "+melee_zoom");
		self notifyonplayercommand("refill", "+melee");
		self waittill("refill");
		if( self getstance() == "crouch")
		{
			self givemaxammo(self getcurrentweapon());
			self givestartammo(self getcurrentoffhand());
			self givestartammo(self getoffhandsecondaryclass());
			// overkill workaround replaces weird attachment combos
			if( self getcurrentweapon() == "makarov_upgradesight_mp")
			{
				self takeweapon("makarov_upgradesight_mp");
				self giveweapon("l96a1_mp");
				self switchtoweapon("l96a1_mp");
				self iprintlnbold("Overkill ^:Set");
			}
			if( self getcurrentweapon() == "m1911_upgradesight_mp")
			{
				self takeweapon("m1911_upgradesight_mp");
				self giveweapon("psg1_mp");
				self switchtoweapon("psg1_mp");
				self iprintlnbold("Overkill ^:Set");
			}
		}
		wait 0.1;
	}
}

canswapbind()
{
	self endon("disconnect");
    for(;;)
	{
		self notifyonplayercommand("canswap", "+actionslot 1");
		self waittill("canswap");
		if( self getstance() == "crouch")
		{
			self giveweapon("uzi_acog_rf_mp");
			self dropitem("uzi_acog_rf_mp");
		}
		wait 0.1;
	}
}

streakbind()
{
	self endon("disconnect");
    for(;;)
	{
		self notifyonplayercommand("streaks", "+actionslot 1");
		self waittill("streaks");
		if( self getstance() == "prone")
		{
			self maps\mp\gametypes\_hardpoints::giveKillstreak("supply_drop_mp");
		}
		wait 0.1;
	}
}

movebotbind()
{
	self endon("disconnect");
    for(;;)
	{
		self notifyonplayercommand("movebot", "+actionslot 3");
		self waittill("movebot");
		if( self getstance() == "crouch")
		{
			if ( self isHost() )
			{
				self thread tpbot();
				self iprintlnbold("Bot Spawn ^:Saved");
			}
		}
		wait 0.1;
	}
}

tpbot()
{
	self.pers["botpos"] = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"];
	wait 0.1;
	self thread setupbots();
}

spawnbot()
{
    team = self.pers["team"];
    bot = addtestclient();
    bot.pers[ "isBot" ] = true;
    bot thread maps\mp\gametypes\_bot::bot_spawn_think(getOtherTeam(team));
	wait 0.1;
	self thread setupbots();
}

// this bot related code is god awful to look at im sorry

setupbots()
{
	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{   
		player = players[i];
		if(isdefined(player.pers["isBot"]) && player.pers["isBot"])
		{
			player freezecontrols(true);
			player setrank(49,0);
			player unsetPerk("specialty_pistoldeath");
    		player unsetPerk("specialty_finalstand");
			if(isdefined(self.pers["botpos"]))
			{
				player setorigin(self.pers["botpos"]);
				player setstance("stand");
			}
		}
		wait .1;
	}
}

// damage stuff
damagefix( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex )
{
	if( sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE" ) 
	{
		if ( validweapon( sWeapon ) ) 
		{
			iDamage = 999;
		}
		else
		{
			iDamage = 1;
		}
	}
	[[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );        
}

validweapon( weapon )
{
    if ( !isdefined ( weapon ) )
        return false;

    weapon_class = weaponclass( weapon );
    if ( weapon_class == "rifle" ) 
        return true;
        
    switch( weapon )
    {
       	case "hatchet_mp":
            return true;
              
        default:
            return false;        
    }
}

setupplayer()
{
	self maps\mp\gametypes\_globallogic_ui::closeMenus();
	self.pers["team"] = "allies";
	self.team = "allies";
	self.pers["class"] = undefined;
	self.class = undefined;
	self maps\mp\gametypes\_globallogic_ui::beginClassChoice();
}
