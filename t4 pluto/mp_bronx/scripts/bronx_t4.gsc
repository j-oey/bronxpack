#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	if(getDvar("g_gametype") != "sd")
		return;

	setDvar("sv_hostname","Bronx, NY");
	setDvar("g_playercollision",0);
	setDvar("g_playerejection",0);
	setDvar("jump_slowdownEnable",0);
	setDvar("pm_bouncing",1);
	setDvar("timescale",1);
	setDvar("bg_surfacePenetration",999999);

	level thread onConnect();

	replaceFunc(maps\mp\_laststand::mayDoLastStand,::mayDoLastStand);
	
	level.callDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::callbackPlayerDamage_stub;
}

onConnect()
{
    for(;;)
    {
        level waittill("connected", player);
		if(player.pers["team"] != "axis" && player.pers["team"] != "allies" && !isDefined(player.pers["isBot"]))
			player maps\mp\gametypes\_teams::changeTeam("allies");

		if(!isDefined(player.pers["isBot"]))
		{
			player thread onSpawned();
			player thread changeClass();
			player thread moveBotBind();
			player thread canswapBind();
			player thread refillBind();
		}
		else
			player thread botSpawn();
    }
}

onSpawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self iprintLn("T4 Setup S&D by ^1@plugwalker47");
		if(self IsHost())
		{
			if(!game["roundsplayed"])
				thread spawnEnemy();

			self thread loadBots();
			self freezeControls(false);
		}
    }
}

botSpawn()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self setRank(self.pers["botrank"],self.pers["botpres"]);
		self unsetPerk("specialty_armorvest");
		self unsetPerk("specialty_pistoldeath");
		self unsetPerk("specialty_grenadepulldeath");
    }
}

changeClass()
{
	wait 1;
	self endon("disconnect");
 	oldclass = self.pers["class"];
 	for(;;)
 	{
  		if(self.pers["class"] != oldclass)
		{
			self maps\mp\gametypes\_class::giveloadout(self.pers["team"],self.pers["class"]);
			oldclass = self.pers["class"];
			self iPrintLnBold(" ");
		}
  		wait 0.1;
 	}
}

moveBotBind()
{
	self endon("disconnect");
    for(;;)
    {
		if( self getStance() == "crouch" && self isHost() && self secondaryOffhandButtonPressed())
		{
			self moveBots();
			wait 0.3;
		}
		wait 0.1;
	}
}

moveBots()
{
	self iprintLn("Bot Spawn ^1Saved");
	forward = self getTagOrigin("j_head");
	end = vectorScale(anglestoforward(self getPlayerAngles()), 1000000);
	self.pers["botspawn"] = BulletTrace( forward, end, false, self )["position"];
	self thread loadBots();
}

loadBots()
{
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].team == "axis")
			level.players[i] setOrigin(self.pers["botspawn"]);
	}
}

refillbind()
{
	self endon("disconnect");
    for(;;)
    {
		if(self getStance() == "crouch" && self meleeButtonPressed())
		{
			self giveMaxAmmo(self getCurrentWeapon());
			class_num = int( self.class[self.class.size-1] )-1;
			self giveMaxAmmo(self.custom_class[class_num]["grenades"]);
			wait 0.3;
		}
		wait 0.1;
	}
}

canswapBind()
{
	self endon("disconnect");
    for(;;)
    {
		if(self getStance() == "prone" && self meleeButtonPressed())
		{
			self giveWeapon("type100smg_aperture_mp");
			self dropItem("type100smg_aperture_mp");
			wait 1;
		}
		wait 0.1;
	}
}

// damage stuff
callbackPlayerDamage_stub(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
{
	if(sMeansofDeath == "MOD_FALLING")
		return;

	if(sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE") 
	{
		if(weaponClass(sWeapon) == "rifle" && sMeansofDeath != "MOD_MELEE")
			iDamage = 999;

		else if(self.team != eAttacker.team)
		{
			eAttacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback(false);
			return;
		}
	}
	[[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
}

spawnEnemy()
{
	ent = AddTestClient();
	ent.pers["isBot"] = true;
	ent thread TestClient( "axis" );
}

TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;

	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;

	classes = getArrayKeys( level.classMap );
	okclasses = [];
	for ( i = 0; i < classes.size; i++ )
	{
		if ( !issubstr( classes[i], "offline_class11_mp" ) && !issubstr( classes[i], "custom" ) && isDefined( level.default_perk[ level.classMap[ classes[i] ] ] ) )
			okclasses[ okclasses.size ] = classes[i];
	
	}
	
	assert( okclasses.size );
	self.pers["botrank"] = randomInt(64);
	self.pers["botpres"] = randomInt(10);

	while( 1 )
	{
		class = okclasses[ randomint( okclasses.size ) ];
		
		if ( !level.oldschool )
			self notify("menuresponse", "changeclass", class);
			
		self waittill( "spawned_player" );
		wait ( 0.10 );
	}
}

mayDoLastStand( sWeapon, sMeansOfDeath, sHitLoc )
{
	return false;
}