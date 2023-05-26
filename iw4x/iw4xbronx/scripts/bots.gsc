#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\bronx;

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
				ent[i] thread smartbotlvl();
			}
			else
			{
				ent[i] thread testclient("allies");
				ent[i].pers["isBot"] = true;
				ent[i] thread smartbotlvl();
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
				p.pers["class"] = "class0";	
				p maps\mp\gametypes\_class::giveloadout(p.pers["team"],p.pers["class"]);
				p setCardTitle(p.pers["randtitle"]);
				p SetcardIcon(p.pers["randemblem"]);
			}
			
		}
	}
}

smartbotlvl()
{
	if (self getPlayerData("experience") < 10 ) 
	{
		self setPlayerData("prestige", RandomIntRange( 0, 11 ) );
		if(self getPlayerData("prestige") == 11)
		{
			self setPlayerData("experience", 2516000);
			self thread TitleRAND();
			self thread EmblemRAND();
		}
		else if(self getPlayerData("prestige") == 0)
		{
			self setPlayerData("experience", RandomIntRange( 0,2516000));
		}
		else
		{
			self setPlayerData("experience", 2516000);
			self thread TitleRAND();
			self thread EmblemRAND();
		}
	}
}

TitleRAND()
{
	Title = "";
	switch(randomintrange(191,567))
	{
		case 191 : 
		Title = "cardtitle_flyswatter";
		break;

		case 192 : 
		Title = "cardtitle_avenger";
		break;

		case 193 : 
		Title = "cardtitle_shotdown";
		break;

		case 194 : 
		Title = "cardtitle_tangodown";
		break;

		case 195 : 
		Title = "cardtitle_bowdown";
		break;

		case 196 : 
		Title = "cardtitle_lowprofile";
		break;

		case 197 : 
		Title = "cardtitle_dishtherock";
		break;

		case 198 : 
		Title = "cardtitle_jointops";
		break;

		case 199 : 
		Title = "cardtitle_sprayandpray";
		break;

		case 200 : 
		Title = "cardtitle_submittoauthority";
		break;

		case 201 : 
		Title = "cardtitle_pyro";
		break;

		case 202 : 
		Title = "cardtitle_fired";
		break;

		case 203 : 
		Title = "cardtitle_drifter";
		break;

		case 204 : 
		Title = "cardtitle_pushindaisy";
		break;

		case 205 : 
		Title = "cardtitle_accidentprone";
		break;

		case 206 : 
		Title = "cardtitle_flag_united_states";
		break;

		case 207 : 
		Title = "cardtitle_flag_uk";
		break;

		case 208 : 
		Title = "cardtitle_flag_canada";
		break;

		case 209 : 
		Title = "cardtitle_flag_australia";
		break;

		case 210 : 
		Title = "cardtitle_flag_france";
		break;

		case 211 : 
		Title = "cardtitle_flag_mexico";
		break;

		case 212 : 
		Title = "cardtitle_flag_germany";
		break;

		case 213 : 
		Title = "cardtitle_flag_italy";
		break;

		case 214 : 
		Title = "cardtitle_flag_japan";
		break;

		case 215 : 
		Title = "cardtitle_flag_norway";
		break;

		case 216 : 
		Title = "cardtitle_flag_russia";
		break;

		case 217 : 
		Title = "cardtitle_flag_greece";
		break;

		case 218 : 
		Title = "cardtitle_flag_spain";
		break;

		case 219 : 
		Title = "cardtitle_flag_sweden";
		break;

		case 220 : 
		Title = "cardtitle_flag_ireland";
		break;

		case 221 : 
		Title = "cardtitle_flag_belgium";
		break;

		case 222 : 
		Title = "cardtitle_flag_finland";
		break;

		case 223 : 
		Title = "cardtitle_flag_luxemburg";
		break;

		case 224 : 
		Title = "cardtitle_flag_czech";
		break;

		case 225 : 
		Title = "cardtitle_flag_netherlands";
		break;

		case 226 : 
		Title = "cardtitle_flag_newzealand";
		break;

		case 227 : 
		Title = "cardtitle_flag_brazil";
		break;

		case 228 : 
		Title = "cardtitle_flag_philippines";
		break;

		case 229 : 
		Title = "cardtitle_flag_poland";
		break;

		case 230 : 
		Title = "cardtitle_flag_portugal";
		break;

		case 231 : 
		Title = "cardtitle_flag_denmark";
		break;

		case 232 : 
		Title = "cardtitle_flag_saudiarabia";
		break;

		case 233 : 
		Title = "cardtitle_flag_singapore";
		break;

		case 234 : 
		Title = "cardtitle_flag_southafrica";
		break;

		case 235 : 
		Title = "cardtitle_flag_southkorea";
		break;

		case 236 : 
		Title = "cardtitle_flag_hongkong";
		break;

		case 237 : 
		Title = "cardtitle_flag_india";
		break;

		case 238 : 
		Title = "cardtitle_flag_swiss";
		break;

		case 239 : 
		Title = "cardtitle_flag_taiwan";
		break;

		case 240 : 
		Title = "cardtitle_flag_austria";
		break;

		case 241 : 
		Title = "cardtitle_flag_united_arab_emirates";
		break;

		case 242 : 
		Title = "cardtitle_flag_elsalvador";
		break;

		case 243 : 
		Title = "cardtitle_flag_china";
		break;

		case 244 : 
		Title = "cardtitle_flag_iran";
		break;

		case 245 : 
		Title = "cardtitle_lonewolf";
		break;

		case 246 : 
		Title = "cardtitle_getreal";
		break;

		case 247 : 
		Title = "cardtitle_teamplayer";
		break;

		case 248 : 
		Title = "cardtitle_destroyer";
		break;

		case 249 : 
		Title = "cardtitle_its_sabotage";
		break;

		case 250 : 
		Title = "cardtitle_hotshot";
		break;

		case 251 : 
		Title = "cardtitle_feared";
		break;

		case 252 : 
		Title = "cardtitle_publicenemy";
		break;

		case 253 : 
		Title = "cardtitle_bombshell";
		break;

		case 254 : 
		Title = "cardtitle_thabomb";
		break;

		case 255 : 
		Title = "cardtitle_explosiveordinance";
		break;

		case 256 : 
		Title = "cardtitle_madbomber";
		break;

		case 257 : 
		Title = "cardtitle_harcoreonly";
		break;

		case 258 : 
		Title = "cardtitle_intergalactic";
		break;

		case 259 : 
		Title = "cardtitle_bob";
		break;

		case 260 : 
		Title = "cardtitle_survivor";
		break;

		case 261 : 
		Title = "cardtitle_overwatch";
		break;

		case 262 : 
		Title = "cardtitle_dzclear";
		break;

		case 263 : 
		Title = "cardtitle_rainoffire";
		break;

		case 264 : 
		Title = "cardtitle_steelreign";
		break;

		case 265 : 
		Title = "cardtitle_timeontarget";
		break;

		case 266 : 
		Title = "cardtitle_brokenarrow";
		break;

		case 267 : 
		Title = "cardtitle_givinstatic";
		break;

		case 268 : 
		Title = "cardtitle_jumpjet";
		break;

		case 269 : 
		Title = "cardtitle_philanthropist";
		break;

		case 270 : 
		Title = "cardtitle_sigint";
		break;

		case 271 : 
		Title = "cardtitle_nohands";
		break;

		case 272 : 
		Title = "cardtitle_ghostrider";
		break;

		case 273 : 
		Title = "cardtitle_squawkbox";
		break;

		case 274 : 
		Title = "cardtitle_companioncrate";
		break;

		case 275 : 
		Title = "cardtitle_straightup";
		break;

		case 276 : 
		Title = "cardtitle_voyeur";
		break;

		case 277 : 
		Title = "cardtitle_fireforget";
		break;

		case 278 : 
		Title = "cardtitle_cr1zby";
		break;

		case 279 : 
		Title = "cardtitle_patriot";
		break;

		case 280 : 
		Title = "cardtitle_greatwhite";
		break;

		case 281 : 
		Title = "cardtitle_continental";
		break;

		case 282 : 
		Title = "cardtitle_neutral";
		break;

		case 283 : 
		Title = "cardtitle_conquerer";
		break;

		case 284 : 
		Title = "cardtitle_terminator";
		break;

		case 285 : 
		Title = "cardtitle_risingsun";
		break;

		case 286 : 
		Title = "cardtitle_redeemer";
		break;

		case 287 : 
		Title = "cardtitle_pineappleexpress";
		break;

		case 288 : 
		Title = "cardtitle_catchshrapnel";
		break;

		case 289 : 
		Title = "cardtitle_mastermind";
		break;

		case 290 : 
		Title = "cardtitle_jackinthebox";
		break;

		case 291 : 
		Title = "cardtitle_copperfield";
		break;

		case 292 : 
		Title = "cardtitle_takeastab";
		break;

		case 293 : 
		Title = "cardtitle_masterblaster";
		break;

		case 294 : 
		Title = "cardtitle_juggernaut";
		break;

		case 295 : 
		Title = "cardtitle_bullseye";
		break;

		case 296 : 
		Title = "cardtitle_stuckonyou";
		break;

		case 297 : 
		Title = "cardtitle_plasticman";
		break;

		case 298 : 
		Title = "cardtitle_c4andafter";
		break;

		case 299 : 
		Title = "cardtitle_silentknight";
		break;

		case 300 : 
		Title = "cardtitle_darkbringer";
		break;

		case 301 : 
		Title = "cardtitle_tacticaldeletion";
		break;

		case 302 : 
		Title = "cardtitle_itspersonal";
		break;

		case 303 : 
		Title = "cardtitle_fragout";
		break;

		case 304 : 
		Title = "cardtitle_cloakanddagger";
		break;

		case 305 : 
		Title = "cardtitle_wopr";
		break;

		case 306 : 
		Title = "cardtitle_rollingthunder";
		break;

		case 307 : 
		Title = "cardtitle_angelofdeath";
		break;

		case 308 : 
		Title = "cardtitle_gettothechoppa";
		break;

		case 309 : 
		Title = "cardtitle_cobracommander";
		break;

		case 310 : 
		Title = "cardtitle_airwolf";
		break;

		case 311 : 
		Title = "cardtitle_blackout";
		break;

		case 312 : 
		Title = "cardtitle_endofline";
		break;

		case 313 : 
		Title = "cardtitle_planewhisperer";
		break;

		case 314 : 
		Title = "cardtitle_starfishprime";
		break;

		case 315 : 
		Title = "cardtitle_watchman";
		break;

		case 316 : 
		Title = "cardtitle_omnipotent";
		break;

		case 317 : 
		Title = "cardtitle_fullthrottle";
		break;

		case 318 : 
		Title = "cardtitle_sbd";
		break;

		case 319 : 
		Title = "cardtitle_spectre";
		break;

		case 320 : 
		Title = "cardtitle_jollygreen";
		break;

		case 321 : 
		Title = "cardtitle_gambler";
		break;

		case 322 : 
		Title = "cardtitle_spirit";
		break;

		case 323 : 
		Title = "cardtitle_sharepackage";
		break;

		case 324 : 
		Title = "cardtitle_santaclaus";
		break;

		case 325 : 
		Title = "cardtitle_chickmagnet";
		break;

		case 326 : 
		Title = "cardtitle_mylilpwny";
		break;

		case 327 : 
		Title = "cardtitle_booyah";
		break;

		case 328 : 
		Title = "cardtitle_streaker";
		break;

		case 329 : 
		Title = "cardtitle_1bullet2kills";
		break;

		case 330 : 
		Title = "cardtitle_dictator";
		break;

		case 331 : 
		Title = "cardtitle_surgical";
		break;

		case 332 : 
		Title = "cardtitle_crackinskulls";
		break;

		case 333 : 
		Title = "cardtitle_popoff";
		break;

		case 334 : 
		Title = "cardtitle_boomheadshot";
		break;

		case 335 : 
		Title = "cardtitle_faceoff";
		break;

		case 336 : 
		Title = "cardtitle_headrush";
		break;

		case 337 : 
		Title = "cardtitle_mach5";
		break;

		case 338 : 
		Title = "cardtitle_notintheface";
		break;

		case 339 : 
		Title = "cardtitle_perfectionist";
		break;

		case 340 : 
		Title = "cardtitle_badaboom";
		break;

		case 341 : 
		Title = "cardtitle_genocidal";
		break;

		case 342 : 
		Title = "cardtitle_partinggift";
		break;

		case 343 : 
		Title = "cardtitle_ambush";
		break;

		case 344 : 
		Title = "cardtitle_pinpuller";
		break;

		case 345 : 
		Title = "cardtitle_boomboompow";
		break;

		case 346 : 
		Title = "cardtitle_anarchist";
		break;

		case 347 : 
		Title = "cardtitle_highlander";
		break;

		case 348 : 
		Title = "cardtitle_enemybenefits";
		break;

		case 349 : 
		Title = "cardtitle_nbk";
		break;

		case 350 : 
		Title = "cardtitle_allpro";
		break;

		case 351 : 
		Title = "cardtitle_hardtarget";
		break;

		case 352 : 
		Title = "cardtitle_dronekiller";
		break;

		case 353 : 
		Title = "cardtitle_truelies";
		break;

		case 354 : 
		Title = "cardtitle_transformer";
		break;

		case 355 : 
		Title = "cardtitle_deathfromabove";
		break;

		case 356 : 
		Title = "cardtitle_droppincrates";
		break;

		case 357 : 
		Title = "cardtitle_hidef";
		break;

		case 358 : 
		Title = "cardtitle_unbelievable";
		break;

		case 359 : 
		Title = "cardtitle_stickman";
		break;

		case 360 : 
		Title = "cardtitle_lastresort";
		break;

		case 361 : 
		Title = "cardtitle_absenteekiller";
		break;

		case 362 : 
		Title = "cardtitle_finishingtouch";
		break;

		case 363 : 
		Title = "cardtitle_og";
		break;

		case 364 : 
		Title = "cardtitle_technokiller";
		break;

		case 365 : 
		Title = "cardtitle_owned";
		break;

		case 366 : 
		Title = "cardtitle_boilermaker";
		break;

		case 367 : 
		Title = "cardtitle_backstabber";
		break;

		case 368 : 
		Title = "cardtitle_stungun";
		break;

		case 369 : 
		Title = "cardtitle_noobtuber";
		break;

		case 370 : 
		Title = "cardtitle_rival";
		break;

		case 371 : 
		Title = "cardtitle_thinkfast";
		break;

		case 372 : 
		Title = "cardtitle_concussive";
		break;

		case 373 : 
		Title = "cardtitle_lightsout";
		break;

		case 374 : 
		Title = "cardtitle_backfire";
		break;

		case 375 : 
		Title = "cardtitle_blindfire";
		break;

		case 376 : 
		Title = "cardtitle_duckhunter";
		break;

		case 377 : 
		Title = "cardtitle_omnicide";
		break;

		case 378 : 
		Title = "cardtitle_devastator";
		break;

		case 379 : 
		Title = "cardtitle_mvpassassin";
		break;

		case 380 : 
		Title = "cardtitle_heart";
		break;

		case 381 : 
		Title = "cardtitle_tagyoureit";
		break;

		case 382 : 
		Title = "cardtitle_timeismoney";
		break;

		case 383 : 
		Title = "cardtitle_imrich";
		break;

		case 384 : 
		Title = "cardtitle_moneyshot";
		break;

		case 385 : 
		Title = "cardtitle_makeitrain";
		break;

		case 386 : 
		Title = "cardtitle_clayback";
		break;

		case 387 : 
		Title = "cardtitle_robinhood";
		break;

		case 388 : 
		Title = "cardtitle_madman";
		break;

		case 389 : 
		Title = "cardtitle_idthief";
		break;

		case 390 : 
		Title = "cardtitle_newjack";
		break;

		case 391 : 
		Title = "cardtitle_bloodmoney";
		break;

		case 392 : 
		Title = "cardtitle_flatliner";
		break;

		case 393 : 
		Title = "cardtitle_evildead";
		break;

		case 394 : 
		Title = "cardtitle_quickdraw";
		break;

		case 395 : 
		Title = "cardtitle_hiredgun";
		break;

		case 396 : 
		Title = "cardtitle_mastatdon";
		break;

		case 397 : 
		Title = "cardtitle_howthe";
		break;

		case 398 : 
		Title = "cardtitle_dominofx";
		break;

		case 399 : 
		Title = "cardtitle_halfbaked";
		break;

		case 400 : 
		Title = "cardtitle_bam";
		break;

		case 401 : 
		Title = "cardtitle_invincible";
		break;

		case 402 : 
		Title = "cardtitle_livelong";
		break;

		case 403 : 
		Title = "cardtitle_claypigeon";
		break;

		case 404 : 
		Title = "cardtitle_reversaloffortune";
		break;

		case 405 : 
		Title = "cardtitle_iceman";
		break;

		case 406 : 
		Title = "cardtitle_enemyofthestate";
		break;

		case 407 : 
		Title = "cardtitle_friendswith";
		break;

		case 408 : 
		Title = "cardtitle_legend";
		break;

		case 409 : 
		Title = "cardtitle_wargasm";
		break;

		case 410 : 
		Title = "cardtitle_biggertheyare";
		break;

		case 411 : 
		Title = "cardtitle_harderthey";
		break;

		case 412 : 
		Title = "cardtitle_epic";
		break;

		case 413 : 
		Title = "cardtitle_denier";
		break;

		case 414 : 
		Title = "cardtitle_carpetbomber";
		break;

		case 415 : 
		Title = "cardtitle_bombsaway";
		break;

		case 416 : 
		Title = "cardtitle_grimreaper";
		break;

		case 417 : 
		Title = "cardtitle_bigbrother";
		break;

		case 418 : 
		Title = "cardtitle_uavrays";
		break;

		case 419 : 
		Title = "cardtitle_afterburner";
		break;

		case 420 : 
		Title = "cardtitle_topgun";
		break;

		case 421 : 
		Title = "cardtitle_gat";
		break;

		case 422 : 
		Title = "cardtitle_theripper";
		break;

		case 423 : 
		Title = "cardtitle_allyourbase";
		break;

		case 424 : 
		Title = "cardtitle_globalthermo";
		break;

		case 425 : 
		Title = "cardtitle_theextreme";
		break;

		case 426 : 
		Title = "cardtitle_earlydetection";
		break;

		case 427 : 
		Title = "cardtitle_trackstar";
		break;

		case 428 : 
		Title = "cardtitle_freerunner";
		break;

		case 429 : 
		Title = "cardtitle_decathlete";
		break;

		case 430 : 
		Title = "cardtitle_2fast";
		break;

		case 431 : 
		Title = "cardtitle_hairtrigger";
		break;

		case 432 : 
		Title = "cardtitle_oneinchpunch";
		break;

		case 433 : 
		Title = "cardtitle_reloaded";
		break;

		case 434 : 
		Title = "cardtitle_bandolier";
		break;

		case 435 : 
		Title = "cardtitle_vulture";
		break;

		case 436 : 
		Title = "cardtitle_fullforce";
		break;

		case 437 : 
		Title = "cardtitle_sonicboom";
		break;

		case 438 : 
		Title = "cardtitle_dangerclose";
		break;

		case 439 : 
		Title = "cardtitle_doubledown";
		break;

		case 440 : 
		Title = "cardtitle_blingbling";
		break;

		case 441 : 
		Title = "cardtitle_armedanddangerous";
		break;

		case 442 : 
		Title = "cardtitle_highcaliber";
		break;

		case 443 : 
		Title = "cardtitle_kfactor";
		break;

		case 444 : 
		Title = "cardtitle_bitethebullet";
		break;

		case 445 : 
		Title = "cardtitle_speeddemon";
		break;

		case 446 : 
		Title = "cardtitle_readyfire";
		break;

		case 447 : 
		Title = "cardtitle_pathfinder";
		break;

		case 448 : 
		Title = "cardtitle_deadline";
		break;

		case 449 : 
		Title = "cardtitle_closesupport";
		break;

		case 450 : 
		Title = "cardtitle_invisible";
		break;

		case 451 : 
		Title = "cardtitle_uavjammer";
		break;

		case 452 : 
		Title = "cardtitle_doubleagent";
		break;

		case 453 : 
		Title = "cardtitle_fullarsenal";
		break;

		case 454 : 
		Title = "cardtitle_quickchange";
		break;

		case 455 : 
		Title = "cardtitle_armyof1";
		break;

		case 456 : 
		Title = "cardtitle_impaler";
		break;

		case 457 : 
		Title = "cardtitle_ninja";
		break;

		case 458 : 
		Title = "cardtitle_excalibur";
		break;

		case 459 : 
		Title = "cardtitle_sureshot";
		break;

		case 460 : 
		Title = "cardtitle_ironlungs";
		break;

		case 461 : 
		Title = "cardtitle_steelnerves";
		break;

		case 462 : 
		Title = "cardtitle_hardtokill";
		break;

		case 463 : 
		Title = "cardtitle_deadmansswitch";
		break;

		case 464 : 
		Title = "cardtitle_dyingbreath";
		break;

		case 465 : 
		Title = "cardtitle_disruptor";
		break;

		case 466 : 
		Title = "cardtitle_heartbreaker";
		break;

		case 467 : 
		Title = "cardtitle_counterintel";
		break;

		case 468 : 
		Title = "cardtitle_xrayvision";
		break;

		case 469 : 
		Title = "cardtitle_amplifier";
		break;

		case 470 : 
		Title = "cardtitle_eod";
		break;

		case 471 : 
		Title = "cardtitle_silentstrike";
		break;

		case 472 : 
		Title = "cardtitle_spygame";
		break;

		case 473 : 
		Title = "cardtitle_artofstealth";
		break;

		case 474 : 
		Title = "cardtitle_toxicavenger";
		break;

		case 475 : 
		Title = "cardtitle_infected";
		break;

		case 476 : 
		Title = "cardtitle_plague";
		break;

		case 477 : 
		Title = "cardtitle_klepto";
		break;

		case 478 : 
		Title = "cardtitle_behindenemy";
		break;

		case 479 : 
		Title = "cardtitle_6fears7";
		break;

		case 480 : 
		Title = "cardtitle_comfortablynumb";
		break;

		case 481 : 
		Title = "cardtitle_martyr";
		break;

		case 482 : 
		Title = "cardtitle_livingdead";
		break;

		case 483 : 
		Title = "cardtitle_sidekick";
		break;

		case 484 : 
		Title = "cardtitle_clickclickboom";
		break;

		case 485 : 
		Title = "cardtitle_hijacker";
		break;

		case 486 : 
		Title = "cardtitle_bountyhunter";
		break;

		case 487 : 
		Title = "cardtitle_no";
		break;

		case 488 : 
		Title = "cardtitle_sentrymaster";
		break;

		case 489 : 
		Title = "cardtitle_predatormaster";
		break;

		case 490 : 
		Title = "cardtitle_airstrikemaster";
		break;

		case 491 : 
		Title = "cardtitle_harriermaster";
		break;

		case 492 : 
		Title = "cardtitle_helimaster";
		break;

		case 493 : 
		Title = "cardtitle_pavelowmaster";
		break;

		case 494 : 
		Title = "cardtitle_stealthmaster";
		break;

		case 495 : 
		Title = "cardtitle_choppermaster";
		break;

		case 496 : 
		Title = "cardtitle_ac130master";
		break;

		case 497 : 
		Title = "cardtitle_blademaster";
		break;

		case 498 : 
		Title = "cardtitle_laststandmaster";
		break;

		case 499 : 
		Title = "cardtitle_silencermaster";
		break;

		case 500 : 
		Title = "cardtitle_flashmaster";
		break;

		case 501 : 
		Title = "cardtitle_stunmaster";
		break;

		case 502 : 
		Title = "cardtitle_sentryveteran";
		break;

		case 503 : 
		Title = "cardtitle_predatorveteran";
		break;

		case 504 : 
		Title = "cardtitle_airstrikeveteran";
		break;

		case 505 : 
		Title = "cardtitle_harrierveteran";
		break;

		case 506 : 
		Title = "cardtitle_heliveteran";
		break;

		case 507 : 
		Title = "cardtitle_pavelowveteran";
		break;

		case 508 : 
		Title = "cardtitle_stealthveteran";
		break;

		case 509 : 
		Title = "cardtitle_chopperveteran";
		break;

		case 510 : 
		Title = "cardtitle_ac130veteran";
		break;

		case 511 : 
		Title = "cardtitle_bladeveteran";
		break;

		case 512 : 
		Title = "cardtitle_laststandveteran";
		break;

		case 513 : 
		Title = "cardtitle_silencerveteran";
		break;

		case 514 : 
		Title = "cardtitle_flashveteran";
		break;

		case 515 : 
		Title = "cardtitle_stunveteran";
		break;

		case 516 : 
		Title = "cardtitle_headsup";
		break;

		case 517 : 
		Title = "cardtitle_predator";
		break;

		case 518 : 
		Title = "cardtitle_automator";
		break;

		case 519 : 
		Title = "cardtitle_shotover";
		break;

		case 520 : 
		Title = "cardtitle_stringfellow";
		break;

		case 521 : 
		Title = "cardtitle_doctor";
		break;

		case 522 : 
		Title = "cardtitle_coldsteel";
		break;

		case 523 : 
		Title = "cardtitle_inciser";
		break;

		case 524 : 
		Title = "cardtitle_phoenixrising";
		break;

		case 525 : 
		Title = "cardtitle_suppressor";
		break;

		case 526 : 
		Title = "cardtitle_shockandawe";
		break;

		case 527 : 
		Title = "cardtitle_flasher";
		break;

		case 528 : 
		Title = "cardtitle_handsfree";
		break;

		case 529 : 
		Title = "cardtitle_clusterbomb";
		break;

		case 530 : 
		Title = "cardtitle_rejected";
		break;

		case 531 : 
		Title = "cardtitle_skycaptain";
		break;

		case 532 : 
		Title = "cardtitle_cobrakai";
		break;

		case 533 : 
		Title = "cardtitle_godhand";
		break;

		case 534 : 
		Title = "cardtitle_ssdd";
		break;

		case 535 : 
		Title = "cardtitle_prestige1";
		break;

		case 536 : 
		Title = "cardtitle_prestige2";
		break;

		case 537 : 
		Title = "cardtitle_prestige3";
		break;

		case 538 : 
		Title = "cardtitle_prestige4";
		break;

		case 539 : 
		Title = "cardtitle_prestige5";
		break;

		case 540 : 
		Title = "cardtitle_prestige6";
		break;

		case 541 : 
		Title = "cardtitle_prestige7";
		break;

		case 542 : 
		Title = "cardtitle_prestige8";
		break;

		case 543 : 
		Title = "cardtitle_prestige9";
		break;

		case 544 : 
		Title = "cardtitle_prestige10";
		break;

		case 545 : 
		Title = "cardtitle_fng";
		break;

		case 546 : 
		Title = "cardtitle_20";
		break;

		case 547 : 
		Title = "cardtitle_30";
		break;

		case 548 : 
		Title = "cardtitle_40";
		break;

		case 549 : 
		Title = "cardtitle_50";
		break;

		case 550 : 
		Title = "cardtitle_60";
		break;

		case 551 : 
		Title = "cardtitle_70";
		break;

		case 552 : 
		Title = "cardtitle_20a";
		break;

		case 553 : 
		Title = "cardtitle_30a";
		break;

		case 554 : 
		Title = "cardtitle_40a";
		break;

		case 555 : 
		Title = "cardtitle_50a";
		break;

		case 556 : 
		Title = "cardtitle_60a";
		break;

		case 557 : 
		Title = "cardtitle_70a";
		break;

		case 558 : 
		Title = "cardtitle_grassyknoll";
		break;

		case 559 : 
		Title = "cardtitle_ghilliemist";
		break;

		case 560 : 
		Title = "cardtitle_rezero";
		break;

		case 561 : 
		Title = "cardtitle_blunttrauma";
		break;

		case 562 : 
		Title = "cardtitle_smashhit";
		break;

		case 563 : 
		Title = "cardtitle_backsmasher";
		break;

		case 564 : 
		Title = "cardtitle_protectserve";
		break;

		case 565 : 
		Title = "cardtitle_bulletproof";
		break;

		case 566 : 
		Title = "cardtitle_unbreakable";
		break;

		case 567 : 
		Title = "cardtitle_preemptive";
		break;
	}
	self.pers["randtitle"] = Title;
	self SetcardTitle(self.pers["randtitle"]);
}

EmblemRAND()
{
	Emblem = "";
	switch(randomint(296))
	{
		case 0 : 
		Emblem = "cardicon_1stlt1";
		break;

		case 1 : 
		Emblem = "cardicon_1stsgt1";
		break;

		case 2 : 
		Emblem = "cardicon_2ndlt1";
		break;

		case 3 : 
		Emblem = "cardicon_8ball";
		break;

		case 4 : 
		Emblem = "cardicon_8bit_price";
		break;

		case 7 : 
		Emblem = "cardicon_abduction";
		break;

		case 8 : 
		Emblem = "cardicon_ac130";
		break;

		case 9 : 
		Emblem = "cardicon_ac130_angelflare";
		break;

		case 12 : 
		Emblem = "cardicon_assad";
		break;

		case 13 : 
		Emblem = "cardicon_attackchopper";
		break;

		case 16 : 
		Emblem = "cardicon_b2";
		break;

		case 17 : 
		Emblem = "cardicon_badgirl";
		break;

		case 18 : 
		Emblem = "cardicon_ball_baseball_1";
		break;

		case 19 : 
		Emblem = "cardicon_ball_basketball_1";
		break;

		case 20 : 
		Emblem = "cardicon_ball_football_1";
		break;

		case 21 : 
		Emblem = "cardicon_ball_soccer_1";
		break;

		case 22 : 
		Emblem = "cardicon_ball_volleyball_1";
		break;

		case 25 : 
		Emblem = "cardicon_bear";
		break;

		case 30 : 
		Emblem = "cardicon_bgen1";
		break;

		case 31 : 
		Emblem = "cardicon_biohazard";
		break;

		case 32 : 
		Emblem = "cardicon_birdbrain";
		break;

		case 33 : 
		Emblem = "cardicon_blastshield";
		break;

		case 34 : 
		Emblem = "cardicon_bling";
		break;

		case 35 : 
		Emblem = "cardicon_blue";
		break;

		case 36 : 
		Emblem = "cardicon_boot";
		break;

		case 37 : 
		Emblem = "cardicon_brad";
		break;

		case 38 : 
		Emblem = "cardicon_brassknuckle";
		break;

		case 39 : 
		Emblem = "cardicon_brassknuckles";
		break;

		case 40 : 
		Emblem = "cardicon_brock";
		break;

		case 41 : 
		Emblem = "cardicon_bulb";
		break;

		case 42 : 
		Emblem = "cardicon_bulletcase";
		break;

		case 43 : 
		Emblem = "cardicon_bullets_50cal";
		break;

		case 44 : 
		Emblem = "cardicon_burgertown";
		break;

		case 45 : 
		Emblem = "cardicon_c4";
		break;

		case 46 : 
		Emblem = "cardicon_capt1";
		break;

		case 47 : 
		Emblem = "cardicon_car";
		break;

		case 48 : 
		Emblem = "cardicon_carepackage";
		break;

		case 51 : 
		Emblem = "cardicon_chicken";
		break;

		case 52 : 
		Emblem = "cardicon_choppergunner";
		break;

		case 53 : 
		Emblem = "cardicon_claw";
		break;

		case 54 : 
		Emblem = "cardicon_claymore";
		break;

		case 55 : 
		Emblem = "cardicon_cmdsgtmaj1";
		break;

		case 56 : 
		Emblem = "cardicon_cod4";
		break;

		case 57 : 
		Emblem = "cardicon_col1";
		break;

		case 58 : 
		Emblem = "cardicon_coldblooded";
		break;

		case 61 : 
		Emblem = "cardicon_comic_price";
		break;

		case 62 : 
		Emblem = "cardicon_comic_shepherd";
		break;

		case 63 : 
		Emblem = "cardicon_comm1";
		break;

		case 64 : 
		Emblem = "cardicon_commando";
		break;

		case 65 : 
		Emblem = "cardicon_compass";
		break;

		case 66 : 
		Emblem = "cardicon_copycat";
		break;

		case 67 : 
		Emblem = "cardicon_counteruav";
		break;

		case 68 : 
		Emblem = "cardicon_cpl1";
		break;

		case 69 : 
		Emblem = "cardicon_dangerclose";
		break;

		case 70 : 
		Emblem = "cardicon_default";
		break;

		case 73 : 
		Emblem = "cardicon_devil";
		break;

		case 74 : 
		Emblem = "cardicon_devilfinger";
		break;

		case 75 : 
		Emblem = "cardicon_dive";
		break;

		case 76 : 
		Emblem = "cardicon_doubletap";
		break;

		case 77 : 
		Emblem = "cardicon_emergencyair";
		break;

		case 78 : 
		Emblem = "cardicon_empkillstreak";
		break;

		case 83 : 
		Emblem = "cardicon_finalstand";
		break;

		case 84 : 
		Emblem = "cardicon_fmj";
		break;

		case 87 : 
		Emblem = "cardicon_frag";
		break;

		case 88 : 
		Emblem = "cardicon_gametype";
		break;

		case 89 : 
		Emblem = "cardicon_gasmask";
		break;

		case 90 : 
		Emblem = "cardicon_gears";
		break;

		case 91 : 
		Emblem = "cardicon_gen1";
		break;

		case 92 : 
		Emblem = "cardicon_ghillie";
		break;

		case 93 : 
		Emblem = "cardicon_ghost_bust";
		break;

		case 94 : 
		Emblem = "cardicon_ghost_skull";
		break;

		case 95 : 
		Emblem = "cardicon_girlskull";
		break;

		case 98 : 
		Emblem = "cardicon_gold";
		break;

		case 99 : 
		Emblem = "cardicon_goodgirl";
		break;

		case 100 : 
		Emblem = "cardicon_grigsby";
		break;

		case 101 : 
		Emblem = "cardicon_grunt";
		break;

		case 102 : 
		Emblem = "cardicon_grunt_2";
		break;

		case 103 : 
		Emblem = "cardicon_gumby";
		break;

		case 104 : 
		Emblem = "cardicon_hardline";
		break;

		case 105 : 
		Emblem = "cardicon_harrier";
		break;

		case 106 : 
		Emblem = "cardicon_harrierstrike";
		break;

		case 107 : 
		Emblem = "cardicon_headshot";
		break;

		case 108 : 
		Emblem = "cardicon_heartbeatsensor";
		break;

		case 109 : 
		Emblem = "cardicon_helmet_baseball_1";
		break;

		case 110 : 
		Emblem = "cardicon_helmet_football_1";
		break;

		case 111 : 
		Emblem = "cardicon_hockey_1";
		break;

		case 112 : 
		Emblem = "cardicon_hockey_2";
		break;

		case 113 : 
		Emblem = "cardicon_honeybadger01";
		break;

		case 114 : 
		Emblem = "cardicon_humantrophy";
		break;

		case 115 : 
		Emblem = "cardicon_hyena";
		break;

		case 116 : 
		Emblem = "cardicon_icecream";
		break;

		case 117 : 
		Emblem = "cardicon_illuminati";
		break;

		case 118 : 
		Emblem = "cardicon_impale";
		break;

		case 119 : 
		Emblem = "cardicon_iss";
		break;

		case 120 : 
		Emblem = "cardicon_iw";
		break;

		case 121 : 
		Emblem = "cardicon_iwlogo";
		break;

		case 122 : 
		Emblem = "cardicon_jets";
		break;

		case 123 : 
		Emblem = "cardicon_joystick";
		break;

		case 124 : 
		Emblem = "cardicon_juggernaut_1";
		break;

		case 125 : 
		Emblem = "cardicon_juggernaut_2";
		break;

		case 126 : 
		Emblem = "cardicon_kinggorilla";
		break;

		case 127 : 
		Emblem = "cardicon_kitten";
		break;

		case 128 : 
		Emblem = "cardicon_knife";
		break;

		case 129 : 
		Emblem = "cardicon_knife_logo";
		break;

		case 130 : 
		Emblem = "cardicon_koiker_hound";
		break;

		case 131 : 
		Emblem = "cardicon_korean";
		break;

		case 134 : 
		Emblem = "cardicon_laststand";
		break;

		case 135 : 
		Emblem = "cardicon_league_1911";
		break;

		case 136 : 
		Emblem = "cardicon_league_grenade";
		break;

		case 137 : 
		Emblem = "cardicon_league_magnum";
		break;

		case 138 : 
		Emblem = "cardicon_lightweight";
		break;

		case 139 : 
		Emblem = "cardicon_lion";
		break;

		case 140 : 
		Emblem = "cardicon_loadedfinger";
		break;

		case 141 : 
		Emblem = "cardicon_ltcol1";
		break;

		case 142 : 
		Emblem = "cardicon_ltgen1";
		break;

		case 153 : 
		Emblem = "cardicon_macgregor";
		break;

		case 154 : 
		Emblem = "cardicon_maj1";
		break;

		case 155 : 
		Emblem = "cardicon_majgen1";
		break;

		case 156 : 
		Emblem = "cardicon_makarov";
		break;

		case 157 : 
		Emblem = "cardicon_marathon";
		break;

		case 158 : 
		Emblem = "cardicon_martyrdom";
		break;

		case 163 : 
		Emblem = "cardicon_minigun";
		break;

		case 166 : 
		Emblem = "cardicon_moon";
		break;

		case 169 : 
		Emblem = "cardicon_msgt1";
		break;

		case 170 : 
		Emblem = "cardicon_mushroom";
		break;

		case 171 : 
		Emblem = "cardicon_mw2_prestige1";
		break;

		case 172 : 
		Emblem = "cardicon_mw2_prestige10";
		break;

		case 173 : 
		Emblem = "cardicon_mw2_prestige2";
		break;

		case 174 : 
		Emblem = "cardicon_mw2_prestige3";
		break;

		case 175 : 
		Emblem = "cardicon_mw2_prestige4";
		break;

		case 176 : 
		Emblem = "cardicon_mw2_prestige5";
		break;

		case 177 : 
		Emblem = "cardicon_mw2_prestige6";
		break;

		case 178 : 
		Emblem = "cardicon_mw2_prestige7";
		break;

		case 179 : 
		Emblem = "cardicon_mw2_prestige8";
		break;

		case 180 : 
		Emblem = "cardicon_mw2_prestige9";
		break;

		case 181 : 
		Emblem = "cardicon_nates";
		break;

		case 182 : 
		Emblem = "cardicon_nightvision_1";
		break;

		case 183 : 
		Emblem = "cardicon_nightvision_2";
		break;

		case 184 : 
		Emblem = "cardicon_ninja";
		break;

		case 185 : 
		Emblem = "cardicon_noseart1";
		break;

		case 186 : 
		Emblem = "cardicon_oma";
		break;

		case 189 : 
		Emblem = "cardicon_pacifier_blue";
		break;

		case 190 : 
		Emblem = "cardicon_pacifier_pink";
		break;

		case 191 : 
		Emblem = "cardicon_painkiller";
		break;

		case 192 : 
		Emblem = "cardicon_patch";
		break;

		case 193 : 
		Emblem = "cardicon_pavelow";
		break;

		case 194 : 
		Emblem = "cardicon_pavelowkillstreak";
		break;

		case 195 : 
		Emblem = "cardicon_pfc1";
		break;

		case 196 : 
		Emblem = "cardicon_pirate";
		break;

		case 197 : 
		Emblem = "cardicon_pirateflag";
		break;

		case 198 : 
		Emblem = "cardicon_porterjustice";
		break;

		case 201 : 
		Emblem = "cardicon_precair";
		break;

		case 202 : 
		Emblem = "cardicon_predatormissile";
		break;

		case 203 : 
		Emblem = "cardicon_prestige1";
		break;

		case 204 : 
		Emblem = "cardicon_prestige10";
		break;

		case 205 : 
		Emblem = "cardicon_prestige10_02";
		break;

		case 206 : 
		Emblem = "cardicon_prestige2";
		break;

		case 207 : 
		Emblem = "cardicon_prestige3";
		break;

		case 208 : 
		Emblem = "cardicon_prestige4";
		break;

		case 209 : 
		Emblem = "cardicon_prestige5";
		break;

		case 210 : 
		Emblem = "cardicon_prestige6";
		break;

		case 211 : 
		Emblem = "cardicon_prestige7";
		break;

		case 212 : 
		Emblem = "cardicon_prestige8";
		break;

		case 213 : 
		Emblem = "cardicon_prestige9";
		break;

		case 214 : 
		Emblem = "cardicon_price_ww2";
		break;

		case 215 : 
		Emblem = "cardicon_pricearctic";
		break;

		case 216 : 
		Emblem = "cardicon_pricewoodland";
		break;

		case 217 : 
		Emblem = "cardicon_pushingupdaisies";
		break;

		case 218 : 
		Emblem = "cardicon_pvt1";
		break;

		case 219 : 
		Emblem = "cardicon_radiation";
		break;

		case 222 : 
		Emblem = "cardicon_readhead";
		break;

		case 223 : 
		Emblem = "cardicon_redhand";
		break;

		case 224 : 
		Emblem = "cardicon_rhino";
		break;

		case 225 : 
		Emblem = "cardicon_riot_shield";
		break;

		case 226 : 
		Emblem = "cardicon_riotdeath";
		break;

		case 233 : 
		Emblem = "cardicon_scavenger";
		break;

		case 234 : 
		Emblem = "cardicon_scrambler";
		break;

		case 235 : 
		Emblem = "cardicon_seasnipers";
		break;

		case 236 : 
		Emblem = "cardicon_semtex";
		break;

		case 237 : 
		Emblem = "cardicon_sentrygun";
		break;

		case 238 : 
		Emblem = "cardicon_sfc1";
		break;

		case 239 : 
		Emblem = "cardicon_sgt1";
		break;

		case 240 : 
		Emblem = "cardicon_sgtmaj1";
		break;

		case 241 : 
		Emblem = "cardicon_sheppard";
		break;

		case 242 : 
		Emblem = "cardicon_shotgun_shells";
		break;

		case 243 : 
		Emblem = "cardicon_sitrep";
		break;

		case 244 : 
		Emblem = "cardicon_skull";
		break;

		case 245 : 
		Emblem = "cardicon_skull_black";
		break;

		case 246 : 
		Emblem = "cardicon_skullaward";
		break;

		case 247 : 
		Emblem = "cardicon_sleightofhand";
		break;

		case 248 : 
		Emblem = "cardicon_sniper";
		break;

		case 249 : 
		Emblem = "cardicon_sniperscope";
		break;

		case 250 : 
		Emblem = "cardicon_soap";
		break;

		case 253 : 
		Emblem = "cardicon_spc1";
		break;

		case 254 : 
		Emblem = "cardicon_spetsnaz";
		break;

		case 255 : 
		Emblem = "cardicon_ssgt1";
		break;

		case 256 : 
		Emblem = "cardicon_stab";
		break;

		case 257 : 
		Emblem = "cardicon_steadyaim";
		break;

		case 258 : 
		Emblem = "cardicon_stealthkillstreak";
		break;

		case 259 : 
		Emblem = "cardicon_stop";
		break;

		case 260 : 
		Emblem = "cardicon_stoppingpower";
		break;

		case 263 : 
		Emblem = "cardicon_sugarglider";
		break;

		case 264 : 
		Emblem = "cardicon_tacticalinsertion";
		break;

		case 265 : 
		Emblem = "cardicon_tacticalnuke";
		break;

		case 266 : 
		Emblem = "cardicon_taskforcearmy01";
		break;

		case 269 : 
		Emblem = "cardicon_tennisracket";
		break;

		case 270 : 
		Emblem = "cardicon_tf141";
		break;

		case 271 : 
		Emblem = "cardicon_thebomb";
		break;

		case 272 : 
		Emblem = "cardicon_thecow";
		break;

		case 273 : 
		Emblem = "cardicon_throwingknife";
		break;

		case 274 : 
		Emblem = "cardicon_tictac";
		break;

		case 275 : 
		Emblem = "cardicon_tiger";
		break;

		case 276 : 
		Emblem = "cardicon_tire";
		break;

		case 279 : 
		Emblem = "cardicon_toon_price_1";
		break;

		case 280 : 
		Emblem = "cardicon_treasurechest";
		break;

		case 281 : 
		Emblem = "cardicon_treasuremap";
		break;

		case 282 : 
		Emblem = "cardicon_tsuenami";
		break;

		case 283 : 
		Emblem = "cardicon_tsunami";
		break;

		case 284 : 
		Emblem = "cardicon_uav";
		break;

		case 285 : 
		Emblem = "cardicon_umbracatervae";
		break;

		case 294 : 
		Emblem = "cardicon_warpig";
		break;

		case 295 : 
		Emblem = "cardicon_weed";
		break;

		case 296 : 
		Emblem = "cardicon_xray";
		break;
	}
	self.pers["randemblem"] = Emblem;
	self SetcardIcon(self.pers["randemblem"]);
}