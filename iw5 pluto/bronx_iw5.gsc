#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	if(getdvar("g_gametype") == "sd")
	{
		level thread onplayerconnect();
		setdvar("sv_hostname","Bronx, NY [Setup]");
		setdvar("sv_enabledoubletaps",1);
		setdvar("player_sprintunlimited",1);
		setdvar("g_playercollision",2);
		setdvar("g_playerejection",2);
		setdvar("perk_bulletpenetrationmultiplier",30);
		setdvar("penetrationcount",10);
		setdvar("jump_slowdownEnable",0);
		setdvar("sv_cheats",0);
		setdvar("didyouknow", "Bronx Pack by @plugwalker47");
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
		if(!isDefined(player.pers["isBot"]) && player.pers["team"] != "allies")
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
		self iprintln("IW5 Setup S&D by ^:@plugwalker47");
		self thread changeclassmf();
        self thread gamecommands();
        self setclientdvar("cg_scoreboardPingGraph", 1);
		self setclientdvar("cg_scoreboardPingText", 0);
		self setclientdvar("safearea_adjusted_horizontal", 0.85);
		self setclientdvar("safearea_adjusted_vertical", 0.85);
		self giveperk("specialty_falldamage",false);
		self giveperk("specialty_quieter",false);
		self giveperk("specialty_fastoffhand",false);
		self giveperk("specialty_quickdraw",false);
		self.matchBonus = randomintrange(200,2000);
		if(self ishost())
		{
            self thread loadbots();
			self freezecontrols(false);
			if ( getteamscore("allies") == 0 && getteamscore("axis") == 0)
			{
				self thread spawnbot();
				self iprintlnbold("Player status ^:Host");
			}
			if ( getteamscore("allies" ) == 3 && getteamscore("axis") == 3)
			{
				self maps\mp\killstreaks\_killstreaks::givekillstreak("nuke",false);
			}
		}
		wait 1;
    }
}

gamecommands()
{
	self thread movebotbind();
	self thread bvestbind();
	self thread predbind();
	self thread changeclassmf();
	self thread canswapbind();
	self thread refillbind();
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
			self iprintlnbold(" ");
			self iprintlnbold(" ");
			self iprintlnbold(" ");
			self iprintlnbold(" ");
			self iprintlnbold(" ");
			self iprintlnbold(" ");
			self iprintlnbold(" ");
			self iprintlnbold(" ");
			self giveperk("specialty_falldamage",false);
			self giveperk("specialty_quieter",false);
			self giveperk("specialty_fastoffhand",false);
			self giveperk("specialty_quickdraw",false);
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

bvestbind()
{
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("bvest", "+actionslot 1");
		self waittill("bvest");
		if( self getstance() == "prone")
		{
			self maps\mp\killstreaks\_killstreaks::givekillstreak("deployable_vest",false);
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
			self giveweapon("iw5_pp90m1_mp_rof_silencer");
			self dropitem("iw5_pp90m1_mp_rof_silencer");
		}
		wait 0.1;
	}
}

spawnbot()
{
	self endon ("Stop");
	self endon("death");
	for(;;)
	{
		for(i = 0; i < 1; i++) 
		{		 
			ent[i] = addtestclient();
			if (!isdefined(ent[i]))
			{
				continue; 
			} 
			if(self.pers["team"] == "allies")
			{
				ent[i] thread testclient("axis");
				ent[i].pers["isBot"] = true;
				ent[i] setplayerdata("experience", 1746200);
			}
			else
			{
				ent[i] thread testclient("allies");
				ent[i].pers["isBot"] = true;
				ent[i] setplayerdata("experience", 1746200);
			}
		}
		self notify("Stop");		
		wait 0.1;
	}
}

testclient(team) 
{ 
	self endon( "disconnect" ); 
	while(!isdefined(self.pers["team"])) 
	wait .05; 
	self notify("menuresponse", game["menu_team"], team); 
	wait 0.5; 
	while(1) 
	{ 
		self notify( "menuresponse", "changeclass", "class1" );
		self waittill("spawned_player");
	} 
}

tpbot()
{
	self.pers["botpos"] = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"];
	wait 0.1;
	self thread loadbots();
}

loadbots()
{
	if (isdefined(self.pers["botpos"]))
	{
		foreach(p in level.players)
		{
			if ((p!=self)&&(p.pers["team"]!=self.pers["team"])) if (isalive(p)) if (p.pers["isBot"] == true)
			{	
				wait 0.1;
				p setorigin(self.pers["botpos"]);
			}
			
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

setupplayer()
{
	self closeMenus();
	self maps\mp\gametypes\_menus::addToTeam("allies");
	self.pers["class"] = undefined;
	self.class = undefined;
	self maps\mp\gametypes\_menus::beginClassChoice();
}