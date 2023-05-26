#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\bots;

init()
{
	if(getdvar("g_gametype") != "sd")
	{
		return;
	}
	level thread onplayerconnect();
	level thread gamedvars();
}

gamedvars()
{
	setDvarIfUninitialized("g_softland", 0);
	setdvar("sv_hostname","Bronx, NY [Setup]");
	setDvar("didyouknow", "Bronx Pack by ^:@plugwalker47");
	setDvar("bg_playerCollision", 0);
	setDvar("bg_playerEjection", 0);
	setDvar("testClients_doAttack", 0);
	setDvar("testClients_doCrouch", 0);
	setDvar("testClients_doMove", 0);
	setDvar("nightVisionDisableEffects", 1);
	exec("g_TeamColor_MyTeam 0.501961 0.8 1 1");
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
		player thread gamecommands();
		game["strings"]["change_class"] = " ";
		if(!isDefined(player.pers["isBot"]) && player.pers["team"] != "axis")
		{
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
		self iprintln("IW4x Setup S&D by ^5@plugwalker47");
		self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
		self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
		self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
		self setActionSlot(1," ");
		if(self ishost())
		{
            self thread loadbots();
			self freezecontrols(false);
			if(getTeamScore("axis") == 0 && getTeamScore("allies") == 0)
			{
				self thread spawnbot();
				self iprintlnbold("Player status ^5Host");
			}
		}
		wait 1;
    }
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
	self thread selfdvars();
	self thread changeclassmf();
}

selfdvars()
{
	self setClientDvar("cg_overheadIconSize", 1);
	self setClientDvar("cg_overheadNamesSize", 0.75);
	self setClientDvar("cg_overheadRankSize", 0.5);
	self setClientDvar("cg_scoreboardPingGraph", 1);
	self setClientDvar("cg_scoreboardPingText", 0);
	self setClientDvar( "g_TeamColor_MyTeam", "0.501961 0.8 1 1");
}

skipmap()
{
	for(;;)
	{
		self notifyOnPlayerCommand("mapcfg", "+skip");
		self waittill("mapcfg");
		if (self ishost())
		{
			hostname = undefined;
			foreach(player in level.players)
			{
				if (player ishost())
				{
					hostname = player.name;
					player iprintlnbold("Skipping Map...");
					
				}
				else
				{
					player iprintlnbold("^5"+hostname+" ^7is skipping this map...");
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
			self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
			self setActionSlot(1," ");
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
				self iprintlnbold("Bot Spawn ^5Saved");
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