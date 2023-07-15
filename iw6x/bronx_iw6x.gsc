#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level thread onplayerconnect();
	setdvar("sv_hostname","Bronx, NY");
	setdvar("g_playercollision",0);
	setdvar("g_playerejection",0);
	setdvar("jump_slowdownEnable",0);
	setdvar("pm_bouncing",1);
	setdvar("bg_surfacePenetration",999999);
	level.callDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::callbackPlayerDamage_stub;
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
			player thread changeclassmf();
			player thread movebotbind();
			player thread streakbind();
			player thread prestigebind();
			player thread canswapbind();
			player thread refillbind();
			player thread onplayerspawned();
			player thread roundstart();
		}
		else
		{
			player thread botfreezer();
		}
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self setclientomnvar( "ui_round_end_match_bonus", randomintrange(200,1600) );
		self giveperk("specialty_bulletaccuracy",false);
		self giveperk("specialty_quickswap",false);
		self giveperk("specialty_fastoffhand",false);
		self giveperk("specialty_marathon",false);
		self giveperk("specialty_bulletpenetration",false);
		self.radarMode = "normal_radar";
		self.hasradar = level.unsetup;
		self givecamo();
		wait 0.1;
    }
}

//this is so shit but idc
roundstart()
{
	self waittill("spawned_player");
	self iprintln("IW6x Setup S&R by ^:@plugwalker47");
	self setrank(59,self.pers["prest"]);
	if(getteamscore("allies") == 0 && getteamscore("axis") == 0)
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
	if(getteamscore("allies" ) == 3 && getteamscore("axis") == 3)
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
	//init game vars
	if(self ishost())
	{
		level.unsetup = self.pers["unsetup"];
		level.botspawn = self.pers["botspawn"];
	}
}

givecamo()
{
    primary = maps\mp\gametypes\_class::cac_getWeapon(getClassIndex(self.class), 0);
    camo = maps\mp\gametypes\_class::cac_getWeaponCamo(getClassIndex(self.class), 0);
    secondary = maps\mp\gametypes\_class::cac_getWeapon(getClassIndex(self.class), 1);
    if(camo == "none" || !isprimary(secondary) || hascamo(self getfullname(secondary)))
    {
        return;
    }
    secondary_new = self getfullname(secondary)+"_"+camo;
    self takeWeapon(self getfullname(secondary));
    self giveWeapon(secondary_new);
}

getfullname(weapon)
{
    foreach(index in self getWeaponsListPrimaries())
    {
        if(IsSubStr(index,weapon))
        {
            return index;
        }
    }
}

hascamo(weapon)
{
    if(isprimary(weapon) && IsSubStr(weapon,"_camo"))
    {
        return true;
    }
    return false;
}

isprimary(weapon)
{
    if(getweaponclass(weapon) == "weapon_pistol")
    {
        return false;
    }
    if(getweaponclass(weapon) == "weapon_projectile")
    {
        return false;
    }
    return true;
}

botfreezer()
{
	self endon("disconnect");
	for(;;)
	{
		if(!level.unsetup)
		{
			self setOrigin(level.botspawn);
			self freezeControls(true);
		}
		self unsetperk("specialty_gpsjammer",true);
		self disableUsability(true);
		self setrank(59);
		wait 0.1;
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
			oldclass = self.pers["class"];
			self giveperk("specialty_bulletaccuracy",false);
			self giveperk("specialty_quickswap",false);
			self giveperk("specialty_fastoffhand",false);
			self giveperk("specialty_marathon",false);
			self giveperk("specialty_bulletpenetration",false);
			self givecamo();
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
		if( self getstance() == "crouch" && self ishost())
		{
			self unsetuptoggle();
		}
		wait 0.1;
	}
}

unsetuptoggle()
{
	if(self.pers["unsetup"])
	{
		self iprintlnbold("Bot Mode ^:Setup");
		self.pers["botspawn"] = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"];
		self.pers["unsetup"] = false;
	}
	else
	{
		self iprintlnbold("Bot Mode ^:Unsetup");
		self.pers["unsetup"] = true;
	}
	level.botspawn = self.pers["botspawn"];
	level.unsetup = self.pers["unsetup"];
	level updateplayers(self.pers["unsetup"]);
}

updateplayers(unsetup)
{
	foreach(player in level.players)
	{
		if(isbot(player))
		{
			player freezeControls(false);
		}
		else
		{
			player.radarMode = "normal_radar";
			player.hasRadar = unsetup;
		}
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
	if(!isdefined(self.pers["prest"]))
	{
	    self.pers["prest"] = 10;	   
	}
	self setrank(59,self.pers["prest"]);
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("prest", "+actionslot 2");
		self waittill("prest");
		if(self getstance() == "prone")
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

// damage stuff
callbackPlayerDamage_stub(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
{
	if(sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE") 
	{
		if(validweapon(sWeapon))
		{
			[[level.callDamage]]( eInflictor, eAttacker, 999, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
			return;
		}
		if(self.team != eAttacker.team)
		{
			eAttacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback("");
		}
	}
}

validweapon(weapon)
{
	if(getweaponclass(weapon) == "weapon_sniper")
	{
		return true;
	}
	if(getweaponclass(weapon) == "weapon_dmr")
	{
		return true;
	}
	if(weapon == "throwingknife_mp")
	{
		return true;
	}
	return false;
}

setupplayer()
{
	if(isbot(self))
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
