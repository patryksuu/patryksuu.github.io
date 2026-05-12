local notifications = {}
local notifX, notifY = 0.15, 0.08
local startX, baseY = 0.92, 0.10
local menuIsOpened = false
local menuAlpha = 0
local selectedIndex = 1
local menuVersion = "v1.0"
local scriptRunning = true
local baseNotificationColor = {255, 255, 255}
local errorNotificationColor = {255, 0, 0}
local maxVisible = 8
local scrollOffset = 0
local lastSliderChange = 0
local holdStartLeft = 0
local holdStartRight = 0
local menuStack = {}
local weaponNames = {}
local originalSpread = {}
local originalRecoil = {}
local keyBinds = keyBinds or {}
local bindCapture = nil
local bindingItem = nil
local allWeapons = {
    "WEAPON_SNOWLAUNCHER","WEAPON_COMPACTLAUNCHER","WEAPON_MINIGUN","WEAPON_GRENADELAUNCHER_SMOKE",
    "WEAPON_HOMINGLAUNCHER","WEAPON_RAILGUN","WEAPON_FIREWORK","WEAPON_GRENADELAUNCHER",
    "WEAPON_RPG","WEAPON_RAYMINIGUN","WEAPON_EMPLAUNCHER","WEAPON_RAILGUNXM3",
    "WEAPON_COMBATSHOTGUN","WEAPON_AUTOSHOTGUN","WEAPON_PUMPSHOTGUN",
    "WEAPON_HEAVYSHOTGUN","WEAPON_PUMPSHOTGUN_MK2","WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_DBSHOTGUN",
    "WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER_MK2","WEAPON_HEAVYSNIPER",
    "WEAPON_MARKSMANRIFLE_MK2","WEAPON_PRECISIONRIFLE","WEAPON_MUSKET","WEAPON_MARKSMANRIFLE",
    "WEAPON_FIREEXTINGUISHER","WEAPON_SNOWBALL","WEAPON_BALL","WEAPON_MOLOTOV",
    "WEAPON_STICKYBOMB","WEAPON_FLARE","WEAPON_GRENADE",
    "WEAPON_BZGAS","WEAPON_PROXMINE","WEAPON_PIPEBOMB",
    "WEAPON_ACIDPACKAGE","WEAPON_SMOKEGRENADE","WEAPON_VINTAGEPISTOL",
    "WEAPON_PISTOL","WEAPON_PISTOLXM3","WEAPON_APPISTOL",
    "WEAPON_CERAMICPISTOL","WEAPON_FLAREGUN","WEAPON_GADGETPISTOL",
    "WEAPON_COMBATPISTOL","WEAPON_SNSPISTOL_MK2","WEAPON_NAVYREVOLVER",
    "WEAPON_DOUBLEACTION","WEAPON_PISTOL50","WEAPON_RAYPISTOL",
    "WEAPON_SNSPISTOL","WEAPON_PISTOL_MK2",
    "WEAPON_REVOLVER","WEAPON_REVOLVER_MK2","WEAPON_HEAVYPISTOL",
    "WEAPON_MARKSMANPISTOL","WEAPON_COMBATPDW","WEAPON_MICROSMG",
    "WEAPON_TECPISTOL","WEAPON_SMG","WEAPON_SMG_MK2",
    "WEAPON_MINISMG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTSMG",
    "WEAPON_FERTILIZERCAN","WEAPON_PETROLCAN","WEAPON_HAZARDCAN","WEAPON_WRENCH",
    "WEAPON_STONE_HATCHET","WEAPON_GOLFCLUB","WEAPON_HAMMER","WEAPON_CANDYCANE",
    "WEAPON_NIGHTSTICK","WEAPON_CROWBAR","WEAPON_FLASHLIGHT","WEAPON_DAGGER",
    "WEAPON_POOLCUE","WEAPON_BAT","WEAPON_KNIFE","WEAPON_BATTLEAXE",
    "WEAPON_STUNROD","WEAPON_MACHETE","WEAPON_SWITCHBLADE",
    "WEAPON_HATCHET","WEAPON_BOTTLE","WEAPON_HACKINGDEVICE",
    "WEAPON_STUNGUN","WEAPON_STUNGUN_MP","WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_COMPACTRIFLE","WEAPON_BATTLERIFLE","WEAPON_BULLPUPRIFLE",
    "WEAPON_CARBINERIFLE","WEAPON_BULLPUPRIFLE_MK2","WEAPON_SPECIALCARBINE_MK2","WEAPON_MILITARYRIFLE",
    "WEAPON_ADVANCEDRIFLE","WEAPON_ASSAULTRIFLE","WEAPON_SPECIALCARBINE","WEAPON_HEAVYRIFLE",
    "WEAPON_TACTICALRIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_RAYCARBINE",
    "WEAPON_GUSENBERG","WEAPON_COMBATMG","WEAPON_MG",
    "WEAPON_COMBATMG_MK2","WEAPON_UNARMED","WEAPON_KNUCKLE",
    "WEAPON_METALDETECTOR"
}

local vehicleCategories = {
    { label="Compacts", description="Compacts",
      list={"asbo","blista","brioso","brioso2","brioso3","club","dilettante","dilettante2","issi2","issi3","issi4","issi5","issi6","kanjo","panto","prairie","rhapsody","weevil"} },
    { label="Sedans", description="Sedans",
      list={"asea","asea2","asterope","asterope2","cinquemila","cog55","cog552","cognoscenti","cognoscenti2","deity","driftchavosv6","drifthardy","emperor","emperor2","emperor3","fugitive","glendale","glendale2","hardy","impaler5","ingot","intruder","limo2","minimus","premier","primo","primo2","regina","rhinehart","romero","schafter2","schafter5","schafter6","stafford","stanier","stratum","stretch","superd","surge","tailgater","tailgater2","warrener","warrener2","washington"} },
    { label="SUVs", description="SUVs",
      list={"aleutian","astron","baller","baller2","baller3","baller4","baller5","baller6","baller7","baller8","bjxl","cavalcade","cavalcade2","cavalcade3","contender","dorado","dubsta","dubsta2","everon3","fq2","granger","granger2","gresley","habanero","huntley","issi8","iwagen","jubilee","landstalker","landstalker2","mesa","mesa2","novak","patriot","patriot2","radi","rebla","rocoto","seminole","seminole2","serrano","squaddie","toros","vivanite","woodlander","xls","xls2"} },
    { label="Coupes", description="Coupes",
      list={"cogcabrio","driftfr36","driftsent2","exemplar","f620","felon","felon2","fr36","jackal","kanjosj","oracle","oracle2","postlude","previon","sentinel","sentinel2","sentinel6","windsor","windsor2","zion","zion2"} },
    { label="Muscles", description="Muscles",
      list={"blade","brigham","broadway","buccaneer","buccaneer2","buffalo4","buffalo5","chino","chino2","clique","clique2","coquette3","deviant","dominator","dominator2","dominator3","dominator4","dominator5","dominator6","dominator7","dominator8","dominator9","driftdom9","driftdominator10","driftgauntlet4","driftyosemite","dukes","dukes2","dukes3","ellie","eudora","faction","faction2","faction3","gauntlet","gauntlet2","gauntlet3","gauntlet4","gauntlet5","greenwood","hermes","hotknife","hustler","impaler","impaler2","impaler3","impaler4","impaler6","imperator","imperator2","imperator3","lurcher","manana2","moonbeam","moonbeam2","nightshade","peyote2","phoenix","picador","ratloader","ratloader2","ruiner","ruiner2","ruiner3","ruiner4","sabregt","sabregt2","slamvan","slamvan2","slamvan3","slamvan4","slamvan5","slamvan6","stalion","stalion2","tahoma","tampa","tampa3","tampa4","tulip","tulip2","vamos","vigero","vigero2","vigero3","virgo","virgo2","virgo3","voodoo","voodoo2","weevil2","yosemite","yosemite2"} },
    { label="Sports Classic", description="Sports Classic",
      list={"ardent","astrale","btype","btype2","btype3","casco","cheburek","cheetah2","cheetah3","coquette2","deluxo","dynasty","fagaloa","feltzer3","gt500","gt750","infernus2","itali2","jb700","jb7002","mamba","manana","michelli","monroe","nebula","peyote","peyote3","pigalle","rapidgt3","retinue","retinue2","savestra","stinger","stingergt","stromberg","swinger","toreador","torero","tornado","tornado2","tornado3","tornado4","tornado5","tornado6","turismo2","viseris","z190","zion3","ztype"} },
    { label="Sports", description="Sports",
      list={"alpha","banshee","bestiagts","blista2","blista3","buffalo","buffalo2","buffalo3","calico","carbonizzare","comet2","comet3","comet4","comet5","comet6","comet7","coquette","coquette4","corsita","coureur","cypher","drafter","drifteuros","driftfuto","driftjester","driftremus","driftrt3","drifttampa","driftzr350","elegy","elegy2","euros","everon2","feltzer2","flashgt","furoregt","fusilade","futo","futo2","gauntlet6","gb200","growler","hotring","imorgon","issi7","italigto","italirsx","jester","jester2","jester3","jester4","jugular","khamelion","komoda","kuruma","kuruma2","locust","lynx","massacro","massacro2","neo","neon","ninef","ninef2","omnis","omnisegt","panthere","paragon","paragon2","pariah","penumbra","penumbra2","r300","raiden","rapidgt","rapidgt2","rapidgt4","raptor","remus","revolter","rt3000","ruston","schafter3","schafter4","schlagen","schwarzer","sentinel3","sentinel4","sentinel5","seven70","sm722","specter","specter2","stingertt","streiter","sugoi","sultan","sultan2","sultan3","surano","tampa2","tenf","tenf2","tropos","vectre","verlierer2","veto","veto2","vstr","zr350","zr380","zr3802","zr3803"} },
    { label="Super", description="Super",
      list={"adder","autarch","banshee2","bullet","champion","cheetah","cyclone","deveste","emerus","entity2","entity3","entityxf","fmj","fmj2","furia","gp1","ignus","infernus","italigtb","italigtb2","krieger","le7b","lm87","luiva","nero","nero2","osiris","penetrator","pfister811","prototipo","reaper","s80","sc1","scramjet","sheava","sultanrs","suzume","t20","taipan","tempesta","tezeract","thrax","tigon","torero2","turismo3","turismor","tyrant","tyrus","vacca","vagner","vigilante","virtue","visione","voltic","voltic2","xa21","xtreme","zeno","zentorno","zorrusso"} },
    { label="Motorcycles", description="Motorcycles",
      list={"akuma","avarus","bagger","bati","bati2","bf400","carbonrs","chimera","cliffhanger","daemon","daemon2","deathbike","deathbike2","deathbike3","defiler","diablous","diablous2","double","enduro","esskey","faggio","faggio2","faggio3","fcr","fcr2","gargoyle","hakuchou","hakuchou2","hexer","innovation","lectro","manchez","manchez2","manchez3","nemesis","nightblade","oppressor","oppressor2","pcj","powersurge","ratbike","reever","rrocket","ruffian","sanchez","sanchez2","sanctus","shinobi","shotaro","sovereign","stryder","thrust","vader","vindicator","vortex","wolfsbane","zombiea","zombieb"} },
    { label="Off-Road", description="Off-Road",
      list={"bfinjection","bifta","blazer","blazer2","blazer3","blazer4","blazer5","bodhi2","boor","brawler","bruiser","bruiser2","bruiser3","brutus","brutus2","brutus3","caracara","caracara2","dloader","draugur","driftl352","dubsta3","dune","dune2","dune3","dune4","dune5","freecrawler","hellion","insurgent","insurgent2","insurgent3","kalahari","kamacho","l35","l352","marshall","menacer","mesa3","monster","monster3","monster4","monster5","monstrociti","nightshark","outlaw","patriot3","rancherxl","rancherxl2","ratel","rcbandito","rebel","rebel2","riata","sandking","sandking2","technical","technical2","technical3","terminus","trophytruck","trophytruck2","vagrant","verus","winky","yosemite3","zhaba"} },
    { label="Industrial", description="Industrial",
      list={"bulldozer","cutter","dump","flatbed","flatbed2","guardian","handler","mixer","mixer2","rubble","tiptruck","tiptruck2"} },
    { label="Utility", description="Utility",
      list={"airtug","armytanker","armytrailer","armytrailer2","baletrailer","boattrailer","boattrailer2","boattrailer3","caddy","caddy2","caddy3","dkeitora","docktrailer","docktug","forklift","freighttrailer","graintrailer","keitora","mower","proptrailer","raketrailer","ripley","sadler","sadler2","scrap","slamtruck","tanker","tanker2","towtruck","towtruck2","towtruck3","towtruck4","tr2","tr3","tr4","tractor","tractor2","tractor3","trailerlarge","trailerlogs","trailers","trailers2","trailers3","trailers4","trailers5","trailersmall","trflat","tvtrailer","tvtrailer2","utillitruck","utillitruck2","utillitruck3"} },
    { label="Vans", description="Vans",
      list={"bison","bison2","bison3","bobcatxl","boxville","boxville2","boxville3","boxville4","boxville5","boxville6","burrito","burrito2","burrito3","burrito4","burrito5","camper","gburrito","gburrito2","journey","journey2","minivan","minivan2","paradise","pony","pony2","rumpo","rumpo2","rumpo3","speedo","speedo2","speedo4","speedo5","surfer","surfer2","surfer3","taco","youga","youga2","youga3","youga4"} },
    { label="Cycles", description="Cycles",
      list={"bmx","cruiser","fixter","inductor","inductor2","scorcher","tribike","tribike2","tribike3"} },
    { label="Boats", description="Boats",
      list={"avisa","dinghy","dinghy2","dinghy3","dinghy4","dinghy5","jetmax","kosatka","longfin","marquis","patrolboat","predator","seashark","seashark2","seashark3","speeder","speeder2","squalo","submersible","submersible2","suntrap","toro","toro2","tropic","tropic2","tug"} },
    { label="Helicopters", description="Helicopters",
      list={"akula","annihilator","annihilator2","buzzard","buzzard2","cargobob","cargobob2","cargobob3","cargobob4","conada","conada2","frogger","frogger2","havok","hunter","maverick","maverick2","polmav","savage","seasparrow","seasparrow2","seasparrow3","skylift","supervolito","supervolito2","swift","swift2","valkyrie","valkyrie2","volatus"} },
    { label="Planes", description="Planes",
      list={"alkonost","alphaz1","avenger","avenger2","avenger3","avenger4","besra","blimp","blimp2","blimp3","bombushka","cargoplane","cargoplane2","cuban800","dodo","duster","howard","hydra","jet","lazer","luxor","luxor2","mammatus","microlight","miljet","mogul","molotok","nimbus","nokota","pyro","raiju","rogue","seabreeze","shamal","starling","streamer216","strikeforce","stunt","titan","tula","velum","velum2","vestra","volatol"} },
    { label="Service", description="Service",
      list={"airbus","brickade","brickade2","bus","coach","pbus2","rallytruck","rentalbus","taxi","tourbus","trash","trash2","vivanite2","wastelander"} },
    { label="Emergency", description="Emergency",
      list={"ambulance","fbi","fbi2","firetruk","lguard","pbus","polbuffalo","polbuffalo6","polgauntlet","police","police2","police3","police4","police5","policeb","policeb2","policeold1","policeold2","policet","pranger","riot","riot2","sheriff","sheriff2"} },
    { label="Military", description="Military",
      list={"apc","barracks","barracks2","barracks3","barrage","chernobog","crusader","halftrack","khanjali","minitank","rhino","scarab","scarab2","scarab3","thruster","trailersmall2","vetir"} },
    { label="Commercial", description="Commercial",
      list={"benson","benson2","biff","cerberus","cerberus2","cerberus3","hauler","hauler2","mule","mule2","mule3","mule4","mule5","packer","phantom","phantom2","phantom3","phantom4","pounder","pounder2","stockade","stockade3","stockade4","terbyte"} },
    { label="Trains", description="Trains",
      list={"cablecar","freight","freight2","freightcar","freightcar2","freightcont1","freightcont2","freightgrain","metrotrain","tankercar"} },
    { label="Open Wheels", description="Open Wheels",
      list={"formula","formula2","openwheel1","openwheel2"} },
}

local weaponCategories = {
    { label="Heavy", description="Heavy", list={"WEAPON_SNOWLAUNCHER","WEAPON_COMPACTLAUNCHER","WEAPON_MINIGUN","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_HOMINGLAUNCHER","WEAPON_RAILGUN","WEAPON_FIREWORK","WEAPON_GRENADELAUNCHER","WEAPON_RPG","WEAPON_RAYMINIGUN","WEAPON_EMPLAUNCHER","WEAPON_RAILGUNXM3"} },
    { label="Shotgun", description="Shotgun", list={"WEAPON_COMBATSHOTGUN","WEAPON_AUTOSHOTGUN","WEAPON_PUMPSHOTGUN","WEAPON_HEAVYSHOTGUN","WEAPON_PUMPSHOTGUN_MK2","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_DBSHOTGUN"} },
    { label="Sniper", description="Sniper", list={"WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER_MK2","WEAPON_HEAVYSNIPER","WEAPON_MARKSMANRIFLE_MK2","WEAPON_PRECISIONRIFLE","WEAPON_MUSKET","WEAPON_MARKSMANRIFLE"} },
    { label="Fire extinguisher", description="Fire extinguisher", list={"WEAPON_FIREEXTINGUISHER"} },
    { label="Thrown", description="Thrown", list={"WEAPON_SNOWBALL","WEAPON_BALL","WEAPON_MOLOTOV","WEAPON_STICKYBOMB","WEAPON_FLARE","WEAPON_GRENADE","WEAPON_BZGAS","WEAPON_PROXMINE","WEAPON_PIPEBOMB","WEAPON_ACIDPACKAGE","WEAPON_SMOKEGRENADE"} },
    { label="Pistol", description="Pistol", list={"WEAPON_VINTAGEPISTOL","WEAPON_PISTOL","WEAPON_PISTOLXM3","WEAPON_APPISTOL","WEAPON_CERAMICPISTOL","WEAPON_FLAREGUN","WEAPON_GADGETPISTOL","WEAPON_COMBATPISTOL","WEAPON_SNSPISTOL_MK2","WEAPON_NAVYREVOLVER","WEAPON_DOUBLEACTION","WEAPON_PISTOL50","WEAPON_RAYPISTOL","WEAPON_SNSPISTOL","WEAPON_PISTOL_MK2","WEAPON_REVOLVER","WEAPON_REVOLVER_MK2","WEAPON_HEAVYPISTOL","WEAPON_MARKSMANPISTOL"} },
    { label="SMG", description="SMG", list={"WEAPON_COMBATPDW","WEAPON_MICROSMG","WEAPON_TECPISTOL","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_MINISMG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTSMG"} },
    { label="Petrol can", description="Petrol can", list={"WEAPON_FERTILIZERCAN","WEAPON_PETROLCAN","WEAPON_HAZARDCAN"} },
    { label="Melee", description="Melee", list={"WEAPON_WRENCH","WEAPON_STONE_HATCHET","WEAPON_GOLFCLUB","WEAPON_HAMMER","WEAPON_CANDYCANE","WEAPON_NIGHTSTICK","WEAPON_CROWBAR","WEAPON_FLASHLIGHT","WEAPON_DAGGER","WEAPON_POOLCUE","WEAPON_BAT","WEAPON_KNIFE","WEAPON_BATTLEAXE","WEAPON_STUNROD","WEAPON_MACHETE","WEAPON_SWITCHBLADE","WEAPON_HATCHET","WEAPON_BOTTLE"} },
    { label="Hacking device", description="Hacking device", list={"WEAPON_HACKINGDEVICE"} },
    { label="Stun gun", description="Stun gun", list={"WEAPON_STUNGUN","WEAPON_STUNGUN_MP"} },
    { label="Rifle", description="Rifle", list={"WEAPON_ASSAULTRIFLE_MK2","WEAPON_COMPACTRIFLE","WEAPON_BATTLERIFLE","WEAPON_BULLPUPRIFLE","WEAPON_CARBINERIFLE","WEAPON_BULLPUPRIFLE_MK2","WEAPON_SPECIALCARBINE_MK2","WEAPON_MILITARYRIFLE","WEAPON_ADVANCEDRIFLE","WEAPON_ASSAULTRIFLE","WEAPON_SPECIALCARBINE","WEAPON_HEAVYRIFLE","WEAPON_TACTICALRIFLE","WEAPON_CARBINERIFLE_MK2"} },
    { label="Machine gun", description="Machine gun", list={"WEAPON_RAYCARBINE","WEAPON_GUSENBERG","WEAPON_COMBATMG","WEAPON_MG","WEAPON_COMBATMG_MK2"} },
    { label="Unarmed", description="Unarmed", list={"WEAPON_UNARMED","WEAPON_KNUCKLE"} },
    { label="Metal detector", description="Metal detector", list={"WEAPON_METALDETECTOR"} },
}
local controlNames = {
    [0] = "V",
    [1] = "MOUSE RIGHT",
    [2] = "MOUSE DOWN",
    [3] = "LOOK_UP_ONLY",
    [4] = "MOUSE DOWN",
    [5] = "LOOK_LEFT_ONLY",
    [6] = "MOUSE RIGHT",
    [7] = "L",
    [8] = "S",
    [9] = "D",
    [10] = "PAGEUP",
    [11] = "PAGEDOWN",
    [12] = "MOUSE DOWN",
    [13] = "MOUSE RIGHT",
    [14] = "SCROLLWHEEL DOWN",
    [15] = "SCROLLWHEEL UP",
    [16] = "SCROLLWHEEL DOWN",
    [17] = "SCROLLWHEEL UP",
    [18] = "ENTER / LEFT MOUSE BUTTON / SPACEBAR",
    [19] = "LEFT ALT",
    [20] = "Z",
    [21] = "LEFT SHIFT",
    [22] = "SPACEBAR",
    [23] = "F",
    [24] = "LEFT MOUSE BUTTON",
    [25] = "RIGHT MOUSE BUTTON",
    [26] = "C",
    [27] = "ARROW UP / SCROLLWHEEL BUTTON (PRESS)",
    [28] = "SPECIAL_ABILITY",
    [29] = "B",
    [30] = "D",
    [31] = "S",
    [32] = "W",
    [33] = "S",
    [34] = "A",
    [35] = "D",
    [36] = "LEFT CTRL",
    [37] = "TAB",
    [38] = "E",
    [39] = "[",
    [40] = "]",
    [41] = "[",
    [42] = "]",
    [43] = "[",
    [44] = "Q",
    [45] = "R",
    [46] = "E",
    [47] = "G",
    [48] = "Z",
    [49] = "F",
    [50] = "SCROLLWHEEL DOWN",
    [51] = "E",
    [52] = "Q",
    [53] = "WEAPON_SPECIAL",
    [54] = "E",
    [55] = "SPACEBAR",
    [56] = "F9",
    [57] = "F10",
    [58] = "G",
    [59] = "D",
    [60] = "LEFT CTRL",
    [61] = "LEFT SHIFT",
    [62] = "LEFT CTRL",
    [63] = "A",
    [64] = "D",
    [65] = "VEH_SPECIAL",
    [66] = "MOUSE RIGHT",
    [67] = "MOUSE DOWN",
    [68] = "RIGHT MOUSE BUTTON",
    [69] = "LEFT MOUSE BUTTON",
    [70] = "RIGHT MOUSE BUTTON",
    [71] = "W",
    [72] = "S",
    [73] = "X",
    [74] = "H",
    [75] = "F",
    [76] = "SPACEBAR",
    [77] = "W",
    [78] = "S",
    [79] = "C",
    [80] = "R",
    [81] = ".",
    [82] = ",",
    [83] = "=",
    [84] = "-",
    [85] = "Q",
    [86] = "E",
    [87] = "W",
    [88] = "S",
    [89] = "A",
    [90] = "D",
    [91] = "RIGHT MOUSE BUTTON",
    [92] = "LEFT MOUSE BUTTON",
    [93] = "VEH_SPECIAL_ABILITY_FRANKLIN",
    [94] = "VEH_STUNT_UD",
    [95] = "MOUSE DOWN",
    [96] = "NUMPAD- / SCROLLWHEEL UP",
    [97] = "NUMPAD+ / SCROLLWHEEL DOWN",
    [98] = "MOUSE RIGHT",
    [99] = "SCROLLWHEEL UP",
    [100] = "[",
    [101] = "H",
    [102] = "SPACEBAR",
    [103] = "E",
    [104] = "H",
    [105] = "X",
    [106] = "LEFT MOUSE BUTTON",
    [107] = "NUMPAD 6",
    [108] = "NUMPAD 4",
    [109] = "NUMPAD 6",
    [110] = "NUMPAD 5",
    [111] = "NUMPAD 8",
    [112] = "NUMPAD 5",
    [113] = "G",
    [114] = "RIGHT MOUSE BUTTON",
    [115] = "SCROLLWHEEL UP",
    [116] = "[",
    [117] = "NUMPAD 7",
    [118] = "NUMPAD 9",
    [119] = "E",
    [120] = "X",
    [121] = "INSERT",
    [122] = "LEFT MOUSE BUTTON",
    [123] = "NUMPAD 6",
    [124] = "NUMPAD 4",
    [125] = "NUMPAD 6",
    [126] = "NUMPAD 5",
    [127] = "NUMPAD 8",
    [128] = "NUMPAD 5",
    [129] = "W",
    [130] = "S",
    [131] = "LEFT SHIFT",
    [132] = "LEFT CTRL",
    [133] = "A",
    [134] = "D",
    [135] = "LEFT MOUSE BUTTON",
    [136] = "W",
    [137] = "CAPSLOCK",
    [138] = "Q",
    [139] = "S",
    [140] = "R",
    [141] = "Q",
    [142] = "LEFT MOUSE BUTTON",
    [143] = "SPACEBAR",
    [144] = "F / LEFT MOUSE BUTTON",
    [145] = "F",
    [146] = "D",
    [147] = "A",
    [148] = "D",
    [149] = "S",
    [150] = "W",
    [151] = "S",
    [152] = "Q",
    [153] = "E",
    [154] = "X",
    [155] = "LEFT SHIFT",
    [156] = "MAP",
    [157] = "1",
    [158] = "2",
    [159] = "6",
    [160] = "3",
    [161] = "7",
    [162] = "8",
    [163] = "9",
    [164] = "4",
    [165] = "5",
    [166] = "F5",
    [167] = "F6",
    [168] = "F7",
    [169] = "F8 (CONSOLE)",
    [170] = "F3",
    [171] = "CAPSLOCK",
    [172] = "ARROW UP",
    [173] = "ARROW DOWN",
    [174] = "ARROW LEFT",
    [175] = "ARROW RIGHT",
    [176] = "ENTER / LEFT MOUSE BUTTON",
    [177] = "BACKSPACE / ESC / RIGHT MOUSE BUTTON",
    [178] = "DELETE",
    [179] = "SPACEBAR",
    [180] = "SCROLLWHEEL DOWN",
    [181] = "SCROLLWHEEL UP",
    [182] = "L",
    [183] = "G",
    [184] = "E",
    [185] = "F",
    [186] = "X",
    [187] = "ARROW DOWN",
    [188] = "ARROW UP",
    [189] = "ARROW LEFT",
    [190] = "ARROW RIGHT",
    [191] = "ENTER",
    [192] = "TAB",
    [193] = "FRONTEND_RLEFT",
    [194] = "BACKSPACE",
    [195] = "D",
    [196] = "S",
    [197] = "]",
    [198] = "SCROLLWHEEL DOWN",
    [199] = "P",
    [200] = "ESC",
    [201] = "ENTER / NUMPAD ENTER",
    [202] = "BACKSPACE / ESC",
    [203] = "SPACEBAR",
    [204] = "TAB",
    [205] = "Q",
    [206] = "E",
    [207] = "PAGE DOWN",
    [208] = "PAGE UP",
    [209] = "LEFT SHIFT",
    [210] = "LEFT CONTROL",
    [211] = "TAB",
    [212] = "HOME",
    [213] = "HOME",
    [214] = "DELETE",
    [215] = "ENTER",
    [216] = "SPACEBAR",
    [217] = "CAPSLOCK",
    [218] = "D",
    [219] = "S",
    [220] = "MOUSE RIGHT",
    [221] = "MOUSE DOWN",
    [222] = "RIGHT MOUSE BUTTON",
    [223] = "LEFT MOUSE BUTTON",
    [224] = "LEFT CTRL",
    [225] = "RIGHT MOUSE BUTTON",
    [226] = "SCRIPT_LB",
    [227] = "SCRIPT_RB",
    [228] = "SCRIPT_LT",
    [229] = "LEFT MOUSE BUTTON",
    [230] = "SCRIPT_LS",
    [231] = "SCRIPT_RS",
    [232] = "W",
    [233] = "S",
    [234] = "A",
    [235] = "D",
    [236] = "V",
    [237] = "LEFT MOUSE BUTTON",
    [238] = "RIGHT MOUSE BUTTON",
    [239] = "CURSOR_X",
    [240] = "CURSOR_Y",
    [241] = "SCROLLWHEEL UP",
    [242] = "SCROLLWHEEL DOWN",
    [243] = "~ / `",
    [244] = "M",
    [245] = "T",
    [246] = "Y",
    [247] = "MP_TEXT_CHAT_FRIENDS",
    [248] = "MP_TEXT_CHAT_CREW",
    [249] = "N",
    [250] = "R",
    [251] = "F",
    [252] = "X",
    [253] = "C",
    [254] = "LEFT SHIFT",
    [255] = "SPACEBAR",
    [256] = "DELETE",
    [257] = "LEFT MOUSE BUTTON",
    [258] = "RAPPEL_JUMP",
    [259] = "RAPPEL_LONG_JUMP",
    [260] = "RAPPEL_SMASH_WINDOW",
    [261] = "SCROLLWHEEL UP",
    [262] = "SCROLLWHEEL DOWN",
    [263] = "R",
    [264] = "Q",
    [265] = "WHISTLE",
    [266] = "D",
    [267] = "D",
    [268] = "S",
    [269] = "S",
    [270] = "MOUSE RIGHT",
    [271] = "MOUSE RIGHT",
    [272] = "MOUSE DOWN",
    [273] = "MOUSE DOWN",
    [274] = "[",
    [275] = "[",
    [276] = "[",
    [277] = "[",
    [278] = "D",
    [279] = "D",
    [280] = "LEFT CTRL",
    [281] = "LEFT CTRL",
    [282] = "MOUSE RIGHT",
    [283] = "MOUSE RIGHT",
    [284] = "MOUSE RIGHT",
    [285] = "MOUSE RIGHT",
    [286] = "MOUSE RIGHT",
    [287] = "MOUSE RIGHT",
    [288] = "F1",
    [289] = "F2",
    [290] = "MOUSE RIGHT",
    [291] = "MOUSE DOWN",
    [292] = "SCALED_LOOK_UP_ONLY",
    [293] = "SCALED_LOOK_DOWN_ONLY",
    [294] = "SCALED_LOOK_LEFT_ONLY",
    [295] = "SCALED_LOOK_RIGHT_ONLY",
    [296] = "DELETE",
    [297] = "DELETE",
    [298] = "SPACEBAR",
    [299] = "ARROW DOWN",
    [300] = "ARROW UP",
    [301] = "M",
    [302] = "S",
    [303] = "U",
    [304] = "H",
    [305] = "B",
    [306] = "N",
    [307] = "ARROW RIGHT",
    [308] = "ARROW LEFT",
    [309] = "T",
    [310] = "R",
    [311] = "K",
    [312] = "[",
    [313] = "]",
    [314] = "NUMPAD +",
    [315] = "NUMPAD -",
    [316] = "PAGE UP",
    [317] = "PAGE DOWN",
    [318] = "F5",
    [319] = "C",
    [320] = "V",
    [321] = "SPACEBAR",
    [322] = "ESC",
    [323] = "X",
    [324] = "C",
    [325] = "V",
    [326] = "LEFT CTRL",
    [327] = "F5",
    [328] = "SPACEBAR",
    [329] = "LEFT MOUSE BUTTON",
    [330] = "RIGHT MOUSE BUTTON",
    [331] = "RIGHT MOUSE BUTTON",
    [332] = "MOUSE DOWN",
    [333] = "MOUSE RIGHT",
    [334] = "SCROLLWHEEL DOWN",
    [335] = "SCROLLWHEEL UP",
    [336] = "SCROLLWHEEL DOWN",
    [337] = "X",
    [338] = "A",
    [339] = "D",
    [340] = "LEFT SHIFT",
    [341] = "LEFT CTRL",
    [342] = "D",
    [343] = "LEFT CTRL",
    [344] = "F11",
    [345] = "X",
    [346] = "LEFT MOUSE BUTTON",
    [347] = "RIGHT MOUSE BUTTON",
    [348] = "SCROLLWHEEL BUTTON (PRESS)",
    [349] = "TAB",
    [350] = "E",
    [351] = "E",
    [352] = "LEFT SHIFT",
    [353] = "SPACEBAR",
    [354] = "X",
    [355] = "E",
    [356] = "E",
    [357] = "X",
}


AddTextEntry("vehName", "Enter vehicle name (example: adder)")
AddTextEntry("weapName", "Enter weapon name (example: WEAPON_PISTOL)")
AddTextEntry("resourceName", "Enter resource name")

local noRagdollToggle = nil
local noClipToggle  = nil
local invisNoclipToggle
local noClipRotateToggle  = nil
local boostToggle   = nil
local godModeToggle = false
local espBox = false
local espTracers = false
local espNames = false
local espIds = false
local espWeaponName = false
local espHealth = false
local aimbotEnabled = false
local showAimbotFov = false
local aimbotFovValue = 50.0
local aimbotSmoothing = 0.5
local aimbotBone = 12844
local invisibility = nil
local vehInvisibility = nil
local noReload = nil
local infiniteAmmo = nil
local noSpread = nil
local noRecoil = nil

--[[
HELPERS
]]

function Notify(title, desc, color, duration)
    table.insert(notifications, {
        title = title, desc = desc,
        color = color or {255,0,0},
        duration = duration or 5000,
        startTime = GetGameTimer(),
        alpha = 0, currentY = baseY, currentX = startX
    })
end

function DrawTxt(text, x, y, scale)
    SetTextFont(0); SetTextScale(scale, scale)
    SetTextColour(255,255,255,255); SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function DrawTxt2(text, x, y, scale)
    SetTextFont(0); SetTextScale(scale, scale)
    SetTextColour(255,255,255,255); SetTextCentre(false)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function HSVtoRGB(h, s, v)
    local i = math.floor(h*6); local f = h*6-i
    local p = v*(1-s); local q = v*(1-f*s); local t = v*(1-(1-f)*s)
    i = i%6
    local r,g,b
    if i==0 then r,g,b=v,t,p elseif i==1 then r,g,b=q,v,p
    elseif i==2 then r,g,b=p,v,t elseif i==3 then r,g,b=p,q,v
    elseif i==4 then r,g,b=t,p,v elseif i==5 then r,g,b=v,p,q end
    return math.floor(r*255), math.floor(g*255), math.floor(b*255)
end

function CurrentMenu()
    while #menuStack > 0 do
        local top = menuStack[#menuStack]
        if top and top.items then return top end
        table.remove(menuStack)
    end
    return mainMenu
end

function SpawnVehicle(modelName)
    local model = GetHashKey(modelName)
    if not IsModelValid(model) then
        Notify("Error", "Invalid model: "..modelName, errorNotificationColor, 3000); return
    end
    RequestModel(model)
    local t = 0
    while not HasModelLoaded(model) and t < 3000 do Citizen.Wait(10); t=t+10 end
    if not HasModelLoaded(model) then
        Notify("Error", "Failed to load model", errorNotificationColor, 3000); return
    end
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local h = GetEntityHeading(ped)
    local veh = CreateVehicle(model, c.x, c.y, c.z, h, true, false)
    SetPedIntoVehicle(ped, veh, -1)
    SetEntityAsNoLongerNeeded(veh); SetModelAsNoLongerNeeded(model)
    Notify("Vehicle", "Spawned: "..modelName, baseNotificationColor, 3000)
end

function SpawnWeapon(weaponName)
    local weaponHash = GetHashKey(weaponName)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped,weaponHash,250,false,true)
    Notify("Weapon", "Gave weapon: "..weaponName, baseNotificationColor, 3000)
end

function RequestVehicleNameInput()
    DisplayOnscreenKeyboard(1, "vehName", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Citizen.Wait(0); DisableAllControlActions(0)
    end
    local result = GetOnscreenKeyboardResult()
    EnableAllControlActions(0)
    if result and result ~= "" then SpawnVehicle(result) end
end

function RequestWeaponNameInput()
    DisplayOnscreenKeyboard(1, "weapName", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Citizen.Wait(0); DisableAllControlActions(0)
    end
    local result = GetOnscreenKeyboardResult()
    EnableAllControlActions(0)
    if result and result ~= "" then SpawnWeapon(result) end
end

function GetAntiCheat()

    for i = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(i)

        if resource then

            -- ELECTRON
            local manifest = LoadResourceFile(resource, "fxmanifest.lua")
            if manifest then
                if string.find(manifest, "Electron Services", 1, true)
                or string.find(manifest, "https://electron-services.com", 1, true)
                or string.find(manifest, "The most advanced fiveM anticheat", 1, true) then
                    return "ElectronAC", resource
                end
            end

            -- FIVEGUARD
            local scriptCount = GetNumResourceMetadata(resource, "client_script")
            if scriptCount and scriptCount > 0 then
                for j = 0, scriptCount - 1 do
                    local script = GetResourceMetadata(resource, "client_script", j)
                    if script and string.find(string.lower(script), "obfuscated", 1, true) then
                        return "FiveGuard", resource
                    end
                end
            end

            -- WAVESHIELD
            if string.lower(resource) == "waveshield" then
                return "WaveShield", resource
            end

            -- CLOWNS
            if resource == "clowns-829523" then
                return "Clowns.cool AC", resource
            end
        end
    end

    return "None", nil
end

local function GetKeyName(index)
    if controlNames and controlNames[index] then
        return controlNames[index]
    end
    return "KEY " .. tostring(index)
end

function DrawAimbotFOV(x, y, radius, r, g, b, a)
    local steps = 64
    local step = (math.pi * 2) / steps
    
    local prevX = x + math.cos(0) * radius * (9/16)
    local prevY = y + math.sin(0) * radius
    
    for i = 1, steps do
        local angle = i * step
        local nextX = x + math.cos(angle) * radius * (9/16)
        local nextY = y + math.sin(angle) * radius
        
        DrawLine_2d(prevX, prevY, nextX, nextY, 0.001, r, g, b, a)
        
        prevX, prevY = nextX, nextY
    end
end


--[[
BUILDER FUNCTIONS
]]

function BuildNearbyPlayersMenu()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local tPed = GetPlayerPed(player)
            local tCoords = GetEntityCoords(tPed)
            local dist = #(coords - tCoords)
            if dist < 500.0 then
                table.insert(players, {
                    id=GetPlayerServerId(player), name=GetPlayerName(player),
                    distance=dist, ped=tPed, localId=player
                })
            end
        end
    end
    table.sort(players, function(a,b) return a.distance < b.distance end)

    local items = {}
    for _, p in ipairs(players) do
        local pc = p
        table.insert(items, {
            type="submenu",
            label=string.format("%s [%d]", pc.name, pc.id),
            description=string.format("Distance: %.1fm", pc.distance),
            items={
                { type="button", label="Spectate", description="Spectate this player",
                  action=function()
                    NetworkSetInSpectatorMode(true, pc.ped)
                    Notify("Spectate", "Spectating "..pc.name, baseNotificationColor, 3000)
                  end },
                { type="button", label="Stop Spectating", description="Stop spectating",
                  action=function()
                    NetworkSetInSpectatorMode(false, pc.ped)
                    Notify("Spectate", "Stopped spectating", baseNotificationColor, 3000)
                  end },
                { type="button", label="Clone Outfit", description="Copy this player's outfit",
                  action=function()
                    local myPed = PlayerPedId()
                    for _, comp in ipairs({0,1,2,3,4,5,6,7,8,9,10,11}) do
                        local draw = GetPedDrawableVariation(pc.ped, comp)
                        local tex  = GetPedTextureVariation(pc.ped, comp)
                        SetPedComponentVariation(myPed, comp, draw, tex, 2)
                    end
                    Notify("Outfit", "Cloned from "..pc.name, baseNotificationColor, 3000)
                  end },
                  
                { type="button", label="Launch player", description="Make this player fly",
                    action=function() 
                        local model = GetHashKey("veto2")
                        RequestModel(model)
                        local t = 0
                        while not HasModelLoaded(model) and t < 3000 do Citizen.Wait(10); t=t+10 end
                        if not HasModelLoaded(model) then
                            Notify("Error", "Failed to load vehicle model: "..model, errorNotificationColor, 3000); return
                        end
                        local c = GetEntityCoords(pc.ped)
                        local h = GetEntityHeading(pc.ped)
                        local veh = CreateVehicle(model, c.x, c.y, c.z - 10, h, true, false)
                        SetEntityVisible(veh,false,false)
                        SetEntityVelocity(veh,0.0,0.0,30.0)
                        SetEntityAsNoLongerNeeded(veh); SetModelAsNoLongerNeeded(model)
                    end  
                },
                { type="button", label="Spawn vehicle", description="Spawn a vehicle for this player",
                    action=function() 
                        DisplayOnscreenKeyboard(1, "vehName", "", "", "", "", "", 30)
                        while UpdateOnscreenKeyboard() == 0 do
                            Citizen.Wait(0); DisableAllControlActions(0)
                        end
                        local result = GetOnscreenKeyboardResult()
                        EnableAllControlActions(0)
                        local model = GetHashKey(result)
                        RequestModel(model)
                        local t = 0
                        while not HasModelLoaded(model) and t < 3000 do Citizen.Wait(10); t=t+10 end
                        if not HasModelLoaded(model) then
                            Notify("Error", "Failed to load vehicle model: "..result, errorNotificationColor, 3000); return
                        end
                        local c = GetEntityCoords(pc.ped)
                        local h = GetEntityHeading(pc.ped)
                        local veh = CreateVehicle(model, c.x, c.y, c.z, h, true, false)
                        SetEntityAsNoLongerNeeded(veh); SetModelAsNoLongerNeeded(model)
                    end  
                },
                { type="button", label="Teleport To", description="Teleport to this player",
                  action=function()
                    local tc = GetEntityCoords(pc.ped)
                    SetEntityCoords(PlayerPedId(), tc.x, tc.y, tc.z, false,false,false,true)
                    Notify("Teleport", "Teleported to "..pc.name, baseNotificationColor, 3000)
                  end },
                { type="button", label="Crash player", description="Try to crash selected player (Don't stand near selected player)",
                  action=function()
                    local targetPlayerId = pc.localId
                    local targetPed = pc.ped
                    
                    Citizen.CreateThread(function()
                        local pedModel = GetHashKey("cs_wade")
                        
                        RequestModel(pedModel)
                        local t = 0
                        while not HasModelLoaded(pedModel) and t < 5000 do 
                            Citizen.Wait(10) 
                            t = t + 10 
                        end

                        if not HasModelLoaded(pedModel) then
                            Notify("Error", "Failed to load crash model!", errorNotificationColor, 3000)
                            return
                        end

                        Notify("Crasher", "Crashing player "..pc.name.." ["..pc.id.."]", baseNotificationColor, 3000)

                        local spawnedPeds = {}
                        local maxPedsPerBatch = 8
                        local maxIterations = 15

                        for i = 0, maxIterations - 1 do
                            local currentTargetPed = GetPlayerPed(targetPlayerId)
                            if not DoesEntityExist(currentTargetPed) then break end
                            local coords = GetEntityCoords(currentTargetPed)

                            for j = 1, maxPedsPerBatch do
                                local ped = CreatePed(28, pedModel, coords.x + (math.random(-10, 10)/10), coords.y + (math.random(-10, 10)/10), coords.z, 0.0, true, false)
                                
                                if DoesEntityExist(ped) then
                                    SetEntityAlpha(ped, 0, false)
                                    SetEntityVisible(ped, false, false)
                                    FreezeEntityPosition(ped, true)
                                    SetEntityCollision(ped, false, false)
                                    
                                    SetPedConfigFlag(ped, 292, true)
                                    SetPedConfigFlag(ped, 301, true)
                                    SetPedConfigFlag(ped, 128, true)
                                    SetPedConfigFlag(ped, 287, true)
                                    SetPedConfigFlag(ped, 17, true)
                                    SetPedConfigFlag(ped, 435, true)
                                    SetBlockingOfNonTemporaryEvents(ped, true)
                                    
                                    TaskWanderInArea(ped, coords.x, coords.y, coords.z, 10.0, 10.0, 10.0)
                                    
                                    SetPedAsNoLongerNeeded(ped)
                                    table.insert(spawnedPeds, ped)
                                end
                            end
                            Citizen.Wait(100) 
                        end
                        Citizen.SetTimeout(6000, function()
                            for _, p in ipairs(spawnedPeds) do
                                if DoesEntityExist(p) then
                                    SetEntityAsMissionEntity(pedModel, true, true) 
                                    DeleteEntity(p) 
                                end
                            end
                            SetModelAsNoLongerNeeded(pedModel)
                        end)
                    end)
                  end 
                }
            }
        })
    end

    if #items == 0 then
        table.insert(items, {
            type="button", label="No players nearby",
            description="No players found within 428m",
            action=function() end
        })
    end
    return { label="Nearby Players", title="Nearby Players", items=items }
end

function BuildResourcesMenu()
    local items = {}
    local numResources = GetNumResources()
    
    for i = 0, numResources - 1 do
        local resName = GetResourceByFindIndex(i)
        if resName then
            local resState = GetResourceState(resName)
            table.insert(items, {
                type = "submenu",
                label = "[" .. resState .. "] " .. resName,
                description = "Status: " .. resState,
                items = {
                    { 
                        type = "button", 
                        label = "Dump", 
                        description = "Dump resource "..resName, 
                        action = function()
                            local num = GetNumResourceMetadata(resName, "client_script")
                            if num > 0 then
                                Notify("Dumper", "Dumping: " .. resName, baseNotificationColor, 3000)
                                print("^5--- DUMP START: " .. resName .. " ---^7")
                                for j = 0, num - 1 do
                                    local fileName = GetResourceMetadata(resName, "client_script", j)
                                    if fileName then
                                        local content = LoadResourceFile(resName, fileName)
                                        if content then
                                            print("^5--- FILE: " .. fileName .. " ---^7")
                                            print(content)
                                            print("--- END ---^7")
                                            Notify("Resource", "File "..fileName.." dumped! Check F8 console",baseNotificationColor,3000)
                                        end
                                    end
                                end
                                print("^5--- DUMP END ---^7")
                            else
                                Notify("Error", "No client scripts", errorNotificationColor, 3000)
                            end
                        end 
                    },
                    { 
                        type = "button", 
                        label = "Stop", 
                        description = "Stop resource "..resName, 
                        action = function()
                            Notify("Resource", "Not implemented yet!", errorNotificationColor, 3000)
                        end 
                    },
                    { 
                        type = "button", 
                        label = "Start", 
                        description = "Start resource "..resName, 
                        action = function()
                            Notify("Resource", "Not implemented yet!", errorNotificationColor, 3000)
                        end 
                    }
                }
            })
        end
    end
    
    table.sort(items, function(a, b) return a.label < b.label end)
    return { label = "Resources", items = items }
end

local _resEntry = nil


local _oldMenuIsOpened = menuIsOpened
Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(500)
        if menuIsOpened and not _oldMenuIsOpened then
            if _resEntry then
                local built = BuildResourcesMenu()
                _resEntry.items = built.items
            end
        end
        _oldMenuIsOpened = menuIsOpened
    end
end)

local outfitComponents = {
    {id=0,label="Head"},{id=1,label="Mask"},{id=2,label="Hair"},
    {id=3,label="Torso"},{id=4,label="Legs"},{id=5,label="Bags/Parachutes"},
    {id=6,label="Shoes"},{id=7,label="Accessories"},{id=8,label="Undershirt"},
    {id=9,label="Armor"},{id=10,label="Decals"},{id=11,label="Tops"},
}

function BuildOutfitMenu()
    local ped = PlayerPedId()
    local items = {}

    for _, comp in ipairs(outfitComponents) do
        local cc = comp

        local curDraw = GetPedDrawableVariation(ped, cc.id)
        local maxDraw = math.max(0, GetNumberOfPedDrawableVariations(ped, cc.id) - 1)

        local curTex = GetPedTextureVariation(ped, cc.id)
        local maxTex = math.max(0, GetNumberOfPedTextureVariations(ped, cc.id, curDraw) - 1)

        local variationItem = {
            type="slider",
            label=cc.label.." Variation",
            value=curTex,
            min=0,
            max=maxTex,
            step=1,
            onChange=function(val)
                local ped = PlayerPedId()
                local draw = GetPedDrawableVariation(ped, cc.id)

                SetPedComponentVariation(ped, cc.id, draw, val, 2)
            end
        }

        local drawableItem = {
            type="slider",
            label=cc.label,
            value=curDraw,
            min=0,
            max=maxDraw,
            step=1,
            onChange=function(val)
                local ped = PlayerPedId()
        
                SetPedComponentVariation(ped, cc.id, val, 0, 2)

                local newMaxTex = math.max(0, GetNumberOfPedTextureVariations(ped, cc.id, val) - 1)

                variationItem.max = newMaxTex
                variationItem.value = 0
            end
        }

        table.insert(items, drawableItem)
        table.insert(items, variationItem)
    end

    return {
        label="Outfit Editor",
        title="Outfit Editor",
        items=items
    }
end

function BuildVehicleSpawnMenu()
    local items = {}
    for _, cat in ipairs(vehicleCategories) do
        local cc = cat
        local catItems = {}
        for _, mn in ipairs(cc.list) do
            local m = mn
            table.insert(catItems, {
                type="button", label=m, description="Spawn "..m,
                action=function() SpawnVehicle(m) end
            })
        end
        table.insert(items, {
            type="submenu", label=cc.label, description=cc.description, items=catItems
        })
    end
    return items
end

function BuildWeaponMenu()
    local items = {}

    for _, cat in ipairs(weaponCategories) do
        local cc = cat
        local catItems = {}

        for _, w in ipairs(cc.list) do
            local weapon = w

            table.insert(catItems, {
                type = "button",
                label = weapon,
                description = "Give " .. weapon,
                action = function()
                    SpawnWeapon(weapon)
                end
            })
        end

        table.insert(items, {
            type = "submenu",
            label = cc.label,
            description = cc.description,
            items = catItems
        })
    end

    return items
end

function BuildTuningMenu()
    return {
        { type="slider", label="Primary Color", description="Vehicle primary color (0-159)",
          value=0, min=0, max=159, step=1,
          onChange=function(val)
            local veh=GetVehiclePedIsIn(PlayerPedId(),false)
            if veh~=0 then local _,sec=GetVehicleColours(veh); SetVehicleColours(veh,val,sec) end
          end },
        { type="slider", label="Secondary Color", description="Vehicle secondary color (0-159)",
          value=0, min=0, max=159, step=1,
          onChange=function(val)
            local veh=GetVehiclePedIsIn(PlayerPedId(),false)
            if veh~=0 then local pri,_=GetVehicleColours(veh); SetVehicleColours(veh,pri,val) end
          end },
        { type="slider", label="Window Tint", description="0=Stock 1=None 2=Limo 3=Dark 4=Light 5=Black 6=Flame",
          value=0, min=0, max=6, step=1,
          onChange=function(val)
            local veh=GetVehiclePedIsIn(PlayerPedId(),false)
            if veh~=0 then SetVehicleWindowTint(veh,val) end
          end },
        { type="button", label="Max Upgrade", description="Apply all performance upgrades",
          action=function()
            local veh=GetVehiclePedIsIn(PlayerPedId(),false)
            if veh==0 then Notify("Error","Not in a vehicle",errorNotificationColor,3000); return end
            SetVehicleModKit(veh,0)
            for mod=0,49 do
                local mx=GetNumVehicleMods(veh,mod)-1
                if mx>=0 then SetVehicleMod(veh,mod,mx,false) end
            end
            ToggleVehicleMod(veh,18,true); ToggleVehicleMod(veh,20,true)
            Notify("Tuning","Max upgrade applied",baseNotificationColor,3000)
          end },
        { type="button", label="Repair Vehicle", description="Restore vehicle to perfect condition",
          action=function()
            local veh=GetVehiclePedIsIn(PlayerPedId(),false)
            if veh==0 then Notify("Error","Not in a vehicle",errorNotificationColor,3000); return end
            SetVehicleFixed(veh); SetVehicleDeformationFixed(veh)
            Notify("Tuning","Vehicle repaired",baseNotificationColor,3000)
          end },
        { type="button", label="Clean Vehicle", description="Remove all dirt from vehicle",
          action=function()
            local veh=GetVehiclePedIsIn(PlayerPedId(),false)
            if veh~=0 then WashDecalsFromVehicle(veh,1.0) end
            Notify("Tuning","Vehicle cleaned",baseNotificationColor,3000)
          end },
    }
end

--[[
MAIN MENU
]]

local _noRagdollItem = {
    type="toggle", label="No Ragdoll", description="Prevent player from entering ragdoll",
    value=false,
    action=function(val)
        Notify("Player","No Ragdoll: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
    end
}
local _noClipItem = {
    type="toggle", label="No Clip", description="Toggle no clip movement",
    value=false,
    action=function(val)
        Notify("Player","No Clip: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
    end
}
local _invisNoClipItem = {
    type="toggle", label="Invisible No Clip", description="Toggle invisible no clip",
    value=false,
    action=function(val)
        Notify("Player","Invisible No Clip: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
    end
}
local _noClipRotateItem = {
    type="toggle", label="No Clip rotate vehicle pitch", description="Toggle no clip pitch vehicle rotation",
    value=false,
    action=function(val)
        Notify("Player","No Clip rotate vehicle pitch: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
    end
}
local _boostItem = {
    type="toggle", label="Shift Boost", description="Hold Shift to boost vehicle speed",
    value=false,
    action=function(val)
        Notify("Vehicle","Shift Boost: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
    end
}

noRagdollToggle = _noRagdollItem
noClipToggle = _noClipItem
invisNoclipToggle = _invisNoClipItem
noClipRotateToggle = _noClipRotateItem
boostToggle  = _boostItem

mainMenu = {
    title = "Patryksu Menu V2",
    items = {

        -- PLAYER
        {
            type="submenu", label="Player", description="Player options and settings",
            items = {
                { type = "toggle", label = "God Mode", description = "Makes you invincible", 
                action = function() godModeToggle = not godModeToggle; Notify("Player", "God Mode: "..(godModeToggle and "ON" or "OFF"), baseNotificationColor, 3000) end 
                },
                {
                    type="toggle", label="Invisibility", description="Toggle player visibility",
                    value=false,
                    action=function(val)
                        SetEntityVisible(PlayerPedId(), not val, false)
                        invisibility = val
                        Notify("Player","Invisibility: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
                    end
                },
                _noRagdollItem,
                { type = "submenu", label = "No Clip", description = "No Clip options",
                  items={
                    _noClipItem,
                    _invisNoClipItem,
                    _noClipRotateItem,
                  }
                },
                {
                    type="button", label="Heal", description="Restore player health to full",
                    action=function()
                        SetEntityHealth(PlayerPedId(), 200)
                        Notify("Player","Health restored",baseNotificationColor,3000)
                    end
                },
                {
                    type="submenu", label="Outfit Editor",
                    description="Edit your outfit components",
                    dynamic=true,
                    buildFn=BuildOutfitMenu,
                    items={}
                },
                {
                    type="button", label="Enable solo session", description="Enable solo session",
                    action=function()
                        NetworkStartSoloTutorialSession()
                        Notify("Player","Solo session enabled",baseNotificationColor,3000)
                    end
                },
                {
                    type="button", label="Disable solo session", description="Disable solo session",
                    action=function()
                        NetworkEndTutorialSession()
                        Notify("Player","Solo session disabled",baseNotificationColor,3000)
                    end
                },
                {
                    type="submenu", label="Model Changer", description="Change your ped model",
                    items={
                        { 
                            type="button", 
                            label="Default Male", 
                            description="Default Male (mp_m_freemode_01)",
                            action=function() 
                                local playerPed = PlayerId()
                                local modelHash = GetHashKey("mp_m_freemode_01")
                                if not HasModelLoaded(modelHash) then
                                    RequestModel(modelHash)
                                    while not HasModelLoaded(modelHash) do
                                        Citizen.Wait(0)
                                    end
                                end
                                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                                local h = GetEntityHeading(playerPed)
                                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                                SetEntityInvincible(ped, false)
                                SetEntityAsMissionEntity(ped, true, true)
                                SetEntityHasGravity(ped, true)
                                SetEntityCollision(ped, true, true)
                                SetPedCanRagdoll(ped, true)
                                SetEntityVisible(ped, true)
                        
                                SetPlayerModel(playerPed, modelHash)
                                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                                SetEntityHeading(playerPed, h)
                                local pped = PlayerPedId()
                                for i = 0, 7 do
                                  ClearPedProp(pped, i)
                                end
                                for i = 0, 11 do
                                  SetPedComponentVariation(pped, i, 0, 0, 0) 
                                end 
                                DeleteEntity(playerPed)
                            end
                        },
                        { 
                            type="button", 
                            label="Default Female", 
                            description="Default Female (mp_f_freemode_01)",
                            action=function() 
                                local playerPed = PlayerId()
                                local modelHash = GetHashKey("mp_f_freemode_01")
                                if not HasModelLoaded(modelHash) then
                                    RequestModel(modelHash)
                                    while not HasModelLoaded(modelHash) do
                                        Citizen.Wait(0)
                                    end
                                end
                                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                                local h = GetEntityHeading(playerPed)
                                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                                SetEntityInvincible(ped, false)
                                SetEntityAsMissionEntity(ped, true, true)
                                SetEntityHasGravity(ped, true)
                                SetEntityCollision(ped, true, true)
                                SetPedCanRagdoll(ped, true)
                                SetEntityVisible(ped, true)
                        
                                SetPlayerModel(playerPed, modelHash)
                                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                                SetEntityHeading(playerPed, h)
                                local pped = PlayerPedId()
                                for i = 0, 7 do
                                  ClearPedProp(pped, i)
                                end
                                for i = 0, 11 do
                                  SetPedComponentVariation(pped, i, 0, 0, 0) 
                                end 
                                DeleteEntity(playerPed)
                            end
                        },
                    }
                },
                {
                    type="submenu", label="Teleport", description="Teleport to various locations",
                    items={
                        { 
                            type="button", 
                            label="Waypoint", 
                            description="Teleport to your waypoint",
                            action=function() 
                                local blip = GetFirstBlipInfoId(8)
                            
                                if DoesBlipExist(blip) then
                                    local coords = GetBlipInfoIdCoord(blip)
                                
                                    local ped = PlayerPedId()
                                    local entity = ped
                                
                                    if IsPedInAnyVehicle(ped, false) then
                                        entity = GetVehiclePedIsIn(ped, false)
                                    end
                                
                                    local foundGround, groundZ = false, 0.0
                                
                                    for height = 1000.0, -100.0, -25.0 do
                                        SetEntityCoordsNoOffset(entity, coords.x, coords.y, height, false, false, false)
                                        Citizen.Wait(5)
                                    
                                        foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, height, false)
                                    
                                        if foundGround then
                                            break
                                        end
                                    end
                                
                                    if foundGround then
                                        SetEntityCoords(entity, coords.x, coords.y, groundZ + 1.0, false, false, false, true)
                                    else
                                        SetEntityCoords(entity, coords.x, coords.y, 100.0, false, false, false, true)
                                    end
                                
                                    Notify("Teleport", "Teleported to waypoint", baseNotificationColor, 3000)
                                else
                                    Notify("Error", "No waypoint found!", errorNotificationColor, 3000)
                                end
                            end
                        },
                        { type="button", label="Legion Square (Kwadraciak)", description="Mission Row area",
                          action=function() SetEntityCoords(PlayerPedId(),195.17,-933.77,30.69,false,false,false,true); Notify("Teleport","Legion Square",baseNotificationColor,3000) end },
                        { type="button", label="Airport", description="LSIA",
                          action=function() SetEntityCoords(PlayerPedId(),-1037.0,-2737.0,20.17,false,false,false,true); Notify("Teleport","Airport",baseNotificationColor,3000) end },
                    }
                },
                {
                    type="submenu", label="Weapons", description="Give or remove weapons",
                    items={
                        { type="submenu", label="Give weapon from list", description="Give weapon by category from the list (no addon weapons)",
                            items=BuildWeaponMenu() },
                        { type="button", label="Give weapon by name", description="Type any weapon model name",
                          action=function()
                            menuIsOpened = false
                            Citizen.Wait(200)
                            RequestWeaponNameInput()
                            menuIsOpened = true
                          end },
                        { type="button", label="Refill Ammo", description="Refill ammo for current weapon",
                          action=function()
                            local ped=PlayerPedId()
                            local _,wh=GetCurrentPedWeapon(ped,true)
                            SetPedAmmo(ped,wh,9999)
                            Notify("Weapons","Ammo refilled",baseNotificationColor,3000)
                          end },
                        { type = "toggle", label = "No reload", description = "Disable reload", 
                            action = function() noReload = not noReload; Notify("Weapons", "No reload: " ..(noReload and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "No spread", description = "Disable spread", 
                            action = function() noSpread = not noSpread; Notify("Weapons", "No spread: " ..(noSpread and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "No recoil", description = "Disable recoil", 
                            action = function() noRecoil = not noRecoil; Notify("Weapons", "No recoil: " ..(noRecoil and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "Infinite Ammo", description = "Make your ammunition infinite", 
                            action = function() infiniteAmmo = not infiniteAmmo; Notify("Weapons", "Infinite ammo: " ..(infiniteAmmo and "ON" or "OFF"), baseNotificationColor) end },
                        { type="submenu", label="Presets", description="Weapon presets / loadouts",
                         items={
                            { type="button", label="Snajper", description="SNS pistol mk2",
                              action=function() GiveWeaponToPed(PlayerPedId(),GetHashKey("WEAPON_SNSPISTOL_MK2"),250,false,true); Notify("Presets","SNS Pistol MK2 given",baseNotificationColor,3000) end
                            },
                            { type="button", label="Bojówkarz", description="Vintage pistol",
                              action=function() GiveWeaponToPed(PlayerPedId(),GetHashKey("WEAPON_VINTAGEPISTOL"),250,false,true); Notify("Presets","Vintage pistol given",baseNotificationColor,3000) end
                            },
                         }
                        },
                    }
                },
            }
        },

        -- NEARBY PLAYERS
        {
            type="submenu", label="Nearby Players",
            description="Players within 428m",
            dynamic=true,
            buildFn=BuildNearbyPlayersMenu,
            items={}
        },

        -- VEHICLE
        {
            type="submenu", label="Vehicle", description="Vehicle options and settings",
            items={
                {
                    type="toggle", label="Vehicle God Mode", description="Make current vehicle indestructible",
                    value=false,
                    action=function(val)
                        local veh=GetVehiclePedIsIn(PlayerPedId(),false)
                        if veh~=0 then SetEntityInvincible(veh,val); SetVehicleCanBeVisiblyDamaged(veh,not val) end
                        Notify("Vehicle","God Mode: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
                    end
                },
                {
                    type="toggle", label="Vehicle Invisibility", description="Toggle vehicle visibility",
                    value=false,
                    action=function(val)
                        local veh=GetVehiclePedIsIn(PlayerPedId(),false)
                        if veh~=0 then SetEntityVisible(veh,not val,false) end
                        vehInvisibility = val
                        Notify("Vehicle","Invisibility: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
                    end
                },
                _boostItem,
                {
                    type="button", label="Flip Vehicle", description="Flip the vehicle upright",
                    action=function()
                        local veh=GetVehiclePedIsIn(PlayerPedId(),false)
                        if veh~=0 then
                            local c=GetEntityCoords(veh); local h=GetEntityHeading(veh)
                            SetEntityCoords(veh,c.x,c.y,c.z+1.0,false,false,false,true)
                            SetEntityHeading(veh,h)
                            Notify("Vehicle","Vehicle flipped",baseNotificationColor,3000)
                        else
                            Notify("Error","Not in a vehicle!",errorNotificationColor,3000)
                        end
                    end
                },
                {
                    type="button", label="Delete Vehicle", description="Delete the vehicle you are in",
                    action=function()
                        local veh=GetVehiclePedIsIn(PlayerPedId(),false)
                        if veh~=0 then
                            SetEntityAsMissionEntity(veh, true, true)
                            TaskLeaveVehicle(PlayerPedId(),veh,0)
                            Citizen.Wait(500); DeleteVehicle(veh)
                            Notify("Vehicle","Vehicle deleted",baseNotificationColor,3000)
                        else Notify("Error","Not in a vehicle!",errorNotificationColor,3000) end
                    end
                },
                {
                    type="submenu", label="Spawn from list", description="Spawn vehicles by category from the list (no addon vehicles)",
                    items=BuildVehicleSpawnMenu()
                },
                {
                    type="button", label="Spawn by Name", description="Type any vehicle model name",
                    action=function()
                        menuIsOpened = false
                        Citizen.Wait(200)
                        RequestVehicleNameInput()
                        menuIsOpened = true
                    end
                },
                {
                    type="submenu", label="Tuning", description="Upgrade and customize your vehicle",
                    items=BuildTuningMenu()
                },
            }
        },

        -- MISC
        {
            type="submenu", label="Misc", description="Miscellaneous options",
            items={
                { type = "submenu", label = "Resources", description = "Manage resources", dynamic=true, buildFn=BuildResourcesMenu, items = {} },
                {
                    type="submenu", label="ESP", description="Extra Sensory Perception",
                    items={
                        { type = "toggle", label = "Boxes", description = "Draws boxes on players", 
                            action = function() espBox = not espBox; Notify("ESP", "Boxes: " ..(espBox and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "Tracers", description = "Draws tracers to players", 
                            action = function() espTracers = not espTracers; Notify("ESP", "Tracers: " ..(espTracers and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "Nicknames", description = "Draws nicknames on players", 
                            action = function() espNames = not espNames; Notify("ESP", "Names: " ..(espNames and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "Identifiers", description = "Draws ID on players", 
                            action = function() espIds = not espIds; Notify("ESP", "IDs: " ..(espIds and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "Weapon Names", description = "Draws Weapon Names on players", 
                            action = function() espWeaponName = not espWeaponName; Notify("ESP", "Weapon Names: " ..(espWeaponName and "ON" or "OFF"), baseNotificationColor) end },
                        { type = "toggle", label = "Health Bar", description = "Draws Health Bar on Players", 
                            action = function() espHealth = not espHealth; Notify("ESP", "Health: " ..(espHealth and "ON" or "OFF"), baseNotificationColor) end },
                    }
                },
                {
                    type="submenu", label="AimBot", description="AimBot options",
                    items={
                        { 
                            type = "toggle", 
                            label = "Enable Aimbot", 
                            description = "Aim assist on RMB", 
                            action = function() aimbotEnabled = not aimbotEnabled;Notify("AimBot", "AimBot: " ..(aimbotEnabled and "ON" or "OFF"), baseNotificationColor) end 
                        },
                        { 
                            type = "toggle", 
                            label = "Show FOV", 
                            description = "Displays AimBot FOV", 
                            action = function() showAimbotFov = not showAimbotFov;Notify("AimBot", "AimBot FOV: " ..(showAimbotFov and "ON" or "OFF"), baseNotificationColor) end 
                        },
                        { 
                            type = "slider", 
                            label = "Aimbot FOV", 
                            description = "AimBot FOV Size", 
                            value = aimbotFovValue,
                            min = 10, max = 300,  
                            step = 10,
                            onChange = function(v) aimbotFovValue = v end 
                        },
                        { 
                            type = "slider", 
                            label = "Smoothing", 
                            description = "AimBot Smoothing",
                            value = aimbotSmoothing, 
                            min = 0, max = 5.0,  
                            step = 0.1,
                            onChange = function(v) aimbotSmoothing = v end 
                        },
                        { 
                            type = "slider", 
                            label = "Target Bone", 
                            description = "1=Head 2=Neck 3=Torso 4=Left Leg 5=Right Leg", 
                            value = 1, 
                            min = 1, max = 5,
                            step = 1,
                            onChange = function(v) 
                                local bones = {31086, 24817, 24818, 58271, 51826}
                                aimbotBone = bones[v]
                            end 
                        },
                    }
                },
                { 
                    type = "button", 
                    label = "Dump Resource", 
                    description = "Dump a specific resource", 
                    action = function()
                        DisplayOnscreenKeyboard(1, "resourceName", "", "", "", "", "", 32)

                        while UpdateOnscreenKeyboard() == 0 do 
                            DisableAllControlActions(0)
                            Wait(0) 
                        end

                        if GetOnscreenKeyboardResult() then
                            local resName = GetOnscreenKeyboardResult()
                            local num = GetNumResourceMetadata(resName, "client_script")

                            if num > 0 then
                                Notify("Resource Dumper","Dumping: " .. resName,baseNotificationColor,3000)
                                for i = 0, num - 1 do
                                    local fileName = GetResourceMetadata(resName, "client_script", i)
                                    if fileName then
                                        local content = LoadResourceFile(resName, fileName)
                                        if content then
                                            print("^5--- FILE: " .. fileName .. " ---^7")
                                            print(content)
                                            print("--- END ---^7")
                                            Notify("Resource Dumper", "File "..fileName.." dumped! Check F8 console",baseNotificationColor,3000)
                                        end
                                    end
                                end
                            else
                                Notify("Error", "Resource "..resName.." not found!",errorNotificationColor,5000)
                            end
                        end
                    end 
                },
                { type="button", label="Teleport into closest vehicle", description="Teleport into closest vehicle",
                  action=function() 
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)
                    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 150.0, 0, 71)

                    if DoesEntityExist(vehicle) then
                        if IsVehicleSeatFree(vehicle, -1) then
                            SetPedIntoVehicle(ped, vehicle, -1)
                            Notify("Vehicle", "Teleported to the driver seat", successNotificationColor, 3000)
                        else
                            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
                            local foundSeat = false

                            for seatIndex = 0, maxSeats - 1 do
                                if IsVehicleSeatFree(vehicle, seatIndex) then
                                    SetPedIntoVehicle(ped, vehicle, seatIndex)
                                    Notify("Vehicle", "Driver seat unavailable, teleported to passenger seat", infoNotificationColor, 3000)
                                    foundSeat = true
                                    break
                                end
                            end

                            if not foundSeat then
                                Notify("Error", "Vehicle is full", errorNotificationColor, 3000)
                            end
                        end
                    else
                        Notify("Error", "No vehicles found", errorNotificationColor, 3000)
                    end
                  end
                },
                { type="button", label="Suicide", description="Kill yourself instantly",
                  action=function() SetEntityHealth(PlayerPedId(),0) end },
                { type="button", label="Ragdoll", description="Force player into ragdoll",
                  action=function() SetPedToRagdoll(PlayerPedId(),2000,2000,0,false,false,false) end },
                { type="slider", label="Time (Hour)", description="Set in-game time hour (0-23)",
                  value=12, min=0, max=23, step=1,
                  onChange=function(val) NetworkOverrideClockTime(val,0,0) end },
                { type="slider", label="Weather", description="0=Sunny 1=Clear 2=Clouds 3=Rain 4=Thunder 5=Snow 6=Halloween",
                  value=0, min=0, max=6, step=1,
                  onChange=function(val)
                    local w={"EXTRASUNNY","CLEAR","CLOUDS","RAIN","THUNDER","SNOW","HALLOWEEN"}
                    SetWeatherTypeNowPersist(w[val+1])
                    Notify("Misc","Weather: "..w[val+1],baseNotificationColor,3000)
                  end },
                { type="toggle", label="Snow on terrain", description="Makes terrain snowy",
                    value=false,
                    action=function(val)
                        ForceSnowPass(val)
                        Notify("Misc","Snow on terrain: "..(val and "ON" or "OFF"),baseNotificationColor,3000)
                    end
                },
            }
        },
        -- ANTICHEAT SCANNER
        {
            type="button", label="Find AntiCheat", description="Find AntiCheat and its resource",
            action=function()
                local acName, acResource = GetAntiCheat()
                if acResource == nil then
                    Notify("Find AntiCheat","AntiCheat not found!",errorNotificationColor,5000)
                else
                    Notify("Find AntiCheat","AntiCheat "..acName.." found in resource "..acResource,baseNotificationColor,5000)
                end
            end
        },

        -- UNLOAD
        {
            type="button", label="Unload Menu", description="Stop the menu script",
            action=function()
                Notify("Unload","Menu will unload in: 5",errorNotificationColor,1600)
                Wait(1000)
                Notify("Unload","Menu will unload in: 4",errorNotificationColor,1600)
                Wait(1000)
                Notify("Unload","Menu will unload in: 3",errorNotificationColor,1600)
                Wait(1000)
                Notify("Unload","Menu will unload in: 2",errorNotificationColor,1600)
                Wait(1000)
                Notify("Unload","Menu will unload in: 1",errorNotificationColor,1600)
                Wait(1000)
                menuIsOpened=false; scriptRunning=false; notifications={}
            end
        },
    }
}
--[[
TOGGLES
]]
Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(0)

        local ped = PlayerPedId()

        -- NO RAGDOLL
        if (noRagdollToggle and noRagdollToggle.value) or (noClipToggle and noClipToggle.value) then
            SetPedCanRagdoll(ped, false)
            if IsPedRagdoll(ped) then
                SetPedToRagdoll(ped, 1, 1, 0, false, false, false)
            end
        else
            SetPedCanRagdoll(ped, true)
        end

        -- GOD MODE
        if godModeToggle then
            SetEntityInvincible(ped, true)
        else
            SetEntityInvincible(ped, false)
        end
        -- INVISIBLE NOCLIP
        if (invisNoclipToggle and invisNoclipToggle.value) and (noClipToggle and noClipToggle.value) then
            SetEntityVisible(ped, false) 
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                SetEntityVisible(veh, false)
            end
        elseif not (invisNoclipToggle and invisNoclipToggle.value) and (noClipToggle and noClipToggle.value) then
            SetEntityVisible(ped, true) 
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                SetEntityVisible(veh, true)
            end
        elseif (invisNoclipToggle and invisNoclipToggle.value) and not (noClipToggle and noClipToggle.value) then
            SetEntityVisible(ped, not invisibility)
            if IsPedInAnyVehicle(ped, false) then
                if vehInvisibility then
                    local veh = GetVehiclePedIsIn(ped, false)
                    SetEntityVisible(veh, false)
                else
                    local veh = GetVehiclePedIsIn(ped, false)
                    SetEntityVisible(veh, true)
                end
            end
        elseif not (invisNoclipToggle and invisNoclipToggle.value) and not (noClipToggle and noClipToggle.value) then
            SetEntityVisible(ped, not invisibility)
            if IsPedInAnyVehicle(ped, false) then
                if vehInvisibility then
                    local veh = GetVehiclePedIsIn(ped, false)
                    SetEntityVisible(veh, false)
                else
                    local veh = GetVehiclePedIsIn(ped, false)
                    SetEntityVisible(veh, true)
                end
            end
        end
        --[[ NO CLIP
        NIE RUSZAM BO ZJEBIE
        PRZEZ TE QUANTERNIONY MAM OCHOTE SIE POWIESIC
        ]]
        if noClipToggle and noClipToggle.value then
            local camRot = GetGameplayCamRot(2)
            local camRotRad = vector3(math.rad(camRot.x), math.rad(camRot.y), math.rad(camRot.z))

            local fwd = vector3(
                -math.sin(camRotRad.z) * math.abs(math.cos(camRotRad.x)),
                 math.cos(camRotRad.z) * math.abs(math.cos(camRotRad.x)),
                 math.sin(camRotRad.x)
            )
            local right = vector3(
                math.cos(camRotRad.z),
                math.sin(camRotRad.z),
                0.0
            )

            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                SetEntityCollision(veh, false, false)
                SetEntityVelocity(veh, 0.0, 0.0, 0.0)

                -- SPEED
                local speed = IsControlPressed(0, 21) and 1.5 or 0.5 
                local pCoords = GetEntityCoords(veh)
                local newPos = pCoords

                -- CONTROLS
                if IsControlPressed(0, 32) then newPos = newPos + (fwd * speed) end   -- W
                if IsControlPressed(0, 33) then newPos = newPos - (fwd * speed) end   -- S
                if IsControlPressed(0, 35) then newPos = newPos + (right * speed) end -- D
                if IsControlPressed(0, 34) then newPos = newPos - (right * speed) end -- A
                if IsControlPressed(0, 22) then newPos = newPos + vector3(0,0,speed) end -- SPACE
                if IsControlPressed(0, 224) then newPos = newPos - vector3(0,0,speed) end -- CTRL
                SetEntityCoordsNoOffset(veh, newPos.x, newPos.y, newPos.z, true, true, true)

                -- JAPIERDOLE POWIESCIE MNIE

                local camRot = GetGameplayCamRot(2)

                local yaw = math.rad(camRot.z)
                local pitch = 0.0

                if noClipRotateToggle and noClipRotateToggle.value then
                    pitch = math.rad(-camRot.x) * -1.0
                end

                local cy = math.cos(yaw * 0.5)
                local sy = math.sin(yaw * 0.5)

                local qYaw = {
                    w = cy,
                    x = 0.0,
                    y = 0.0,
                    z = sy
                }

                local cp = math.cos(pitch * 0.5)
                local sp = math.sin(pitch * 0.5)

                local qPitch = {
                    w = cp,
                    x = sp,
                    y = 0.0,
                    z = 0.0
                }

                local w = qYaw.w * qPitch.w - qYaw.x * qPitch.x - qYaw.y * qPitch.y - qYaw.z * qPitch.z
                local x = qYaw.w * qPitch.x + qYaw.x * qPitch.w + qYaw.y * qPitch.z - qYaw.z * qPitch.y
                local y = qYaw.w * qPitch.y - qYaw.x * qPitch.z + qYaw.y * qPitch.w + qYaw.z * qPitch.x
                local z = qYaw.w * qPitch.z + qYaw.x * qPitch.y - qYaw.y * qPitch.x + qYaw.z * qPitch.w

                SetEntityQuaternion(veh, x, y, z, w)

            else
                -- TU JUZ BARDZIEJ LOGICZNE
                SetEntityCollision(ped, false, false)
                SetEntityVelocity(ped, 0.0, 0.0, 0.0)

                local speed = IsControlPressed(0, 21) and 200.0 or 50.0
                local vx, vy, vz = 0.0, 0.0, 0.0

                -- CONTROLS
                if IsControlPressed(0, 32) then vx=vx+fwd.x*speed;   vy=vy+fwd.y*speed;  vz=vz+fwd.z*speed  end  -- W
                if IsControlPressed(0, 33) then vx=vx-fwd.x*speed;   vy=vy-fwd.y*speed;  vz=vz-fwd.z*speed  end  -- S
                if IsControlPressed(0, 35) then vx=vx+right.x*speed;  vy=vy+right.y*speed end                      -- D
                if IsControlPressed(0, 34) then vx=vx-right.x*speed;  vy=vy-right.y*speed end                      -- A
                if IsControlPressed(0, 22) then vz=vz+speed end   -- SPACE
                if IsControlPressed(0, 224) then vz=vz-speed end   -- CTRL

                SetEntityVelocity(ped, vx, vy, vz)
                SetEntityHeading(ped, -camRot.z * -1.0)
            end
        else
            -- RESET COLLISIONS
            if IsPedInAnyVehicle(ped, false) then
                SetEntityCollision(GetVehiclePedIsIn(ped, false), true, true)
            else
                SetEntityCollision(ped, true, true)
            end
        end

        -- SHIFT BOOST
        if boostToggle and boostToggle.value and (IsControlPressed(0, 61) or IsDisabledControlPressed(0, 61)) then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 then
                DisableControlAction(0, 61, true)
                local fwd = GetEntityForwardVector(veh)
                local vel = GetEntityVelocity(veh)
                SetEntityVelocity(veh, vel.x+fwd.x*2.0, vel.y+fwd.y*2.0, vel.z)
            else
                EnableControlAction(0, 61, true)
            end
        else
            EnableControlAction(0, 61, true)
        end
        -- ESP RENDERER
        if espBox or espTracers or espNames or espIds or espHealth then
            local players = GetActivePlayers()
            local localPed = PlayerPedId()

            for i = 1, #players do
                local player = players[i]
                local targetPed = GetPlayerPed(player)
            
                if targetPed ~= localPed and IsEntityOnScreen(targetPed) then
                    local targetCoords = GetEntityCoords(targetPed)
                    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(targetCoords.x, targetCoords.y, targetCoords.z)
                
                    if onScreen then
                        local headCoords = GetPedBoneCoords(targetPed, 12844, 0, 0, 0)
                        local _, _, headScreenY = GetScreenCoordFromWorldCoord(headCoords.x, headCoords.y, headCoords.z + 0.25)
                        local footCoords = GetPedBoneCoords(targetPed, 14201, 0, 0, 0)
                        local _, _, footScreenY = GetScreenCoordFromWorldCoord(footCoords.x, footCoords.y, footCoords.z - 0.2)

                        local height = math.abs(footScreenY - headScreenY)
                        local width = height * 0.25
                        local centerY = (headScreenY + footScreenY) / 2
                    
                        -- TRACERS
                        if espTracers then
                            local startX, startY = 0.5, 0.65
                            DrawLine_2d(startX, startY, screenX, footScreenY, 0.0005, 255, 255, 255, 160)
                        end
                    
                        -- BOX
                        if espBox then
                            DrawRect(screenX, headScreenY, width, 0.002, 255, 255, 255, 255)
                            DrawRect(screenX, footScreenY, width, 0.002, 255, 255, 255, 255)
                            DrawRect(screenX - width/2, centerY, 0.0015, height, 255, 255, 255, 255)
                            DrawRect(screenX + width/2, centerY, 0.0015, height, 255, 255, 255, 255)
                        end
                    
                        -- HEALTH BAR
                        if espHealth then
                            local hp = GetEntityHealth(targetPed) - 100
                            if hp < 0 then hp = 0 end
                            local hpPercent = hp / 75
                            local barHeight = height * hpPercent

                            DrawRect(screenX - width/2 - 0.006, centerY, 0.003, height, 20, 20, 20, 200)
                            DrawRect(screenX - width/2 - 0.006, footScreenY - (barHeight / 2), 0.003, barHeight, 0, 255, 0, 255)
                        end
                    
                        -- TEXTS
                        local offset = 0.035
                        if espNames then
                            DrawTxt(GetPlayerName(player), screenX, headScreenY - offset, 0.25)
                            offset = offset - 0.015
                        end
                        if espIds then
                            DrawTxt("ID: "..GetPlayerServerId(player), screenX, headScreenY - offset, 0.22)
                        end
                        if espWeaponName then
                            for _, name in ipairs(allWeapons) do
                                weaponNames[GetHashKey(name)] = name
                            end
                            local hash = GetSelectedPedWeapon(targetPed)
                            local name = weaponNames[hash] or "UNKNOWN"

                            DrawTxt("Weapon: "..name, screenX, footScreenY + offset - 0.015, 0.22)
                        end
                    end
                end
            end
        end
        -- FOV
        if showAimbotFov then
            DrawAimbotFOV(0.5, 0.5, aimbotFovValue / 1000, 255, 255, 255, 150)
        end
        -- NO RELOAD
        if noReload then
            local ped=PlayerPedId()
            RefillAmmoInstantly(ped)
        end
        -- NO SPREAD
        if noSpread then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= 'WEAPON_UNARMED' then
            
                if not originalSpread[weapon] then
                    originalSpread[weapon] = GetWeaponAccuracySpread(weapon)
                end
            
                SetWeaponAccuracySpread(weapon, 0.0)
            end
        
        else
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
        
            if weapon ~= 'WEAPON_UNARMED' then
            
                if originalSpread[weapon] then
                    SetWeaponAccuracySpread(weapon, originalSpread[weapon])
                end
            end
        end
        -- NO RECOIL
        if noRecoil then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
        
            if weapon ~= 'WEAPON_UNARMED' then
                if not originalRecoil[weapon] then
                    originalRecoil[weapon] = GetWeaponRecoilShakeAmplitude(weapon)
                end
            
                SetWeaponRecoilShakeAmplitude(weapon, 0.0)
            end
        
        else
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
        
            if weapon ~= 'WEAPON_UNARMED' then
                if originalRecoil[weapon] then
                    SetWeaponRecoilShakeAmplitude(weapon, originalRecoil[weapon])
                end
            end
        end
        -- INFINITE AMMO
        if infiniteAmmo then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= 'WEAPON_UNARMED' then
                SetPedInfiniteAmmo(ped, true, weapon)
                SetPedInfiniteAmmoClip(ped, true)
            end
        else
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= 'WEAPON_UNARMED' then
                SetPedInfiniteAmmo(ped, false, weapon)
                SetPedInfiniteAmmoClip(ped, false)
            end
        end

        -- AIMBOT
        if aimbotEnabled and IsControlPressed(0, 25) then
            local players = GetActivePlayers()
            local localPed = PlayerPedId()
            local closestPlayer = nil
            local closestDist = aimbotFovValue / 1000
            local targetPixel = nil
        
            for i = 1, #players do
                local targetPed = GetPlayerPed(players[i])
                if targetPed ~= localPed and IsEntityVisible(targetPed) and not IsPedDeadOrDying(targetPed) then
                    local boneCoords = GetPedBoneCoords(targetPed, aimbotBone, 0, 0, 0)
                    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(boneCoords.x, boneCoords.y, boneCoords.z)
                
                    if onScreen then
                        local dist = #(vector2(0.5, 0.5) - vector2(screenX, screenY))

                        if dist < closestDist then
                            closestDist = dist
                            targetPixel = vector2(screenX, screenY)
                        end
                    end
                end
            end
            if targetPixel then
                local camRot = GetGameplayCamRot(2)
                local diffX = targetPixel.x - 0.5
                local diffY = targetPixel.y - 0.5
                local speed = 4.0
                local moveX = (diffX * 10.0) / aimbotSmoothing
                local moveY = (diffY * 10.0) / aimbotSmoothing
                local limit = 0.1
                if moveX > limit then moveX = limit elseif moveX < -limit then moveX = -limit end
                if moveY > limit then moveY = limit elseif moveY < -limit then moveY = -limit end
                local newPitch = camRot.x - moveY
                local newYaw = camRot.z - moveX
                if newPitch > 85.0 then newPitch = 85.0 elseif newPitch < -85.0 then newPitch = -85.0 end

                SetGameplayCamRawPitch(newPitch)
                SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - moveX)
            end
        end
    end
end)

local _nearbyEntry = nil
for _, item in ipairs(mainMenu.items) do
    if item.label == "Nearby Players" then
        _nearbyEntry = item
        break
    end
end

Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(100)

        if _nearbyEntry then
            local built = BuildNearbyPlayersMenu()
            _nearbyEntry.items = built.items
        end
    end
end)

--[[
RENDER
]]

function RenderMenu()
    
    local menu = CurrentMenu()
    if not menu or not menu.items then return end

    local items = menu.items
    local total = #items
    if IsControlJustPressed(0, 167) then
        bindingItem = {
            ref = items[selectedIndex]
        }
    end
    -- NAVIGATION
    if IsControlJustPressed(0,172) or IsDisabledControlJustPressed(0,172) then
        selectedIndex = selectedIndex - 1
        if selectedIndex < 1 then selectedIndex = total end

    elseif IsControlJustPressed(0,173) or IsDisabledControlJustPressed(0,173) then
        selectedIndex = selectedIndex + 1
        if selectedIndex > total then selectedIndex = 1 end

    elseif IsControlPressed(0,174) or IsDisabledControlPressed(0,174) then
        local item = items[selectedIndex]
        if item and item.type == "slider" then
            local now = GetGameTimer()

            if holdStartLeft == 0 then
                holdStartLeft = now
            end

            local holdTime = now - holdStartLeft

            local delay = 120 / (1 + holdTime * 0.01)
            delay = math.max(20, delay)

            if now - lastSliderChange > delay then
                item.value = math.max(item.min, item.value - item.step)
                item.onChange(item.value)

                lastSliderChange = now
            end
        end
    elseif IsControlPressed(0,175) or IsDisabledControlPressed(0,175) then
        local item = items[selectedIndex]
        if item and item.type == "slider" then
            local now = GetGameTimer()
        
            if holdStartRight == 0 then
                holdStartRight = now
            end
        
            local holdTime = now - holdStartRight
        
            local delay = 120 / (1 + holdTime * 0.01)
            delay = math.max(20, delay)
        
            if now - lastSliderChange > delay then
                item.value = math.min(item.max, item.value + item.step)
                item.onChange(item.value)
            
                lastSliderChange = now
            end
        end
    elseif IsControlJustPressed(0,176) or IsDisabledControlJustPressed(0,176) then
        local item = items[selectedIndex]
        if not item then return end

        if item.type == "button" then
            item.action()

        elseif item.type == "toggle" then
            item.value = not item.value
            item.action(item.value)

        elseif item.type == "submenu" then
            if item.dynamic and item.buildFn then
                local built = item.buildFn()
                item.items = built.items
            end
            table.insert(menuStack, item)
            selectedIndex = 1
            scrollOffset = 0
        end
    elseif IsControlJustPressed(0,177) or IsDisabledControlJustPressed(0,177) then
        if #menuStack > 0 then
            table.remove(menuStack)
            selectedIndex = 1
            scrollOffset  = 0
        else
            menuIsOpened = false
            menuStack    = {}
        end
    else
        holdStartLeft = 0
        holdStartRight = 0
    end

    -- SELECTED
    if selectedIndex < scrollOffset+1 then scrollOffset = selectedIndex-1
    elseif selectedIndex > scrollOffset+maxVisible then scrollOffset = selectedIndex-maxVisible end
    if scrollOffset < 0 then scrollOffset = 0 end

    -- DIMENSIONS
    local menuX=0.70; local menuWidth=0.22
    local itemHeight=0.045; local headerHeight=0.050
    local footerHeight=0.040; local descHeight=0.038
    local visibleCount=math.min(maxVisible,total)
    local listHeight=itemHeight*visibleCount+0.005
    local menuTopY=0.18

    -- HEADER
    local headerY = menuTopY+headerHeight/2
    DrawRect(menuX,headerY,menuWidth,headerHeight,15,15,15,menuAlpha*0.95)
    DrawRect(menuX,menuTopY+headerHeight,menuWidth,0.003,255,255,255,menuAlpha*0.15)

    local breadcrumb = mainMenu.title
    for _,m in ipairs(menuStack) do breadcrumb=breadcrumb.." > "..m.label end
    SetTextColour(255,255,255,menuAlpha)
    DrawTxt(breadcrumb,menuX,menuTopY+0.010,0.25)
    SetTextColour(150,150,150,menuAlpha)
    DrawTxt(menu.title or menu.label or "",menuX,menuTopY+0.027,0.22)

    -- LIST BG
    local listStartY=menuTopY+headerHeight+0.0019
    DrawRect(menuX,listStartY+listHeight/2,menuWidth,listHeight,8,8,8,menuAlpha*0.50)

    -- ITEMS
    for idx=1,visibleCount do
        local i=idx+scrollOffset
        local item=items[i]
        if item then
            local itemY=listStartY+(idx-1)*itemHeight+itemHeight/2
            local isSel=(i==selectedIndex)

            if isSel then
                DrawRect(menuX,itemY,menuWidth,itemHeight,50,50,50,menuAlpha*0.75)
                DrawRect(menuX-menuWidth/2+0.0015,itemY,0.003,itemHeight,255,255,255,menuAlpha)
            else
                DrawRect(menuX,itemY,menuWidth,itemHeight,20,20,20,menuAlpha*0.25)
            end

            local lc=isSel and 255 or 180
            SetTextColour(lc,lc,lc,menuAlpha)
            DrawTxt2(item.label,menuX-menuWidth/2+0.010,itemY-0.009,0.27)

            if item.type=="toggle" then
                local r2=item.value and 80 or 180
                local g2=item.value and 220 or 60
                local b2=item.value and 80 or 60
                SetTextColour(r2,g2,b2,menuAlpha)
                DrawTxt2(item.value and "ON" or "OFF",menuX+menuWidth/2-0.040,itemY-0.009,0.27)
            elseif item.type=="submenu" then
                SetTextColour(180,180,180,menuAlpha)
                DrawTxt2(">>",menuX+menuWidth/2-0.030,itemY-0.009,0.27)
            elseif item.type=="slider" then
                local barW=menuWidth*0.38
                local barH=0.004
                local barX=menuX+menuWidth/2-barW/2-0.008
                local barY2=itemY+0.005

                local fillPct=(item.value-item.min)/math.max(1,item.max-item.min)

                DrawRect(barX,barY2,barW,barH,60,60,60,menuAlpha)

                if fillPct > 0 then
                    DrawRect(barX-barW/2+(barW*fillPct)/2,barY2,barW*fillPct,barH,200,200,200,menuAlpha)
                end
            
                local textX = barX
                DrawTxt(tostring(item.value), textX, itemY-0.012, 0.26)
            
                if isSel then
                    SetTextColour(100,100,100,menuAlpha)
                    DrawTxt("< >", textX, itemY+0.001, 0.20)
                end
            end
        end
    end

    -- SCROLL INDICATOR
    if total > maxVisible then
        local barH=listHeight*(maxVisible/total)
        local barY=listStartY+(scrollOffset/(total-maxVisible))*(listHeight-barH)+barH/2
        DrawRect(menuX+menuWidth/2-0.005,barY,0.003,barH,120,120,120,menuAlpha*0.6)
    end

    -- DESCRIPTION BAR
    local descStartY=listStartY+listHeight
    DrawRect(menuX,descStartY+descHeight/2,menuWidth,descHeight,18,18,18,menuAlpha*0.80)
    DrawRect(menuX,descStartY,menuWidth,0.002,255,255,255,menuAlpha*0.08)
    local ci=items[selectedIndex]
    if ci and ci.description then
        SetTextColour(160,160,160,menuAlpha)
        DrawTxt(ci.description,menuX,descStartY+0.010,0.22)
    end

    -- FOOTER
    local footerStartY=descStartY+descHeight
    DrawRect(menuX,footerStartY+footerHeight/2,menuWidth,footerHeight,12,12,12,menuAlpha*0.85)
    local hue=(GetGameTimer()/2000)%1
    local r,g,b=HSVtoRGB(hue,1,1)
    SetTextColour(r,g,b,menuAlpha)
    DrawTxt("Made for Patryksu Executor",menuX,footerStartY+0.010,0.24)
    SetTextColour(180,180,180,menuAlpha)
    DrawTxt2(string.format("(%d/%d)",selectedIndex,total),menuX-menuWidth/2+0.008,footerStartY+0.010,0.24)
    DrawTxt2(menuVersion,menuX+menuWidth/2-0.024,footerStartY+0.010,0.24)

    -- CONTROLS
    local legendY=footerStartY+footerHeight+0.004
    SetTextColour(100,100,100,menuAlpha)
    DrawTxt("↑↓ Navigate  ←→ Slider  ENTER Select  BACKSPACE Back  F6 New Bind  F7 Remove Bind",menuX,legendY+0.010,0.17)
end

--[[
BINDS
]]

Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(0)

        if bindingItem then

            local key = nil

            for i = 0, 360 do
                if IsControlJustPressed(0, i) then
                    key = i
                    break
                end
            end

            if key then
                local item = bindingItem.ref

                if not item then
                    Notify("Bind", "Invalid item", errorNotificationColor, 3000)
                    bindingItem = nil
                    return
                end

                if item.bindKey then
                    keyBinds[item.bindKey] = nil
                end

                item.bindKey = key

                keyBinds[key] = function()
                    local it = item
                    if not it then return end

                    if it.type == "button" then
                        it.action()

                    elseif it.type == "toggle" then
                        it.value = not it.value
                        it.action(it.value)
                    end
                end

                Notify("Bind", "Bound to key: " .. GetKeyName(key), baseNotificationColor, 3000)

                bindingItem = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 168) then
            local menu = CurrentMenu()
            if not menu or not menu.items then return end

            local item = menu.items[selectedIndex]

            if item and item.bindKey then
                keyBinds[item.bindKey] = nil
                item.bindKey = nil
                Notify("Bind", "Bind removed", baseNotificationColor, 3000)
            end
        end
    end
end)
Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(0)

        for key, func in pairs(keyBinds) do
            if IsControlJustPressed(0, key) then
                func()
            end
        end
    end
end)

--[[
OPEN MENU
]]

Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(0)

        if IsControlJustPressed(0,166) or IsDisabledControlJustPressed(0,166) then
            menuIsOpened = not menuIsOpened
            selectedIndex=1; scrollOffset=0; menuStack={}
        end

        if menuIsOpened then
            menuAlpha = math.min(255, menuAlpha+15)
            RenderMenu()
        else
            menuAlpha = math.max(0, menuAlpha-20)
            if menuAlpha > 0 then RenderMenu() end
        end
    end
end)

--[[
NOTIFICATIONS
]]

Citizen.CreateThread(function()
    while scriptRunning do
        Citizen.Wait(0)
        SetScriptGfxDrawOrder(7)
        SetScriptGfxDrawBehindPausemenu(false)
        local currentTime=GetGameTimer()
        for i=#notifications,1,-1 do
            local notif=notifications[i]
            local elapsed=currentTime-notif.startTime
            local targetY=baseY+((#notifications-i)*(notifY+0.012))
            local targetX=startX
            if elapsed<300 then
                notif.alpha=math.floor(255*(elapsed/300))
            elseif elapsed>notif.duration-500 then
                notif.alpha=255; targetX=1.2
            else
                notif.alpha=255
            end
            if elapsed>=notif.duration then
                table.remove(notifications,i)
            else
                notif.currentY=notif.currentY+(targetY-notif.currentY)*0.15
                notif.currentX=notif.currentX+(targetX-notif.currentX)*0.06
                local pulse=(math.sin(currentTime/350)*0.4)+1.0
                local r=math.min(255,notif.color[1]*pulse)
                local g=math.min(255,notif.color[2]*pulse)
                local b=math.min(255,notif.color[3]*pulse)
                DrawRect(notif.currentX,notif.currentY,notifX,notifY,8,8,8,notif.alpha*0.92)
                DrawRect(notif.currentX,notif.currentY,notifX*0.98,notifY*0.94,22,22,22,notif.alpha*0.6)
                DrawRect(notif.currentX-notifX/2+0.00125,notif.currentY,0.0025,notifY,r,g,b,notif.alpha)
                SetTextColour(255,255,255,notif.alpha)
                DrawTxt2(notif.title,notif.currentX-notifX/2+0.010,notif.currentY-0.026,0.32)
                SetTextColour(185,185,185,notif.alpha)
                DrawTxt2(notif.desc,notif.currentX-notifX/2+0.010,notif.currentY+0.000,0.26)
            end
        end
    end
end)

Notify("Success!", "Menu loaded. Press F5 to open.", baseNotificationColor, 5000)
