# The Bronx Pack
-updated since all client have gsc support in some way now, ignore old tutorial
-old mods can still be found in the bronx 3.0 folder
-if you are having trouble please read all of the documentation i provided, it may be a lot but trust me it is worth it <br />
# FAQ
Q- how do we connect to eachother on plutonium? <br />
A- add them via [Plutonium Fourm](https://forum.plutonium.pw and join/invite with the in game friends list) <br />
 <br />
Q- why can we not connect to eachother even with radmin? <br />
A- try another host or restart your game/pc <br />
 <br />
Q- why did the mod not load? <br />
A- double check your folders and make sure they match the tutorial <br />
 <br />
 <br />
Q- where is the download link? <br />
A- click on the green code button on the main page of this repository, and click download as zip <br />
 <br />
Q- how do i get tac inserts and tks on s1x? <br />
A- download this zip file and replace the files in your players2 folder <br />
[S1x Tac Insert/Throwing Knife Player Data Files](https://drive.google.com/file/d/1id8WatOmAC8nVLZZO45oBVlUnP1dT1Wr/view) <br />
# How to Connect to Friends <br />
These methods may not work, as some people just cannot connect to eachother, if that is the case find a host everyone can connect to <br />
## (XLabs/H1-Mod)
-use radmin vpn and join a network together <br />
-open the dev console, press this key (~), and type /connect "host ip" <br />
-for example if the host ip was 0.0.0.0 you would type /connect 0.0.0.0 <br />
-watch this tutorial to see how its done https://youtu.be/MZ1bKhVFUTA?t=508 <br />
**IW4x Everyone must have the same mod loaded, before joining, if you edit one file, zip the mod and send to your friends <br />
## (Plutonium)
-add your friends on the plutonium forum by clicking the + button on the top right of the profile <br />
-they shold then appear on you in game friends list, then join them or start a party(bo2 only) <br />
-you may have to invite if your game is set to invite only <br />
# Instal Guides/Refernces
-when you download this full repository each game's mod is found in the folder with the game name <br />
-here is some good references to look at if you are struggling to setup the mod <br />
-all the mods have a brief text guide showing how to install so please check that out as well, i advise you to read that as well before reaching out to me directly <br />
-also if all else fails, ask a friend, or dm me directly on twitter @plugwalker47 or discord joey#9504 <br />
 <br />
IW4x -https://xlabs.dev/mod_guide <br />
-put the iw4xbronx folder in your mods folder and launch like a normal mod<br />
IW6x <br />
-place bronx_iw6x.gsc in iw6x_full_game\scripts (iw6x_full_game) is whatever your game folder is <br />
S1x <br />
-place bronx_s1x.gsc in s1x_full_game\scripts (s1x_full_game) is whatever your game folder is <br />
T5 Plutonium - https://twitter.com/plugwalker47/status/1533631002601455616 <br />
-put bronx.gsc in %localappdata%\Plutonium\storage\t5\scripts <br />
IW5 Plutonium - [Loading Existing Mods on IW5](https://plutonium.pw/docs/modding/loading-mods/#loading-existing-mods-on-iw5) <br />
-put bronx_iw5.gsc in %localappdata%\Plutonium\storage\iw5\scripts <br />
T6 Plutonium - [Loading Existing Mods on T6](https://plutonium.pw/docs/modding/loading-mods/#loading-existing-mods-on-t60) <br />
-put bronx_t6.gsc in %localappdata%\Plutonium\storage\t6\scripts\mp <br />
BO3 Steam - [BO3 GSC Script Injector/Compiler](https://www.youtube.com/watch?v=7MepTbdJlmU&ab_channel=Serious) <br />
-install the compiler and follow the tutorial showing how to run scripts <br />
	-open project i made <br />
	-inject in prgame lobby <br />
# Lobby Setup
## (IW4x)
-choose the game mode search and destory <br />
-the mod automatically setups up the game rules for you <br />
-bot auto connects in when host spawns on first round <br />
-teams are auto assigned with humans always being on the same team <br />
## (IW6x)
-choose the game mode search and rescue <br />
-the mod automatically setups up the game rules for you <br />
-when in game type "spawnbot" in console to add a bot <br />
## (S1x)
-choose the game modes search and destroy or search and rescue <br />
-add an enemy bot in the pregame menu <br />
-the mod automatically setups up the game rules for you <br />
 <br />
## (Plutonium T5)
-choose the game mode search and destory <br />
-the mod automatically setups up the game rules for you <br />
-bot auto connects in when host spawns on first round <br />
## (Plutonium IW5)
-choose the game mode search and destory <br />
-the mod automatically setups up the game rules for you <br />
-bot auto connects in when host spawns on first round <br />
-teams are auto assigned with humans always being on the same team <br />
## (Plutonium T6)
-choose the game mode search and destory <br />
-the mod automatically setups up the game rules for you <br />
-add a bot in the pregame settings or type "spawnbot" in console in game <br />
## (Steam BO3)
-choose the game mode search and destory <br />
-the mod automatically setups up the game rules for you <br />
-add bot in pregame menu under setup bots <br />
# In Game Commands/Functions
## (IW4x)
### Host Only
-crouch + dpad left = save bot spawn to crosshair <br />
-killcam softlands can be toggled with the "g_softland" dvar in console (1/0 is on/off respectively) <br />
-use the cfg command "+skip" to skip the current map <br />
### All Players
-crouch + dpad up = drop canswap <br />
-prone + dpad up = give care package <br />
-prone + dpad down = give predator missile <br />
-crouch + knife = refill ammo and equipment <br />
### Other Notes
-everyone must download the mod in order to play, and everyone must have the same exact mod files, if you change one thing, so does everyone else. <br />
-changing bot names is done within "iw4x_full_game/iw4x/iw4x_00.iwd" (in there is a bots.txt file that will work across the whole client) <br />
-classes can be changed whenever <br />
-depatch bounces are enabled by default <br />
-at the end of game it picks a random map, i took some like wasteland, those you gotta pick in the pregame menu <br />
-steady aim and commando pro are given on spawn <br />
-bullet penetration is extremely high to avoid hitmarkers <br />
-added funny console ui bits (shoutout aerosol) <br />
## (IW6x)
### Host Only
-crouch + dpad left = save bot spawn to crosshair <br />
-host is given a kem strike on the last round <br />
### All Players
-crouch + knife = refill ammo and equipment <br />
-crouch + dpad up = drop canswap <br />
-prone + dpad up = give killstreaks <br />
-prone + dpad down = change prestige <br />
### Other Notes
-changing classes works the entire round <br />
-resilliance is not needed as fall damage is disabled <br />
-reflex and steady aim are given automatically <br />
## (S1x)
### Host Only
-crouch + dpad left = save bot spawn to crosshair <br />
-dna bomb is given to host on last round <br />
(doesnt give to your inventory, just calls it in right away)  <br />
### All Players
-crouch + knife = refill ammo and exo <br />
-crouch + dpad up = drop canswap <br />
-prone + dpad up = fill killstreaks <br />
-prone + dpad down = change prestige <br />
### Other Notes
-equip an explosive drone and it will be swapped out for right hand throwing knives (need flak jacket perk to cancel them) <br />
-equip exo overclock to get a grapple hook (only works on grapple maps) <br />
 <br />
## (Plutonium T5)
### Host Only
-crouch + dpad left = save bot spawn to crosshair <br />
### All Players
-crouch + knife = refill ammo and equipment <br />
-crouch + dpad up = drop canswap <br />
-prone + dpad up = give care package <br />
### Other Notes
-steady aim and lightweight pro are given on spawn <br />
-snipers and ars kill in one bullet <br />
-classes can be changed whenever <br />
-depatch bounces are enabled by default <br />
-bullet penetration is extremely high to avoid hitmarkers <br />
-refilling ammo with certain pistols will give a sniper as follows: <br />
	Makarov + Upgraded Sights = L96A1 <br />
	M1911 + Upgraded Sights = PSG1 <br />
-bot auto spawns when the host spawns in on the first round <br />
## (Plutonium IW5)
### Host Only
-moab is given on last round (score tied 3-3) <br />
-crouch + dpad left = save bot spawn to crosshair <br />
### All Players
-crouch + dpad up = drop canswap <br />
-prone + dpad up = give ballistic vest <br />
-prone + dpad down = give predator missile <br />
-crouch + knife = refill ammo and equipment <br />
### Other Notes
-bot names are done via bots.txt in "%localappdata%/Plutonium/storage/iw5" <br/>
-double taps are enabled <br />
-classes can be changed whenever <br />
-depatch bounces are enabled by default <br />
-dead silence pro and quickdraw pro are given on spawn <br />
-bullet penetration is extremely high to avoid hitmarkers <br />
## (Plutonium T6)
### Host Only
-crouch + dpad left = save bot spawn to crosshair <br />
### All Players
-crouch + knife = refill ammo and equipment <br />
-crouch + dpad up = drop canswap <br />
-prone + dpad up = fill all killstreaks <br />
### Other Notes
-sniperskill in one bullet <br />
-classes can be changed whenever <br />
-depatch bounces are enabled by default <br />
-bullet penetration is extremely high to avoid hitmarkers <br />
## (Steam BO3)
### Host Only
-crouch + dpad left = save bot spawn to crosshair <br />
### All Players
-crouch + knife = refill ammo and equipment <br />
-crouch + dpad up = drop canswap <br />
-prone + dpad up = fill all killstreaks <br />
### Other Notes
-authorization is done by team so always pick top team <br />
-includes console hud fix (sorta) <br />
