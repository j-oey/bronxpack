#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level thread onplayerconnect();
	setdvar("sv_hostname","Bronx, NY [Setup]");
	setdvar("g_playercollision",0);
	setdvar("g_playerejection",0);
	setdvar("bg_surfacePenetration",999999);
	setdvar("jump_slowdownEnable",0);
	setdvar("pm_bouncing",1);
	setdvar("sv_cheats",0);
	level.callDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::damagefix;
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
		if(player.pers["team"] != "axis" && player.pers["team"] != "allies")
		{
			player thread setupplayer();
		}
		if(!isbot(player))
		{
			player thread onplayerspawned();
			player setrank(49,30);
		}
		else
		{
			player thread botfreezer();
			player setrank(49,0);
		}
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self iprintln("S1x Setup S&R by ^:@plugwalker47");
		self setclientomnvar( "ui_disable_team_change", 1 );
		self setrank(49,30);
		self thread changeclassmf();
		self thread gamecommands();
		self thread roundstart();
		wait 0.1;
    }
}

gamecommands()
{
	self thread movebotbind();
	self thread streakbind();
	self thread prestigebind();
	self thread changeclassmf();
	self thread canswapbind();
	self thread refillbind();
}

roundstart()
{
	//s1x doesnt read team scores idk why
	if ( getteamscore("allies") == 0 && getteamscore("axis") == 0)
	{
		if(self ishost())
		{
			self iprintlnbold("Player Status ^:Host");
			self freezecontrols(false);
		}
		else
		{
			self iprintlnbold("Player Status ^:Verified");
		}
	}
	else if (getteamscore("allies") == 5 && getteamscore("axis") == 5)
	{
		if(self ishost())
		{
			self maps\mp\killstreaks\_killstreaks::givekillstreak("nuke",false);
			self.pers["kills"] = 25;
			self.kills = 25;
			self.pers["score"] = 2350;
			self.score = 2200;
		}
		else
		{
			self iprintlnbold("Host has ^:DNA Bomb ^7Available");
		}
	}
}

changeclassmf()
{
	self endon("disconnect");
 	for(;;)
 	{
  		level.ingraceperiod = 1;
  		self.hasdonecombat = 0;
  		wait 0.1;
 	}
}

botfreezer()
{
	
	if(isbot(self))
	{
		self endon("disconnect");
		for(;;)
		{
			self freezecontrols(true);
			self setrank(49,0);
			wait 0.1;
		}
	}
}

movebotbind()
{
	self endon("disconnect");
    for(;;)
    {
		if ( self ishost() )
		{
			self thread loadbots();
			self notifyonplayercommand("movebot", "+actionslot 3");
			self waittill("movebot");
			if( self getstance() == "crouch")
			{
				
				self.pers["botspawn"] = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getangles()) * 1000000, 0, self)["position"];
				self iprintlnbold("Bot Spawn ^:Saved");
				wait 0.1;
				self loadbots();
			}
		}
		wait 0.1;
	}
}

streakbind()
{
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("streak", "+actionslot 1");
		self waittill("streak");
		if( self getstance() == "prone")
		{
			foreach(streak in self.killstreaks)
			{
				self maps\mp\killstreaks\_killstreaks::givekillstreak(streak,true);
			}
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
    			self batteryfullrecharge(self getcurrentoffhand());
		}
		wait 0.1;
	}
}

prestigebind()
{
	if(!isdefined(self.pers["prest"]))
	{
	    self.pers["prest"] = 30;	   
	}
	self setrank(49,self.pers["prest"]);
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("prest", "+actionslot 2");
		self waittill("prest");
		if( self getstance() == "prone")
		{
			lvl = self.pers["prest"];
			if(lvl == 31)
			{
				lvl = 0;
			}
			else
			{
				lvl++;
			}
			wait 0.01;
			self iprintlnbold("Prestige ^:"+lvl);
			self setrank(49,lvl);
			self.pers["prest"] = lvl;
		}
		wait 0.1;
	}
}

canswapbind()
{
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("cswap", "+actionslot 1");
		self waittill("cswap");
		if( self getstance() == "crouch")
		{
			self giveweapon("iw5_dlcgun1loot0_mp_heatsink_opticsacog2ar_parabolicmicrophone_camo21");
			self dropitem("iw5_dlcgun1loot0_mp_heatsink_opticsacog2ar_parabolicmicrophone_camo21");
		}
		wait 0.1;
	}
}

spawnbot()
{

}

loadbots()
{
	foreach(p in level.players)
	{
		if ((isalive(p)) && isbot(p) )
		{	
			p setorigin(self.pers["botspawn"]);
		}
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
			level.ingraceperiod = 0;
		}
		else
		{
			iDamage = 1;
		}
	}
	if( sMeansofDeath == "MOD_FALLING" )
	{
		iDamage = 0;
	}
	[[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
}

validweapon( weapon )
{
    if ( !isdefined ( weapon ) )
        return false;

    if ( getweaponclass( weapon ) == "weapon_sniper" || getweaponclass( weapon ) == "weapon_dmr")
        return true;
        
    switch( weapon )
    {
       	case "throwingknife_mp":
            return true;
              
        default:
            return false;        
    }
}

setupplayer()
{
	if( !isbot(self) )
	{
		self maps\mp\gametypes\_menus::addToTeam("allies");
		self.pers["class"] = undefined;
		self.class = undefined;
		self maps\mp\gametypes\_menus::beginClassChoice();
	}
}
