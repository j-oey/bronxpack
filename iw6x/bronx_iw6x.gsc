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
			player setrank(59,10);
		}
		else
		{
			player thread botfreezer();
			player setrank(59,0);
		}
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self iprintln("IW6x Setup S&R by ^:@plugwalker47");
		self thread changeclassmf();
		self thread gamecommands();
		self thread roundstart();
		self setrank(59,10);
		self setclientomnvar( "ui_round_end_match_bonus", randomintrange(200,1600) );
		self giveperk("specialty_bulletaccuracy",false);
		self giveperk("specialty_quickswap",false);
		self giveperk("specialty_fastoffhand",false);
		self giveperk("specialty_marathon",false);
		self giveperk("specialty_bulletpenetration",false);
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

//this is so shit but idc
roundstart()
{
	if ( getteamscore("allies" ) == 0 && getteamscore("axis") == 0)
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
	if (getteamscore("allies" ) == 3 && getteamscore("axis") == 3)
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
			self iprintlnbold("Host has ^:KEM Strike ^7Available");
		}
	}
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
			self iprintln("test"+ self.pers["rank"]);
			oldclass = self.pers["class"];
			self giveperk("specialty_bulletaccuracy",false);
			self giveperk("specialty_quickswap",false);
			self giveperk("specialty_fastoffhand",false);
			self giveperk("specialty_marathon",false);
			self giveperk("specialty_bulletpenetration",false);
		}
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
			self setrank(59,0);
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
				
				self.pers["botspawn"] = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"];
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
			self givemaxammo(self getcurrentoffhand());
			self givemaxammo(self getoffhandsecondaryclass());
		}
		wait 0.1;
	}
}

prestigebind()
{
	if(!isdefined(self.pers["prest"])
	{
	    self.pers["prest"] = 10;	   
	}
	self setrank(59,self.pers["prest"]);
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("prest", "+actionslot 2");
		self waittill("prest");
		if( self getstance() == "prone")
		{
			lvl = self.pers["prest"];
			if(lvl == 11)
			{
				lvl = 0;
			}
			else
			{
				lvl++;
			}
			wait 0.01;
			self iprintlnbold("Prestige ^:"+lvl);
			self setrank(59,lvl);
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
			self giveweapon("iw6_arx160_mp_acog_grip_silencer");
			self dropitem("iw6_arx160_mp_acog_grip_silencer");
		}
		wait 0.1;
	}
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
		}
		else
		{
			iDamage = 1;
			eAttacker iprintln(getweaponclass(sWeapon));
		}
	}
	if( sMeansofDeath == "MOD_FALLING" )
	{
		iDamage = 0;
	}
	[[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
	if(getdvar("g_gametype") == "sr" && validweapon( sWeapon ))
	{
		//online point popup
		waitframe();
		eAttacker setclientomnvar("ui_points_popup",250);  
	}
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
	if( isbot(self) == true)
	{
		self maps\mp\gametypes\_menus::addToTeam("axis");
		self.pers["class"] = undefined;
		self.class = undefined;
		self maps\mp\gametypes\_menus::beginClassChoice();
	}
	else
	{
		self maps\mp\gametypes\_menus::addToTeam("allies");
		self.pers["class"] = undefined;
		self.class = undefined;
		self maps\mp\gametypes\_menus::beginClassChoice();
	}
}
