--[[
|------------------------------------------------------------|
|      Include contating dummies used to replace globals     |
|      specifically created by DotaAPI to allow testing      |
|                    software to run tests                   |
|------------------------------------------------------------|
	Do not include this anywhere except for testing scripts!
--]]
--TODO: Implement a Regex powered script to copy functions from script_help2 to DotaAPIDummies
function class()
	return {}
end
GameRules = {}
CBaseEntity = {}
LogLib = {}
--DotaAPI Global Variables
-- Enum DAMAGE_TYPES
DAMAGE_TYPE_ALL = 7
DAMAGE_TYPE_HP_REMOVAL = 8
DAMAGE_TYPE_MAGICAL = 2
DAMAGE_TYPE_NONE = 0
DAMAGE_TYPE_PHYSICAL = 1
DAMAGE_TYPE_PURE = 4
-- Enum DOTADamageFlag_t
DOTA_DAMAGE_FLAG_BYPASSES_BLOCK = 8
DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY = 4
DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN = 2048
DOTA_DAMAGE_FLAG_HPLOSS = 32
DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR = 1
DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR = 2
DOTA_DAMAGE_FLAG_NONE = 0
DOTA_DAMAGE_FLAG_NON_LETHAL = 128
DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS = 512
DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT = 64
DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION = 1024
DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL = 4096
DOTA_DAMAGE_FLAG_PROPERTY_FIRE = 8192
DOTA_DAMAGE_FLAG_REFLECTION = 16
DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY = 256
-- Enum DOTAScriptInventorySlot_t
DOTA_ITEM_SLOT_1 = 0
DOTA_ITEM_SLOT_2 = 1
DOTA_ITEM_SLOT_3 = 2
DOTA_ITEM_SLOT_4 = 3
DOTA_ITEM_SLOT_5 = 4
DOTA_ITEM_SLOT_6 = 5
DOTA_ITEM_SLOT_7 = 6
DOTA_ITEM_SLOT_8 = 7
DOTA_ITEM_SLOT_9 = 8
DOTA_STASH_SLOT_1 = 9
DOTA_STASH_SLOT_2 = 10
DOTA_STASH_SLOT_3 = 11
DOTA_STASH_SLOT_4 = 12
DOTA_STASH_SLOT_5 = 13
DOTA_STASH_SLOT_6 = 14
-- Enum DOTATeam_t
DOTA_TEAM_BADGUYS = 3
DOTA_TEAM_COUNT = 14
DOTA_TEAM_CUSTOM_1 = 6
DOTA_TEAM_CUSTOM_2 = 7
DOTA_TEAM_CUSTOM_3 = 8
DOTA_TEAM_CUSTOM_4 = 9
DOTA_TEAM_CUSTOM_5 = 10
DOTA_TEAM_CUSTOM_6 = 11
DOTA_TEAM_CUSTOM_7 = 12
DOTA_TEAM_CUSTOM_8 = 13
DOTA_TEAM_CUSTOM_COUNT = 8
DOTA_TEAM_CUSTOM_MAX = 13
DOTA_TEAM_CUSTOM_MIN = 6
DOTA_TEAM_FIRST = 2
DOTA_TEAM_GOODGUYS = 2
DOTA_TEAM_NEUTRALS = 4
DOTA_TEAM_NOTEAM = 5
-- Enum DOTA_ABILITY_BEHAVIOR
DOTA_ABILITY_BEHAVIOR_AOE = 32
DOTA_ABILITY_BEHAVIOR_ATTACK = 131072
DOTA_ABILITY_BEHAVIOR_AURA = 65536
DOTA_ABILITY_BEHAVIOR_AUTOCAST = 4096
DOTA_ABILITY_BEHAVIOR_CAN_SELF_CAST = 0
DOTA_ABILITY_BEHAVIOR_CHANNELLED = 128
DOTA_ABILITY_BEHAVIOR_DIRECTIONAL = 1024
DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET = 16777216
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL = 536870912
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT = 8388608
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK = 33554432
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT = 262144
DOTA_ABILITY_BEHAVIOR_HIDDEN = 1
DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING = 134217728
DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL = 4194304
DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE = 2097152
DOTA_ABILITY_BEHAVIOR_IMMEDIATE = 2048
DOTA_ABILITY_BEHAVIOR_ITEM = 256
DOTA_ABILITY_BEHAVIOR_LAST_RESORT_POINT = -2147483648
DOTA_ABILITY_BEHAVIOR_NONE = 0
DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN = 67108864
DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE = 64
DOTA_ABILITY_BEHAVIOR_NO_TARGET = 4
DOTA_ABILITY_BEHAVIOR_OPTIONAL_NO_TARGET = 32768
DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT = 16384
DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET = 8192
DOTA_ABILITY_BEHAVIOR_PASSIVE = 2
DOTA_ABILITY_BEHAVIOR_POINT = 16
DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES = 524288
DOTA_ABILITY_BEHAVIOR_RUNE_TARGET = 268435456
DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES = 0
DOTA_ABILITY_BEHAVIOR_TOGGLE = 512
DOTA_ABILITY_BEHAVIOR_UNIT_TARGET = 8
DOTA_ABILITY_BEHAVIOR_UNRESTRICTED = 1048576
DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING = 1073741824
-- Enum DOTA_UNIT_TARGET_FLAGS
DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP = 65536
DOTA_UNIT_TARGET_FLAG_DEAD = 8
DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE = 128
DOTA_UNIT_TARGET_FLAG_INVULNERABLE = 64
DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES = 16
DOTA_UNIT_TARGET_FLAG_MANA_ONLY = 32768
DOTA_UNIT_TARGET_FLAG_MELEE_ONLY = 4
DOTA_UNIT_TARGET_FLAG_NONE = 0
DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS = 512
DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE = 16384
DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO = 131072
DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED = 2048
DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS = 8192
DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES = 32
DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED = 524288
DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED = 4096
DOTA_UNIT_TARGET_FLAG_NO_INVIS = 256
DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD = 262144
DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED = 1024
DOTA_UNIT_TARGET_FLAG_PREFER_ENEMIES = 1048576
DOTA_UNIT_TARGET_FLAG_RANGED_ONLY = 2
DOTA_UNIT_TARGET_FLAG_RESPECT_OBSTRUCTIONS = 2097152
-- Enum DOTA_UNIT_TARGET_TEAM
DOTA_UNIT_TARGET_TEAM_BOTH = 3
DOTA_UNIT_TARGET_TEAM_CUSTOM = 4
DOTA_UNIT_TARGET_TEAM_ENEMY = 2
DOTA_UNIT_TARGET_TEAM_FRIENDLY = 1
DOTA_UNIT_TARGET_TEAM_NONE = 0
-- Enum DOTA_UNIT_TARGET_TYPE
DOTA_UNIT_TARGET_ALL = 55
DOTA_UNIT_TARGET_BASIC = 18
DOTA_UNIT_TARGET_BUILDING = 4
DOTA_UNIT_TARGET_COURIER = 16
DOTA_UNIT_TARGET_CREEP = 2
DOTA_UNIT_TARGET_CUSTOM = 128
DOTA_UNIT_TARGET_HERO = 1
DOTA_UNIT_TARGET_NONE = 0
DOTA_UNIT_TARGET_OTHER = 32
DOTA_UNIT_TARGET_TREE = 64
function Vector(xc, yc, zc) return {x = xc, y = yc, z = zc} end
--Fake Functions for testing outputs without including other modules or closed source APIs
function LogLib:Log_Error() end
function LogLib:Log_Warning() end
--Fake GetAbsOrigin() for extensions
function string:GetAbsOrigin() return nil end
function FindUnitsInRadius()
	return {"unit1", "unit2", "unit3"}
end
