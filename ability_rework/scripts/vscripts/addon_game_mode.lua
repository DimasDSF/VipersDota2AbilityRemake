local RADIANT_TEAM_MAX_PLAYERS = 1
local DIRE_TEAM_MAX_PLAYERS = 8
local RUNE_SPAWN_TIME_POWERUP = 2
local RUNE_SPAWN_TIME_BOUNTY = 5
local VGMAR_DEBUG = false
local VGMAR_DEBUG_DRAW = false
local VGMAR_DEBUG_ENABLE_VARIABLE_SETTING = true
local VGMAR_GIVE_DEBUG_ITEMS = false
local VGMAR_BOT_FILL = true
local VGMAR_LOG_BALANCE_PERIODIC = false
local VGMAR_LOG_BALANCE_EVENTS = false
local VGMAR_LOG_BALANCE_GAMEEND = false
local VGMAR_LOG_BALANCE_INTERVAL = 120
local MAX_COURIER_LVL = 5
local COURIER_UPGRADE_TIME = 3
local BOT_COURIER_UPGRADE_INTERVAL = 10
--/////////////////////////
-- Think Function Interval
--/////////////////////////
local VGMAR_GTHINK_TIME = 1
--/////////////////////////

require('libraries/timers')
require('libraries/extensions')
require('libraries/heronames')
require('libraries/heroabilityslots')
require('libraries/loglib')
require('libraries/keyvaluesmanager')
require('libraries/inventorymanager')
require('libraries/botroleslib')
require('libraries/botsupportlib')

--/////////////////////////

local debugitems = {
	["item_shivas_guard"] = 0,
	["item_assault"] = 0,
	["item_sheepstick"] = 0,
	["item_ogre_axe"] = 0,
	["item_travel_boots_2"] = 1,
	["item_diffusal_blade"] = 1,
	["item_octarine_core"] = 0,
	["item_kaya"] = 0,
	["item_aether_lens"] = 0,
	["item_ultimate_scepter"] = 1,
	["item_mystic_staff"] = 0,
	["item_energy_booster"] = 0,
	["item_soul_booster"] = 0,
	["item_butterfly"] = 0,
	["item_bfury"] = 0,
	["item_eagle"] = 0,
	["item_orb_of_venom"] = 0,
	["item_silver_edge"] = 0,
	["item_yasha"] = 0,
	["item_dragon_lance"] = 4,
	["item_demon_edge"] = 2,
	["item_mask_of_madness"] = 0,
	["item_gloves"] = 0,
	["item_ethereal_blade"] = 0,
	["item_tome_of_knowledge"] = 3,
	["item_blade_mail"] = 0,
}

--Creep -> Building Damage Multiplier
local creeptobuildingdmgmult = {
	["npc_dota_creep_lane"] = 0.5,
	["npc_dota_creep_siege"] = 0.25
}

local botpushrewards = {
	basegold = {solo = 200, team = 500},
	basexp = {solo = 300, team = 2000},
	splitgoldxp = {false, true},
	denyfactor = 0.5
}

local botancientlastresort = {
	healththreshold = 0.4,
	gold = 10000,
	xp = 3000
}

local botmodifiers = {
}

local botupgradepriorities = {
	["npc_dota_hero_juggernaut"] = {"travel1", "moonshard", "aghs", "travel2"},
	["npc_dota_hero_kunkka"] = {"travel1", "travel2", "moonshard", "aghs"},
	["npc_dota_hero_dazzle"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_zuus"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_lion"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_jakiro"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_necrolyte"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_sven"] = {"travel1", "moonshard", "aghs", "travel2"},
	["npc_dota_hero_axe"] = {"travel1", "travel2", "aghs", "moonshard"},
	["npc_dota_hero_lina"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_riki"] = {"travel1", "moonshard", "travel2", "aghs"},
	["npc_dota_hero_crystal_maiden"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_oracle"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_bloodseeker"] = {"travel1", "moonshard", "aghs", "travel2"},
	["npc_dota_hero_witch_doctor"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_vengefulspirit"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_bristleback"] = {"travel1", "travel2", "moonshard", "aghs"},
	["npc_dota_hero_skeleton_king"] = {"travel1", "moonshard", "aghs", "travel2"},
	["npc_dota_hero_tiny"] = {"travel1", "moonshard", "travel2", "aghs"},
	["npc_dota_hero_chaos_knight"] = {"travel1", "moonshard", "travel2", "aghs"},
	["npc_dota_hero_phantom_assassin"] = {"travel1", "moonshard", "travel2", "aghs"},
	["npc_dota_hero_sniper"] = {"travel1", "moonshard", "travel2", "aghs"},
	["npc_dota_hero_skywrath_mage"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_bounty_hunter"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_lich"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_razor"] = {"travel1", "aghs", "moonshard", "travel2"},
	["npc_dota_hero_earthshaker"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_death_prophet"] = {"travel1", "travel2", "moonshard", "aghs"},
	["npc_dota_hero_warlock"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_luna"] = {"travel1", "moonshard", "travel2", "aghs"},
	["npc_dota_hero_bane"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_tidehunter"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_pudge"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_viper"] = {"travel1", "moonshard", "aghs", "travel2"},
	["npc_dota_hero_nevermore"] = {"travel1", "aghs", "moonshard", "travel2"},
	["npc_dota_hero_omniknight"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_windrunner"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_sand_king"] = {"travel1", "aghs", "travel2", "moonshard"},
	["npc_dota_hero_dragon_knight"] = {"travel1", "moonshard", "travel2", "aghs"},
	["npc_dota_hero_drow_ranger"] = {"travel1", "aghs", "moonshard", "travel2"}
}

--Preventing bots from spending all early game boost gold on endgame QoL upgrades
local botupgradetimings = {
	travel1 = {30, 0},
	aghs = {0, 0},
	moonshard = {30, 0},
	travel2 = {45, 0}
}

--Add Particles to the last resort modifier
local modifierdatatable = {
	["modifier_vgmar_i_manaregen_aura"] = {radius = 4000, bonusmanaself = 400, bonusmanaallies = 300, regenself = 4.5, regenallies = 2.5},
	["modifier_vgmar_i_attackrange"] = {range = 140, bonusstr = 12, bonusagi = 12},
	["modifier_vgmar_i_castrange"] = {range = 250, manaregen = 3.0, bonusmana = 400},
	["modifier_vgmar_i_spellamp"] = {percentage = 10, costpercentage = 10, bonusint = 16},
	["modifier_vgmar_i_cdreduction"] = {percentage = 25, bonusmana = 905, bonushealth = 905, intbonus = 25, spelllifestealhero = 25, spelllifestealcreep = 5},
	["modifier_vgmar_i_essence_aura"] = {radius = 1000, bonusmana = 900, restorechancemax = 20, restorechancemin = 5, restoremax = 1, restoremin = 0.15, restoreamount = 20},
	["modifier_vgmar_i_spellshield"] = {resistance = 35, cooldown = 12, maxstacks = 2},
	["modifier_vgmar_i_fervor"] = {maxstacks = 15, asperstack = 15},
	["modifier_vgmar_i_essence_shift"] = {reductionprimary = 1, reductionsecondary = 0, increaseprimary = 1, increasesecondary = 0, hitsperstackinc = 1, hitsperstackred = 2, duration = 40, durationtarget = 40},
	["modifier_vgmar_i_pulse"] = {stackspercreep = 1, stacksperhero = 8, duration = 4, hpregenperstack = 1, manaregenperstack = 1.5, maxstacks = 20},
	["modifier_vgmar_i_greatcleave"] = {cleaveperc = 100, cleavestartrad = 150, cleaveendrad = 360, cleaveradius = 700, bonusdamage = 75, manaregen = 3.0},
	["modifier_vgmar_i_vampiric_aura"] = {radius = 700, lspercent = 20, lspercentranged = 15},
	["modifier_vgmar_i_multishot"] = {basetargets = 1, mainattrpertarget = 50, bonusdamage = 60, bonusrange = 140, startradius = 150, endradius = 750, modifierperc = 50},
	["modifier_vgmar_i_midas_greed"] = {min_bonus_gold = 0, count_per_kill = 1, reduction_per_tick = 2, bonus_gold_cap = 40, stack_duration = 30, reduction_duration = 2.5, killsperstack = 3, midasusestacks = 2},
	--["modifier_vgmar_i_kingsaegis_cooldown"] = {cooldown = 240, reincarnate_time = 5},
	["modifier_vgmar_i_consumed_aegis"] = {reincarnate_time = 5, aegisduration = 300, expireregendur = 10},
	["modifier_vgmar_i_critical_mastery"] = {critdmgpercentage = 200, finishercritpercentage = 250, critchance = 20},
	["modifier_vgmar_i_atrophy"] = {radius = 1000, dmgpercreep = 1, dmgperhero = 5, stack_duration = 240, stack_duration_scepter = -1, max_stacks = 1000, initial_stacks = 0},
	["modifier_vgmar_i_deathskiss"] = {critdmgpercentage = 20000, critchance = 1.0},
	["modifier_vgmar_i_truesight"] = {maxrange = 1300, minrange = 200, maxtime = 180},
	["modifier_item_ultimate_scepter_consumed"] = {bonus_all_stats = 10, bonus_health = 175, bonus_mana = 175},
	["modifier_vgmar_i_arcane_intellect"] = {percentage = 10, multpercast = 0.2, bonusint = 25, csmaxmana = 6000, csminmana = 0, minimalcooldown = 1},
	["modifier_vgmar_i_multidimension_cast"] = {multicastchance1 = 50, multicastchance2 = 40, multicastchance3 = 30, multicastchance4 = 20, multicastchance5 = 10, multicastminint1 = 50, multicastminint2 = 70, multicastminint3 = 90, multicastminint4 = 110, multicastminint5 = 130, multicastinterval = 0.2, multicastpointrange = 200, multicastunitrange = 400},
	["modifier_vgmar_i_thirst"] = {threshold = 75, visionthreshold = 50, damagethreshold = 75, visionrange = 10, visionduration = 0.2, giverealvision = 0, givemodelvision = 1, damageperstack = 3, radius = 5000},
	["modifier_vgmar_i_poison_dagger"] = {cooldown = 60, potencycooldown = 10, agiperpotency = 20, maxdistance = 1400, hitdamageperc = 70, manaloss = 25, durationperpot = 10, manacostperc = 10, dmgpermana = 0.2, ticktime = 2, nomanadmgmult = 1, bonusagi = 45, bonusmisschance = 30, daggerspeed = 1000},
	["modifier_vgmar_i_scorching_light"] = {radius = 700, interval = 1.0, visioninterval = 5.0, initialdamage = 60, damageincpertick = 2, maxdamage = 300, missrate = 17, visiondelay = 3, maxillusionstacks = 3, lingerduration = 3.0},
	["modifier_vgmar_i_permafrost"] = {radius = 600, interval = 1.0, attackspeedperstack = -5, movespeedperstack = -5, bonusarmor = 25, bonusint = 60, maxstacks = 20, freezedmg = 150, lingerduration = 3},
	["modifier_vgmar_i_manashield"] = {minmana = 0.5, lowmana = 0.55, maxtotalmana = 6000, mindmgfraction = 30, maxdmgfraction = 90, stunradius = 600, stunduration = 3, stundamage = 200, rechargetime = 60, bonusarmor = 15, bonusint = 20},
	["modifier_vgmar_b_fountain_anticamp"] = {radius = 2000, interval = 1.0, strpertick = 4, intpertick = 2, agipertick = 2, disablepassivestick = 20, silencetick = 40, blindnessendtick = 60, blindnessrange = 200, lingerduration = 30.0},
	["modifier_vgmar_b_last_resort_armor"] = {dur = 120, reductiontick = 1, reductionpertick = 1, armor_per_stack = 3, bonus_regen = 15, start_stacks = 100},
	["modifier_vgmar_b_ancient_tether"] = {damagereducion = -20, healthregen = 15, manaregen = 7, bonusas = 120},
	["modifier_vgmar_anticreep_protection"] = {radius = 1800, strikeinterval = 2.0, activeduration = 5.0, dmgpercentpercreep = 5.0, goldbountyperc = 10},
	["modifier_vgmar_c_cannon_ball"] = {damageperlevel = 20, stunduration = 1.0},
	["modifier_vgmar_i_ogre_tester"] = {}
}

local table_modifier_vgmar_crai_courier_shield = {
	maxattentiondistance = 1500,
	minadmult = 0.2,
	maxadmult = 1.0,
	startattackchance = 50,
	hitattackchance = 80
}

local table_modifier_vgmar_courier_burst_var = {
	distanceperlevel = 400,
	msperlevel = 100,
	rechargepertickperlevel = 0.01,
	rechargedelay = 30,
	rechargedelayperlvl = 3,
	maxcharge = 10,
	ticktime = 0.1,
	basems = 470
}

--Modifiers added in addition to modifiers applied by the game
--[[Structure:
	-originalModifier
	--addedModifier1
	---addedModifier1KV1
	{KVname, baseValue, isBalancedWithAdvantageFormula, AdvantageFormulaOffset, isBalancedWithTime, TimeBalanceData{minMinute, maxMinute, minMult, maxMult}, isCasterOriented}
	---addedModifier1KV2
	--addedModifier2
	---addedModifier2KV1
	---addedModifier2KV2
--]]
local table_bot_modifier_additions = {
	["modifier_item_blade_mail_reflect"] = {
		["modifier_vgmar_bam_blade_mail"] = {
			{"damage_perc", 100, true, -1, true, {15, 70, 0.1, 1}, false}
		}
	}
}
--///////////////////////////////////////////

if VGMAR == nil then
	VGMAR = class({})
end

function Precache( ctx )
	--Precaching Custom Ability sounds (and all used heros' sounds :fp:)
	
	--Warning! Hero Names should be in internal format ex. OD is obsidian_destroyer
	local herosoundprecachelist = {
		"tusk",
		"faceless_void",
		"kunkka",
		"obsidian_destroyer",
		"phantom_assassin",
		"antimage",
		"razor",
		"wisp",
		"zuus",
		"medusa",
		"ancient_apparition",
		"alchemist"
	}
	
	for i=1,#herosoundprecachelist do
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_"..herosoundprecachelist[i]..".vsndevts", ctx)
	end
	
end

function Activate()
	GameRules.VGMAR = VGMAR()
	GameRules.VGMAR:Init()
end

function VGMAR:Init()
	AbilitySlotsLib:Init()
	LogLib:Init()
	Extensions:Init()
	BotSupportLib:Init()
	KeyValuesManager:Init()
	if VGMAR_BOT_FILL then
		BotRolesLib:Init()
	end
	self.n_players_radiant = 0
	self.n_players_dire = 0
	self.allheroes = {}
	self.radiantheroes = {}
	self.direheroes = {}
	self.botheroes = {}
	self.allspawned = false
	self.spawnedheroes = {}
	self.forcedpause = true
	self.pausedn = 0
	self.istimescalereset = false
	self.direcourieruplevel = 1
	self.radiantcourieruplevel = 1
	self.couriersinit = 0
	self.couriergiven = false
	self.direcourieruptable = {}
	for i=1,MAX_COURIER_LVL-1,1 do
		local courup = {lvl = i, upgradetime = BOT_COURIER_UPGRADE_INTERVAL*i, done = false}
		table.insert( self.direcourieruptable, courup )
	end
	--self.lastrunetype = -1
	--self.currunenum = 1
	--self.removedrunenum = math.random(1,2)
	self.buildingdecaydurrange = {300, 720}
	self.botsInLateGameMode = false
	self.backdoorstatustable = {}
	self.backdoortimertable = {}
	self.customitemsreminderfinished = false
	self.balancelogprinttimestamp = 0
	self.towerskilleddire = 0
	self.towerskilledrad = 0
	self.direanc = Entities:FindByName(nil, "dota_badguys_fort")
	self.radiantanc = Entities:FindByName(nil, "dota_goodguys_fort")
	self.lastrunefixtimestamp = -1
	--self.realbountyrunes = {}
	self.botupgradestatus = {}
	self.botitemaghsremoved = {}
	self.shrinedecaystarted = false
	self.bottomepurchausetimestamp = 0
	self.tomepurchaseallmaxlvl = false
	self.botinnategemapplied = false
	self.gemapplyretrytime = 0
	self.lastresortboostgiven = false
	self.botmaxpushtier = 1
	self.advformulacache = {
		radiant = {
			tower = {val = nil, upd = 0},
			kill = {val = nil, upd = 0},
			nw = {val = nil, upd = 0}
		},
		dire = {
			tower = {val = nil, upd = 0},
			kill = {val = nil, upd = 0},
			nw = {val = nil, upd = 0}
		}
	}
	self.roshandeathtime = -1
	
	--CustomAbilitiesValues
	--For ClientSide
	self:InitNetTables()
	
	--Util
	LinkLuaModifier("modifier_vgmar_util_dominator_ability_purger", "abilities/util/modifiers/modifier_vgmar_util_dominator_ability_purger.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_util_creep_ability_updater", "abilities/util/modifiers/modifier_vgmar_util_creep_ability_updater", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_util_give_debugitems", "abilities/util/modifiers/modifier_vgmar_util_give_debugitems", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_util_all_vision", "abilities/util/modifiers/modifier_vgmar_util_all_vision", LUA_MODIFIER_MOTION_NONE)
	--Items
	LinkLuaModifier("modifier_vgmar_i_spellshield", "abilities/modifiers/modifier_vgmar_i_spellshield", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_consumed_aegis", "abilities/modifiers/modifier_vgmar_i_consumed_aegis", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_purgefield_visual", "abilities/modifiers/modifier_vgmar_i_purgefield_visual", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_truesight", "abilities/modifiers/modifier_vgmar_i_truesight", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_truesight_vision", "abilities/modifiers/modifier_vgmar_i_truesight", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_fervor", "abilities/modifiers/modifier_vgmar_i_fervor", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_cdreduction", "abilities/modifiers/modifier_vgmar_i_cdreduction", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_midas_greed", "abilities/modifiers/modifier_vgmar_i_midas_greed", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_spellamp", "abilities/modifiers/modifier_vgmar_i_spellamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_castrange", "abilities/modifiers/modifier_vgmar_i_castrange", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_attackrange", "abilities/modifiers/modifier_vgmar_i_attackrange", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_aura", "abilities/modifiers/modifier_vgmar_i_essence_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_aura_effect", "abilities/modifiers/modifier_vgmar_i_essence_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_atrophy", "abilities/modifiers/modifier_vgmar_i_atrophy", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_greatcleave", "abilities/modifiers/modifier_vgmar_i_greatcleave", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_ogre_tester", "abilities/modifiers/modifier_vgmar_i_ogre_tester", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_manaregen_aura", "abilities/modifiers/modifier_vgmar_i_manaregen_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_manaregen_aura_effect", "abilities/modifiers/modifier_vgmar_i_manaregen_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_spellshield_active", "abilities/modifiers/modifier_vgmar_i_spellshield", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_vampiric_aura", "abilities/modifiers/modifier_vgmar_i_vampiric_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_vampiric_aura_effect", "abilities/modifiers/modifier_vgmar_i_vampiric_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift", "abilities/modifiers/modifier_vgmar_i_essence_shift", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_buff", "abilities/modifiers/modifier_vgmar_i_essence_shift", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_debuff", "abilities/modifiers/modifier_vgmar_i_essence_shift", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_deathskiss", "abilities/modifiers/modifier_vgmar_i_deathskiss", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_deathskiss_active", "abilities/modifiers/modifier_vgmar_i_deathskiss", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_critical_mastery", "abilities/modifiers/modifier_vgmar_i_critical_mastery", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_critical_mastery_active", "abilities/modifiers/modifier_vgmar_i_critical_mastery", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_pulse", "abilities/modifiers/modifier_vgmar_i_pulse", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_thirst", "abilities/modifiers/modifier_vgmar_i_thirst", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_thirst_debuff", "abilities/modifiers/modifier_vgmar_i_thirst", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_multishot", "abilities/modifiers/modifier_vgmar_i_multishot", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_arcane_intellect", "abilities/modifiers/modifier_vgmar_i_arcane_intellect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_multidimension_cast", "abilities/modifiers/modifier_vgmar_i_multidimension_cast", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_poison_dagger", "abilities/modifiers/modifier_vgmar_i_poison_dagger", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_poison_dagger_debuff", "abilities/modifiers/modifier_vgmar_i_poison_dagger", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_scorching_light", "abilities/modifiers/modifier_vgmar_i_scorching_light", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_scorching_light_debuff", "abilities/modifiers/modifier_vgmar_i_scorching_light", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_scorching_light_debuff_lingering", "abilities/modifiers/modifier_vgmar_i_scorching_light", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_scorching_light_vision", "abilities/modifiers/modifier_vgmar_i_scorching_light", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_permafrost", "abilities/modifiers/modifier_vgmar_i_permafrost", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_permafrost_debuff", "abilities/modifiers/modifier_vgmar_i_permafrost", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_permafrost_debuff_lingering", "abilities/modifiers/modifier_vgmar_i_permafrost", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_manashield", "abilities/modifiers/modifier_vgmar_i_manashield", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_manashield_stun", "abilities/modifiers/modifier_vgmar_i_manashield", LUA_MODIFIER_MOTION_NONE)
	--Building Specific
	LinkLuaModifier("modifier_vgmar_buildings_destroyed_counter", "abilities/modifiers/modifier_vgmar_buildings_destroyed_counter.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_anticreep_protection", "abilities/modifiers/modifier_vgmar_anticreep_protection.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_buildings_decay", "abilities/modifiers/modifier_vgmar_buildings_decay.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_fountain_anticamp", "abilities/modifiers/modifier_vgmar_b_fountain_anticamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_fountain_anticamp_debuff_break", "abilities/modifiers/modifier_vgmar_b_fountain_anticamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_fountain_anticamp_debuff_silence", "abilities/modifiers/modifier_vgmar_b_fountain_anticamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_fountain_anticamp_debuff_blindness", "abilities/modifiers/modifier_vgmar_b_fountain_anticamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_fountain_anticamp_debuff", "abilities/modifiers/modifier_vgmar_b_fountain_anticamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_fountain_anticamp_debuff_lingering", "abilities/modifiers/modifier_vgmar_b_fountain_anticamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_last_resort_armor", "abilities/modifiers/modifier_vgmar_b_last_resort_armor", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_ancient_tether", "abilities/modifiers/modifier_vgmar_b_ancient_tether", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_b_ancient_tether_counter", "abilities/modifiers/modifier_vgmar_b_ancient_tether", LUA_MODIFIER_MOTION_NONE)
	--Bot Balance Additional Modifiers
	LinkLuaModifier("modifier_vgmar_bam_blade_mail", "abilities/modifiers/modifier_vgmar_bam_blade_mail", LUA_MODIFIER_MOTION_NONE)
	--Unit Specific
	LinkLuaModifier("modifier_vgmar_courier_burst", "abilities/modifiers/modifier_vgmar_courier_burst.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_courier_burst_effect", "abilities/modifiers/modifier_vgmar_courier_burst.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_courier_burst_charge", "abilities/modifiers/modifier_vgmar_courier_burst.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_crai_courier_shield", "abilities/modifiers/ai/modifier_vgmar_crai_courier_shield.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_c_cannon_ball", "abilities/modifiers/modifier_vgmar_c_cannon_ball.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_c_cannon_ball_stun", "abilities/modifiers/modifier_vgmar_c_cannon_ball.lua", LUA_MODIFIER_MOTION_NONE)
	
	self.buildingadvantagevaluelist = {
		["dota_badguys_tower1_mid"] = 1,
		["dota_badguys_tower1_top"] = 1,
		["dota_badguys_tower1_bot"] = 1,
		["dota_badguys_tower2_mid"] = 2,
		["dota_badguys_tower2_top"] = 2,
		["dota_badguys_tower2_bot"] = 2,
		["dota_badguys_tower3_mid"] = 2,
		["dota_badguys_tower3_top"] = 2,
		["dota_badguys_tower3_bot"] = 2,
		["bad_rax_melee_mid"] = 3,
		["bad_rax_range_mid"] = 3,
		["bad_rax_melee_top"] = 3,
		["bad_rax_range_top"] = 3,
		["bad_rax_melee_bot"] = 3,
		["bad_rax_range_bot"] = 3,
		["bad_healer_7"] = 2,
		["bad_healer_6"] = 2,
		["dota_badguys_tower4_top"] = 4,
		["dota_badguys_tower4_bot"] = 4,
		["dota_goodguys_tower1_mid"] = 1,
		["dota_goodguys_tower1_top"] = 1,
		["dota_goodguys_tower1_bot"] = 1,
		["dota_goodguys_tower2_mid"] = 2,
		["dota_goodguys_tower2_top"] = 2,
		["dota_goodguys_tower2_bot"] = 2,
		["dota_goodguys_tower3_mid"] = 2,
		["dota_goodguys_tower3_top"] = 2,
		["dota_goodguys_tower3_bot"] = 2,
		["good_rax_melee_mid"] = 3,
		["good_rax_range_mid"] = 3,
		["good_rax_melee_top"] = 3,
		["good_rax_range_top"] = 3,
		["good_rax_melee_bot"] = 3,
		["good_rax_range_bot"] = 3,
		["good_healer_7"] = 2,
		["good_healer_6"] = 2,
		["dota_goodguys_tower4_top"] = 4,
		["dota_goodguys_tower4_bot"] = 4
	}
	self.essenceauraignoredabilities = {
		nyx_assassin_burrow = true,
		nyx_assassin_unburrow = true,
		spectre_reality = true,
		techies_focused_detonate = true,
		furion_teleportation = true,
		life_stealer_consume = true,
		life_stealer_assimilate_eject = true,
		winter_wyvern_arctic_burn = true,
		invoker_quas = true,
		invoker_wex = true,
		invoker_exort = true,
		shadow_demon_shadow_poison_release = true,
		alchemist_unstable_concoction_throw = true,
		ancient_apparition_ice_blast_release = true,
		bane_nightmare_end = true,
		bloodseeker_bloodrage = true,
		centaur_double_edge = true,
		clinkz_searing_arrows = true,
		doom_bringer_infernal_blade = true,
		drow_ranger_trueshot = true,
		earth_spirit_stone_caller = true,
		elder_titan_return_spirit = true,
		ember_spirit_fire_remnant = true,
		enchantress_impetus = true,
		huskar_burning_spear = true,
		huskar_life_break = true,
		jakiro_liquid_fire = true,
		kunkka_tidebringer = true,
		keeper_of_the_light_illuminate_end = true,
		keeper_of_the_light_spirit_form_illuminate_end = true,
		lone_druid_true_form = true,
		lone_druid_true_form_druid = true,
		monkey_king_tree_dance = true,
		monkey_king_mischief = true,
		monkey_king_untransform = true,
		monkey_king_primal_spring_early = true,
		phoenix_sun_ray_toggle_move = true,
		phoenix_icarus_dive_stop = true,
		phoenix_launch_fire_spirit = true,
		phoenix_sun_ray_stop = true,
		puck_phase_shift = true,
		puck_ethereal_jaunt = true,
		rubick_telekinesis_land = true,
		silencer_glaives_of_wisdom = true,
		slardar_sprint = true,
		spirit_breaker_empowering_haste = true,
		techies_minefield_sign = true,
		templar_assassin_trap = true,
		tiny_toss_tree = true,
		life_stealer_control = true,
		tiny_toss = false,
		death_prophet_spirit_siphon = false,
		broodmother_spin_web = false,
		gyrocopter_homing_missile = false,
		shadow_demon_demonic_purge = false,
		morphling_waveform = false,
		shadow_demon_disruption = false
	}

	self.arcaneintignoredabilities = {
		nyx_assassin_burrow = true,
		nyx_assassin_unburrow = true,
		spectre_reality = true,
		techies_focused_detonate = true,
		furion_teleportation = true,
		life_stealer_consume = true,
		life_stealer_assimilate_eject = true,
		winter_wyvern_arctic_burn = true,
		invoker_quas = true,
		invoker_wex = true,
		invoker_exort = true,
		invoker_invoke = true,
		shadow_demon_shadow_poison_release = true,
		alchemist_unstable_concoction_throw = true,
		ancient_apparition_ice_blast_release = true,
		bane_nightmare_end = true,
		bloodseeker_bloodrage = true,
		centaur_double_edge = true,
		clinkz_searing_arrows = true,
		doom_bringer_infernal_blade = true,
		drow_ranger_trueshot = true,
		earth_spirit_stone_caller = true,
		elder_titan_return_spirit = true,
		ember_spirit_fire_remnant = true,
		enchantress_impetus = true,
		huskar_burning_spear = true,
		huskar_life_break = true,
		jakiro_liquid_fire = true,
		kunkka_tidebringer = true,
		keeper_of_the_light_illuminate_end = true,
		keeper_of_the_light_spirit_form_illuminate_end = true,
		lone_druid_true_form = true,
		lone_druid_true_form_druid = true,
		monkey_king_tree_dance = true,
		monkey_king_mischief = true,
		monkey_king_untransform = true,
		monkey_king_primal_spring_early = true,
		phoenix_sun_ray_toggle_move = true,
		phoenix_icarus_dive_stop = true,
		phoenix_launch_fire_spirit = true,
		phoenix_sun_ray_stop = true,
		puck_phase_shift = true,
		puck_ethereal_jaunt = true,
		rubick_telekinesis_land = true,
		silencer_glaives_of_wisdom = true,
		slardar_sprint = true,
		spirit_breaker_empowering_haste = true,
		techies_minefield_sign = true,
		templar_assassin_trap = true,
		tiny_toss_tree = true,
		life_stealer_control = true,
		obsidian_destroyer_astral_imprisonment = false,
		sniper_shrapnel = false,
		tiny_toss = false,
		death_prophet_spirit_siphon = false,
		broodmother_spin_web = false,
		gyrocopter_homing_missile = false,
		shadow_demon_demonic_purge = false,
		morphling_waveform = false,
		shadow_demon_disruption = false
	}
	
	self.md_cast_ignored_abilities = {
		nyx_assassin_burrow = true,
		nyx_assassin_unburrow = true,
		spectre_reality = true,
		techies_focused_detonate = true,
		furion_teleportation = true,
		life_stealer_consume = true,
		life_stealer_assimilate_eject = true,
		winter_wyvern_arctic_burn = true,
		invoker_quas = true,
		invoker_wex = true,
		invoker_exort = true,
		invoker_invoke = true,
		shadow_demon_shadow_poison_release = true,
		alchemist_unstable_concoction_throw = true,
		ancient_apparition_ice_blast_release = true,
		bane_nightmare_end = true,
		bloodseeker_bloodrage = true,
		centaur_double_edge = true,
		clinkz_searing_arrows = true,
		doom_bringer_infernal_blade = true,
		drow_ranger_trueshot = true,
		earth_spirit_stone_caller = true,
		elder_titan_return_spirit = true,
		ember_spirit_fire_remnant = true,
		enchantress_impetus = true,
		huskar_burning_spear = true,
		huskar_life_break = true,
		jakiro_liquid_fire = true,
		kunkka_tidebringer = true,
		keeper_of_the_light_illuminate_end = true,
		keeper_of_the_light_spirit_form_illuminate_end = true,
		lone_druid_true_form = true,
		lone_druid_true_form_druid = true,
		monkey_king_tree_dance = true,
		monkey_king_mischief = true,
		monkey_king_untransform = true,
		monkey_king_primal_spring_early = true,
		phoenix_sun_ray_toggle_move = true,
		phoenix_icarus_dive_stop = true,
		phoenix_launch_fire_spirit = true,
		phoenix_sun_ray_stop = true,
		puck_phase_shift = true,
		puck_ethereal_jaunt = true,
		rubick_telekinesis_land = true,
		silencer_glaives_of_wisdom = true,
		slardar_sprint = true,
		spirit_breaker_empowering_haste = true,
		techies_minefield_sign = true,
		templar_assassin_trap = true,
		life_stealer_control = true,
		broodmother_spin_web = true,
		morphling_waveform = true
	}
	
	self.spellshieldpurgeignore = {
		["modifier_nyx_assassin_burrow"] = {silence = false, stun = false, root = true},
		["modifier_life_stealer_infest"] = {silence = false, stun = false, root = true},
		["modifier_life_stealer_assimilate"] = {silence = false, stun = false, root = true},
		["modifier_phoenix_supernova_hiding"] = {silence = false, stun = false, root = true},
		["modifier_legion_commander_duel"] = {silence = true, stun = false, root = false},
		["modifier_obsidian_destroyer_astral_imprisonment_prison"] = {silence = false, stun = true, root = false},
		["modifier_shadow_demon_disruption"] = {silence = false, stun = true, root = false},
		["modifier_winter_wyvern_cold_embrace"] = {silence = false, stun = true, root = false},
		["modifier_winter_wyvern_winters_curse_aura"] = {silence = false, stun = true, root = false},
		["modifier_brewmaster_primal_split"] = {silence = false, stun = true, root = false},
		["modifier_necrolyte_reapers_scythe"] = {silence = false, stun = true, root = false},
		["modifier_item_mask_of_madness_berserk"] = {silence = true, stun = false, root = false},
		["modifier_grimstroke_spirit_walk_buff"] = {silence = true, stun = false, root = false},
		["modifier_vgmar_b_fountain_anticamp_debuff_silence"] = {silence = true, stun = false, root = false}
	}
	
	self.botitemskv = {
		maxbotupgradestatus = 4,
		travelbootscost = KeyValuesManager:GetItemPrice('item_travel_boots'),
		travelbootsrecipecost = KeyValuesManager:GetItemPrice('item_recipe_travel_boots'),
		moonshardvalues = {consumed_bonus = 60, consumed_bonus_night_vision = 200},
		moonshardcost = KeyValuesManager:GetItemPrice('item_moon_shard'),
		moonshardmindmg = 250,
		aghanimscost = KeyValuesManager:GetItemPrice('item_ultimate_scepter'),
		aghanimsupgradecost = KeyValuesManager:GetItemPrice('item_recipe_ultimate_scepter_2'),
		aghanimsstats = {bonus_all_stats = 10, bonus_health = 175, bonus_mana = 175},
		--Heroes that get modified cast mechanics(ex. base:instant cast-> aghs: point target) with aghs
		--Such interactions disable bots from using the ability
		noaghsheroes = {
			["npc_dota_hero_chaos_knight"] = true,
			["npc_dota_hero_riki"] = true,
			["npc_dota_hero_sniper"] = true,
			["npc_dota_hero_bristleback"] = true
		},
		cheapboots = {
			"item_boots",
			"item_phase_boots",
			"item_power_treads",
			"item_arcane_boots",
			"item_tranquil_boots"
		},
		tomerestock = {690.0, 600.0},
		tomeinitialstack = 2,
		tomeprice = KeyValuesManager:GetItemPrice('item_tome_of_knowledge'),
		gemtime = {50, 0}
	}
	
	self.mode = GameRules:GetGameModeEntity()
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, RADIANT_TEAM_MAX_PLAYERS)
    if VGMAR_BOT_FILL == true then
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, DIRE_TEAM_MAX_PLAYERS)
	else
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 10)
	end
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 5 )
	--RuneSpawnTime set to 60 to workaround BaseCustomGameAPI Bug forcing all runes to spawn at RuneSpawnTime
	GameRules:SetRuneSpawnTime( 60 )
	GameRules:SetRuneMinimapIconScale( 1 )
	self.mode:SetRecommendedItemsDisabled(true)
	if VGMAR_BOT_FILL == true then
		GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
	end
	self.mode:SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_HASTE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_ILLUSION, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_INVISIBILITY, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_REGENERATION, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_ARCANE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_BOUNTY, true )
	self.mode:SetUseDefaultDOTARuneSpawnLogic(true)
	self.mode:SetPowerRuneSpawnInterval(RUNE_SPAWN_TIME_POWERUP * 60)
	self.mode:SetBountyRuneSpawnInterval(RUNE_SPAWN_TIME_BOUNTY * 60)
	--self.mode:SetRuneSpawnFilter( Dynamic_Wrap( VGMAR, "FilterRuneSpawn" ), self )
	self.mode:SetExecuteOrderFilter( Dynamic_Wrap( VGMAR, "ExecuteOrderFilter" ), self )
	self.mode:SetDamageFilter( Dynamic_Wrap( VGMAR, "FilterDamage" ), self )
	self.mode:SetModifierGainedFilter( Dynamic_Wrap( VGMAR, "FilterModifierGained" ), self)
	self.mode:SetModifyGoldFilter(Dynamic_Wrap( VGMAR, "FilterGoldGained" ), self)
	self.mode:SetModifyExperienceFilter( Dynamic_Wrap( VGMAR, "FilterExperienceGained" ), self)
	self.mode:SetBountyRunePickupFilter( Dynamic_Wrap( VGMAR, "FilterBountyRunePickup" ), self)
	self.mode:SetItemAddedToInventoryFilter( Dynamic_Wrap(VGMAR, "FilterItemAddedToInventory" ), self)
	self.mode:SetBotsMaxPushTier(self.botmaxpushtier)

	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( VGMAR, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( VGMAR, "OnPlayerLearnedAbility" ), self)
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( VGMAR, 'OnGameStateChanged' ), self )
	--ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( VGMAR, 'OnItemPickedUp' ), self )
	ListenToGameEvent( "dota_tower_kill", Dynamic_Wrap( VGMAR, 'OnTowerKilled' ), self )
	--ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( VGMAR, 'OnPlayerUsedAbility' ), self )
	Convars:RegisterConvar('vgmar_devmode', "0", "Set to 1 to show debug info.  Set to 0 to disable.", 0)
	Convars:RegisterConvar('vgmar_blockbotcontrol', "1", "Set to 0 to enable controlling bots", 0)
	Convars:RegisterConvar('vgmar_enable_full_vision', "0", "Set to 1 to enable all vision", 0)
	Convars:RegisterCommand('vgmar_reload_test_modifier', Dynamic_Wrap( VGMAR, "ReloadTestModifier" ), "Reload script modifier", 0)
	Convars:RegisterCommand('vgmar_test', Dynamic_Wrap( VGMAR, "TestFunction" ), "Runs a test function", 0)
	Convars:RegisterCommand('vgmar_test_readvar', Dynamic_Wrap( VGMAR, "TestReadVar" ), "Tries to read a variable from lua", 0)
	Convars:RegisterCommand('vgmar_restart', Dynamic_Wrap( VGMAR, "CallRestartCommand" ), "A shortcut calling game reload if DevMode is enabled", 0)
	if VGMAR_DEBUG_ENABLE_VARIABLE_SETTING then
		Convars:RegisterCommand('vgmar_test_writevar', Dynamic_Wrap( VGMAR, "TestWriteVar" ), "Tries to write a variable to lua", 0)
	end
	Convars:RegisterCommand('vgmar_forcebalancelog', Dynamic_Wrap( VGMAR, "LogBalance" ), "Forces a balance log print", 0)
	if VGMAR_DEBUG == true then
		Convars:SetInt("vgmar_devmode", 1)
	end
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
end

function VGMAR:CallRestartCommand()
	if IsDevMode() then
		SendToServerConsole("dota_launch_custom_game var dota")
	else
		print('Restart is only available in DevMode.')
	end
end

function VGMAR:TestFunction()
	--dmsg("Msg")
	--dwarning("Warning")
	--dhudmsg("Testing\nStuff")
	--[[local herolst = HeroList:GetAllHeroes()
	for i=1,#herolst do
		local hero = herolst[i]
		if hero then
			local modifiers = hero:FindAllModifiers()
			dprint(HeroNamesLib:ConvertInternalToHeroName(hero:GetName()).." has "..#modifiers.." modifiers")
			dprint("Stunned: "..tostring(hero:IsStunned()).." Silenced: "..tostring(hero:IsSilenced()).." Rooted: "..tostring(hero:IsRooted()))
			if #modifiers > 0 then
				dprint("----------")
				for j=1,#modifiers do
					dprint(j.."."..modifiers[j]:GetName())
				end
				dprint("----------")
			end
		end
	end--]]
end

function IsDevMode()
	if Convars:GetInt("vgmar_devmode") == 1 then
		return true
	end
	return false
end

function IsIssuerHost()
	if GameRules:PlayerHasCustomGameHostPrivileges(Convars:GetDOTACommandClient()) then
		return true
	else
		return false
	end
end

function VGMAR:TestReadVar(varname, deep)
	--local varname = "GameRules.VGMAR."..var
	dprint("Reading "..varname)
	local value = debug.ReadVar(varname)
	if value ~= nil then
		dprint(varname)
		local sep = ""
		for i=1,#varname do
			sep = sep.."-"
		end
		dprint(sep)
		dprint("type: "..type(value))
		dprint("-----")
		if type(value) == "table" then
			if deep then
				DeepPrintTable(value)
			else
				debug.PrintTable(value)
			end
		else
			dprint(value)
		end
	else
		dprint(varname)
		dprint("-----")
		dprint("nil")
	end
end

function VGMAR:TestWriteVar(var, val)
	if VGMAR_DEBUG_ENABLE_VARIABLE_SETTING and IsDevMode() then
		if IsIssuerHost() then
			local function setfield (f, v)
				local t = _G
				for w, d in string.gfind(f, "([%w_]+)(.?)") do
					if d == "." then
						t[w] = t[w] or {}
						t = t[w]
					else
						t[w] = v
					end
				end
			end
			if val == "false" then
				val = false
			elseif val == "true" then
				val = true
			elseif tonumber(val) ~= nil then
				val = tonumber(val)
			end
			if var ~= nil and val ~= nil then
				if debug.ReadVar(var) ~= nil then
					dprint("Variable "..var.." changing from "..tostring(debug.ReadVar(var)).." to "..tostring(val))
				else
					dprint("Creating a variable "..var.." = "..tostring(val))
				end
				setfield(var, val)
				GameRules.VGMAR:TestReadVar(var)
			end
		else
			print("Only Host can use this function")
		end
	else
		print("Variable Setting is disabled.\nTo enable turn VGMAR_DEBUG_ENABLE_VARIABLE_SETTING to true")
	end
end

function VGMAR:ReloadTestModifier()
	SendToServerConsole("script_reload")
	LinkLuaModifier("modifier_vgmar_i_ogre_tester", "abilities/modifiers/modifier_vgmar_i_ogre_tester", LUA_MODIFIER_MOTION_NONE)
end

function dprint(...)
	if IsDevMode() then
		print(...)
	end
end

function dmsg(...)
	if IsDevMode() then
		Msg(....."\n")
	end
end

function dwarning(...)
	if IsDevMode() then
		Warning(....."\n")
	end
end

function dhudmsg(...)
	if IsDevMode() then
		GameRules.VGMAR:DisplayClientError(0, ...)
	end
end

function VGMAR:LogBalance()
	local timeminute = GameRules:GetDOTATime(false, false) / 60
	local timesecond = GameRules:GetDOTATime(false, false) % 60
	LogLib:WriteLog("balance", 0, false, "-----------------------")
	LogLib:WriteLog("balance", 0, false, "Game Time: "..math.floor(timeminute)..":"..math.floor(timesecond))
	--NetWorth Data
	local radiantteamnetworth = 0
	local direteamnetworth = 0
	local radiantheroes = 0
	local direheroes = 0
	local radiantXP = 0
	local direXP = 0
	local allheroes = HeroList:GetAllHeroes()
	local trackedmodifiers = {
		"modifier_item_moon_shard_consumed",
		"modifier_silencer_int_steal",
		"modifier_legion_commander_duel_damage_boost",
		"modifier_pudge_flesh_heap",
		"modifier_nevermore_necromastery",
		"modifier_lion_finger_of_death_kill_counter",
		"modifier_abyssal_underlord_atrophy_aura_hero_permanent_buff",
		"modifier_slark_essence_shift_permanent_buff",
		"modifier_slark_essence_shift_permanent_debuff",
		"modifier_bounty_hunter_jinada"
	}
	LogLib:WriteLog("balance", 1, false, "")
	LogLib:WriteLog("balance", 1, false, "Hero Data:")
	for i=1,#allheroes do
		LogLib:WriteLog("balance", 2, false, "Hero: "..HeroNamesLib:ConvertInternalToHeroName( allheroes[i]:GetName() ))
		local playerID = allheroes[i]:GetPlayerID()
		if allheroes[i]:GetTeamNumber() == 2 then
			radiantheroes = radiantheroes + 1
			LogLib:WriteLog("balance", 3, false, "Team: Radiant")
			LogLib:WriteLog("balance", 3, false, "Kills: "..allheroes[i]:GetKills())
			for _,v in ipairs(GameRules.VGMAR.direheroes) do
				LogLib:WriteLog("balance", 4, false, HeroNamesLib:ConvertInternalToHeroName( v:GetName() ).." : "..PlayerResource:GetKillsDoneToHero(playerID, v:GetPlayerID()))
			end
			LogLib:WriteLog("balance", 3, false, "Deaths: "..allheroes[i]:GetDeaths())
			LogLib:WriteLog("balance", 3, false, "Assists: "..allheroes[i]:GetAssists())
			LogLib:WriteLog("balance", 3, false, "Last Hits: "..allheroes[i]:GetLastHits())
			LogLib:WriteLog("balance", 3, false, "Denies: "..PlayerResource:GetDenies(playerID))
			LogLib:WriteLog("balance", 3, false, "Gold: "..allheroes[i]:GetGold())
			LogLib:WriteLog("balance", 3, false, "Gold Per Minute: "..math.truncate(PlayerResource:GetGoldPerMin(playerID), 2))
			LogLib:WriteLog("balance", 3, false, "Gold Lost to Deaths: "..PlayerResource:GetGoldLostToDeath(playerID))
			LogLib:WriteLog("balance", 3, false, "Total Gold Earned: "..PlayerResource:GetTotalEarnedGold(playerID))
			LogLib:WriteLog("balance", 3, false, "XP: "..allheroes[i]:GetCurrentXP())
			LogLib:WriteLog("balance", 3, false, "XP Per Minute: "..math.truncate(PlayerResource:GetXPPerMin(playerID), 2))
			LogLib:WriteLog("balance", 3, false, "Runes picked up: "..PlayerResource:GetRunePickups(playerID))
			LogLib:WriteLog("balance", 3, false, "Stuns: "..math.truncate(PlayerResource:GetStuns(playerID), 2))
			LogLib:WriteLog("balance", 3, false, "Misses: "..PlayerResource:GetMisses(playerID))
			LogLib:WriteLog("balance", 3, false, "Level: "..allheroes[i]:GetLevel())
			LogLib:WriteLog("balance", 3, false, "Healing: "..PlayerResource:GetHealing(playerID))
			LogLib:WriteLog("balance", 3, false, "Damage: ")
			LogLib:WriteLog("balance", 4, false, "Total: "..PlayerResource:GetRawPlayerDamage(playerID))
			LogLib:WriteLog("balance", 4, false, "------")
			for _,v in ipairs(GameRules.VGMAR.direheroes) do
				LogLib:WriteLog("balance", 4, false, HeroNamesLib:ConvertInternalToHeroName( v:GetName() ).." : "..PlayerResource:GetDamageDoneToHero(playerID, v:GetPlayerID()))
			end
			LogLib:WriteLog("balance", 4, false, "------")
			LogLib:WriteLog("balance", 3, false, "Items: ")
			local heronw = 0
			for j = 0, 14 do
				local slotitem = allheroes[i]:GetItemInSlot(j);
				if slotitem then
					LogLib:WriteLog("balance", 4, false, "Slot: "..j.." Item: "..slotitem:GetName().." Cost: "..slotitem:GetCost())
					heronw = heronw + slotitem:GetCost()
				end
			end
			LogLib:WriteLog("balance", 3, false, "Item Networth: "..heronw)
			radiantteamnetworth = radiantteamnetworth + heronw

			LogLib:WriteLog("balance", 3, false, "Modifiers: ")
			for _,v in ipairs(trackedmodifiers) do
				if allheroes[i]:HasModifier(v) then
					LogLib:WriteLog("balance", 4, false, "- "..v.." | StackCount: "..allheroes[i]:FindModifierByName(v):GetStackCount())
				end
			end
			for k,v in pairs(modifierdatatable) do
				if allheroes[i]:HasModifier(k) then
					LogLib:WriteLog("balance", 4, false, "- "..k.." | StackCount: "..allheroes[i]:FindModifierByName(k):GetStackCount())
				end
			end
			radiantXP = radiantXP + allheroes[i]:GetCurrentXP()
		elseif allheroes[i]:GetTeamNumber() == 3 then
			direheroes = direheroes + 1
			LogLib:WriteLog("balance", 3, false, "Team: Dire")
			LogLib:WriteLog("balance", 3, false, "Kills: "..allheroes[i]:GetKills())
			for _,v in ipairs(GameRules.VGMAR.radiantheroes) do
				LogLib:WriteLog("balance", 4, false, HeroNamesLib:ConvertInternalToHeroName( v:GetName() ).." : "..PlayerResource:GetKillsDoneToHero(playerID, v:GetPlayerID()))
			end
			LogLib:WriteLog("balance", 3, false, "Deaths: "..allheroes[i]:GetDeaths())
			LogLib:WriteLog("balance", 3, false, "Assists: "..allheroes[i]:GetAssists())
			LogLib:WriteLog("balance", 3, false, "Last Hits: "..allheroes[i]:GetLastHits())
			LogLib:WriteLog("balance", 3, false, "Denies: "..PlayerResource:GetDenies(playerID))
			LogLib:WriteLog("balance", 3, false, "Gold: "..allheroes[i]:GetGold())
			LogLib:WriteLog("balance", 3, false, "Gold Per Minute: "..math.truncate(PlayerResource:GetGoldPerMin(playerID), 2))
			LogLib:WriteLog("balance", 3, false, "Gold Lost to Deaths: "..PlayerResource:GetGoldLostToDeath(playerID))
			LogLib:WriteLog("balance", 3, false, "Total Gold Earned: "..PlayerResource:GetTotalEarnedGold(playerID))
			LogLib:WriteLog("balance", 3, false, "XP: "..allheroes[i]:GetCurrentXP())
			LogLib:WriteLog("balance", 3, false, "XP Per Minute: "..math.truncate(PlayerResource:GetXPPerMin(playerID), 2))
			LogLib:WriteLog("balance", 3, false, "Runes picked up: "..PlayerResource:GetRunePickups(playerID))
			LogLib:WriteLog("balance", 3, false, "Stuns: "..math.truncate(PlayerResource:GetStuns(playerID), 2))
			LogLib:WriteLog("balance", 3, false, "Misses: "..PlayerResource:GetMisses(playerID))
			LogLib:WriteLog("balance", 3, false, "Level: "..allheroes[i]:GetLevel())
			LogLib:WriteLog("balance", 3, false, "Healing: "..PlayerResource:GetHealing(playerID))
			LogLib:WriteLog("balance", 3, false, "Damage: ")
			LogLib:WriteLog("balance", 4, false, "Total: "..PlayerResource:GetRawPlayerDamage(playerID))
			LogLib:WriteLog("balance", 4, false, "------")
			for _,v in ipairs(GameRules.VGMAR.radiantheroes) do
				LogLib:WriteLog("balance", 4, false, HeroNamesLib:ConvertInternalToHeroName( v:GetName() ).." : "..PlayerResource:GetDamageDoneToHero(playerID, v:GetPlayerID()))
			end
			LogLib:WriteLog("balance", 4, false, "------")
			LogLib:WriteLog("balance", 3, false, "Items: ")
			local heronw = 0
			for j = 0, 14 do
				local slotitem = allheroes[i]:GetItemInSlot(j);
				if slotitem then
					LogLib:WriteLog("balance", 4, false, "Slot: "..j.." Item: "..slotitem:GetName().." Cost: "..slotitem:GetCost())
					heronw = heronw + slotitem:GetCost()
				end
			end
			LogLib:WriteLog("balance", 3, false, "Item Networth: "..heronw)
			
			LogLib:WriteLog("balance", 3, false, "Modifiers: ")
			for _,v in ipairs(trackedmodifiers) do
				if allheroes[i]:HasModifier(v) then
					LogLib:WriteLog("balance", 4, false, "- "..v.." | StackCount: "..allheroes[i]:FindModifierByName(v):GetStackCount())
				end
			end
			for k,v in pairs(modifierdatatable) do
				if allheroes[i]:HasModifier(k) then
					LogLib:WriteLog("balance", 4, false, "- "..k.." | StackCount: "..allheroes[i]:FindModifierByName(k):GetStackCount())
				end
			end
			direteamnetworth = direteamnetworth + heronw
			direXP = direXP + allheroes[i]:GetCurrentXP()
		end
	end
	LogLib:WriteLog("balance", 0, false, "")
	LogLib:WriteLog("balance", 1, false, "Team Data:")
	LogLib:WriteLog("balance", 2, false, "Radiant Players: "..radiantheroes)
	LogLib:WriteLog("balance", 2, false, "Dire Players: "..direheroes)
	LogLib:WriteLog("balance", 2, false, "Networth: ")
	LogLib:WriteLog("balance", 3, false, "Full Radiant: "..radiantteamnetworth)
	LogLib:WriteLog("balance", 3, false, "Full Dire: "..direteamnetworth)
	local avgradiantnw = radiantteamnetworth
	if radiantheroes > 0 then
		avgradiantnw = radiantteamnetworth/radiantheroes
	end
	local avgdirenw = direteamnetworth
	if direheroes > 0 then
		avgdirenw = direteamnetworth/direheroes
	end
	LogLib:WriteLog("balance", 3, false, "Average Radiant: "..avgradiantnw)
	LogLib:WriteLog("balance", 3, false, "Average Dire: "..avgdirenw)
	--Tower Kill Data
	LogLib:WriteLog("balance", 2, false, "Buildings: ")
	LogLib:WriteLog("balance", 3, false, "Buildings Destroyed by Radiant: "..GameRules.VGMAR.towerskilledrad)
	LogLib:WriteLog("balance", 3, false, "Buildings Destroyed by Dire: "..GameRules.VGMAR.towerskilleddire)
	--Kills Data
	LogLib:WriteLog("balance", 2, false, "Kills: ")
	LogLib:WriteLog("balance", 3, false, "Radiant Kills: "..PlayerResource:GetTeamKills(2))
	LogLib:WriteLog("balance", 3, false, "Dire Kills: "..PlayerResource:GetTeamKills(3))
	--XP Data
	LogLib:WriteLog("balance", 2, false, "XP: ")
	LogLib:WriteLog("balance", 3, false, "Full Radiant: "..radiantXP)
	LogLib:WriteLog("balance", 3, false, "Full Dire: "..direXP)
	local avgxprad = radiantXP
	if radiantheroes > 0 then
		avgxprad = radiantXP/radiantheroes
	end
	local avgxpdire = direXP
	if direheroes > 0 then
		avgxpdire = direXP/direheroes
	end
	LogLib:WriteLog("balance", 3, false, "Average Radiant: "..avgxprad)
	LogLib:WriteLog("balance", 3, false, "Average Dire: "..avgxpdire)
	--Advantage Formula Output
	LogLib:WriteLog("balance", 2, false, "Advantage Formula Output")
	LogLib:WriteLog("balance", 2, false, "Tower/Kill/Networth/Full")
	LogLib:WriteLog("balance", 3, false, "Radiant: "..GameRules.VGMAR:GetTeamAdvantage(true, true, false, false).."/"..GameRules.VGMAR:GetTeamAdvantage(true, false, true, false).."/"..GameRules.VGMAR:GetTeamAdvantage(true, false, false, true).."/"..GameRules.VGMAR:GetTeamAdvantage(true, true, true, true))
	LogLib:WriteLog("balance", 3, false, "Dire: "..GameRules.VGMAR:GetTeamAdvantage(false, true, false, false).."/"..GameRules.VGMAR:GetTeamAdvantage(false, false, true, false).."/"..GameRules.VGMAR:GetTeamAdvantage(false, false, false, true).."/"..GameRules.VGMAR:GetTeamAdvantage(false, true, true, true))
end

function VGMAR:LogEvent(text)
	if text ~= nil and VGMAR_LOG_BALANCE_EVENTS then
		LogLib:WriteLog("balance", 0, true, "BE:"..text)
		LogLib:WriteLog("balance", 0, false, "-------------")
	end
end

local missclickproofabilities = {
	["item_tpscroll"] = true,
	["item_travel_boots"] = true,
	["item_travel_boots_2"] = true,
	["item_moon_shard"] = true,
	["item_ward_observer"] = true,
	["item_ward_sentry"] = true,
	["item_ward_dispenser"] = true
}
	
function VGMAR:InitNetTables()
	local num = 0
	for i,v in pairs(modifierdatatable) do
		CustomNetTables:SetTableValue( "client_side_ability_values", i, v )
		num = num + 1
	end
	print("Initiated "..num.." KeyNames in Ability Value Net Table")
end

--BackDoorProtected Building List
local bdplist = {
	{group = "goodbase",
		buildinglist = {
			"dota_goodguys_fort",
			"good_rax_melee_bot",
			"good_rax_melee_mid",
			"good_rax_melee_top",
			"good_rax_range_bot",
			"good_rax_range_mid",
			"good_rax_range_top",
			"dota_goodguys_tower3_bot",
			"dota_goodguys_tower3_mid",
			"dota_goodguys_tower3_top",
			"dota_goodguys_tower4_bot",
			"dota_goodguys_tower4_top",
			"good_filler_1",
			"good_filler_2",
			"good_filler_3",
			"good_filler_4",
			"good_filler_5",
			"good_filler_6",
			"good_filler_7"
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_fort",
		protectionrange = 2800,
		maxdamage = 10
		},
	{group = "badbase",
		buildinglist = {
			"dota_badguys_fort",
			"bad_rax_melee_bot",
			"bad_rax_melee_mid",
			"bad_rax_melee_top",
			"bad_rax_range_bot",
			"bad_rax_range_mid",
			"bad_rax_range_top",
			"dota_badguys_tower3_bot",
			"dota_badguys_tower3_mid",
			"dota_badguys_tower3_top",
			"dota_badguys_tower4_bot",
			"dota_badguys_tower4_top",
			"bad_filler_1",
			"bad_filler_2",
			"bad_filler_3",
			"bad_filler_4",
			"bad_filler_5",
			"bad_filler_6",
			"bad_filler_7"
			},
		activationtime = 25,
		protectionholder = "dota_badguys_fort",
		protectionrange = 2800,
		maxdamage = 10
		},
	{group = "g_t2_top",
		buildinglist = {
			"dota_goodguys_tower2_top"	
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_tower2_top",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "g_t2_mid",
		buildinglist = {
			"dota_goodguys_tower2_mid"		
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_tower2_mid",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "g_t2_bot",
		buildinglist = {
			"dota_goodguys_tower2_bot"		
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_tower2_bot",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "b_t2_top",
		buildinglist = {
			"dota_badguys_tower2_top"		
			},
		activationtime = 25,
		protectionholder = "dota_badguys_tower2_top",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "b_t2_mid",
		buildinglist = {
			"dota_badguys_tower2_mid"		
			},
		activationtime = 25,
		protectionholder = "dota_badguys_tower2_mid",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "b_t2_bot",
		buildinglist = {
			"dota_badguys_tower2_bot"		
			},
		activationtime = 25,
		protectionholder = "dota_badguys_tower2_bot",
		protectionrange = 700,
		maxdamage = 1
		}
	}
	
--List of Units with additional abilities
--[[
Leveling mechanic modes unitlevel, returnvalue, daynight.
-unitlevel args - N/A (sets ability level to unit level)
-returnvalue args - any script (unit pointer not available)
-daynight args - {daylvl = ,nightlvl = }
Unbroken modes - 1:Remove abilities 0:UnLvl abilities

Up to 10 abilities

Example:
{classname = "npc_dota_creep_siege",
	abilities = {
		{name = "ability1", ismodifier = 0},
		{name = "ability2", ismodifier = 1}
	},
	levelmechanicmode = {
		"unitlevel",
		"daynight"
	},
	levelmechanicarg = {
		nil,
		{daylvl = 1, nightlvl = 2}
	},
	unbroken = true,
	unbrokenmode = 1
}

]]--
local creepabilitieslist = {
	{classname = "npc_dota_creep_siege",
		abilities = {
			{name = "modifier_vgmar_c_cannon_ball", ismodifier = 1}
		},
		levelmechanicmode = {
			"unitlevel"
		},
		levelmechanicarg = {
			nil
		},
		unbroken = true,
		unbrokenmode = 1
	}
}
	
function PreGameSpeed()
	if Convars:GetInt("vgmar_devmode") == 1 then
		return 8.0
	end
	return 2.0
end

function VGMAR:DisplayClientError(pid, message)
    local player = PlayerResource:GetPlayer(pid)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "VGMARDisplayError", {message=message})
    end
end

--[[function VGMAR:FilterRuneSpawn( filterTable )
	--dprint("Rune spawn premodified filterTable")
	--DeepPrintTable( filterTable )
	if (math.round(GameRules:GetDOTATime(false, false)/60)%RUNE_SPAWN_TIME_POWERUP == 0) then
		local function GetRandomRune( notrune )
			local runeslist = {
				0,
				1,
				2,
				3,
				4,
				6
			}
			
			local rune = notrune
			
			while rune == notrune do
				rune = runeslist[math.random(#runeslist)]
			end
			return rune
		end
		filterTable.rune_type = GetRandomRune( -1 )
		if self.currunenum > 2 then
			self.currunenum = 1
			self.removedrunenum = math.random(1,2)
		end

		if filterTable.rune_type == self.lastrunetype then
			filterTable.rune_type = GetRandomRune( self.lastrunetype )
		end
		if GameRules:GetDOTATime(false, false) < 10 then
			filterTable.rune_type = DOTA_RUNE_INVALID
		end
		if GameRules:GetDOTATime(false, false) < 2400 then
			if self.currunenum == self.removedrunenum then
				filterTable.rune_type = DOTA_RUNE_INVALID
			end
		end

		if filterTable.rune_type ~= -1 then
			self.lastrunetype = filterTable.rune_type
		end
		self.currunenum = self.currunenum + 1
		--dprint("Rune spawn aftermodified filterTable")
		--DeepPrintTable( filterTable )
	else
		filterTable.rune_type = DOTA_RUNE_INVALID
	end
	if math.round(GameRules:GetDOTATime(false, false)/60) > self.lastrunefixtimestamp then
		self.lastrunefixtimestamp = math.round(GameRules:GetDOTATime(false, false)/60)
		Timers:CreateTimer(FrameTime(), function()
			if (math.round(GameRules:GetDOTATime(false, false)/60)%RUNE_SPAWN_TIME_BOUNTY == 0) then
				local bountyrunes = {}
				bountyrunes = Entities:FindAllByModel("models/props_gameplay/rune_goldxp.vmdl")
				self.realbountyrunes = {}
				--dprint("Adding "..#bountyrunes.." Bounty Runes to the list of legitimately spawned bounty runes")
				if #bountyrunes > 0 then
					for i=1,#bountyrunes do
						table.insert(self.realbountyrunes, bountyrunes[i]:GetEntityIndex())
					end
					--DeepPrintTable(self.realbountyrunes)
				end
			else
				--dprint("Runes Spawned at "..math.round(GameRules:GetDOTATime(false, false)/60))
				local bountyrunes = {}
				bountyrunes = Entities:FindAllByModel("models/props_gameplay/rune_goldxp.vmdl")
				--dprint("Found "..#bountyrunes.." Bounty Runes")
				if #bountyrunes > 0 then
					for i=1,#bountyrunes do
						local bruneisreal = false
						for j=1,#self.realbountyrunes do
							if bountyrunes[i]:GetEntityIndex() == self.realbountyrunes[j] then
								bruneisreal = true
							end
						end
						if bruneisreal == false then
							--dprint("Removing a newly spawned bounty rune "..bountyrunes[i]:GetEntityIndex())
							bountyrunes[i]:Destroy()
						end
					end
				end
			end
		end)
	end
	return true
end--]]

function VGMAR:FilterExperienceGained( filterTable )
	--DeepPrintTable( filterTable )
	return true
end

function VGMAR:FilterGoldGained( filterTable )
	--dprint("PreModification Table: HeroId: ", filterTable["player_id_const"], "Gold: ", filterTable["gold"])
	--DeepPrintTable( filterTable )
	--[[
	reason_const
	reliable
	player_id_const
	gold
	--]]
	local player = PlayerResource:GetPlayer(filterTable.player_id_const)
	if filterTable.reliable == 0 then
		if player:GetTeamNumber() == 2 then
			filterTable["gold"] = filterTable["gold"] * self:GetTeamAdvantageClamped(false, true, true, true, 0.5, 2.5) --math.min(2.0,math.max(0.5,self:GetTeamAdvantage(false, true, true, true, filterTable["player_id_const"])))
		elseif player:GetTeamNumber() == 3 then
			filterTable["gold"] = filterTable["gold"] * self:GetTeamAdvantageClamped(true, true, true, true, 0.5, 2.5) --math.min(2.0,math.max(0.5,self:GetTeamAdvantage(true, true, true, true, filterTable["player_id_const"])))
		end
	end
	--HeroKill
	if filterTable.reason_const == 12 then
		local hero = PlayerResource:GetPlayer(filterTable.player_id_const):GetAssignedHero()
		local gold = filterTable.gold
		if player:GetTeamNumber() == 2 then
			dprint("HeroKill gold modifier: "..math.truncate(self:GetTeamAdvantageClamped(false, false, true, true, 0.01, 2.0), 4))
			dprint("HeroKill gold: base: "..filterTable.gold.." modified: "..math.truncate(filterTable.gold * self:GetTeamAdvantageClamped(false, false, true, true, 0.01, 2.0), 4))
			filterTable["gold"] = math.truncate(filterTable["gold"] * self:GetTeamAdvantageClamped(false, false, true, true, 0.01, 2.0), 4)
			if VGMAR_DEBUG_DRAW == true then Extensions:AddEntText(hero:entindex(), "GoldMod: "..gold.."->"..filterTable["gold"]) end
		elseif player:GetTeamNumber() == 3 then
			dprint("HeroKill gold modifier: "..math.truncate(self:GetTeamAdvantageClamped(true, false, true, true, 0.01, 2.0), 4))
			dprint("HeroKill gold: base: "..filterTable.gold.." modified: "..math.truncate(filterTable.gold * self:GetTeamAdvantageClamped(true, false, true, true, 0.01, 2.0), 4))
			filterTable["gold"] = math.truncate(filterTable["gold"] * self:GetTeamAdvantageClamped(true, false, true, true, 0.01, 2.0), 4)
			if VGMAR_DEBUG_DRAW == true then Extensions:AddEntText(hero:entindex(), "GoldMod: "..gold.."->"..filterTable["gold"]) end
		end
	end
	--dprint("PostModification Table: HeroId: ", filterTable["player_id_const"], "Gold: ", filterTable["gold"])
	return true
end

function VGMAR:FilterBountyRunePickup( filterTable )
	--[[
	player_id_const (number)
	xp_bounty (number)
	gold_bounty (number)
	]]--
	local playerteam = PlayerResource:GetTeam(filterTable.player_id_const)
	local goldbounty = 0
	local xpbounty = 0
	if playerteam == 2 then
		--radiant
		goldbounty = (filterTable.gold_bounty * 5)/self.n_players_radiant
		xpbounty = (filterTable.xp_bounty * 5)/self.n_players_radiant
	elseif playerteam == 3 then
		--dire
		goldbounty = (filterTable.gold_bounty * 5)/self.n_players_dire
		xpbounty = (filterTable.xp_bounty * 5)/self.n_players_dire
	end
	filterTable.gold_bounty = goldbounty
	filterTable.xp_bounty = xpbounty
	return true
end

--TODO:Add A Table for bot balance modifier modification(duration)
function VGMAR:FilterModifierGained( filterTable )
	--if IsDevMode() then
		--DeepPrintTable( filterTable )
	--end
	--[[
	entindex_parent_const           	= (number)
	entindex_ability_const          	= (number)
	duration                        	= (number)
	entindex_caster_const           	= (number)
	name_const                      	= (string)
	]]--
	local modifiername = filterTable["name_const"]
	local ability = nil
	local parent = nil
	local caster = nil
	if filterTable["entindex_ability_const"] then
		ability = EntIndexToHScript(filterTable.entindex_ability_const)
	end
	if filterTable["entindex_parent_const"] then
		parent = EntIndexToHScript(filterTable.entindex_parent_const)
	end
	if filterTable["entindex_caster_const"] then
		caster = EntIndexToHScript(filterTable.entindex_caster_const)
	end
	if parent:IsHero() then
		BotSupportLib:Event_ModifierApplied(parent, caster, modifiername, ability)
	end
	if parent:IsHero() or (caster and caster:IsHero()) then
		self:ApplyBotBalanceModifiers(parent, caster, filterTable)
	end
	return true
end

function VGMAR:ApplyBotBalanceModifiers(parent, caster, filterTable)
	if parent then
		local modifiername = filterTable["name_const"]
		local ability = nil
		if filterTable["entindex_ability_const"] then
			ability = EntIndexToHScript(filterTable.entindex_ability_const)
		end
		if table_bot_modifier_additions[modifiername] ~= nil then
			for i,v in pairs(table_bot_modifier_additions[modifiername]) do
				local kvdata = {}
				for j,k in ipairs(v) do
					local AFTarget = parent
					if v[j][7] then
						if caster ~= nil then
							AFTarget = caster
						else
							LogLib:Log_Error("KVData has caster oriented flag but caster is nil", 0, "Error in VGMAR:ApplyBotBalanceModifiers()")
							LogLib:Log_Error("Data: "..v[j][1]..", Parent: "..parent:GetName(), 1)
						end
					end
					local keyname = v[j][1]
					dprint("Adding keyname: "..keyname)
					table.insert(kvdata, keyname)
					local keyvalue = v[j][2]
					dprint("Keyvalue for "..keyname.." set to: "..keyvalue)
					if v[j][3] then
						local mod = math.truncate(self:GetTeamAdvantage(AFTarget:GetTeamNumber() == 3, false, true, true), 4)
						if v[j][4] ~= nil then
							mod = math.max(0, mod + v[j][4])
						end
						keyvalue = keyvalue * mod
						dprint("Balance mod is on, Modifying keyvalue to "..keyvalue)
					end
					if v[j][5] and v[j][6] ~= nil then
						local currentminute = math.floor(GameRules:GetDOTATime(false, false)/60)
						local timemoddata = v[j][6]
						local timemod = math.max(0, math.mapl(currentminute, timemoddata[1], timemoddata[2], timemoddata[3], timemoddata[4]))
						keyvalue = keyvalue * timemod
						dprint("Time mod is on, Modifying keyvalue to "..keyvalue)
					end
					kvdata[keyname] = keyvalue
				end
				local modifier = parent:AddNewModifier(caster, ability, i, kvdata)
				if modifier then
					modifier:SetDuration(filterTable.duration, true)
				end
			end
		end
	end
end

function VGMAR:FilterItemAddedToInventory( filterTable )
	local item = EntIndexToHScript(filterTable.item_entindex_const)
	local unit = EntIndexToHScript(filterTable.inventory_parent_entindex_const)
	if item.suggestedSlot then
		filterTable.suggested_slot = item.suggestedSlot
		item.suggestedSlot = nil
	end
	return true
end

function VGMAR:TimeIsLaterThan( minute, second )
	local num = minute * 60 + second
	if GameRules:GetDOTATime(false, false) > num then
		return true
	else
		return false
	end
end

--[[
function VGMAR:OnItemPickedUp(keys)
	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex or keys.UnitEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
	
	if heroEntity:IsRealHero() and not heroEntity:IsCourier() then
	end
end
--]]

function VGMAR:OnTowerKilled( keys )
	local switchAI = (RandomInt(1,3))
	if switchAI == 1 then
		self.botsInLateGameMode = false
		GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
		GameRules:GetGameModeEntity():SetThink(function()
			self.botsInLateGameMode = true
			GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
		end, DoUniqueString('makesBotsLateGameAgain'), 180)
	else
		self.botsInLateGameMode = true
		GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
	end
end

function VGMAR:TeamReward(teamnumber, amount, split)
	local heroes = HeroList:GetAllHeroes()
	local targets = {}
	for i=0,HeroList:GetHeroCount() do
		local heroent = heroes[i]
		if heroent then
			if heroent:GetTeamNumber() == teamnumber then
				table.insert(targets, heroent)
			end
		end
	end
	if #targets > 0 then
		if split[1] then
			amount[1] = amount[1]/#targets
		end
		if split[2] then
			amount[2] = amount[2]/#targets
		end
		for i=1,#targets do
			if amount[1] > 0 then
				targets[i]:ModifyGold(amount[1], false, 0)
			end
			if amount[2] then
				targets[i]:AddExperience(amount[2], 2, false, true)
			end
		end
		self:LogEvent("TeamReward: Team: "..teamnumber.." Gold: "..amount[1].." Split: "..tostring(split[1]).." |XP: "..amount[2].." Split: "..tostring(split[2]))
	else
		dprint("TeamReward found 0 targets")
	end
end

local ADVANTAGE_CACHE_DURATION = 5
function VGMAR:GetTeamAdvantage( radiant, tower, kill, networth )
	--////////////
	--Team Balance
	--////////////
	--Importance Percentages
	--!!!Should add up to 100!!!
	local towerkillimp = 50
	local killsimp = 20
	local networthimp = 30
	--End of Importance Percentages
	--Return Cache values if present and not older than 5s
	--TODO: Rework to allow partial use of cache ex. need kill+tower -> kill available in cache -> calculate tower, use kill from cache -> return
	local function CheckDataUTD(data)
		return ((data.upd + ADVANTAGE_CACHE_DURATION >= math.floor(GameRules:GetGameTime())) and (data.val ~= nil))
	end
	local function StoreInAdvCache(cache, value)
		cache.val = value
		cache.upd = math.floor(GameRules:GetGameTime())
	end
	local advcache = self.advformulacache.dire
	if radiant then
		advcache = self.advformulacache.radiant
	end
	local cachedadv = {0, 0, 0, true}
	if tower then
		if CheckDataUTD(advcache.tower) then
			cachedadv[1] = advcache.tower.val
		else
			cachedadv[4] = false
		end
	else
		cachedadv[1] = (1/100)*towerkillimp
	end
	if kill then
		if CheckDataUTD(advcache.kill) then
			cachedadv[2] = advcache.kill.val
		else
			cachedadv[4] = false
		end
	else
		cachedadv[2] = (1/100)*killsimp
	end
	if networth then
		if CheckDataUTD(advcache.nw) then
			cachedadv[3] = advcache.nw.val
		else
			cachedadv[4] = false
		end
	else
		cachedadv[3] = (1/100)*networthimp
	end
	--If we didnt fail return cached values
	if cachedadv[4] then
		return cachedadv[1]+cachedadv[2]+cachedadv[3]
	end
	--Calculating Networth
	local radiantteamnetworth = 0
	local direteamnetworth = 0
	if networth == true then
		local radiantheroes = {}
		local direheroes = {}
		local allheroes = HeroList:GetAllHeroes()
		for i=1,#allheroes do
			local hero = {id = allheroes[i]:GetPlayerID(), hero = allheroes[i]}
			if allheroes[i]:GetTeamNumber() == 2 then
				table.insert(radiantheroes, hero)
			elseif allheroes[i]:GetTeamNumber() == 3 then
				table.insert(direheroes, hero)
			end
		end
		
		--PureItemsMethod
		for i=1,#radiantheroes do
			--radiantteamnetworth = radiantteamnetworth + PlayerResource:GetGold(radiantheroes[i].id)
			for j = 0, 14 do
				local slotitem = radiantheroes[i].hero:GetItemInSlot(j);
				if slotitem then
					radiantteamnetworth = radiantteamnetworth + slotitem:GetCost()
				end
			end
		end
		for i=1,#direheroes do
			--direteamnetworth = direteamnetworth + PlayerResource:GetGold(direheroes[i].id)
			for j = 0, 14 do
				local slotitem = direheroes[i].hero:GetItemInSlot(j);
				if slotitem then
					direteamnetworth = direteamnetworth + slotitem:GetCost()
				end
			end
		end
		--DotaMethod
		local radiantteamnetworthdota = 0
		local direteamnetworthdota = 0
		for i=1,#radiantheroes do
			radiantteamnetworthdota = radiantteamnetworthdota + ((radiantheroes[i].hero:GetDeathGoldCost() - 50) * 40)
		end
		for i=1,#direheroes do
			direteamnetworthdota = direteamnetworthdota + ((direheroes[i].hero:GetDeathGoldCost() - 50) * 40)
		end
		if #radiantheroes ~= 0 and #direheroes ~= 0 then
			radiantteamnetworth = radiantteamnetworth / #radiantheroes
			direteamnetworth = direteamnetworth / #direheroes
			radiantteamnetworthdota = radiantteamnetworthdota / #radiantheroes
			direteamnetworthdota = direteamnetworthdota / #direheroes
		end
		--[[dprint("Networth:")
		dprint("Custom: Radiant: "..radiantteamnetworth.." Dire: "..direteamnetworth)
		dprint("Dota: Radiant: "..radiantteamnetworthdota.." Dire: "..direteamnetworthdota)--]]
	end
	--End Values Calculation
	local towerkilladv
	local killadv
	local networthadv
	if radiant == true then
		if tower == true then
			if self.towerskilleddire ~= 0 and self.towerskilledrad ~= 0 then
				towerkilladv = ((self.towerskilledrad/self.towerskilleddire)/100)*towerkillimp
			else
				if self.towerskilleddire ~= 0 then
					towerkilladv = ((0/self.towerskilleddire)/100)*towerkillimp
				elseif self.towerskilledrad ~= 0 then
					towerkilladv = (((self.towerskilledrad+1)/1)/100)*towerkillimp
				else
					towerkilladv = (1/100)*towerkillimp
				end
			end
			StoreInAdvCache(advcache.tower, towerkilladv)
		else
			towerkilladv = (1/100)*towerkillimp
		end
		if kill == true then
			if PlayerResource:GetTeamKills(2) ~= 0 and PlayerResource:GetTeamKills(3) ~= 0 then
				killadv = ((PlayerResource:GetTeamKills(2)/PlayerResource:GetTeamKills(3))/100)*killsimp
			else
				if PlayerResource:GetTeamKills(2) ~= 0 then
					killadv = (((PlayerResource:GetTeamKills(2)+1)/1)/100)*killsimp
				elseif PlayerResource:GetTeamKills(3) ~= 0 then
					killadv = ((0/PlayerResource:GetTeamKills(3))/100)*killsimp
				else
					killadv = (1/100)*killsimp
				end
			end
			StoreInAdvCache(advcache.kill, killadv)
		else
			killadv = (1/100)*killsimp
		end
		if networth == true then
			if radiantteamnetworth ~= 0 and direteamnetworth ~= 0 then
				networthadv = ((radiantteamnetworth/direteamnetworth)/100)*networthimp
			else
				networthadv = (1/100)*networthimp
			end
			StoreInAdvCache(advcache.nw, networthadv)
		else
			networthadv = (1/100)*networthimp
		end
	else
		if tower == true then
			if self.towerskilleddire ~= 0 and self.towerskilledrad ~= 0 then
				towerkilladv = ((self.towerskilleddire/self.towerskilledrad)/100)*towerkillimp
			else
				if self.towerskilleddire ~= 0 then
					towerkilladv = (((self.towerskilleddire+1)/1)/100)*towerkillimp
				elseif self.towerskilledrad ~= 0 then
					towerkilladv = ((0/self.towerskilledrad)/100)*towerkillimp
				else
					towerkilladv = (1/100)*towerkillimp
				end
			end
			StoreInAdvCache(advcache.tower, towerkilladv)
		else
			towerkilladv = (1/100)*towerkillimp
		end
		if kill == true then
			if PlayerResource:GetTeamKills(2) ~= 0 and PlayerResource:GetTeamKills(3) ~= 0 then
				killadv = ((PlayerResource:GetTeamKills(3)/PlayerResource:GetTeamKills(2))/100)*killsimp
			else
				if PlayerResource:GetTeamKills(2) ~= 0 then
					killadv = ((0/PlayerResource:GetTeamKills(2))/100)*killsimp
				elseif PlayerResource:GetTeamKills(3) ~= 0 then
					killadv = (((PlayerResource:GetTeamKills(3)+1)/1)/100)*killsimp
				else
					killadv = (1/100)*killsimp
				end
			end
			StoreInAdvCache(advcache.kill, killadv)
		else
			killadv = (1/100)*killsimp
		end
		if networth == true then
			if radiantteamnetworth ~= 0 and direteamnetworth ~= 0 then
				networthadv = ((direteamnetworth/radiantteamnetworth)/100)*networthimp
			else
				networthadv = (1/100)*networthimp
			end
			StoreInAdvCache(advcache.nw, networthadv)
		else
			networthadv = (1/100)*networthimp
		end
	end
	--[[if tower == true and kill == true and networth == true then
		dprint("Radiant Team Net: "..radiantteamnetworth.." Dire Team Net: "..direteamnetworth)
		if self.towerskilleddire ~= nil and self.towerskilledrad ~= nil then
			dprint("Towers Killed Radiant: "..self.towerskilledrad.." Towers Killed Dire: "..self.towerskilleddire)
		end
		dprint("Tower Kill Advantage: "..towerkilladv.." Kill Advantage: "..killadv.." Networth Advantage: "..networthadv)
		dprint("Total Advantage: ", towerkilladv + killadv + networthadv)
	end--]]
	return towerkilladv + killadv + networthadv
end

function VGMAR:GetTeamAdvantageClamped(radiant, tower, kill, networth, min, max)
	--[[local rdtext 
	if radiant then
		rdtext = "Radiant"
	else
		rdtext = "Dire"
	end--]]
	--dprint("Balance: "..rdtext.." Unclamped Adv: "..self:GetTeamAdvantage(radiant, tower, kill, networth))
	if self:GetTeamAdvantage(radiant, tower, kill, networth) > 1 then
		--dprint("Balance: "..rdtext..": Adv: "..math.clamp(1, self:GetTeamAdvantage(radiant, tower, kill, networth), 2).." Remapped: "..math.scale(1, math.map(math.clamp(1, self:GetTeamAdvantage(radiant, tower, kill, networth), 2), 1, 2, 0, 1), max))
		return math.scale(1, math.map(math.clamp(1, self:GetTeamAdvantage(radiant, tower, kill, networth), 2), 1, 2, 0, 1), max)
	elseif self:GetTeamAdvantage(radiant, tower, kill, networth) == 1 then
		--dprint("Balance: "..rdtext..": Adv: 1")
		return 1
	else
		--dprint("Balance: "..rdtext..": Adv: "..math.clamp(0, self:GetTeamAdvantage(radiant, tower, kill, networth), 1).." Remapped: "..math.scale( min, self:GetTeamAdvantage(radiant, tower, kill, networth), 1 ))
		return math.scale( min, self:GetTeamAdvantage(radiant, tower, kill, networth), 1 )
	end
end

function VGMAR:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, PlayerResource:GetPlayerCount())
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, PlayerResource:GetPlayerCount())
		for playerID=0,PlayerResource:GetPlayerCount() do
			if PlayerResource:IsValidPlayer(playerID) and PlayerResource:GetConnectionState(playerID) == 2 then
				dprint("Valid Player found on slot:", playerID)
				dprint("Player Team is:", PlayerResource:GetTeam(playerID))
				if PlayerResource:GetTeam(playerID) ~= 2 then
					PlayerResource:SetCustomTeamAssignment(playerID, DOTA_TEAM_GOODGUYS)
				end
			end
		end
		GameRules:LockCustomGameSetupTeamAssignment(true)
	end
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		if Convars:GetInt("vgmar_enable_full_vision") == 1 then
			local wards = {}
			for _,ward in ipairs (Entities:FindAllByClassname("npc_dota_ward_base")) do table.insert(wards, ward) end
			for _,ward in ipairs (Entities:FindAllByClassname("npc_dota_ward_base_truesight")) do table.insert(wards, ward) end
			for _,courier in ipairs (Entities:FindAllByClassname("npc_dota_courier")) do table.insert(wards, courier) end
			for _,ent in ipairs(wards) do
				if ent:GetTeamNumber() == 3 and not ent:HasModifier("modifier_vgmar_util_all_vision") then
					ent:AddNewModifier(ent, nil, "modifier_vgmar_util_all_vision", {})
				end
			end
			local heroes = HeroList:GetAllHeroes()
			for i=0,HeroList:GetHeroCount() do
				local heroent = heroes[i]
				if heroent then
					local heroplayerid = heroent:GetPlayerID()
					if PlayerResource:GetConnectionState(heroplayerid) == 1 then
						if Convars:GetInt("vgmar_enable_full_vision") == 1 then
							if not heroent:HasModifier("modifier_vgmar_util_all_vision") then
								heroent:AddNewModifier(heroent, nil, "modifier_vgmar_util_all_vision", {})
							end
						end
					end
				end
			end
		end
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		local heroes = HeroList:GetAllHeroes()
		for i=0,HeroList:GetHeroCount() do
			local heroent = heroes[i]
			if heroent then
			--///////////////////////////
			--Bot Rune Fix
			--///////////////////////////
				local heroplayerid = heroent:GetPlayerID()
				
				if PlayerResource:GetConnectionState(heroplayerid) == 1 then
					local closestrune = Entities:FindByClassnameNearest("dota_item_rune", heroent:GetOrigin(), 250.0)
					heroent:SetBotDifficulty(3)
					if closestrune and heroent:IsChanneling() == false then
						heroent:PickupRune(closestrune)
					end
					
					--TODO: Add teamAdvantage into the buyback cooldown reset price calculation for bots
					--Buyback Cooldown Reset
					if heroent:IsAlive() == false then
						local bbcost = heroent:GetBuybackCost(false)
						--check for 2.1x buyback cost to be sure that the bot has excess amount of gold to actually want to buyback afterwards
						if heroent:GetGold() > (bbcost * 2.1) and heroent:GetBuybackCooldownTime() > GameRules:GetGameTime() then
							heroent:SpendGold(bbcost, 2)
							heroent:SetBuybackCooldownTime( 0 )
							dprint("Resetting Buyback Cooldown for "..HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()))
							dprint("Buyback Cost: "..heroent:GetBuybackCost(false).." Gold Remaining: "..(heroent:GetGold() - heroent:GetBuybackCost(false)))
							self:LogEvent("Resetting Buyback Cooldown for "..HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Buyback Cost: "..heroent:GetBuybackCost(false).." Gold Remaining: "..(heroent:GetGold() - heroent:GetBuybackCost(false)))
						end
					end
					
					--///////////////////
					--Dire Ancient Tether
					--///////////////////
					if heroent:IsRealHero() then
						if self.direanc:IsAlive() and heroent:IsAlive() and heroent:GetTeamNumber() == self.direanc:GetTeamNumber() and (heroent:GetAbsOrigin() - self.direanc:GetAbsOrigin()):Length2D() < 2800 then
							if  heroent:HasModifier("modifier_vgmar_b_ancient_tether") == false then
								heroent:AddNewModifier(self.direanc, nil, "modifier_vgmar_b_ancient_tether", modifierdatatable["modifier_vgmar_b_ancient_tether"])
							end
						else
							if heroent:HasModifier("modifier_vgmar_b_ancient_tether") then
								heroent:FindModifierByName("modifier_vgmar_b_ancient_tether"):Destroy()
							end
						end
					end
					
					--//////////////////////
					--Bot Progression System
					--//////////////////////
					if heroent:IsRealHero() then
						if self.botupgradestatus[heroent:entindex()] == nil then
							table.insert(self.botupgradestatus, heroent:entindex())
							self.botupgradestatus[heroent:entindex()] = 1
						else
							if self.botupgradestatus[heroent:entindex()] <= self.botitemskv.maxbotupgradestatus then
								local bus = self.botupgradestatus[heroent:entindex()]
								local uppriolist = botupgradepriorities[heroent:GetName()]
								local bup = uppriolist[bus]
								if bup == "travel1" and self:TimeIsLaterThan(botupgradetimings.travel1[1], botupgradetimings.travel1[2]) then
									if heroent:GetGold() >= heroent:GetBuybackCost(false) + self.botitemskv.travelbootscost then
										local cboot = InvManager:GetFirstItemFromListInUnitInventory( heroent, self.botitemskv.cheapboots, true, true, true )
										if cboot or (cboot == nil and InvManager:GetFirstItemFromListInUnitInventory( heroent, {"item_travel_boots", "item_travel_boots_2"}, true, true, true ) == nil) then
											if cboot then
												local bootsname = cboot:GetName()
												heroent:ModifyGold(cboot:GetCost(), true, 0)
												heroent:RemoveItem(cboot)
												dprint(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Sold CheapBoot "..bootsname)
											end
											heroent:SpendGold(self.botitemskv.travelbootscost, 2)
											heroent:AddItemByName("item_travel_boots")
											dprint(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Spent "..tostring(self.botitemskv.travelbootscost).." Purchased Travel Boots | Gold Remaining: "..heroent:GetGold())
											self:LogEvent(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Upgraded to Travel Boots | Gold Remaining: "..heroent:GetGold())
											self.botupgradestatus[heroent:entindex()] = self.botupgradestatus[heroent:entindex()] + 1
										end
									end
								elseif bup == "travel2" and self:TimeIsLaterThan(botupgradetimings.travel2[1], botupgradetimings.travel2[2]) then
									if heroent:GetGold() >= heroent:GetBuybackCost(false) + self.botitemskv.travelbootsrecipecost then
										heroent:SpendGold(self.botitemskv.travelbootsrecipecost, 2)
										heroent:AddItemByName("item_recipe_travel_boots")
										dprint(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Spent "..tostring(self.botitemskv.travelbootsrecipecost).." Upgraded Travel Boots to level 2 | Gold Remaining: "..heroent:GetGold())
										self:LogEvent(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Upgraded Travel Boots to level 2 | Gold Remaining: "..heroent:GetGold())
										self.botupgradestatus[heroent:entindex()] = self.botupgradestatus[heroent:entindex()] + 1
									end
								elseif bup == "aghs" and self:TimeIsLaterThan(botupgradetimings.aghs[1], botupgradetimings.aghs[2]) then
									if self.botitemskv.noaghsheroes[heroent:GetName()] == true then
										self.botupgradestatus[heroent:entindex()] = self.botupgradestatus[heroent:entindex()] + 1
									else
										if heroent:GetGold() >= heroent:GetBuybackCost(false) + self.botitemskv.aghanimsupgradecost then
											local aghs = InvManager:GetItemFromInventoryByName( heroent, "item_ultimate_scepter", false, true, false )
											if aghs ~= nil and heroent:GetGold() >= heroent:GetBuybackCost(false) + self.botitemskv.aghanimsupgradecost then
												heroent:RemoveItem(aghs)
												heroent:SpendGold(self.botitemskv.aghanimsupgradecost, 2)
												heroent:AddNewModifier(heroent, nil, "modifier_item_ultimate_scepter_consumed", self.botitemskv.aghanimsstats)
												dprint(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Spent "..tostring(self.botitemskv.aghanimsupgradecost).." Consumed Aghanims replacing inventory Aghanims | Gold Remaining: "..heroent:GetGold())
												self:LogEvent(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Consumed Aghanims replacing inventory Aghanims | Gold Remaining: "..heroent:GetGold())
												self.botupgradestatus[heroent:entindex()] = self.botupgradestatus[heroent:entindex()] + 1
											elseif aghs == nil and heroent:GetGold() >= heroent:GetBuybackCost(false) + self.botitemskv.aghanimscost + self.botitemskv.aghanimsupgradecost then
												heroent:SpendGold(self.botitemskv.aghanimscost + self.botitemskv.aghanimsupgradecost, 2)
												heroent:AddNewModifier(heroent, nil, "modifier_item_ultimate_scepter_consumed", self.botitemskv.aghanimsstats)
												dprint(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Spent "..tostring(self.botitemskv.aghanimscost + self.botitemskv.aghanimsupgradecost).." Consumed Aghanims | Gold Remaining: "..heroent:GetGold())
												self:LogEvent(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Consumed Aghanims | Gold Remaining: "..heroent:GetGold())
												self.botupgradestatus[heroent:entindex()] = self.botupgradestatus[heroent:entindex()] + 1
											end
										end
									end
								elseif bup == "moonshard" and self:TimeIsLaterThan(botupgradetimings.moonshard[1], botupgradetimings.moonshard[2]) then
									--TODO:??Make Supports Give Carries moonshards
									if (heroent:GetGold() >= heroent:GetBuybackCost(false) + self.botitemskv.moonshardcost and heroent:GetAverageTrueAttackDamage(heroent) > self.botitemskv.moonshardmindmg) or (heroent:GetGold() >= heroent:GetBuybackCost(false) + self.botitemskv.moonshardcost * 2) then
										heroent:SpendGold(self.botitemskv.moonshardcost, 2)
										heroent:AddNewModifier(heroent, nil, "modifier_item_moon_shard_consumed", self.botitemskv.moonshardvalues)
										dprint(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Spent "..tostring(self.botitemskv.moonshardcost).." Consumed Moonshard | Gold Remaining: "..heroent:GetGold())
										self:LogEvent(HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." Consumed Moonshard | Gold Remaining: "..heroent:GetGold())
										self.botupgradestatus[heroent:entindex()] = self.botupgradestatus[heroent:entindex()] + 1
									end
								end
							end
						end
						--//////////////////////////////////////////
						--Remove Item Aghanim if consumed is present
						--Edge case when bot builds Aghanims 
						--after getting an infused one
						--//////////////////////////////////////////
						if self.botitemaghsremoved[heroent:entindex()] == nil then
							if heroent:HasModifier("modifier_item_ultimate_scepter_consumed") and heroent:HasItemInInventory("item_ultimate_scepter") then
								local aghs = InvManager:GetItemFromInventoryByName( heroent, "item_ultimate_scepter", false, true, false )
								if aghs ~= nil then
									heroent:ModifyGold(aghs:GetCost(), true, 0)
									heroent:RemoveItem(aghs)
									table.insert(self.botitemaghsremoved, heroent:entindex())
									self.botitemaghsremoved[heroent:entindex()] = true
								end
							end
						end
					end
					--///////////////////
					--[[--BotShrineActivation
					--///////////////////
					local nearbyshrine = Entities:FindByClassnameWithin(nil, "npc_dota_healer", heroent:GetOrigin(), 400)
					if nearbyshrine ~= nil and nearbyshrine:GetTeamNumber() == heroent:GetTeamNumber() then
						dprint("Found a shrine: ", nearbyshrine:GetName())
						local shrineability = nearbyshrine:FindAbilityByName("filler_ability")
						local shrinemodifier = nearbyshrine:FindModifierByName("modifier_filler_heal_aura")
						if shrineability ~= nil and (shrineability:GetCooldownTimeRemaining() == 0 or shrinemodifier ~= nil) then
							if heroent:GetHealth()/heroent:GetMaxHealth() < 0.7 or heroent:GetMana()/heroent:GetMaxMana() <= 0.5 then
								shrineability:CastAbility()
								heroent:MoveToPositionAggressive(nearbyshrine:GetOrigin())
							end
						elseif shrineability:GetCooldownTimeRemaining() >= 295 then
							if heroent:GetHealth()/heroent:GetMaxHealth() < 0.7 or heroent:GetMana()/heroent:GetMaxMana() <= 0.5 then
								heroent:MoveToPositionAggressive(nearbyshrine:GetOrigin())
							end					
						end
					end--]]
				end
				
				--//////////////////
				--AbilityAutoUpgrade
				--//////////////////
				local heroname = heroent:GetName()
				--AbilityAutoUpgradeTable
				local heroautoabilityuplist = {
					--[[["npc_dota_hero_riki"] = {
						spells = {"riki_smoke_screen",
							"riki_blink_strike", 
							"riki_permanent_invisibility", 
							"riki_tricks_of_the_trade"},
						levelup = {
							{[5] = heroent:GetLevel() >= 22},
							{[5] = heroent:GetLevel() >= 20},
							{[5] = heroent:GetLevel() >= 15 or heroent:HasScepter(), [6] = heroent:HasScepter() and heroent:GetLevel() >= 15},
							{[4] = heroent:HasScepter() or heroent:GetLevel() == 25, [5] = heroent:HasScepter() and heroent:GetLevel() == 25}
						}
					},--]]
				}
				if heroautoabilityuplist[heroname] ~= nil then
					for j=1,#heroautoabilityuplist[heroname].spells do
						local ability = heroent:FindAbilityByName(heroautoabilityuplist[heroname].spells[j])
						if ability then
							local ablvl = ability:GetLevel()
							if heroautoabilityuplist[heroname].levelup[j][ablvl] ~= nil and heroautoabilityuplist[heroname].levelup[j][ablvl] == false then
								ability:SetLevel( ability:GetLevel() - 1 )
							elseif heroautoabilityuplist[heroname].levelup[j][ablvl + 1] ~= nil and heroautoabilityuplist[heroname].levelup[j][ablvl + 1] == true then
								ability:SetLevel( ability:GetLevel() + 1 )
							end
						end
					end
				end
				
				if heroent:IsRealHero() and not heroent:IsCourier() then
					--Shrines Fill Bottles --modifier_filler_heal_aura
					if InvManager:HeroHasUsableItemInInventory( heroent, "item_bottle", false, true, false) and heroent:FindModifierByName("modifier_filler_heal") ~= nil then
						local bottle = InvManager:GetItemFromInventoryByName( heroent, "item_bottle", false, true, false )
						if bottle:GetCurrentCharges() < bottle:GetInitialCharges() then
							bottle:SetCurrentCharges( bottle:GetInitialCharges() )
						end
					end
					--##Obsolete707
					--Diffusal Blade 2+ Upgrade
					--[[if InvManager:HeroHasUsableItemInInventory( heroent, "item_recipe_diffusal_blade", false, false, false) and InvManager:HeroHasUsableItemInInventory( heroent, "item_diffusal_blade_2", false, false, false)  then
						local diffbladeitem = InvManager:GetItemFromInventoryByName( heroent, "item_diffusal_blade_2", false, false, false )
						local diffbladerecipe = InvManager:GetItemFromInventoryByName( heroent, "item_recipe_diffusal_blade", false, false, false )
						if diffbladeitem ~= nil and diffbladeitem:GetCurrentCharges() < diffbladeitem:GetInitialCharges() then
							heroent:RemoveItem(diffbladerecipe)
							diffbladeitem:SetCurrentCharges(diffbladeitem:GetInitialCharges())
						end
					end--]]
					--//////////////////////////////
					--Consumable Items System
					--//////////////////////////////
					--Bloodstone recharge
					if InvManager:HeroHasUsableItemInInventory(heroent, "item_bloodstone", false, false, false) and InvManager:CountUsableItemsInHeroInventory(heroent, "item_pers", false, true, false) >= 2 then
						InvManager:RemoveNItemsInInventory(heroent, "item_pers", 2)
						local bloodstone = InvManager:GetItemFromInventoryByName( heroent, "item_bloodstone", false, false, false )
						if bloodstone ~= nil then
							bloodstone:SetCurrentCharges(bloodstone:GetCurrentCharges() + 24)
						end
					end
					--Aegis
					if InvManager:HeroHasUsableItemInInventory(heroent, "item_aegis", false, false, false) then
						InvManager:RemoveNItemsInInventory(heroent, "item_aegis", 1)
						heroent:AddNewModifier(heroent, nil, "modifier_vgmar_i_consumed_aegis", modifierdatatable["modifier_vgmar_i_consumed_aegis"])
					end
				end
				
				--//////////////////////
				--Passive Item Abilities
				--//////////////////////
				--Items For Spells Table
				local itemlistforspell = {
			{spell = "modifier_vgmar_i_midas_greed",
				items = {itemnames = {"item_hand_of_midas"}, itemnum = {1}},
				isconsumable = false,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {min_bonus_gold = 0, count_per_kill = 1, reduction_per_tick = 2, bonus_gold_cap = 80, stack_duration = 30, reduction_duration = 2.5, killsperstack = 4},
				usesmultiple = false,
				backpack = self:TimeIsLaterThan( 30, 0 ) or heroent:GetLevel() >= 25,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_essence_shift",
				items = {itemnames = {"item_diffusal_blade"}, itemnum = {1}},
				isconsumable = false,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {reductionprimary = 1, reductionsecondary = 0, increaseprimary = 1, increasesecondary = 0, hitsperstackinc = 1, hitsperstackred = 2, duration = 40, durationtarget = 40},
				usesmultiple = false,
				backpack = false,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_thirst",
				items = {itemnames = {"item_lesser_crit", "item_bloodstone"}, itemnum = {1, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = false,
				backpack = true,
				preventedhero = "npc_dota_hero_bloodseeker",
				specificcond = true },
			{spell = "modifier_vgmar_i_pulse",
				items = {itemnames = {"item_urn_of_shadows"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {stackspercreep = 1, stacksperhero = 10, duration = 3, hpregenperstack = 4, manaregenperstack = 4},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_fervor",
				items = {itemnames = {"item_gloves", "item_mask_of_madness"}, itemnum = {2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {maxstacks = 15, asperstack = 15},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_troll_warlord",
				specificcond = true },
			{spell = "modifier_vgmar_i_atrophy",
				items = {itemnames = {"item_helm_of_the_dominator", "item_satanic"}, itemnum = {2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 1000, dmgpercreep = 1, dmgperhero = 5, stack_duration = 240, stack_duration_scepter = -1, max_stacks = 1000, initial_stacks = 0},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_deathskiss",
				items = {itemnames = {"item_relic"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {critdmgpercentage = 20000, critchance = 1},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:FindModifierByName("modifier_vgmar_i_critical_mastery") == nil },
			{spell = "modifier_vgmar_i_cdreduction",
				items = {itemnames = {"item_octarine_core"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { percentage = 25, bonusmana = 905, bonushealth = 905, intbonus = 25, spelllifestealhero = 25, spelllifestealcreep = 5 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_manaregen_aura",
				items = {itemnames = {"item_infused_raindrop", "item_energy_booster"}, itemnum = {2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 4000, bonusmanaself = 400, bonusmanaallies = 300, regenself = 1.5, regenallies = 1},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_spellshield",
				items = {itemnames = {"item_lotus_orb", "item_aeon_disk"}, itemnum = {1, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {resistance = 35, cooldown = 12, maxstacks = 2},
				usesmultiple = false,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_vampiric_aura",
				items = {itemnames = {"item_vladmir"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 700, lspercent = 30, lspercentranged = 20},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_critical_mastery",
				items = {itemnames = {"item_greater_crit", "item_lesser_crit"}, itemnum = {2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {critdmgpercentage = 300, critchance = 100},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:FindModifierByName("modifier_vgmar_i_deathskiss") == nil },
			{spell = "modifier_vgmar_i_truesight",
				items = {itemnames = {"item_gem"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 900},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_spellamp",
				items = {itemnames = {"item_kaya"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {percentage = 10, costpercentage = 10, bonusint = 16},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_castrange",
				items = {itemnames = {"item_aether_lens"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {range = 250, manaregen = 1.25, bonusmana = 400},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true},
			{spell = "modifier_vgmar_i_attackrange",
				items = {itemnames = {"item_dragon_lance"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {range = 140, bonusstr = 12, bonusagi = 12},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:IsRangedAttacker()},
			{spell = "modifier_vgmar_i_essence_aura",
				items = {itemnames = {"item_soul_booster"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { radius = 1000, bonusmana = 900, restorechance = 25, restoreamount = 20 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_greatcleave",
				items = {itemnames = {"item_bfury"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { cleaveperc = 100, cleavestartrad = 150, cleaveendrad = 300, cleaveradius = 700 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:IsRangedAttacker() == false },
			{spell = "modifier_vgmar_i_multishot",
				items = {itemnames = {"item_dragon_lance", "item_demon_edge"}, itemnum = {1, 2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {stackscap = 5, shotspercap = 8, attackduration = 2},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:IsRangedAttacker() == true },
			{spell = "modifier_vgmar_i_arcane_intellect",
				items = {itemnames = {"item_mystic_staff"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { percentage = 10, multperhit = 0.5, stack_duration = 30 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true	},
			{spell = "modifier_vgmar_i_multidimension_cast",
				items = {itemnames = {"item_mystic_staff", "item_refresher"}, itemnum = {1, 2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true	},
				--TODO:Rework Poison Dagger Recipe
			{spell = "modifier_vgmar_i_poison_dagger",
				items = {itemnames = {"item_butterfly", "item_orb_of_venom", "item_eagle"}, itemnum = {1, 2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true	},
			{spell = "modifier_vgmar_i_scorching_light",
				items = {itemnames = {"item_radiance"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_permafrost",
				items = {itemnames = {"item_shivas_guard"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_manashield",
				items = {itemnames = {"item_shivas_guard", "item_energy_booster"}, itemnum = {1,2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_ogre_tester",
				items = {itemnames = {"item_ogre_axe"}, itemnum = {2}},
				isconsumable = false,
				ismodifier = true,
				usemodifierdatatable = false,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = Convars:GetInt("vgmar_devmode") == 1 }
			}
			--TableEND
			
				for k=1,#itemlistforspell do
					if heroent:IsRealHero() then
						if heroent:GetClassname() ~= itemlistforspell[k].preventedhero then
							if itemlistforspell[k].specificcond == true then
								if itemlistforspell[k].isconsumable == true then
									if itemlistforspell[k].ismodifier == true then
										if InvManager:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) and heroent:IsAlive() and not heroent:HasModifier(itemlistforspell[k].spell) then
											for j=1,#itemlistforspell[k].items.itemnames do
												InvManager:RemoveNItemsInInventory( heroent, itemlistforspell[k].items.itemnames[j], itemlistforspell[k].items.itemnum[j])
											end
											if itemlistforspell[k].usemodifierdatatable == true then
												heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, modifierdatatable[itemlistforspell[k].spell])
											else
												heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, itemlistforspell[k].modifierdata)
											end
										end
									else
										if AbilitySlotsLib:GetFreeAbilitySlotsForSpecificHero( heroent, true ) > 0 then
											if InvManager:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) and heroent:IsAlive() and not heroent:FindAbilityByName(itemlistforspell[k].spell) then
												local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
												if itemability == nil then
													for j=1,#itemlistforspell[k].items.itemnames do
														InvManager:RemoveNItemsInInventory( heroent, itemlistforspell[k].items.itemnames[j], itemlistforspell[k].items.itemnum[j])
													end
													AbilitySlotsLib:SafeAddAbility( heroent, itemlistforspell[k].spell, 1 )
												end
											end
										end
									end
								else
									if InvManager:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) then
										if heroent:IsAlive() then
											if itemlistforspell[k].ismodifier == true then
												if not heroent:HasModifier(itemlistforspell[k].spell) then
													if itemlistforspell[k].usemodifierdatatable == true then
														heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, modifierdatatable[itemlistforspell[k].spell])
													else
														heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, itemlistforspell[k].modifierdata)
													end
												end
											else
												if AbilitySlotsLib:GetFreeAbilitySlotsForSpecificHero( heroent, true ) > 0 then
													local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
													if itemability == nil then
														AbilitySlotsLib:SafeAddAbility( heroent, itemlistforspell[k].spell, 1 )
														--heroent:AddAbility(itemlistforspell[k].spell):SetLevel(1)
													end
												end
											end
										end
									else
										if itemlistforspell[k].ismodifier == true then
											if heroent:HasModifier(itemlistforspell[k].spell) then
												heroent:RemoveModifierByName(itemlistforspell[k].spell)
											end
										else
											local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
											if itemability ~= nil then
												AbilitySlotsLib:SafeRemoveAbility( heroent, itemlistforspell[k].spell )
												--heroent:RemoveAbility(itemlistforspell[k].spell)
											end
										end
									end
								end
							end
						end
					end
				end
				
				--///////////////////
				--CourierBurstUpgrade
				--///////////////////
				if InvManager:HeroHasUsableItemInInventory(heroent, "item_flying_courier_upgrade", false, true, true) then
					local couriers = Entities:FindAllByClassname("npc_dota_courier")
					for j=1,#couriers do
						if couriers[j]:GetTeamNumber() == heroent:GetTeamNumber() then
							local courierburstmod = couriers[j]:FindModifierByName("modifier_vgmar_courier_burst")
							if courierburstmod and courierburstmod:GetStackCount() >= 1 then
								if couriers[j]:GetTeamNumber() == 2 and self.radiantcourieruplevel < MAX_COURIER_LVL then
									InvManager:RemoveNItemsInInventory(heroent, "item_flying_courier_upgrade", 1)
									couriers[j]:AddNewModifier(couriers[j], nil, "modifier_vgmar_courier_burst", {level = self.radiantcourieruplevel + 1})
									self.radiantcourieruplevel = courierburstmod:GetStackCount()
								elseif couriers[j]:GetTeamNumber() == 3 and self.direcourieruplevel < MAX_COURIER_LVL then
									InvManager:RemoveNItemsInInventory(heroent, "item_flying_courier_upgrade", 1)
									couriers[j]:AddNewModifier(couriers[j], nil, "modifier_vgmar_courier_burst", {level = self.direcourieruplevel + 1})
									self.direcourieruplevel = courierburstmod:GetStackCount()
								end
							end
						end
					end
				end
				--/////////////////
				--BotCourierUpgrade
				--/////////////////
				for k,v in ipairs(self.direcourieruptable) do
					if v.done == false and self:TimeIsLaterThan(v.upgradetime, 0) and self:GetCourierBurstLevel( nil, 3 ) >= v.lvl then
						if heroent:GetTeamNumber() == 3 and InvManager:GetHeroFreeInventorySlots(heroent, true, true, false) > 0 then
							dprint("Giving ".. HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()).." having "..InvManager:GetHeroFreeInventorySlots(heroent, true, true, false).." empty slots lvl "..v.lvl.." courier upgrade")
							heroent:AddItemByName("item_flying_courier_upgrade")
							v.done = true
						end
					end
				end
				--/////////////
				--Tome Purchase
				--/////////////
				if self:TimeIsLaterThan( math.floor(self.botitemskv.tomerestock[1]/60), self.botitemskv.tomerestock[1] % 60 ) and self.tomepurchaseallmaxlvl == false and #self.direheroes > 0 then
					local function GetLowestXpBot()
						local lowestxpbot = {99999, nil}
						for k,v in ipairs(self.direheroes) do
							if v:GetCurrentXP() < lowestxpbot[1] and v:GetGold() >= self.botitemskv.tomeprice then
								lowestxpbot = {v:GetCurrentXP(), v}
							end
						end
						return lowestxpbot[2]
					end
					local function BuyTome(tomes)
						for tomenum=1, tomes do
							local lxpb = GetLowestXpBot()
							if lxpb ~= nil then
								if lxpb:GetLevel() < 25 and InvManager:GetHeroFreeInventorySlots(lxpb, true, true, false) > 0 then
									lxpb:SpendGold(self.botitemskv.tomeprice, 2)
									lxpb:AddItemByName("item_tome_of_knowledge")
									Timers:CreateTimer(5, function()
										local tome = InvManager:GetItemFromInventoryByName( lxpb, "item_tome_of_knowledge", false, true, false )
										if tome ~= nil then
											local slot = InvManager:GetItemSlotFromInventoryByItemName( lxpb, "item_tome_of_knowledge", false, true, false )
											if slot > 5 and slot < 9 then
												lxpb:SwapItems(slot, 0)
											end
											lxpb:CastAbilityNoTarget(tome, lxpb:GetPlayerID())
											return 5.0
										end
									end)
									dprint("Buying item_tome_of_knowledge for "..HeroNamesLib:ConvertInternalToHeroName(lxpb:GetName()))
									self:LogEvent("Buying item_tome_of_knowledge for "..HeroNamesLib:ConvertInternalToHeroName(lxpb:GetName()))
									self.bottomepurchausetimestamp = GameRules:GetDOTATime(false, false)
								elseif lxpb:GetLevel() == 25 then
									self.tomepurchaseallmaxlvl = true
								end
							end
						end
					end
					if GameRules:GetDOTATime(false, false) < self.botitemskv.tomerestock[1] + 1 then
						if self.bottomepurchausetimestamp + self.botitemskv.tomerestock[1] < GameRules:GetDOTATime(false, false) then
							BuyTome(self.botitemskv.tomeinitialstack)
						end
					elseif self.bottomepurchausetimestamp + self.botitemskv.tomerestock[2] < GameRules:GetDOTATime(false, false) then
						BuyTome(1)
					end
				end
				--/////////////////////
				--Innate Gem Assignment
				--/////////////////////
				if self:TimeIsLaterThan( self.botitemskv.gemtime[1], self.botitemskv.gemtime[2] ) and GameRules:GetDOTATime(false, false) > self.gemapplyretrytime and self.botinnategemapplied == false and #self.direheroes > 0 then
					local fathero = {-1, nil}
					for _, fatso in ipairs(self.direheroes) do
						if fatso:GetMaxHealth() > fathero[1] then
							fathero = {fatso:GetMaxHealth(), fatso}
						end
					end
					if fathero[2] ~= nil then
						if fathero[2]:IsAlive() then
							local gemmodifier = fathero[2]:AddNewModifier(fathero[2], nil, "modifier_vgmar_i_truesight", modifierdatatable["modifier_vgmar_i_truesight"])
							dprint("Adding modifier_vgmar_i_truesight to "..HeroNamesLib:ConvertInternalToHeroName(fathero[2]:GetName()))
							if gemmodifier ~= nil then
								self.botinnategemapplied = true
								self:LogEvent("Adding modifier_vgmar_i_truesight to "..HeroNamesLib:ConvertInternalToHeroName(fathero[2]:GetName()))
							else
								dprint("Failed to attach Gem Modifier to "..HeroNamesLib:ConvertInternalToHeroName(fathero[2]:GetName()))
								LogLib:Log_Warning("Failed to attach Gem Modifier to "..HeroNamesLib:ConvertInternalToHeroName(fathero[2]:GetName()), 0, "Innate Gem Assignment")
							end
						else
							self.gemapplyretrytime = GameRules:GetDOTATime(false, false) + fathero[2]:GetTimeUntilRespawn() + 1
						end
					end
				end
			end
			--///////////
			--CourierInit
			--///////////
			if self:TimeIsLaterThan(COURIER_UPGRADE_TIME, 0) and self.couriersinit < 2 then
				local couriers = Entities:FindAllByClassname("npc_dota_courier")
				for j=1,#couriers do
					if not couriers[j]:HasModifier("modifier_vgmar_courier_burst") then
						if couriers[j]:GetTeamNumber() == 2 then
							couriers[j]:AddNewModifier(couriers[j], nil, "modifier_vgmar_courier_burst", table_modifier_vgmar_courier_burst_var)
							couriers[j]:AddNewModifier(couriers[j], nil, "modifier_vgmar_courier_burst", {level = self.radiantcourieruplevel})
						elseif couriers[j]:GetTeamNumber() == 3 then
							couriers[j]:AddNewModifier(couriers[j], nil, "modifier_vgmar_courier_burst", table_modifier_vgmar_courier_burst_var)
							couriers[j]:AddNewModifier(couriers[j], nil, "modifier_vgmar_courier_burst", {level = self.direcourieruplevel})
							--Add Bot Courier Shield AI Controller
							couriers[j]:AddNewModifier(couriers[j], nil, "modifier_vgmar_crai_courier_shield", table_modifier_vgmar_crai_courier_shield)
						end
						self.couriersinit = self.couriersinit + 1
					end
				end
			end
		end
		--/////////////////
		--Last Resort Boost
		--/////////////////
		if self.lastresortboostgiven == false then
			if self.direanc:GetHealth()/self.direanc:GetMaxHealth() <= botancientlastresort.healththreshold then
				self:TeamReward(3, {botancientlastresort.gold, botancientlastresort.xp}, {false, false})
				self:LogEvent("Last Resort Boost Triggered")
				EmitSoundOn("DOTA_Item.DoE.Activate",self.direanc)
				self.direanc:AddNewModifier(self.direanc, nil, "modifier_vgmar_b_last_resort_armor", modifierdatatable["modifier_vgmar_b_last_resort_armor"])
				self.lastresortboostgiven = true
			end
		end
		--//////////////////
		--BackDoorProtection
		--//////////////////
		for j=1,#bdplist do
			for k=1,#bdplist[j].buildinglist do
				local buildingname = bdplist[j].buildinglist[k]
				if self.backdoorstatustable[buildingname] == nil then
					table.insert(self.backdoorstatustable, buildingname)
					self.backdoorstatustable[buildingname] = true
				else
					if self.backdoortimertable[buildingname] == nil then
						table.insert(self.backdoortimertable, buildingname)
						self.backdoortimertable[buildingname] = GameRules:GetDOTATime(false, false)
					else
						self.backdoorstatustable[buildingname] = GameRules:GetDOTATime(false, false) >= self.backdoortimertable[buildingname] + bdplist[j].activationtime
						local buildingentity = Entities:FindByName(nil, buildingname)
						if buildingentity then
							if self.backdoorstatustable[buildingname] == true then
								buildingentity:AddNewModifier(buildingentity, nil, "modifier_backdoor_protection_active", {})
							else
								buildingentity:RemoveModifierByName("modifier_backdoor_protection_active")
							end
						end
					end
				end
			end	
		end
		--///////////////
		--BalanceLogPrint
		--///////////////
		if VGMAR_LOG_BALANCE_PERIODIC == true then
			if GameRules:GetDOTATime(false, false) >= self.balancelogprinttimestamp + VGMAR_LOG_BALANCE_INTERVAL then
				self.balancelogprinttimestamp = math.floor(GameRules:GetDOTATime(false, false))
				self:LogBalance()
			end
		end
	end
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		--///////////////////
		--CustomItemsReminder
		--///////////////////
		
		local customitemreminderlist = {
			[-60] = "<font color='honeydew'>Remember, this gamemode has multiple scripted item abilities</font>",
			[-50] = "<font color='honeydew'>Use information Icon above your minimap</font>",
			[-40] = "<font color='honeydew'>You can reset your buyback cooldown by buying an item at the base shop.</font>",
			[-30] = "<font color='honeydew'>Bots can also do that.",
			[-5] = "<font color='lime'>GLHF</font>"
		}
		
		if self.customitemsreminderfinished == false then
			local gametimefloor = math.floor(GameRules:GetDOTATime( false, true ))
			if customitemreminderlist[gametimefloor] ~= nil then
				GameRules:SendCustomMessageToTeam(customitemreminderlist[gametimefloor], DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
				customitemreminderlist[gametimefloor] = nil
			end
			if gametimefloor >= -5 then
				self.customitemsreminderfinished = true
			end
		end
		
		--///////////////////////////
		--END
		--///////////////////////////
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end
	return VGMAR_GTHINK_TIME
end

--Function Called from a modifier attached on game start
function VGMAR:OnBuildingDestroyed(attacker, denied, buildingteamnumber, buildingname, buildingvalue)
	--Dire Building Down
	if buildingteamnumber == 3 then
		self.towerskilledrad = self.towerskilledrad + buildingvalue
	--Radiant Building Down
	elseif buildingteamnumber == 2 then
		self.towerskilleddire = self.towerskilleddire + buildingvalue
		self:BuildingKillReward(attacker, denied, buildingteamnumber, buildingname, buildingvalue)
	end
	local shrinedecaystarters = {
		["dota_goodguys_tower3_top"] = true,
		["dota_goodguys_tower3_mid"] = true,
		["dota_goodguys_tower3_bot"] = true
	}
	--Shrine Decay
	if shrinedecaystarters[buildingname] ~= nil and shrinedecaystarters[buildingname] == true and self.shrinedecaystarted == false then
		local decaybuildings = {"good_healer_7", "good_healer_6"}
		for i=1,#decaybuildings do
			local building = Entities:FindByName(nil, decaybuildings[i])
			if building and building:HasModifier("modifier_vgmar_buildings_decay") == false then
				building:AddNewModifier(building, nil, "modifier_vgmar_buildings_decay", {})
			end
		end
		self.shrinedecaystarted = true
	end
	--Bot Balanced Push
	if buildingteamnumber == 2 and self.botmaxpushtier ~= -1 then
		if self:GetAllTierTowersDestroyed(2, self.botmaxpushtier) then
			if self.botmaxpushtier < 3 then
				self.botmaxpushtier = self.botmaxpushtier + 1
				dprint("Bot Balanced Push: Now Pushing: Tier "..self.botmaxpushtier)
			else
				self.botmaxpushtier = -1
				dprint("Bot Balanced Push: Push Restrictions Removed")
			end
			self.mode:SetBotsMaxPushTier(self.botmaxpushtier)
		end
	end
end

function VGMAR:GetAllTierTowersDestroyed(teamnum, tier)
	return (self:GetTierTowersStatus(teamnum, tier, "bot") == false and self:GetTierTowersStatus(teamnum, tier, "mid") == false and self:GetTierTowersStatus(teamnum, tier, "top") == false)
end

function VGMAR:GetTierTowersStatus(teamnum, tier, lane)
	local teamname = "goodguys"
	if teamnum == 2 then
		teamname = "goodguys"
	elseif teamnum == 3 then
		teamname = "badguys"
	else
		dprint("GetTierTowersStatus: Error. Incorrect teamnumber specified")
		LogLib:Log_Error("Incorrect teamnumber: "..teamnum.." specified", 0, "GetTierTowersStatus(): Error.")
		return nil
	end
	if lane == "bot" or lane == "mid" or lane == "top" and (tier > 0 and tier < 5) then
		local tower = Entities:FindByName(nil, "dota_"..teamname.."_tower"..tier.."_"..lane)
		local towerstate = false
		if tower then
			towerstate = tower:IsAlive()
		end
		return towerstate
	else
		if not (lane == "bot" or lane == "mid" or lane == "top") then
			LogLib:Log_Error("Incorrect lane: "..lane.." specified", 0, "GetTierTowersStatus(): Error.")
		elseif not (tier > 0 and tier < 5) then
			LogLib:Log_Error("Incorrect tier: "..tier.." specified", 0, "GetTierTowersStatus(): Error.")
		end
		return nil
	end
end

function VGMAR:BuildingKillReward(attacker, denied, buildingteamnumber, buildingname, buildingvalue)
	--TODO:Balance
	local function GetRealAttacker(attkr)
		if attkr:IsRealHero() then
			return {id = attkr:GetPlayerID(), ent = PlayerResource:GetPlayer(attkr:GetPlayerID()), hero = attkr}
		else
			if attkr:GetPlayerOwner() then
				return {id = attkr:GetPlayerOwnerID(), ent = PlayerResource:GetPlayer(attkr:GetPlayerOwnerID()), hero = PlayerResource:GetPlayer(attkr:GetPlayerOwnerID()):GetAssignedHero()}
			end
		end
		return {id = nil, ent = nil, hero = nil}
	end
	if denied then
		self:TeamReward(Extensions:GetOpposingTeamNumber(buildingteamnumber), {(buildingvalue * botpushrewards.basegold.team) * botpushrewards.denyfactor, (buildingvalue * botpushrewards.basexp.team) * botpushrewards.denyfactor}, botpushrewards.splitgoldxp)
	else
		if(GetRealAttacker(attacker).hero ~= nil) then
			--SoloGold
			PlayerResource:ModifyGold(GetRealAttacker(attacker).id, buildingvalue*botpushrewards.basegold.solo, false, 0)
			--SoloXp
			GetRealAttacker(attacker).hero:AddExperience(buildingvalue*botpushrewards.basexp.solo, 2, false, true)
		end
		self:TeamReward(Extensions:GetOpposingTeamNumber(buildingteamnumber), {buildingvalue * botpushrewards.basegold.team, buildingvalue * botpushrewards.basexp.team}, botpushrewards.splitgoldxp)
	end
end

function VGMAR:GetBarracksStatus(teamnum, lane)
	local teamname = "good"
	if teamnum == 2 then
		teamname = "good"
	elseif teamnum == 3 then
		teamname = "bad"
	else
		LogLib:Log_Error("Incorrect teamnumber"..teamnum.." specified", 0, "GetBarracksStatus(): Error.")
		return nil
	end
	if lane == "bot" or lane == "mid" or lane == "top" then
		local rangerax = Entities:FindByName(nil, teamname.."_rax_range_"..lane)
		local meleerax = Entities:FindByName(nil, teamname.."_rax_melee_"..lane)
		local rangeraxstate = false
		local meleeraxstate = false
		if rangerax ~= nil then
			rangeraxstate = rangerax:IsAlive()
		end
		if meleerax then
			meleeraxstate = meleerax:IsAlive()
		end
		local allraxstate = rangeraxstate and meleeraxstate
		return {meleeraxstate, rangeraxstate, allraxstate}
	else
		LogLib:Log_Error("Incorrect lane"..lane.." specified", 0, "GetBarracksStatus(): Error.")
		return nil
	end
end

function VGMAR:GetMegaCreepsStatus(teamnum)
	return (self:GetBarracksStatus(teamnum, "bot")[3] and self:GetBarracksStatus(teamnum, "mid")[3] and self:GetBarracksStatus(teamnum, "top")[3]) == false
end

function VGMAR:OnAllHeroesSpawned()
	--Handle unpause
	GameRules:SendCustomMessageToTeam("<font color='palegreen'>Finished Loading.</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
	self.forcedpause = false
	self.pausedn = nil
	PauseGame(false)
	-----------------
	--////////////////////////////////////
	--BotSupportLib Heroes Init
	--Extensions Hero Damage Tracking Init
	--Extensions Hero Tables
	--BotRolesLib HeroList Parsing
	--////////////////////////////////////
	Extensions:CallWithDelay(2, true, function()
		BotSupportLib:StartBotInit()
		Extensions:InitHeroDamageTrackingTable(self.allheroes)
		Extensions:InitHeroTables(self.radiantheroes, self.direheroes)
		if VGMAR_BOT_FILL then
			BotRolesLib:ParseHeroList(self.botheroes)
		end
	end)
	--//////////////////////
	--Applying Bot Modifiers
	--//////////////////////
	for _, bot in ipairs(self.botheroes) do
		if botmodifiers[bot:GetName()] ~= nil then
			local botmods = botmodifiers[bot:GetName()]
			for _, mod in ipairs(botmods) do
				bot:AddNewModifier(bot, nil, mod.modifier, mod.data)
				dprint("Attached modifier: "..mod.modifier.." to bot: "..HeroNamesLib:ConvertInternalToHeroName(bot:GetName()))
			end
		end
	end
	
	--/////////
	--Timescale
	--/////////
	
	Extensions:CallWithDelay(10, true, function() Convars:SetFloat("host_timescale", PreGameSpeed()) end)
	Extensions:CallWithDelay(85, true, function()
		if self.istimescalereset == false then
			Convars:SetFloat("host_timescale", 1.0)
			self.istimescalereset = true
		end
	end)
	
	--////////////
	--Free Courier
	--////////////
	if self.couriergiven == false then
		local luckyhero = self.radiantheroes[math.random(1, #self.radiantheroes)]
		if luckyhero ~= nil then
			luckyhero:AddItemByName("item_courier")
			local heroname = HeroNamesLib:ConvertInternalToHeroName(luckyhero:GetName())
			GameRules:SendCustomMessageToTeam("<font color='turquoise'>Giving Free Courier to</font> <font color='gold'>"..heroname.."</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
			self.couriergiven = true
		end
	end
	--Giving Debug Items
	if IsDevMode() and VGMAR_GIVE_DEBUG_ITEMS == true then
		local itemslist = {}
		for k,v in pairs(debugitems) do
			if v >= 1 then
				for j=1, v do
					table.insert(itemslist, k)
				end
			end
		end
		if #itemslist > 0 then
			for i=1,#self.radiantheroes do
				self.radiantheroes[i]:AddNewModifier(self.radiantheroes[i], nil, "modifier_vgmar_util_give_debugitems", 
					{item1 = itemslist[1],
					item2 = itemslist[2],
					item3 = itemslist[3],
					item4 = itemslist[4],
					item5 = itemslist[5],
					item6 = itemslist[6],
					item7 = itemslist[7],
					item8 = itemslist[8],
					item9 = itemslist[9],
					item10 = itemslist[10],
					item11 = itemslist[11],
					item12 = itemslist[12],
					item13 = itemslist[13],
					item14 = itemslist[14],
					item15 = itemslist[15],
					item16 = itemslist[16],
					item17 = itemslist[17],
					item18 = itemslist[18],
					item19 = itemslist[19],
					item20 = itemslist[20],
					item21 = itemslist[21],
					item22 = itemslist[22],
					item23 = itemslist[23],
					item24 = itemslist[24],
					item25 = itemslist[25],
					item26 = itemslist[26],
					item27 = itemslist[27],
					item28 = itemslist[28],
					item29 = itemslist[29],
					item30 = itemslist[30],
					item31 = itemslist[31],
					item32 = itemslist[32],
					item33 = itemslist[33],
					item34 = itemslist[34],
					item35 = itemslist[35],
					item36 = itemslist[36],
					item37 = itemslist[37],
					item38 = itemslist[38],
					item39 = itemslist[39],
					item40 = itemslist[40],
					item41 = itemslist[41],
					item42 = itemslist[42],
					item43 = itemslist[43],
					item44 = itemslist[44],
					item45 = itemslist[45],
					item46 = itemslist[46],
					item47 = itemslist[47],
					item48 = itemslist[48],
					item49 = itemslist[49],
					item50 = itemslist[50]})
			end
		end
	end
end

function VGMAR:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end
	
	if spawnedUnit:IsRealHero() and self.allspawned == false then
		if self.spawnedheroes[event.entindex] == nil then
			dprint(HeroNamesLib:ConvertInternalToHeroName(spawnedUnit:GetName()).." | Index: "..event.entindex.." Spawned for the first time")
			table.insert(self.spawnedheroes, event.entindex)
			self.spawnedheroes[event.entindex] = true
			--///////////////
			--Fill Hero Lists
			--///////////////
			table.insert(self.allheroes, spawnedUnit)
			if spawnedUnit:GetTeamNumber() == 2 then
				table.insert(self.radiantheroes, spawnedUnit)
			elseif spawnedUnit:GetTeamNumber() == 3 then
				table.insert(self.direheroes, spawnedUnit)
			end
			if BotSupportLib:IsHeroBotControlled(spawnedUnit) then
				table.insert(self.botheroes, spawnedUnit)
			end
			if PlayerResource:GetPlayerCountForTeam(2) + PlayerResource:GetPlayerCountForTeam(3) <= #self.spawnedheroes then
				dprint("All heroes successfully spawned")
				self.allspawned = true
				self.spawnedheroes = nil
				self:OnAllHeroesSpawned()
			end
		end
	end
	
	if spawnedUnit:GetClassname() == "npc_dota_venomancer_plagueward" then
		local destroySpell = spawnedUnit:FindAbilityByName( "vgmar_util_plague_ward_destroy" )
		if destroySpell then
			destroySpell:SetLevel( 1 )
		end
	end
	
	for i=1,#creepabilitieslist do
		if spawnedUnit:GetClassname() == creepabilitieslist[i].classname then
			local requiresupdater = false
			local updaterabilitieslist = {}
			for k=1,#creepabilitieslist[i].abilities do
				if creepabilitieslist[i].abilities[k] then
					if creepabilitieslist[i].abilities[k].ismodifier == 1 then
						spawnedUnit:AddNewModifier(spawnedUnit, nil, creepabilitieslist[i].abilities[k].name, modifierdatatable[creepabilitieslist[i].abilities[k].name])
					else
						local ability = spawnedUnit:AddAbility( creepabilitieslist[i].abilities[k].name )
						local updaylvl = 0
						local upnightlvl = 0
						local uptype = 0
						if creepabilitieslist[i].levelmechanicmode[k] == "unitlevel" then
							ability:SetLevel( spawnedUnit:GetLevel() )
						elseif creepabilitieslist[i].levelmechanicmode[k] == "returnvalue" then
							ability:SetLevel( creepabilitieslist[i].levelmechanicarg[k] )
						elseif creepabilitieslist[i].levelmechanicmode[k] == "daynight" then
							requiresupdater = true
							uptype = 1
							if GameRules:IsDaytime() then
								ability:SetLevel( creepabilitieslist[i].levelmechanicarg[k].daylvl )
								updaylvl = creepabilitieslist[i].levelmechanicarg[k].daylvl
							else
								ability:SetLevel( creepabilitieslist[i].levelmechanicarg[k].nightlvl )
								upnightlvl = creepabilitieslist[i].levelmechanicarg[k].nightlvl
							end
						end
						local abil = {name = creepabilitieslist[i].abilities[k].name, uptype = uptype, updaylvl = updaylvl, upnightlvl = upnightlvl}
						table.insert(updaterabilitieslist, abil)
					end
					if creepabilitieslist[i].unbroken == true then
						spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_vgmar_util_dominator_ability_purger", 
						{remove_mode = creepabilitieslist[i].unbrokenmode,
							ability = creepabilitieslist[i].abilities[k].name,
							abilityismod = creepabilitieslist[i].abilities[k].ismodifier})
					end
					if requiresupdater then
						for j=1,#updaterabilitieslist do
							spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_vgmar_util_creep_ability_updater", 
								{name = updaterabilitieslist[j].name, uptype = updaterabilitieslist[j].uptype, updaylvl = updaterabilitieslist[j].updaylvl, upnightlvl = updaterabilitieslist[j].upnightlvl})
						end
					end
				end
			end
		end
	end
end

--[[function VGMAR:OnPlayerUsedAbility( keys )
	local PlayerID = keys.PlayerID
	local ability = keys.abilityname
end--]]

function VGMAR:OnPlayerLearnedAbility( keys )
	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
	
	local playerhero = player:GetAssignedHero()
	
	--///////////////////////////////////
	--Preventing manual ability upgrading
	--///////////////////////////////////
	
	local blockedlvlupabilities = {
		{spell = "riki_smoke_screen", maxmanuallevel = 4},
		{spell = "riki_blink_strike", maxmanuallevel = 4},
		{spell = "riki_permanent_invisibility", maxmanuallevel = 4},
		{spell = "riki_tricks_of_the_trade", maxmanuallevel = 3}
	}
	
	
	for i=1,#blockedlvlupabilities do
		if abilityname == blockedlvlupabilities[i].spell then
			local ability = playerhero:FindAbilityByName(abilityname)
			local abilitylevel = ability:GetLevel()
			if abilitylevel > blockedlvlupabilities[i].maxmanuallevel then
				playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
				ability:SetLevel( ability:GetLevel() - 1 )
			end
		end
	end
end

function GetBuildingGroupFromName( name )
	for i=1,#bdplist do
		for k=1,#bdplist[i].buildinglist do
			if bdplist[i].buildinglist[k] == name then
				return bdplist[i].group
			end
		end
	end
	return nil
end

function GetEnemyCreepsInRadius(team, origin, radius, dominated)
	local ret = false
	local creeps = FindUnitsInRadius(team, origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false)
	if #creeps > 0 then
		for i=1,#creeps do
			if creeps[i]:GetClassname() == "npc_dota_creep_lane" or creeps[i]:GetClassname() == "npc_dota_creep_siege" then
				if not creeps[i]:IsDominated() then
					ret = true
				elseif creeps[i]:IsDominated() and dominated == true then
					ret = true
				end
			end
		end
	end
	return ret
end

function VGMAR:UpdateBackdoorGroupTimer(group)
	for i=1,#bdplist do
		if bdplist[i].group == group then
			for k=1,#bdplist[i].buildinglist do
			local buildingname = bdplist[i].buildinglist[k]
				if self.backdoortimertable[buildingname] == nil then
					table.insert(self.backdoortimertable, buildingname)
					self.backdoortimertable[buildingname] = GameRules:GetDOTATime(false, false)
				else
					self.backdoortimertable[buildingname] = GameRules:GetDOTATime(false, false)
					self.backdoorstatustable[buildingname] = false
					local buildingentity = Entities:FindByName(nil, buildingname)
					if buildingentity then
						buildingentity:RemoveModifierByName("modifier_backdoor_protection_active")
					end
				end
			end
		end
	end
end

function VGMAR:CreepDamage(radiant, min, max)
	--[[local rdtext 
	if radiant then
		rdtext = "Radiant"
	else
		rdtext = "Dire"
	end--]]
	--dprint("Balance: "..rdtext.." C to C Dmg: Unclamped Adv: "..self:GetTeamAdvantage(radiant == false, true, false, false))
	if self:GetTeamAdvantage(radiant == false, true, false, false) > 1 then
		--dprint("Balance: "..rdtext.." C to C Dmg: Adv: "..math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5).." Remapped: "..math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1).." Scaled: "..math.scale(min, math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1), max))
		--[[if radiant then
			dprint("Radiant C to C DMG mult: "..math.scale(min, math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1), max))
		else
			dprint("Dire C to C DMG mult: "..math.scale(min, math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1), max))
		end--]]
		return math.scale(min, math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1), max)
	else
		--dprint("Balance: "..rdtext.." C to C Dmg: Adv: "..math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1).." Remapped: "..math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5).." Scaled: "..math.scale(min, math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5), max))
		--[[if radiant then
			dprint("Radiant C to C DMG mult: "..math.scale(min, math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5), max))
		else
			dprint("Dire C to C DMG mult: "..math.scale(min, math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5), max))
		end--]]
		return math.scale(min, math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5), max)
	end
end

function VGMAR:FilterDamage( filterTable )
	--local victim_index = filterTable["entindex_victim_const"]
    --local attacker_index = filterTable["entindex_attacker_const"]
	if not filterTable["entindex_victim_const"] or not filterTable["entindex_attacker_const"] then
        return true
    end
	local victim = EntIndexToHScript(filterTable.entindex_victim_const)
	local attacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	local damage = filterTable["damage"]
	
	--Damn 7.07 Makes Creeps SuperDemolishingSquads
	--Reduce Creep Damage to Buildings
	if (victim:IsBuilding() or victim:IsTower()) and (attacker:GetClassname() == "npc_dota_creep_lane" or attacker:GetClassname() == "npc_dota_creep_lane") and not attacker:IsDominated() then
		filterTable["damage"] = filterTable["damage"] * creeptobuildingdmgmult[attacker:GetClassname()]
	end
	
	--Creep and Tower Damage Balance System
	if attacker:IsDominated() == false and victim:IsDominated() == false then
		if (victim:GetClassname() == "npc_dota_creep_lane" or victim:GetClassname() == "npc_dota_creep_siege") and (attacker:GetClassname() == "npc_dota_creep_lane" or attacker:GetClassname() == "npc_dota_creep_siege") then
			--Creep to Creep Damage
			if attacker:GetTeamNumber() == 2 then --Radiant damage
				if VGMAR_DEBUG_DRAW == true then DebugDrawText(attacker:GetAbsOrigin(), "Rad DMGMult: "..math.truncate(self:CreepDamage(true, 0.8, 1.2),2), false, 2.0) end
				filterTable["damage"] = filterTable["damage"] * self:CreepDamage(true, 0.8, 1.2) --math.min(1.2,math.max(0.8,self:GetTeamAdvantage(false, true, false, false)))
			elseif attacker:GetTeamNumber() == 3 then --Dire damage
				if VGMAR_DEBUG_DRAW == true then DebugDrawText(attacker:GetAbsOrigin(), "Dire DMGMult: "..math.truncate(self:CreepDamage(false, 0.8, 1.2),2), false, 2.0) end
				filterTable["damage"] = filterTable["damage"] * self:CreepDamage(false, 0.8, 1.2) --math.min(1.2,math.max(0.8,self:GetTeamAdvantage(true, true, false, false)))
			end
		--[[elseif (attacker:GetClassname() == "npc_dota_creep_lane" or attacker:GetClassname() == "npc_dota_creep_siege") and (victim:IsBuilding() or victim:IsTower()) then
			--Creep to Building Damage
			if attacker:GetTeamNumber() == 2 then --Radiant damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(false, true, false, false)))
			elseif attacker:GetTeamNumber() == 3 then --Dire damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(true, true, false, false)))
			end
		elseif attacker:IsTower() and (victim:GetClassname() == "npc_dota_creep_lane" or victim:GetClassname() == "npc_dota_creep_siege") then
			--Tower to Creep Damage
			if attacker:GetTeamNumber() == 2 then --Radiant damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(false, true, false, false)))
			elseif attacker:GetTeamNumber() == 3 then --Dire damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(true, true, false, false)))
			end--]]
		end
	end

	--///////////////////
	--BackDoor Protection
	--///////////////////
	for i=1,#bdplist do
		for k=1,#bdplist[i].buildinglist do
			if victim:GetName() == bdplist[i].buildinglist[k] then
				local buildingname = bdplist[i].buildinglist[k]
				local protent = Entities:FindByName(nil, bdplist[i].protectionholder)
				local protorigin = protent:GetOrigin()
				if GetEnemyCreepsInRadius(victim:GetTeamNumber(), protorigin, bdplist[i].protectionrange, false) then
					self:UpdateBackdoorGroupTimer(bdplist[i].group)
				end
				if self.backdoorstatustable[buildingname] == true then
					if attacker:GetTeamNumber() ~= victim:GetTeamNumber() then
						if filterTable["damage"] > bdplist[i].maxdamage then
							filterTable["damage"] = bdplist[i].maxdamage
						end
					end
					return true
				end
			end
		end
	end
	return true
end

function VGMAR:GetHerosCourier(hero)
	local couriers = Entities:FindAllByClassname("npc_dota_courier")
	for i=1,#couriers do
		if couriers[i]:GetTeamNumber() == hero:GetTeamNumber() then
			return couriers[i]
		end
	end
	return nil
end

function VGMAR:GetCourierBurstLevel( hero, teamnumber )
	if hero ~= nil then
		local courier = self:GetHerosCourier( hero )
		if courier then
			local courierburstability = courier:FindModifierByName("modifier_vgmar_courier_burst")
			if courierburstability then
				return courierburstability:GetStackCount()
			end
		end
	elseif hero == nil and teamnumber ~= nil then
		local couriers = Entities:FindAllByClassname("npc_dota_courier")
		if #couriers > 0 then
			for i=1,#couriers do
				if couriers[i]:GetTeamNumber() == teamnumber then
					local courierburstability = couriers[i]:FindModifierByName("modifier_vgmar_courier_burst")
					if courierburstability then
						return courierburstability:GetStackCount()
					end
				end
			end
		end
	else
		return 0
	end
	return 0
end

function VGMAR:ExecuteOrderFilter( filterTable )
	--[[if filterTable["issuer_player_id_const"] == 0 then
		DeepPrintTable(filterTable)
	end--]]
	local order_type = filterTable.order_type
    local units = filterTable["units"]
    local issuer = filterTable["issuer_player_id_const"]
	local unit = nil
	if units["0"] ~= nil then
		unit = EntIndexToHScript(units["0"])
	end
    local ability = EntIndexToHScript(filterTable.entindex_ability)
    local target = EntIndexToHScript(filterTable.entindex_target)
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		dprint("LoadingTime: Blocking order:"..order_type.." PlayerID: "..issuer)
		return false
	end
	
	--///////////////////////////
	--Extensions Order Event Hook
	--///////////////////////////
	local ext_order_event_return = Extensions:Event_OnOrder(unit, ability, target, filterTable)
	if ext_order_event_return ~= nil then
		return ext_order_event_return
	end
	--//////////
	--Buy Orders
	--//////////
	local itempurchaseblocklist = {
		["item_courier"] = { radiant = {true, "This item cannot be purchased"}, dire = {false, nil} },
		["item_flying_courier_upgrade"] = { radiant = {self.radiantcourieruplevel >= MAX_COURIER_LVL, "Courier is at max level"}, dire = {self.direcourieruplevel >= MAX_COURIER_LVL, "Courier is at max level"} }
	}
	
	--[[
		[0] = "DOTA_UNIT_ORDER_NONE",
		[1] = "DOTA_UNIT_ORDER_MOVE_TO_POSITION",
		[2] = "DOTA_UNIT_ORDER_MOVE_TO_TARGET",
		[3] = "DOTA_UNIT_ORDER_ATTACK_MOVE",
		[4] = "DOTA_UNIT_ORDER_ATTACK_TARGET",
		[5] = "DOTA_UNIT_ORDER_CAST_POSITION",
		[6] = "DOTA_UNIT_ORDER_CAST_TARGET",
		[7] = "DOTA_UNIT_ORDER_CAST_TARGET_TREE",
		[8] = "DOTA_UNIT_ORDER_CAST_NO_TARGET", 
		[9] = "DOTA_UNIT_ORDER_CAST_TOGGLE",
		[10] = "DOTA_UNIT_ORDER_HOLD_POSITION",
		[11] = "DOTA_UNIT_ORDER_TRAIN_ABILITY",
		[12] = "DOTA_UNIT_ORDER_DROP_ITEM",
		[13] = "DOTA_UNIT_ORDER_GIVE_ITEM",
		[14] = "DOTA_UNIT_ORDER_PICKUP_ITEM",
		[15] = "DOTA_UNIT_ORDER_PICKUP_RUNE",
		[16] = "DOTA_UNIT_ORDER_PURCHASE_ITEM",
		[17] = "DOTA_UNIT_ORDER_SELL_ITEM",
		[18] = "DOTA_UNIT_ORDER_DISASSEMBLE_ITEM",
		[19] = "DOTA_UNIT_ORDER_MOVE_ITEM",
		[20] = "DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO",
		[21] = "DOTA_UNIT_ORDER_STOP",
		[22] = "DOTA_UNIT_ORDER_TAUNT",
		[23] = "DOTA_UNIT_ORDER_BUYBACK",
		[24] = "DOTA_UNIT_ORDER_GLYPH",
		[25] = "DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH",
		[26] = "DOTA_UNIT_ORDER_CAST_RUNE",
		[27] = "DOTA_UNIT_ORDER_PING_ABILITY",
		[28] = "DOTA_UNIT_ORDER_MOVE_TO_DIRECTION",
		[29] = "DOTA_UNIT_ORDER_PATROL",
		[30] = "DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION",
		[31] = "DOTA_UNIT_ORDER_RADAR",
		[32] = "DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK",
		[33] = "DOTA_UNIT_ORDER_CONTINUE",
		[34] = "DOTA_UNIT_ORDER_VECTOR_TARGET_CANCELED",
		[35] = "DOTA_UNIT_ORDER_CAST_RIVER_PAINT"
	]]--
	if order_type == 16 then
		--dprint("Purchase Order Detected.")
		--dprint("Item ID: ", filterTable["entindex_ability"])
		local itemname = KeyValuesManager:GetItemByID(filterTable["entindex_ability"])
		--dprint("Item: "..itemname)
		if itempurchaseblocklist[itemname] ~= nil then
			if PlayerResource:GetTeam(issuer) == 2 then
				if itempurchaseblocklist[itemname].radiant[1] == true then
					if itempurchaseblocklist[itemname].radiant[2] ~= nil then
						self:DisplayClientError(issuer, itempurchaseblocklist[itemname].radiant[2])
					end
					return false
				end
			elseif PlayerResource:GetTeam(issuer) == 3 then
				if itempurchaseblocklist[itemname].dire[1] == true then
					if itempurchaseblocklist[itemname].dire[2] ~= nil then
						self:DisplayClientError(issuer, itempurchaseblocklist[itemname].dire[2])
					end
					return false
				end
			end
		end
	end
	
	--Buyback Cooldown Reset
	if order_type == 16 then
		if KeyValuesManager:GetItemByID(filterTable["entindex_ability"]) == "item_buyback_cooldown_reset" then
			local hero = PlayerResource:GetPlayer(issuer):GetAssignedHero()
			dprint("Buyback Cooldown: "..hero:GetBuybackCooldownTime().." Cost: "..hero:GetBuybackCost(true).." Cost(f): "..hero:GetBuybackCost(false))
			dprint("GameTime: "..GameRules:GetGameTime())
			local bbcost = hero:GetBuybackCost(false)
			if hero:GetBuybackCooldownTime() > GameRules:GetGameTime() and hero:GetGold() > bbcost then
				hero:SpendGold(bbcost, 2)
				hero:SetBuybackCooldownTime( 0 )
				GameRules:SendCustomMessageToTeam("<font color='limegreen'>"..HeroNamesLib:ConvertInternalToHeroName(hero:GetName()).."</font><font color='honeydew'>".." has reset their buyback cooldown for </font><font color='gold'>"..bbcost.."</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
			else
				if hero:GetBuybackCooldownTime() < GameRules:GetGameTime() then
					self:DisplayClientError(issuer, "Buyback is not on cooldown")
				elseif hero:GetGold() < bbcost then
					self:DisplayClientError(issuer, "Not enough gold to reset Buyback Cooldown")
				end
			end
			return false
		end
	end
	
	if order_type == DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK then
		if ability and ability:IsItem() then
			ability.isLocked = not ability.isLocked
		end
	end
	
	--Bot Control Prevention
	if units and Convars:GetInt("vgmar_blockbotcontrol") == 1 and order_type ~= 27 then
		local player = PlayerResource:GetPlayer(issuer)
		for k,j in pairs(units) do
			local junit = EntIndexToHScript(j)
			if junit:IsRealHero() then
				local unitPlayerID = junit:GetPlayerID()
				if PlayerResource:GetConnectionState(unitPlayerID) == 1 and unitPlayerID ~= issuer and issuer ~= -1 then
					dprint("Blocking a command to a unit not owned by player UnitPlayerID: ", unitPlayerID, "PlayerID: ", issuer)
					if IsDevMode() then
						DeepPrintTable(filterTable)
					end
					if player then
						dprint("Trying to call panorama to reset players unit selection")
						CustomGameEventManager:Send_ServerToPlayer(player, "selection_reset", {})
						local relayedOrders = {
							[1] = true,
							[2] = true,
							[3] = true,
							[4] = true,
							[10] = true,
							[14] = true,
							[15] = true,
							[21] = true,
							[28] = true,
							[29] = true
						}
						if relayedOrders[order_type] ~= nil and relayedOrders[order_type] == true then
							local relayedOrder = {
								UnitIndex = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"]):GetAssignedHero():entindex(), 
								OrderType = filterTable.order_type,
								TargetIndex = filterTable["entindex_target"], --Optional.  Only used when targeting units
								AbilityIndex = filterTable["entindex_ability"], --Optional.  Only used when casting abilities
								Position = Vector(filterTable["position_x"],filterTable["position_y"],filterTable["position_z"]), --Optional.  Only used when targeting the ground
								Queue = filterTable["queue"] --Optional.  Used for queueing up abilities
							}
							ExecuteOrderFromTable(relayedOrder)
						end
					end
					return false
				end
			end
			if junit:GetClassname() == "npc_dota_courier" or junit:GetClassname() == "npc_dota_flying_courier" then
				if PlayerResource:GetTeam(issuer) == 2 or PlayerResource:GetTeam(issuer) == 3 then
					if junit:GetTeamNumber() ~= PlayerResource:GetTeam(issuer) then
						dprint("Blocking enemy team Courier usage CourierTeamID: ", junit:GetTeamNumber(), "PlayerTeamID: ", PlayerResource:GetTeam(issuer))
						CustomGameEventManager:Send_ServerToPlayer(player, "selection_reset", {})
						return false
					end
				end
			end
		end
	end
	
	--Preventing Console Spam By invalid attack orders
	if units then
		for _,j in pairs(units) do
			local junit = EntIndexToHScript(j)
			if junit:GetAttackCapability() == 0 and (order_type == 3 or order_type == 4) then return false end
			if junit:HasMovementCapability() == false and (order_type == 1 or order_type == 2 or order_type == 3 or order_type == 28 or order_type == 29) then return false end
			if junit:GetName() == "npc_dota_zeus_cloud" then return false end
			if junit:IsCommandRestricted() then
				if junit:HasModifier("modifier_skeleton_king_mortal_strike_summon") then return false end
			end
			if ability then
				if ability:GetName() == "item_butterfly" and (order_type == 5 or order_type == 6 or order_type == 8) then return false end
				if ability:GetName() == "item_ancient_janggo" and ability:GetCurrentCharges() == 0 and order_type == 8 then return false end
			end
		end
	end
	
	--[[--Preventing players from picking up nonlegit bounty runes
	if order_type == 15 and GameRules:GetDOTATime(false, false)%60 <= 0.5 then
		return false
	end--]]
	
	--///////////////////////
	--SecondCourierPrevention
	--///////////////////////
	if unit then
		--[[if unit:IsRealHero() then
			if ability and ability:GetName() == "item_courier" then
				if self:GetHerosCourier(unit) ~= nil then
					InvManager:RemoveNItemsInInventory(unit, "item_courier", 1)
					SendOverheadEventMessage( nil, 0, unit, 100, nil )
					self:DisplayClientError(issuer, "Second Courier is not allowed")
					unit:ModifyGold(100, false, 6)
					return false
				end
			end
		end--]]
		if unit:GetClassname() == "npc_dota_venomancer_plagueward" then
			if ability and ability:GetName() == "vgmar_util_plague_ward_destroy" then
				unit:ForceKill(false)
				return false
			end
		end
	end
	
	if unit then
        if unit:IsRealHero() then
            local unitPlayerID = unit:GetPlayerID()

            -- BOT STUCK FIX
            -- How It Works: Every time bot creates an order, this checks their position, if they are in the same last position as last order,
            -- increase counter. If counter gets too high, it means they have been stuck in same position for a long time, do action to help them.
            if PlayerResource:GetConnectionState(unitPlayerID) == 1 then
                -- Bot Armlet Fix: Bots do not know how to use armlets so return false if they attempt to and put on cooldown
                if ability and ability:GetName() == "item_armlet" then
                    ability:StartCooldown(200)
                    return false
                end

                if not unit.OldPosition then
                    unit.OldPosition = unit:GetAbsOrigin()
                    unit.StuckCounter = 0
                elseif unit:GetAbsOrigin() == unit.OldPosition then
                    unit.StuckCounter = unit.StuckCounter + 1

                    --[[-- Stuck at observer ward fix
                    if unit.StuckCounter > 50 then
                        for i=0,11 do
                            local item = unit:GetItemInSlot(i)
                            if item and item:GetName() == "item_ward_observer" then
                                unit:ModifyGold(item:GetCost() * item:GetCurrentCharges(), true, 0)
                                unit:RemoveItem(item)
                                return true
                            end
                        end
                    end--]]
					
                    --[[-- Stuck at shop trying to get stash items, remove stash items. THIS IS A BAND-AID FIX. IMPROVE AT SOME POINT
                    if unit.StuckCounter > 150 and fixed == false then
                        for slot =  DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
                            item = unit:GetItemInSlot(slot)
                            if item ~= nil then
                                item:RemoveSelf()
                                return true
                            end
                        end
                    end

                    -- Its well and truly borked, kill it and hope for the best.
                    if unit.StuckCounter > 300 and fixed == false then
                        unit:Kill(nil, nil)
                        return true
                    end--]]

                else
                   unit.OldPosition = unit:GetAbsOrigin()
                   unit.StuckCounter = 0
                end
				
				--//////////////////////////
				--Bot Action Miss Simulation
				--//////////////////////////
				if order_type == 5 or order_type == 6 or order_type == 8 or order_type == 9 then
					local minidlechance = 0
					local maxidlechance = 25
					local minmissclickchance = 0
					local maxmissclickchance = 35
					local maxminute = 90
					local currentminute = math.floor(GameRules:GetDOTATime(false, false)/60)
					local idlechance = math.scale( maxidlechance, math.clamp(0, (currentminute/maxminute), 1), minidlechance)
					local missclickchance = math.scale( maxmissclickchance, math.clamp(0, (currentminute/maxminute), 1), minmissclickchance)
					local missclickrange = 150
					--Deny an order
					if missclickproofabilities[EntIndexToHScript(filterTable.entindex_ability):GetName()] == nil or missclickproofabilities[EntIndexToHScript(filterTable.entindex_ability):GetName()] ~= true then
						if math.random(1,100) <= idlechance then
							dprint("Making PlayerID: "..issuer.." not cast an ability: "..ability:GetName().." probability: "..idlechance)
							return false
						else
							if order_type == 6 then
								--Check for Missclick Opportunity
								local targetteam = DOTA_UNIT_TARGET_TEAM_ENEMY
								if ability:GetAbilityTargetTeam() == "DOTA_UNIT_TARGET_TEAM_ENEMY" then
									targetteam = DOTA_UNIT_TARGET_TEAM_ENEMY
								elseif ability:GetAbilityTargetTeam() == "DOTA_UNIT_TARGET_TEAM_FRIENDLY" then
									targetteam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
								elseif ability:GetAbilityTargetTeam() == "DOTA_UNIT_TARGET_TEAM_BOTH" then
									targetteam = DOTA_UNIT_TARGET_TEAM_BOTH
								end
								local missclicktargets = FindUnitsInRadius(unit:GetTeamNumber(), target:GetOrigin(), nil, missclickrange, targetteam, EntIndexToHScript(filterTable.entindex_ability):GetAbilityTargetType(), 0, FIND_CLOSEST, false)
								local filteredmissclicktargets = {}
								if #missclicktargets > 1 then
									for i=1,#missclicktargets do
										if missclicktargets[i] ~= target then
											table.insert(filteredmissclicktargets, missclicktargets[i])
										end
									end
								end
								if #filteredmissclicktargets > 0 then
									if math.random(1,100) <= missclickchance then
										dprint("Making PlayerID: "..issuer.." missclick a unit target ability: "..ability:GetName().." probability: "..missclickchance)
										local newtar = filteredmissclicktargets[math.random(1,#filteredmissclicktargets)]
										if IsDevMode() and VGMAR_DEBUG_DRAW then
											DebugDrawLine(unit:GetOrigin(), target:GetOrigin(), 128, 255, 255, true, 2)
											DebugDrawCircle(target:GetOrigin(), Vector(128, 255, 255), 100, missclickrange, true, 2)
											DebugDrawCircle(target:GetOrigin(), Vector(128, 255, 128), 255, 15, true, 2)
											DebugDrawLine(target:GetOrigin(), newtar:GetOrigin(), 255, 128, 128, true, 2)
										end
										unit:CastAbilityOnTarget(newtar, ability, issuer)
										return false
									end
								end
							elseif order_type == 5 then
								if math.random(1,100) <= missclickchance then
									dprint("Making PlayerID: "..issuer.." missclick a ground point ability: "..ability:GetName().." probability: "..missclickchance)
									local TargetVector = Vector(filterTable["position_x"], filterTable["position_y"], filterTable["position_z"])
									local newx = filterTable["position_x"] + math.random(-1*missclickrange, missclickrange)
									local newy = filterTable["position_y"] + math.random(-1*missclickrange, missclickrange)
									local newz = GetGroundHeight(Vector(newx,newy,0), nil)
									if IsDevMode() and VGMAR_DEBUG_DRAW then
										DebugDrawLine(unit:GetOrigin(), TargetVector, 128, 255, 255, true, 2)
										DebugDrawCircle(TargetVector, Vector(128, 255, 255), 100, missclickrange, true, 2)
										DebugDrawCircle(TargetVector, Vector(128, 255, 128), 255, 15, true, 2)
										DebugDrawLine(TargetVector, Vector(newx,newy,newz), 255, 128, 128, true, 2)
									end
									unit:CastAbilityOnPosition(Vector(newx,newy,newz), ability, issuer)
									return false
								end
							end
						end
					end
				end
				local bslofoutput = BotSupportLib:OrderFilter(filterTable)
				if bslofoutput ~= nil then
					return bslofoutput
				end
            end
		end
	end
	
	--Riki No Enemy Ult Before lvl4 scepters
	--[[if unit and unit:IsRealHero() then
		if ability and ability:GetName() == "riki_tricks_of_the_trade" then
			if ability:GetLevel() < 4 then
				if filterTable.entindex_target ~= 0 and target:GetTeamNumber() ~= unit:GetTeamNumber() then
					self:DisplayClientError(issuer, "Unable to cast on enemies before LVL4")
					return false
				end
			end
		end
	end--]]
	return true
end

function VGMAR:OnGameStateChanged( keys )
	local state = GameRules:State_Get()
	
	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if IsServer() then
			Convars:SetBool("sv_cheats", true)
			dprint("Instant:Enabling Cheats")
			if VGMAR_BOT_FILL == true then
				SendToServerConsole("dota_bot_populate")
			end
			Timers:CreateTimer(3, function()
				Convars:SetBool("sv_cheats", true)
				dprint("Timer:Enabling Cheats")
				SendToServerConsole("dota_bot_set_difficulty 3")
				if VGMAR_BOT_FILL == true then
					GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
				end
			end)
			SendToServerConsole("dota_bot_set_difficulty 3")
			Convars:SetBool("sv_cheats", false)
			if VGMAR_BOT_FILL == true then
				GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
			end
		end
	elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local used_hero_name = "npc_dota_hero_dragon_knight"
		dprint("Checking players...")

		for playerID=0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayer(playerID) then
				dprint("PlayerID:", playerID)

				-- Random heroes for people who have not picked
				if PlayerResource:HasSelectedHero(playerID) == false then
					dprint("Randoming hero for:", playerID)
					PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection()
					dprint("Randomed:", PlayerResource:GetSelectedHeroName(playerID))
				end
				
				used_hero_name = PlayerResource:GetSelectedHeroName(playerID)
			end
		end
		
		Convars:SetBool("sv_cheats", true)
		if VGMAR_BOT_FILL == true then
			SendToServerConsole("dota_bot_populate")
			SendToServerConsole("dota_bot_set_difficulty 3")
		end
		Convars:SetBool("dota_bot_disable", false)
		Convars:SetInt("dota_max_physical_items_purchase_limit", 999)
		Convars:SetInt("dota_max_physical_items_drop_limit", 999)
		
	elseif state == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		if IsServer() then
			Timers:CreateTimer({ 
				useGameTime = false,
				endTime = 2,
				callback = function()
					self.n_players_radiant = PlayerResource:GetPlayerCountForTeam(2)
					self.n_players_dire = PlayerResource:GetPlayerCountForTeam(3)
					
					dprint("Number of players:", self.n_players_radiant + self.n_players_dire)
					dprint("Radiant:", self.n_players_radiant)
					dprint("Dire:", self.n_players_dire)
				end
			})
		end
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		if IsServer() then
			GameRules:SendCustomMessageToTeam("<font color='lightyellow'>Loading. Please wait.</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
			Timers:CreateTimer(0.1, function()
				if self.forcedpause and GameRules:IsGamePaused() == false then
					PauseGame(true)
					self.pausedn = self.pausedn + 1
					if self.pausedn == 2 then
						GameRules:SendCustomMessageToTeam("<font color='lightsalmon'>Please do not interfere with the loading.</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
						GameRules:SendCustomMessageToTeam("<font color='lightyellow'>Game will unpause automatically when loading is finished.</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
					end
				end
				if self.forcedpause then
					return 0.1
				end
			end)
			Timers:CreateTimer(10, function()
				Convars:SetBool("sv_cheats", true)
				Convars:SetBool("dota_bot_disable", false)
				if VGMAR_BOT_FILL == true then
					GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
					GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
				end
			end)
		end
		--////////////////////
		--AntiDireFountainCamp
		--////////////////////
		local direfountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		self.direanc = Entities:FindByName(nil, "dota_badguys_fort")
		self.radiantanc = Entities:FindByName(nil, "dota_goodguys_fort")
		if self.direanc then
			self.direanc:AddNewModifier(self.direanc, nil, "modifier_vgmar_buildings_destroyed_counter", {})
			self.direanc:AddNewModifier(self.direanc, nil, "modifier_vgmar_anticreep_protection", modifierdatatable["modifier_vgmar_anticreep_protection"])
			self.direanc:AddNewModifier(self.direanc, nil, "modifier_vgmar_b_ancient_tether_counter", {})
		end
		if self.radiantanc then
			self.radiantanc:AddNewModifier(self.radiantanc, nil, "modifier_vgmar_buildings_destroyed_counter", {})
		end
		if direfountain then
			direfountain:AddNewModifier(direfountain, nil, "modifier_vgmar_b_fountain_anticamp", modifierdatatable["modifier_vgmar_b_fountain_anticamp"])
		end
		--///////////////////////////////
		--Tower Model Manipulation
		--///////////////////////////////
		local towerlist = {
			{tn = "dota_goodguys_tower1_top", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower1_mid", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower1_bot", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower1_top", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower1_mid", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower1_bot", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower2_top", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower2_mid", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower2_bot", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower2_bot", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower2_mid", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower2_top", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower3_top", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower3_mid", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower3_bot", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower3_bot", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower3_mid", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower3_top", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower4_top", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_goodguys_tower4_bot", proj = "particles/econ/world/towers/rock_golem/radiant_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower4_bot", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"},
			{tn = "dota_badguys_tower4_top", proj = "particles/econ/world/towers/rock_golem/dire_rock_golem_attack.vpcf"}
		}
		for _,k in ipairs(towerlist) do
			local building = Entities:FindByName(nil, k.tn)
			if building then
				if k.matgroup then
					building:SetMaterialGroup(k.matgroup)
				end
				if k.model then
					building:SetModel(k.model)
				end
				if k.proj then
					building:SetRangedProjectileName(k.proj)
				end
			end
		end
		--///////////////////////////////
		--New Implementation of defskills
		--///////////////////////////////
		local buildingstobufflist = {
			{bn = "dota_goodguys_fort", priority = 4, istower = 0, regnegation = 7.0},
			{bn = "good_rax_melee_bot", priority = 3, istower = 0, regnegation = 7.0},
			{bn = "good_rax_melee_mid", priority = 3, istower = 0, regnegation = 7.0},
			{bn = "good_rax_melee_top", priority = 3, istower = 0, regnegation = 7.0},
			{bn = "good_rax_range_top", priority = 2, istower = 0, regnegation = 7.0},
			{bn = "good_rax_range_mid", priority = 2, istower = 0, regnegation = 7.0},
			{bn = "good_rax_range_bot", priority = 2, istower = 0, regnegation = 7.0},
			{bn = "dota_goodguys_tower4_bot", priority = 1, istower = 1, regnegation = 7.0},
			{bn = "dota_goodguys_tower4_top", priority = 1, istower = 1, regnegation = 7.0},
			{bn = "dota_goodguys_tower3_top", priority = 0, istower = 1, regnegation = 7.0},
			{bn = "dota_goodguys_tower3_mid", priority = 0, istower = 1, regnegation = 7.0},
			{bn = "dota_goodguys_tower3_bot", priority = 0, istower = 1, regnegation = 7.0}
		}
		
		local defskills = {
			{skill = "dragon_knight_dragon_blood", agressive = 0, p0 = 0, p1 = 0, p2 = 0, p3 = 0, p4 = 1, autocast = 0},
			{skill = "tower_corrosive_skin", agressive = 0, p0 = 1, p1 = 3, p2 = 3, p3 = 3, p4 = 4, autocast = 0},
			{skill = "tower_dispersion", agressive = 0, p0 = 1, p1 = 4, p2 = 1, p3 = 2, p4 = 3, autocast = 0},
			{skill = "tower_atrophy_aura", agressive = 1, p0 = 1, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_berserkers_blood", agressive = 1, p0 = 1, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_take_aim", agressive = 1, p0 = 0, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_walrus_punch", agressive = 1, p0 = 2, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 1},
			{skill = "tower_great_cleave", agressive = 1, p0 = 0, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_tidebringer", agressive = 1, p0 = 2, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0}
		}
		
		local defitems = {
			{item = "item_vanguard", agressive = 0, p0 = 1, p1 = 1, p2 = 1, p3 = 1, p4 = 1},
			{item = "item_shivas_guard", agressive = 0, p0 = 0, p1 = 0, p2 = 0, p3 = 1, p4 = 1},
			{item = "item_assault", agressive = 0, p0 = 0, p1 = 0, p2 = 0, p3 = 1, p4 = 1},
			--{item = "item_radiance", agressive = 1, p0 = 0, p1 = 1, p2 = 0, p3 = 0, p4 = 0},
			{item = "item_vladmir", agressive = 0, p0 = 0, p1 = 0, p2 = 1, p3 = 0, p4 = 0},
			{item = "item_maelstrom", agressive = 1, p0 = 0, p1 = 1, p2 = 0, p3 = 0, p4 = 0},
			{item = "item_dragon_lance", agressive = 1, p0 = 0, p1 = 1, p2 = 0, p3 = 0, p4 = 0},
			{item = "item_solar_crest", agressive = 0, p0 = 1, p1 = 1, p2 = 1, p3 = 1, p4 = 1}
		}
		
		for k=1,#buildingstobufflist do
			local building = Entities:FindByName(nil, buildingstobufflist[k].bn)
			if building then
				--Negating unnecessary regen
				building:SetBaseHealthRegen(building:GetBaseHealthRegen() + (buildingstobufflist[k].regnegation * -1))
				for i=1,#defskills do
					--Applying Spells(only towers get agressive spells)
					if buildingstobufflist[k].istower == 1 and defskills[i].agressive == 1 then
						building:AddAbility(defskills[i].skill)
					elseif defskills[i].agressive == 0 then
						building:AddAbility(defskills[i].skill)
					end
					--Leveling Spells
					local processedskill = building:FindAbilityByName(defskills[i].skill)
					if processedskill then
						if buildingstobufflist[k].priority == 0 then
							processedskill:SetLevel(defskills[i].p0)
						elseif buildingstobufflist[k].priority == 1 then
							processedskill:SetLevel(defskills[i].p1)
						elseif buildingstobufflist[k].priority == 2 then
							processedskill:SetLevel(defskills[i].p2)
						elseif buildingstobufflist[k].priority == 3 then
							processedskill:SetLevel(defskills[i].p3)
						elseif buildingstobufflist[k].priority == 4 then
							processedskill:SetLevel(defskills[i].p4)
						else
							LogLib:Log_Error("UNEXPECTED_PRIORITY_FOUND", 0, "Error in defspells assigning mechanism")
						end
						if processedskill:GetLevel() == 0 then
							building:RemoveAbility(defskills[i].skill)
						end
						if defskills[i].autocast == 1 then
							processedskill:ToggleAutoCast()
						end
					end
				end
				for j=1,#defitems do
					if buildingstobufflist[k].priority == 0 and defitems[j].p0 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 1 and defitems[j].p1 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 2 and defitems[j].p2 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 3 and defitems[j].p3 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 4 and defitems[j].p4 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					end
				end
			end
		end
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if BotRolesLib.DBReady and VGMAR_BOT_FILL then
			print('Midlaner: '..BotRolesLib:GetMidLaner():GetName())
			print('Pure Support: '..BotRolesLib:GetPureSupport():GetName())
		end
		--///////////////
		--Reset Timescale
		--///////////////
		if IsServer() and self.istimescalereset == false then
			Convars:SetFloat("host_timescale", 1.0)
			self.istimescalereset = true
		end
	elseif state == DOTA_GAMERULES_STATE_POST_GAME then
		if IsServer() and VGMAR_LOG_BALANCE_GAMEEND and VGMAR_BOT_FILL then
			LogLib:WriteLog("balance", 0, false, "------------------------")
			LogLib:WriteLog("balance", 0, false, "------------------------")
			LogLib:WriteLog("balance", 0, false, "      Game End Log      ")
			LogLib:WriteLog("balance", 0, false, "------------------------")
			LogLib:WriteLog("balance", 0, false, "------------------------")
			self:LogBalance()
		end
	end
end
