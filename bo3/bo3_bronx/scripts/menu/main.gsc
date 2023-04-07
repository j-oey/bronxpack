#include scripts\mp\gametypes\_loadout;
#include scripts\mp\gametypes\_globallogic_score;
#include scripts\mp\_util;

on_player_spawned()
{
    if(self.team == "allies")
    {
		SetDvar("cg_gun_x", 1.7);
        self iPrintLn("BO3 Setup S&D by ^2@plugwalker47");
        self thread gamecommands();
    }
    else if(self.team == "axis")
    {
        self thread botfreezer();
    }
}

botfreezer()
{
    self endon("disconnect");
    for(;;)
    {
        self freezeControls(true);
        wait 0.1;
    }
}

gamecommands()
{
	self thread refillbind();
	self thread canswapbind();
	self thread streakbind();
	self thread changeclass();
    if(self IsHost())
    {
        self thread movebotbind();
        self thread loadbots();
    }
}

changeclass()
{
	self endon("disconnect");
 	oldclass = self.pers["class"];
 	for(;;)
 	{
  		if(self.pers["class"] != oldclass)
		{
			self loadout::giveloadout(self.team, self.pers["class"]);
			oldclass = self.pers["class"];
			self iPrintLnBold(" ");
		}
  		wait 0.1;
 	}
}

movebotbind()
{
	self endon("disconnect");
    for(;;)
	{
		if( self getStance() == "crouch" && self ActionSlotThreeButtonPressed())
		{
            start = self geteye();
            end = start + anglestoforward(self getplayerangles()) * 1000000;
            location = bullettrace(start, end, false, self)["position"];
            self.pers["botspawn"] = location;
            self iPrintLnBold("Bot Spawn ^2Saved");
            self thread loadbots();
		}
		wait 0.01;
	}
}

loadbots()
{
    foreach(player in level.players)
	{
		if (player.team == "axis")
		{	
			player setOrigin(self.pers["botspawn"]);
		}
	}
}

refillbind()
{
	self endon("disconnect");
    for(;;)
	{
		if( self getStance() == "crouch" && self meleeButtonPressed())
		{
			self giveMaxAmmo(self getCurrentWeapon());
			self giveStartAmmo(self getCurrentOffhand());
			self giveStartAmmo(self getOffhandSecondaryClass());
		}
		wait 0.01;
	}
}

canswapbind()
{
	self endon("disconnect");
    for(;;)
	{
		if( self getStance() == "crouch" && self ActionSlotOneButtonPressed())
		{
			self giveweapon("pistol_fullauto");
			self dropitem("pistol_fullauto");
		}
		wait 0.01;
	}
}

streakbind()
{
	self endon("disconnect");
    for(;;)
    {
		if( self getStance() == "prone" && self ActionSlotOneButtonPressed())
		{
            globallogic_score::_setplayermomentum(self, 9999);
		}
		wait 0.01;
	}
}