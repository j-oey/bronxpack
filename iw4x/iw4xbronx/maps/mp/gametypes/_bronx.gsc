#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_bots;
#include common_scripts\utility;

bronx()
{
	if(getdvar("g_gametype") == "sd")
	{
		level thread onplayerconnect();
		level thread gamedvars();
		level.callDamage = level.callbackPlayerDamage;
		level.callbackPlayerDamage = ::damagefix;
	}
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
		game["strings"]["change_class"] = " ";
		if(!isDefined(player.pers["isBot"]) && player.pers["team"] != "axis")
		{
			player thread setupplayer();
		}
		level.numKills = 1;
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self iprintln("IW4x Setup S&D by ^:@plugwalker47");
		self thread changeclassmf();
        self thread gamecommands();
        self thread selfdvars();
		self maps\mp\perks\_perks::givePerk("specialty_bulletdamage"); //lmao
		self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
		self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
		self maps\mp\perks\_perks::givePerk("specialty_falldamage");
		if(self ishost())
		{
            self thread loadbots();
			self freezecontrols(false);
			if ( getteamscore("allies") == 0 && getteamscore("axis") == 0)
			{
				self thread spawnbot();
				self iprintlnbold("Player status ^:Host");
			}
		}
		wait 1;
    }
}

selfdvars()
{
	self setClientDvar("cg_overheadIconSize", 1);
	self setClientDvar("cg_overheadNamesSize", 0.75);
	self setClientDvar("cg_overheadRankSize", 0.5);
	self setClientDvar("cg_scoreboardPingGraph", 1);
	self setClientDvar("cg_scoreboardPingText", 0);
	self setClientDvar("safeArea_horizontal", 0.85);
	self setClientDvar("safeArea_adjusted_horizontal",0.85);
	self setClientDvar("safeArea_vertical", 0.85);
	self setClientDvar("safeArea_adjusted_vertical",0.85);
	self setClientDvar("nightVisionDisableEffects",1);
}

gamedvars()
{
	setDvarIfUninitialized("killedby_name", "");
	setDvarIfUninitialized("killedby_tag", "");
	setDvarIfUninitialized("youkilled_name", "");
	setDvarIfUninitialized("youkilled_tag", "");
	setDvarIfUninitialized("g_softland", 0);
	setdvar("sv_hostname","Bronx, NY [Setup]");
	setDvar("didyouknow", "Bronx Pack by ^:@plugwalker47");
	setDvar("bg_playerCollision", 0);
	setDvar("bg_playerEjection", 0);
	setDvar("g_speed", 190);
	setDvar("jump_height", 39);
	setDvar("g_gravity", 800);
	setDvar("jump_ladderPushVel", 108);
	setDvar("ui_maxclients", 18);
	setDvar("player_sprintunlimited", 1);
	setDvar("testClients_doAttack", 0);
	setDvar("testClients_doCrouch", 0);
	setDvar("testClients_doMove", 0);
}

gamecommands()
{
	self thread movebotbind();
	self thread carepackbind();
	self thread predbind();
	self thread changeclassmf();
	self thread canswapbind();
	self thread refillbind();
	self thread skipmap();
}

skipmap()
{
	for(;;)
	{
		self notifyOnPlayerCommand("mapcfg", "+skip");
		self waittill("mapcfg");
		if (self ishost())
		{
			hostname = "";
			foreach(p in level.players)
			{
				if ( p ishost() )
				{
					hostname = p.name;
					p iprintlnbold("Skipping Map...");
					
				}
				else
				{
					p iprintlnbold("^:"+hostname+" ^7is skipping this map...");
				}
				wait 2.5;
				nextmapselect();
				
			}
		}
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
			self maps\mp\perks\_perks::givePerk("specialty_bulletdamage"); //lmao
			self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
			self maps\mp\perks\_perks::givePerk("specialty_falldamage");
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
			if ( self ishost() )
			{
				self thread tpbot();
				self iprintlnbold("Bot Spawn ^:Saved");
			}
		}
		wait 0.1;
	}
}

carepackbind()
{
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("cpack", "+actionslot 1");
		self waittill("cpack");
		if( self getstance() == "prone")
		{
			self maps\mp\killstreaks\_killstreaks::givekillstreak("airdrop",false);
		}
		wait 0.1;
	}
}

predbind()
{
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("pred", "+actionslot 2");
		self waittill("pred");
		if( self getstance() == "prone")
		{
			self maps\mp\killstreaks\_killstreaks::givekillstreak("predator_missile",false);
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

canswapbind()
{
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("cswap", "+actionslot 1");
		self waittill("cswap");
		if( self getstance() == "crouch")
		{
			self giveweapon("aug_heartbeat_reflex_mp");
			self dropitem("aug_heartbeat_reflex_mp");
		}
		wait 0.1;
	}
}

dosoftland()
{
	setDvar( "bg_falldamagemaxheight", "300" );
    setDvar( "bg_falldamageminheight", "128" );
	self waittill("begin_killcam");
	wait 3;
    if ( getdvar("g_softland") == "1" )
    {
        setDvar( "bg_falldamagemaxheight", "1" );
        setDvar( "bg_falldamageminheight", "1" );
    }
    else
    {
        setDvar( "bg_falldamagemaxheight", "300" );
        setDvar( "bg_falldamageminheight", "128" );
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

    weapon_class = getweaponclass( weapon );
    if ( weapon_class == "weapon_sniper" ) 
        return true;
        
    switch( weapon )
    {
       	case "throwingknife_mp":
            return true;
              
        default:
            return false;        
    }
}

nextmapselect()
{
	Map = "";
	switch(randomint(16))
	{
		case 0 : 
		Map = "mp_afghan";
		break;
		
		case 1 : 
		Map = "mp_derail";
		break;
		
		case 2 : 
		Map = "mp_estate";
		break;
		
		case 3 : 
		Map = "mp_favela";
		break;
		
		case 4 : 
		Map = "mp_highrise";
		break;
		
		case 5 : 
		Map = "mp_invasion";
		break;
		
		case 6 : 
		Map = "mp_checkpoint";
		break;
		
		case 7 : 
		Map = "mp_quarry";
		break;
		
		case 9 : 
		Map = "mp_boneyard";
		break;
		
		case 10 : 
		Map = "mp_subbase";
		break;
		
		case 11 : 
		Map = "mp_terminal";
		break;
		
		case 12 : 
		Map = "mp_underpass";
		break;
		
		case 13 : 
		Map = "mp_complex";
		break;
		
		case 14 : 
		Map = "mp_crash";
		break;
		
		case 15 : 
		Map = "mp_overgrown";
		break;
		
		case 16 : 
		Map = "mp_fuel2";
		break;
	}
	wait 0.5;
	map(Map);
}

setupplayer()
{
	self closeMenus();
	self maps\mp\gametypes\_menus::addToTeam("axis");
	self.pers["class"] = undefined;
	self.class = undefined;
	self maps\mp\gametypes\_menus::beginClassChoice();
}