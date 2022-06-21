#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

clantags()
{
	for(;;)
	{
		level waittill( "connected", player );
		level.onPlayerKilled = ::onplayerkilled;
		player thread onPlayerSpawn();
	}
}

onPlayerSpawn()
{
	self endon( "disconnect" );
	for(;;)
	{
		self waittill("spawned_player");

		setDvarIfUninitialized( "killedby_name", "" );
		setDvarIfUninitialized( "killedby_tag", "" );
		setDvarIfUninitialized( "youkilled_name", "" );
		setDvarIfUninitialized( "youkilled_tag", "" );
		setDvarIfUninitialized( "splash_tag", "" );
		setDvarIfUninitialized( "splash_name", "" );
	}
}

onPlayerKilled(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration) 
{
	// "Killed by" dvars
	if (isSubStr(attacker.name, "[") && isSubStr(attacker.name, "]")) // I know you can easily break this but let's assume people will use normal names/tags
	{ 
		if (getPartFromName("clantag", attacker.name) == getPartFromName("name", attacker.name))
			self setClientDvar("killedby_tag", "");
		else self setClientDvar("killedby_tag", getPartFromName("clantag", attacker.name));
		self setClientDvar("killedby_name", getPartFromName("name", attacker.name));
		attacker.tag = getPartFromName("clantag", attacker.name);
		attacker.shortname = getPartFromName("name", attacker.name);
	}
	else 
	{
		self setClientDvar("killedby_tag", " ");
		self setClientDvar("killedby_name", attacker.name);
		attacker.tag = "";
		attacker.shortname = attacker.name;
	}

	// "You killed" dvars
	if (isSubStr(self.name, "[") && isSubStr(self.name, "]"))  // dito with this one
	{
		if (getPartFromName("clantag", self.name) == getPartFromName("name", self.name))
			attacker setClientDvar("youkilled_tag", "");
		else attacker setClientDvar("youkilled_tag", getPartFromName("clantag", self.name));
		attacker setClientDvar("youkilled_name", getPartFromName("name", self.name));
	}
	else 
	{
		attacker setClientDvar("youkilled_tag", "");
		attacker setClientDvar("youkilled_name", self.name);
	}
}

getPartFromName(mode, name)
{
	parts = StrTok(name, "]");
	if (mode == "clantag" || ((parts[1] == "" || parts[1] == " ") && mode == "name")) 
		return (parts[0] + "]");
	if (mode == "name") 
		return parts[1];
	else return "";
}