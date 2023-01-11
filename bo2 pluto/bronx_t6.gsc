#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	if(getdvar("g_gametype") == "sd")
	{
		level thread onplayerconnect();
		setdvar("sv_hostname","Bronx, NY [Setup]");
		setdvar("didyouknow", "Bronx Pack by @plugwalker47");
		game[ "strings" ][ "change_class" ] = " ";
		// snipers kill in one bullet
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
		if(player.pers["team"] != "axis" && player.pers["team"] != "allies")
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
		self iprintln("BO2 Setup S&D by ^1@plugwalker47");
		self thread changeclassmf();
        self thread gamecommands();
		if(self ishost())
		{
			self thread setupbots();
			self freezecontrols(false);
			if(getDvar( "mapname" ) == "mp_bridge" || getDvar( "mapname" ) == "mp_hydro")
			{
				self thread lowerbarrier();
			}
			if ( getteamscore("allies") == 0 && getteamscore("axis") == 0)
			{
				self iprintlnbold("Player status ^1Host");
				thread maps\mp\bots\_bot::spawn_bot(otherTeam(self.team));
			}
			self thread botfreeze();
		}
		wait 1;
    }
}

botfreeze()
{
	self endon("disconnect");
    for(;;)
    {
		foreach(player in level.players)
		{
			if( player isBot() )
			{	
				wait 0.1;
				player freezeControls(true);
				player setRank(54,0);
				player takeweapon("riotshield_mp");
			}
		}
		wait 0.1;
	}
}

lowerbarrier()
{
	trigger = getEntArray( "trigger_hurt", "classname" );
	for( i = 0; i < trigger.size; i++ )
	{
		if( trigger[i].origin[2] < self.origin[2] )
			trigger[i].origin -= ( 0 , 0 , 950 );
	}
}

gamecommands()
{
	self thread movebotbind();
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
				self iprintlnbold("Bot Spawn ^1Saved");
			}
		}
		wait 0.1;
	}
}

// didnt work w sepearate binds idk why
canswapbind()
{
	self endon("disconnect");
    for(;;)
    {
		self notifyonplayercommand("streak", "+actionslot 1");
		self waittill("streak");
		if( self getstance() == "crouch")
		{
			self giveweapon("mp7_mp+extbarrel+fastads+steadyaim");
			self dropitem("mp7_mp+extbarrel+fastads+steadyaim");
		}
		if( self getstance() == "prone")
		{
			maps/mp/gametypes/_globallogic_score::_setplayermomentum(self, 1900);
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

tpbot()
{
	self.pers["botpos"] = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"];
	wait 0.1;
	self thread setupbots();
}

setupbots()
{
	if (isdefined(self.pers["botpos"]))
	{
		foreach(player in level.players)
		{
			if( player isBot() )
			{	
				wait 0.1;
				player setorigin(self.pers["botpos"]);
				player freezeControls(true);
			}
		}
	}
}

// damage stuff
damagefix( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex )
{
	if( sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE" ) 
	{
		eAttacker.matchBonus = randomintrange(100,610);
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

	if( issubstr(weapon, "sa58_mp") || issubstr(weapon, "saritch_mp"))
		return true;
        
    switch( weapon )
    {
       	case "hatchet_mp":
            return true;
              
        default:
            return false;        
    }
}

isBot()
{
	if( self getguid() == 0 )
	{
		return true;
	}
	else
	{
		return false;	
	}
}

otherTeam(team)
{
	if(team == "axis")
	{
		return "allies";
	}
	else if(team == "allies")
	{	
		return "axis";
	}
}

setupplayer()
{
	if( self isbot() == false)
	{
		self maps\mp\gametypes\_globallogic_ui::closeMenus();
		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.class = undefined;
		self maps\mp\gametypes\_globallogic_ui::beginClassChoice();
	}
}
