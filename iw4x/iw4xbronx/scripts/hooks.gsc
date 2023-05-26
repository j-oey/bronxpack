#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    replacefunc(maps\mp\_events::firstBlood,::firstBlood_stub); //events
    replacefunc(maps\mp\gametypes\_class::isValidPrimary,::isValidPrimary_stub); //class
	replacefunc(maps\mp\gametypes\_class::isValidSecondary,::isValidSecondary_stub);
	replacefunc(maps\mp\gametypes\_class::isValidOffhand,::isValidOffhand_stub);
    replacefunc(maps\mp\gametypes\_hud_message::teamOutcomeNotify,::teamOutcomeNotify_stub); //hud_message
	replacefunc(maps\mp\gametypes\_killcam::initKCElements,::initKCElements_stub); //killcam
	replacefunc(maps\mp\gametypes\sd::onOneLeftEvent,::onOneLeftEvent_stub); //sd
    replacefunc(maps\mp\gametypes\_gamelogic::matchStartTimer,::matchStartTimer_stub); //gamelogic
    replacefunc(maps\mp\gametypes\_gamelogic::endGame,::endGame_stub);
	replacefunc(maps\mp\killstreaks\_nuke::doNuke,::doNuke_stub); //nuke
    replacefunc(maps\mp\killstreaks\_nuke::nukeEffects,::nukeEffects_stub);
    replacefunc(maps\mp\killstreaks\_nuke::nukeDeath,::nukeDeath_stub);

    level.callDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::callbackPlayerDamage_stub;
}

// damage stuff
callbackPlayerDamage_stub( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex )
{
	if(sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE") 
	{
		if(getweaponclass(sWeapon) == "weapon_sniper" || sWeapon == "throwingknife_mp" || sWeapon == "throwingknife_rhand_mp") 
		{
			iDamage = 999;
		}
		else
		{
			iDamage = 0;
			eAttacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback("");
		}
	}
    if(sMeansofDeath == "MOD_FALLING")
	{
		iDamage = 0;
	}
	[[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );        
}

//events
firstBlood_stub( killId )
{

}

//class
isValidPrimary_stub( refString )
{
	return true;
}

isValidSecondary_stub( refString )
{
	return true;
}

isValidOffhand_stub( refString )
{
	return true;
}

//killcam
initKCElements_stub()
{
	if ( !isDefined( self.kc_skiptext ) )
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "top";
		self.kc_skiptext.horzAlign = "center_adjustable";
		self.kc_skiptext.vertAlign = "top_adjustable";
		self.kc_skiptext.sort = 1; // force to draw after the bars
		self.kc_skiptext.font = "default";
		self.kc_skiptext.foreground = true;
		self.kc_skiptext.hideWhenInMenu = true;
		
		if ( level.splitscreen )
		{
			self.kc_skiptext.y = 20;
			self.kc_skiptext.fontscale = 1.2; // 1.8/1.5
		}
		else
		{
			self.kc_skiptext.y = 32;
			self.kc_skiptext.fontscale = 1.8;
		}
	}
	if ( !isDefined( self.kc_othertext ) )
	{
		self.kc_othertext = newClientHudElem(self);
		self.kc_othertext.archived = false;		
		self.kc_othertext.y = 18;
		self.kc_othertext.alignX = "left";
		self.kc_othertext.alignY = "top";
		self.kc_othertext.horzAlign = "center";
		self.kc_othertext.vertAlign = "middle";
		self.kc_othertext.sort = 10; // force to draw after the bars
		self.kc_othertext.font = "small";
		self.kc_othertext.foreground = true;
		self.kc_othertext.hideWhenInMenu = true;
		
		if ( level.splitscreen )
		{
			self.kc_othertext.x = 16;
			self.kc_othertext.fontscale = 1.2;
		}
		else
		{
			self.kc_othertext.x = 62;
			self.kc_othertext.fontscale = 1.6;
		}
	}
	if ( !isDefined( self.kc_icon ) )
	{
		self.kc_icon = newClientHudElem(self);
		self.kc_icon.archived = false;
		self.kc_icon.x = 16;
		self.kc_icon.y = 16;
		self.kc_icon.alignX = "left";
		self.kc_icon.alignY = "top";
		self.kc_icon.horzAlign = "center";
		self.kc_icon.vertAlign = "middle";
		self.kc_icon.sort = 1; // force to draw after the bars
		self.kc_icon.foreground = true;
		self.kc_icon.hideWhenInMenu = true;		
	}
	if ( !level.splitscreen )
	{
		if ( !isdefined( self.kc_timer ) )
		{
			self.kc_timer = createFontString( "hudbig", 1.2 );
			self.kc_timer.archived = false;
			self.kc_timer.x = 0;
			self.kc_timer.alignX = "center";
			self.kc_timer.alignY = "middle";
			self.kc_timer.horzAlign = "center_safearea";
			self.kc_timer.vertAlign = "top_adjustable";
			self.kc_timer.y = 42;
			self.kc_timer.sort = 1; // force to draw after the bars
			self.kc_timer.font = "hudbig";
			self.kc_timer.foreground = true;
			self.kc_timer.color = (0.85,0.85,0.85);
			self.kc_timer.hideWhenInMenu = true;
		}
	}
}

//hud_message
teamOutcomeNotify_stub( winner, isRound, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	wait ( 0.5 );
	team = self.pers["team"];
	if ( !isDefined( team ) || (team != "allies" && team != "axis") )
		team = "allies";

	// wait for notifies to finish
	while ( self maps\mp\gametypes\_hud_message::isDoingSplash() )
		wait 0.05;

	self endon ( "reset_outcome" );	
	if ( level.splitscreen )
	{
		// These are mostly fullscreen values divided by 1.5
		titleSize = 1;
		titleOffset = -76;
		textSize = 0.667;
		textOffset = 12;
		numberSize = 0.833;
		iconSize = 46;
		iconSpacingH = 40;
		iconSpacing = 30;
		scoreSpacing = 0;
		bonusSpacing = 60;
		font = "hudbig";
	}
	else
	{
		titleSize = 1.7;
		titleOffset = -134;
		textSize = 1.1;
		textOffset = 18;
		numberSize = 1.6;
		iconSize = 67;
		iconSpacingH = 60;
		iconSpacing = 45;
		scoreSpacing = 0;
		bonusSpacing = 85;
		font = "hudbig";
	}
	duration = 60000;

	outcomeTitle = createFontString( font, titleSize );
	outcomeTitle setPoint( "CENTER", undefined, 0, titleOffset );
	outcomeTitle.foreground = true;
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeText = createFontString( font, textSize );
	outcomeText setParent( outcomeTitle );
	outcomeText.foreground = true;
	outcomeText setPoint( "TOP", "BOTTOM", 0, textOffset );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	
	if ( winner == "halftime" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["halftime"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "intermission" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["intermission"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "roundend" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["roundend"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "overtime" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["overtime"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "tie" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_draw"] );
		else
			outcomeTitle setText( game["strings"]["draw"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( isDefined( self.pers["team"] ) && winner == team )
	{
		outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_win"] );
		else
			outcomeTitle setText( game["strings"]["victory"] );
		outcomeTitle.color = (0.6, 0.9, 0.6);
	}
	else
	{
		outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_loss"] );
		else
			outcomeTitle setText( game["strings"]["defeat"] );
		outcomeTitle.color = (0.7, 0.3, 0.2);
	}
	
	outcomeText.glowColor = (0.2, 0.3, 0.7);
	outcomeText setText( endReasonText );
	
	outcomeTitle setPulseFX( 100, duration, 1000 );
	outcomeText setPulseFX( 100, duration, 1000 );
	
	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		leftIcon = createIcon( game["icons"][team] + "_blue", iconSize, iconSize );
	else
		leftIcon = createIcon( game["icons"][team], iconSize, iconSize );
	leftIcon setParent( outcomeText );
	leftIcon setPoint( "TOP", "BOTTOM", (iconSpacingH*-1), iconSpacing );
	leftIcon.foreground = true;
	leftIcon.hideWhenInMenu = false;
	leftIcon.archived = false;
	leftIcon.alpha = 0;
	leftIcon fadeOverTime( 0.5 );
	leftIcon.alpha = 1;

	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		rightIcon = createIcon( game["icons"][level.otherTeam[team]] + "_red", iconSize, iconSize );
	else
		rightIcon = createIcon( game["icons"][level.otherTeam[team]], iconSize, iconSize );
	rightIcon setParent( outcomeText );
	rightIcon setPoint( "TOP", "BOTTOM", iconSpacingH, iconSpacing );
	rightIcon.foreground = true;
	rightIcon.hideWhenInMenu = false;
	rightIcon.archived = false;
	rightIcon.alpha = 0;
	rightIcon fadeOverTime( 0.5 );
	rightIcon.alpha = 1;

	leftScore = createFontString( font, numberSize );
	leftScore setParent( leftIcon );
	leftScore setPoint( "TOP", "BOTTOM", 0, scoreSpacing );
	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		leftScore.glowColor = game["colors"]["blue"];
	else
		leftScore.glowColor = game["colors"][team];
	leftScore.glowAlpha = 1;
	if ( !isRoundBased() || !isObjectiveBased() )
		leftScore setValue( maps\mp\gametypes\_gamescore::_getTeamScore( team ) );
	else
		leftScore setValue( game["roundsWon"][team] );
	leftScore.foreground = true;
	leftScore.hideWhenInMenu = false;
	leftScore.archived = false;
	leftScore setPulseFX( 100, duration, 1000 );

	rightScore = createFontString( font, numberSize );
	rightScore setParent( rightIcon );
	rightScore setPoint( "TOP", "BOTTOM", 0, scoreSpacing );
	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		rightScore.glowColor = game["colors"]["red"];
	else
		rightScore.glowColor = game["colors"][level.otherTeam[team]];
	rightScore.glowAlpha = 1;
	if ( !isRoundBased() || !isObjectiveBased() )
		rightScore setValue( maps\mp\gametypes\_gamescore::_getTeamScore( level.otherTeam[team] ) );
	else
		rightScore setValue( game["roundsWon"][level.otherTeam[team]] );
	rightScore.foreground = true;
	rightScore.hideWhenInMenu = false;
	rightScore.archived = false;
	rightScore setPulseFX( 100, duration, 1000 );

    matchBonus = undefined;
	if ( isDefined( self.matchBonus ) )
	{
		matchBonus = createFontString( font, 1.15 );
		matchBonus setParent( outcomeText );
		matchBonus setPoint( "TOP", "BOTTOM", 0, iconSize + bonusSpacing + leftScore.height );
		matchBonus.glowAlpha = 1;
		matchBonus.foreground = true;
		matchBonus.hideWhenInMenu = false;
		matchBonus.color = (1,1,0.5);
		matchBonus.archived = false;
		matchBonus.label = game["strings"]["match_bonus"];
		matchBonus setValue( self.matchBonus );
	}
	
	self thread maps\mp\gametypes\_hud_message::resetTeamOutcomeNotify( outcomeTitle, outcomeText, leftIcon, rightIcon, leftScore, rightScore, matchBonus );
}

//sd
onOneLeftEvent_stub( team )
{
	
}

//gamelogic
matchStartTimer_stub( type, duration )
{
	level notify( "match_start_timer_beginning" );
	
	matchStartText = createServerFontString( "objective", 1.5 );
	matchStartText setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( game["strings"]["waiting_for_teams"] );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;
	
	matchStartText setText( "Bronx begins in:" );
	
	matchStartTimer = createServerFontString( "hudbig", 1 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer maps\mp\gametypes\_hud::fontPulseInit();

	countTime = int( duration );
	
	if ( countTime >= 2 )
	{
		maps\mp\gametypes\_gamelogic::matchStartTimer_Internal( countTime, matchStartTimer );
		visionSetNaked( getDvar( "mapname" ), 3.0 );
	}
	else
	{
		visionSetNaked( "mpIntro", 0 );
		visionSetNaked( getDvar( "mapname" ), 1.0 );
	}
	
	matchStartTimer destroyElem();
	matchStartText destroyElem();
}

endGame_stub( winner, endReasonText, nukeDetonated )
{
	if ( !isDefined(nukeDetonated) )
		nukeDetonated = false;
	
	// return if already ending via host quit or victory, or nuke incoming
	if ( game["state"] == "postgame" || level.gameEnded || (isDefined(level.nukeIncoming) && !nukeDetonated) && ( !isDefined( level.gtnw ) || !level.gtnw ) )
		return;

	game["state"] = "postgame";

	level.gameEndTime = getTime();
	level.gameEnded = true;
	level.inGracePeriod = false;
	level notify ( "game_ended", winner );
	levelFlagSet( "game_over" );
	levelFlagSet( "block_notifies" );
	waitframe(); // give "game_ended" notifies time to process
	
	setGameEndTime( 0 ); // stop/hide the timers
	
	maps\mp\gametypes\_playerlogic::printPredictedSpawnpointCorrectness();
	
	if ( isDefined( winner ) && isString( winner ) && winner == "overtime" )
	{
		maps\mp\gametypes\_gamelogic::endGameOvertime( winner, endReasonText );
		return;
	}
	
	if ( isDefined( winner ) && isString( winner ) && winner == "halftime" )
	{
		maps\mp\gametypes\_gamelogic::endGameHalftime();
		return;
	}

	game["roundsPlayed"]++;
	
	if ( level.teamBased )
	{
		if ( winner == "axis" || winner == "allies" )
			game["roundsWon"][winner]++;

		maps\mp\gametypes\_gamescore::updateTeamScore( "axis" );
		maps\mp\gametypes\_gamescore::updateTeamScore( "allies" );
	}
	else
	{
		if ( isDefined( winner ) && isPlayer( winner ) )
			game["roundsWon"][winner.guid]++;
	}
	
	maps\mp\gametypes\_gamescore::updatePlacement();

	maps\mp\gametypes\_gamelogic::rankedMatchUpdates( winner );

	foreach ( player in level.players )
	{
		player setClientDvar( "ui_opensummary", 1 );
	}
	
	setDvar( "g_deadChat", 1 );
	setDvar( "ui_allow_teamchange", 0 );

	// freeze players
	foreach ( player in level.players )
	{
		player thread maps\mp\gametypes\_gamelogic::freezePlayerForRoundEnd( 1.0 );
		player thread maps\mp\gametypes\_gamelogic::roundEndDoF( 4.0 );
		
		player maps\mp\gametypes\_gamelogic::freeGameplayHudElems();

		player setClientDvars( "cg_everyoneHearsEveryone", 1 );
		player setClientDvars( "cg_drawSpectatorMessages", 0,
							   "g_compassShowEnemies", 0,
							   "cg_fovScale", 1 );
							   
		if ( player.pers["team"] == "spectator" )
			player thread maps\mp\gametypes\_playerlogic::spawnIntermission();
	}

	if( !nukeDetonated )
		visionSetNaked( "mpOutro", 0.5 );		
	
	// End of Round
	if ( !wasOnlyRound() && !nukeDetonated )
	{
		setDvar( "scr_gameended", 2 );
	
		maps\mp\gametypes\_gamelogic::displayRoundEnd( winner, endReasonText );

		if ( level.showingFinalKillcam )
		{
			foreach ( player in level.players )
				player notify ( "reset_outcome" );

			level notify ( "game_cleanup" );

			maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone();
		}
				
		if ( !wasLastRound() )
		{
			levelFlagClear( "block_notifies" );
			if ( maps\mp\gametypes\_gamelogic::checkRoundSwitch() )
				maps\mp\gametypes\_gamelogic::displayRoundSwitch();

			foreach ( player in level.players )
				player.pers["stats"] = player.stats;

        	level notify ( "restarting" );
            game["state"] = "playing";
            map_restart( true );
            return;
		}
		
		if ( !level.forcedEnd )
			endReasonText = maps\mp\gametypes\_gamelogic::updateEndReasonText( winner );
	}

	setDvar( "scr_gameended", 1 );
	
	if ( !isDefined( game["clientMatchDataDef"] ) )
	{
		game["clientMatchDataDef"] = "mp/clientmatchdata.def";
		setClientMatchDataDef( game["clientMatchDataDef"] );
	}

	maps\mp\gametypes\_missions::roundEnd( winner );

	maps\mp\gametypes\_gamelogic::displayGameEnd( winner, endReasonText );

	if ( level.showingFinalKillcam && wasOnlyRound() )
	{
		foreach ( player in level.players )
			player notify ( "reset_outcome" );

		level notify ( "game_cleanup" );

		maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone();
	}				

	levelFlagClear( "block_notifies" );

	level.intermission = true;

	level notify ( "spawning_intermission" );
	
	foreach ( player in level.players )
	{
		player closepopupMenu();
		player closeInGameMenu();
		player notify ( "reset_outcome" );
		player thread maps\mp\gametypes\_playerlogic::spawnIntermission();
	}

	maps\mp\gametypes\_gamelogic::processLobbyData();

	wait ( 1.0 );

	if ( matchMakingGame() )
		sendMatchData();

	foreach ( player in level.players )
		player.pers["stats"] = player.stats;

	//logString( "game ended" );
	if( !nukeDetonated && !level.postGameNotifies )
	{
		if ( !wasOnlyRound() )
			wait 6.0;
		else
			wait 3.0;
	}
	else
	{
		wait ( min( 10.0, 4.0 + level.postGameNotifies ) );
	}
	
	level notify( "exitLevel_called" );
	level scripts\bronx::nextmapselect();
}

//nuke
doNuke_stub( allowCancel )
{
	level endon ( "nuke_cancelled" );
	level.nukeInfo = spawnStruct();
	level.nukeInfo.player = self;
	level.nukeInfo.team = self.team;
	maps\mp\gametypes\_gamelogic::pauseTimer();
	level.timeLimitOverride = true;
	setGameEndTime( int( gettime() + (level.nukeTimer * 1000) ) );
	setDvar( "ui_bomb_timer", 4 ); // Nuke sets '4' to avoid briefcase icon showing
	level thread maps\mp\killstreaks\_nuke::delaythread_nuke( (level.nukeTimer - 3.3), maps\mp\killstreaks\_nuke::nukeSoundIncoming );
	level thread maps\mp\killstreaks\_nuke::delaythread_nuke( level.nukeTimer, maps\mp\killstreaks\_nuke::nukeSoundExplosion );
	level thread maps\mp\killstreaks\_nuke::delaythread_nuke( level.nukeTimer, maps\mp\killstreaks\_nuke::nukeSlowMo );
	level thread maps\mp\killstreaks\_nuke::delaythread_nuke( level.nukeTimer, maps\mp\killstreaks\_nuke::nukeEffects );
	level thread maps\mp\killstreaks\_nuke::delaythread_nuke( (level.nukeTimer + 0.25), maps\mp\killstreaks\_nuke::nukeVision );
	level thread maps\mp\killstreaks\_nuke::delaythread_nuke( (level.nukeTimer + 1.5), ::nukeDeath_stub );
	level thread maps\mp\killstreaks\_nuke::delaythread_nuke( (level.nukeTimer + 1.5), maps\mp\killstreaks\_nuke::nukeEarthquake );
	level thread maps\mp\killstreaks\_nuke::nukeAftermathEffect();
	clockObject = spawn( "script_origin", (0,0,0) );
	clockObject hide();
	while ( !isDefined( level.nukeDetonated_stub ) )
	{
		clockObject playSound( "ui_mp_nukebomb_timer" );
		wait( 1.0 );
	}
}

nukeEffects_stub()
{
	level endon ( "nuke_cancelled" );
	setDvar( "ui_bomb_timer", 0 );
	setGameEndTime( 0 );
	level.nukeDetonated_stub = true;
	level maps\mp\killstreaks\_emp::destroyActiveVehicles( level.nukeInfo.player );
	foreach( player in level.players )
	{
		playerForward = anglestoforward( player.angles );
		playerForward = ( playerForward[0], playerForward[1], 0 );
		playerForward = VectorNormalize( playerForward );
		nukeDistance = 5000;
		/# nukeDistance = getDvarInt( "scr_nukeDistance" );	#/
		nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
		nukeEnt setModel( "tag_origin" );
		nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
		/#
		if ( getDvarInt( "scr_nukeDebugPosition" ) )
		{
			lineTop = ( nukeEnt.origin[0], nukeEnt.origin[1], (nukeEnt.origin[2] + 500) );
			thread draw_line_for_time( nukeEnt.origin, lineTop, 1, 0, 0, 10 );
		}
		#/
		nukeEnt thread maps\mp\killstreaks\_nuke::nukeEffect( player );
		player.nuked = true;
	}
}

nukeDeath_stub()
{
	level endon("game_ended");
	level notify("nuke_death");
	maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	AmbientStop(1);
	foreach(player in level.players)
	{
		if( isAlive(player) && player.team == "allies")
        {
            player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( player, player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0 );
        }
	}
	level.postRoundTime = 10;
	thread nukeroundend(); //maybe need this
}

nukeroundend()
{
	botteam = "allies";
	if(botteam == game["attackers"])
	{
		level thread maps\mp\gametypes\sd::sd_endGame(game["defenders"], game["strings"][game["attackers"]+"_eliminated"]);
	}
	else if(botteam == game["defenders"])
	{
		level thread maps\mp\gametypes\sd::sd_endGame(game["attackers"], game["strings"][game["defenders"]+"_eliminated"]);
	}
}