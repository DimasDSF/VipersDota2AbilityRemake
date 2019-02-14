--Extensions for various standart libs

--Class Init
if not Extensions then
	Extensions = class({})
end

function Extensions:Init()
	print("[Extensions] : Initiating")
	Convars:RegisterConvar('vgmar_ext_debugdraw', "0", "Set to 1 to draw Extensions debug info. Set to 0 to disable.", 0)
	self.enttexttable = {
		lasttime = 0,
		texts = {}
	}
	self.herodamagetrackingtable = {}
	self.heroestable = {
		radiant = {},
		dire = {},
		filled = false
	}
	print("[Extensions] : Starting 1s Thinker Timer")
	Timers:CreateTimer(function()
		Extensions:ShowEntText()
		Extensions:HeroDamageTrackingLoop()
		return 1.0
	end)
end

--Called from AllHeroesSpawned
function Extensions:InitHeroTables(radiant, dire)
	self.heroestable.radiant = radiant
	self.heroestable.dire = dire
	self.heroestable.filled = true
end

function Extensions:DebugDraw()
	if Convars:GetInt("vgmar_ext_debugdraw") == 1 then
		return true
	end
	return false
end

--Extensions
function Extensions:FindUnitsInCone(teamNumber, vDirection, vPosition, startRadius, endRadius, flLength, hCacheUnit, teamFilter, typeFilter, flagFilter, findOrder, bCache)
	local vDirectionCone = Vector( vDirection.y, -vDirection.x, 0.0 )
	local units = FindUnitsInRadius(teamNumber, vPosition, hCacheUnit, endRadius + flLength, teamFilter, typeFilter, flagFilter, findOrder, bCache )
	local unitTable = {}
	if #units > 0 then
		for _,unit in pairs(units) do
			if unit ~= nil then
				local vToPotentialTarget = unit:GetOrigin() - vPosition
				local flSideAmount = math.abs( vToPotentialTarget.x * vDirectionCone.x + vToPotentialTarget.y * vDirectionCone.y + vToPotentialTarget.z * vDirectionCone.z )
				local unit_distance_from_caster = ( vToPotentialTarget.x * vDirection.x + vToPotentialTarget.y * vDirection.y + vToPotentialTarget.z * vDirection.z )

				local max_increased_radius_from_distance = endRadius - startRadius
				local pct_distance = unit_distance_from_caster / flLength
				local radius_increase_from_distance = max_increased_radius_from_distance * pct_distance
				if ( flSideAmount < startRadius + radius_increase_from_distance ) and ( unit_distance_from_caster > 0.0 ) and ( unit_distance_from_caster < flLength ) then
					table.insert(unitTable, unit)
				end
			end
		end
		if self:DebugDraw() then
			DebugDrawLine(vPosition+(vDirectionCone*startRadius), vPosition+(vDirection*flLength)+(vDirectionCone*(endRadius)), 0, 0, 255, true, 2)
			DebugDrawLine(vPosition+(vDirectionCone*-startRadius), vPosition+(vDirection*flLength)+(vDirectionCone*(-1*(endRadius))), 0, 0, 255, true, 2)
			DebugDrawLine(vPosition+(vDirection*flLength)+(vDirectionCone*-endRadius), vPosition+(vDirection*flLength)+(vDirectionCone*endRadius), 0, 0, 255, true, 2)
			DebugDrawLine(vPosition+(vDirectionCone*-startRadius), vPosition+(vDirectionCone*startRadius), 0, 0, 255, true, 2)
		end
	end
	return unitTable
end

function Extensions:DoCleaveAttackPositional(attacker, target, position, direction, checkDistantCleave, damageInfo, startRadius, endRadius, length, teamFilter, typeFilter, flagFilter, particle)
	local isDistantCleave = false
	if checkDistantCleave then
		if attacker ~= nil and target ~= nil then
			if (attacker:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > attacker:Script_GetAttackRange() + attacker:GetAttackRangeBuffer() then
				isDistantCleave = true
			end
		end
	end
	local victims = {}
	if isDistantCleave then
		victims = Extensions:FindUnitsInCone(attacker:GetTeamNumber(), direction, position, startRadius, endRadius, length, nil, teamFilter, typeFilter, flagFilter, FIND_CLOSEST, false)
		if self:DebugDraw() then
			DebugDrawLine(position, position+(direction*length), 0, 255, 0, true, 2)
		end
	else
		victims = Extensions:FindUnitsInCone(attacker:GetTeamNumber(), direction, attacker:GetAbsOrigin(), startRadius, endRadius, length, nil, teamFilter, typeFilter, flagFilter, FIND_CLOSEST, false)
		if self:DebugDraw() then
			DebugDrawLine(attacker:GetAbsOrigin(), attacker:GetAbsOrigin()+(direction*length), 255, 0, 0, true, 2)
		end
	end
	local targetarr = {target}
	victims = table.sub(victims, targetarr)
	if self:DebugDraw() then print("Found "..#victims.." Units for cleave") end
	if #victims > 0 then
		if self:DebugDraw() then
			DebugDrawText(attacker:GetAbsOrigin()+Vector(0,0,100), "Cleave Targets: "..#victims, false, 2)
		end
		for _,unit in pairs(victims) do
			if target ~= nil and unit ~= target then
				local damageTable = {
					victim = unit,
					attacker = attacker,
					damage = damageInfo.damage,
					damage_type = damageInfo.type
				}
				ApplyDamage(damageTable)
				if self:DebugDraw() then
					DebugDrawBox(unit:GetAbsOrigin(), Vector(-5, -5, 0), Vector(5, 5, 0), 0, 255, 0, 180, 2)
					DebugDrawText(unit:GetAbsOrigin()+Vector(0,0,50), "CleaveDMG: "..damageInfo.damage, false, 2)
				end
			end
		end
		--Draw Particle
		local pfx
		if isDistantCleave then
			pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControl( pfx, 0, target:GetOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, target:GetOrigin() )
		else
			pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControl( pfx, 0, attacker:GetOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, attacker:GetOrigin() )
		end
		ParticleManager:SetParticleControlForward( pfx, 0, direction )
		ParticleManager:ReleaseParticleIndex( pfx )
	end
end

function Extensions:GetOpposingTeamNumber(teamNumber)
	if teamNumber and type(teamNumber) == "number" then
		if teamNumber == 3 then
			return 2
		elseif teamNumber == 2 then
			return 3
		end
	end
	return nil
end

function Extensions:CalculateArmorDamageReductionMultiplier(armor)
	if type(armor) == "number" then
		return 1-((0.052*armor)/(0.9+0.048*armor))
	end
	return nil
end

function Extensions:IsEntityVisibleToTeam(entity, team)
	if entity == nil then 
		return false
	end
	if type(team) == "string" then
		if team == "radiant" then
			team = 2
		elseif team == "dire" then
			team = 3
		end
	end
	if type(team) ~= "number" or (team ~= 2 and team ~= 3) then
		LogLib:Log_Error("Error: Invalid team: "..tostring(team), 0, "Extensions:VisibleToTeam()::")
		return nil
	else
		local unitcheck = FindUnitsInRadius(team, entity:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local unitmatch = false
		for i,v in ipairs(unitcheck) do
			if v==entity then
				unitmatch = true
			end
		end
		return unitmatch
	end
end

--An inaccurate Auto-attack damage prediction
function Extensions:PredictAttackDamage(attacker, target)
	if attacker and target then
		if attacker:IsNull() == false and target:IsNull() == false then
			if target:IsAlive() then
				return attacker:GetAverageTrueAttackDamage(attacker)*Extensions:CalculateArmorDamageReductionMultiplier(target:GetPhysicalArmorValue())
			end
		end
	end
	return 0
end

function Extensions:CallWithDelay(delay, gametime, func)
	Timers:CreateTimer({
		useGameTime = gametime,
		endTime = delay, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = func
	})
end

--EntText with offsets
function Extensions:AddEntText(entindex, text)
	if entindex ~= nil and text ~= nil then
		if self.enttexttable.texts[entindex] == nil then
			table.insert(self.enttexttable.texts, entindex)
			self.enttexttable.texts[entindex] = {}
		end
		if self.enttexttable.texts[entindex] ~= nil then
			table.insert(self.enttexttable.texts[entindex], text)
		else
			LogLib:Log_Warning("entindex: "..entindex, 0, "Extensions:EntText failed to AddText")
		end
	end
end

function Extensions:ShowEntText()
	local gametimeseconds = math.floor(GameRules:GetDOTATime(false, false))
	if self.enttexttable.texts ~= {} then
		if self.enttexttable.lasttime < gametimeseconds then
			for k,v in pairs(self.enttexttable.texts) do
				if type(v) == "table" then
					local unit = EntIndexToHScript(tonumber(k))
					if unit then
						local text = ""
						for i,j in ipairs(v) do
							text = text..j.."\n"
						end
						DebugDrawText(unit:GetAbsOrigin(), text, false, 5.0)
					else
						print("unit "..k.." is missing")
					end
				end
			end
			self.enttexttable.texts = {}
			self.enttexttable.lasttime = gametimeseconds
		end
	end
end

local DAMAGE_TRACKING_MAX_SECONDS = 10
--Tracking Hero Damage
function Extensions:TrackDamage(entindex, damage, damagetype, isHero)
	if self.herodamagetrackingtable[entindex] == nil then
		table.insert(self.herodamagetrackingtable, entindex)
		self.herodamagetrackingtable[entindex] = {}
		for i=1,DAMAGE_TRACKING_MAX_SECONDS do
			self.herodamagetrackingtable[entindex][i] = {herodmg = {phys = 0, magic = 0, pure = 0}, nonherodmg = {phys = 0, magic = 0, pure = 0}}
		end
	end
	if self.herodamagetrackingtable[entindex] ~= nil then
		--No need for super precise tracking -> drop decimals here
		damage = math.floor(damage)
		local damagetable = self.herodamagetrackingtable[entindex]
		if isHero then
			if damagetype == DAMAGE_TYPE_PURE then	
				damagetable[1].herodmg.pure = damagetable[1].herodmg.pure + math.max(0, damage)
			elseif damagetype == DAMAGE_TYPE_MAGICAL then
				damagetable[1].herodmg.magic = damagetable[1].herodmg.magic + math.max(0, damage)
			else
				damagetable[1].herodmg.phys = damagetable[1].herodmg.phys + math.max(0, damage)
			end
		else
			if damagetype == DAMAGE_TYPE_PURE then	
				damagetable[1].nonherodmg.pure = damagetable[1].nonherodmg.pure + math.max(0, damage)
			elseif damagetype == DAMAGE_TYPE_MAGICAL then
				damagetable[1].nonherodmg.magic = damagetable[1].nonherodmg.magic + math.max(0, damage)
			else
				damagetable[1].nonherodmg.phys = damagetable[1].nonherodmg.phys + math.max(0, damage)
			end
		end
	else
		LogLib:Log_Error("Error: Failed to initialize a tracking table for entindex: "..tonumber(entindex), 0, "Extensions:TrackDamage():: Error")
	end
end

function Extensions:QueryHeroDamage(entindex, sec, types, addHero, addNonHero)
	local damagetable = self.herodamagetrackingtable[entindex]
	--This unit either was not initiated on start and not attacked to start tracking or is not enabled for tracking -> return 0
	if damagetable == nil then return 0 end
	--Clamping time value
	sec = math.clamp(1, sec, DAMAGE_TRACKING_MAX_SECONDS)
	local ret = 0
	for i=1,sec,1 do
		if addHero then
			if bit.bor(DAMAGE_TYPE_PHYSICAL, types) == types then
				ret = ret + damagetable[i].herodmg.phys
			end
			if bit.bor(DAMAGE_TYPE_MAGICAL, types) == types then
				ret = ret + damagetable[i].herodmg.magic
			end
			if bit.bor(DAMAGE_TYPE_PURE, types) == types then
				ret = ret + damagetable[i].herodmg.pure
			end
		end
		if addNonHero then
			if bit.bor(DAMAGE_TYPE_PHYSICAL, types) == types then
				ret = ret + damagetable[i].nonherodmg.phys
			end
			if bit.bor(DAMAGE_TYPE_MAGICAL, types) == types then
				ret = ret + damagetable[i].nonherodmg.magic
			end
			if bit.bor(DAMAGE_TYPE_PURE, types) == types then
				ret = ret + damagetable[i].nonherodmg.pure
			end
		end
	end
	return ret
end

function Extensions:InitHeroDamageTrackingTable(heroes)
	for _,i in ipairs(heroes) do
		--Init tables
		self:TrackDamage(i:entindex(), 0, DAMAGE_TYPE_PHYSICAL, false)
	end
end

function Extensions:HeroDamageTrackingLoop()
	if GameRules:IsGamePaused() == false then
		for i,v in pairs(self.herodamagetrackingtable) do
			if type(v) == "table" then
				for k=DAMAGE_TRACKING_MAX_SECONDS, 2, -1 do
					v[k].herodmg = v[k-1].herodmg
					v[k].nonherodmg = v[k-1].nonherodmg
				end
				v[1] = {herodmg = {phys = 0, magic = 0, pure = 0}, nonherodmg = {phys = 0, magic = 0, pure = 0}}
			end
		end
	end
end

--math
function math.scale( min, value, max )
	if ((min == nil or max == nil or value == nil) or (type(min) ~= 'number' or type(max) ~= 'number' or type(value) ~= 'number')) then return nil end
	return value * (max - min) + min
end

function math.map(value, explow, exphigh, outlow, outhigh)
	if ((outlow == nil or outhigh == nil or explow == nil or exphigh == nil or value == nil) or (type(outlow) ~= 'number' or type(outhigh) ~= 'number' or type(explow) ~= 'number' or type(exphigh) ~= 'number' or type(value) ~= 'number')) then return nil end
	return outlow + (value - explow) * (outhigh - outlow) / (exphigh - explow)
end

function math.clamp(min, value, max)
	if ((min == nil or max == nil or value == nil) or (type(min) ~= 'number' or type(max) ~= 'number' or type(value) ~= 'number')) then return nil end
	if (min > max) then return nil end
	if (value < min) then return min end
	if (value > max) then return max end
	return value
end

function math.mapl(value, explow, exphigh, outlow, outhigh)
	if ((outlow == nil or outhigh == nil or explow == nil or exphigh == nil or value == nil) or (type(outlow) ~= 'number' or type(outhigh) ~= 'number' or type(explow) ~= 'number' or type(exphigh) ~= 'number' or type(value) ~= 'number')) then return nil end
	if outlow > outhigh then
		return math.clamp(outhigh, math.map(value, explow, exphigh, outlow, outhigh), outlow)
	else
		return math.clamp(outlow, math.map(value, explow, exphigh, outlow, outhigh), outhigh)
	end
end

function math.isNaN(input)
	return input ~= input
end

function math.round(input)
	if ((input == nil) or (type(input) ~= 'number')) then return nil end
    if input >= 0 then
		return math.floor(input + 0.5)
	else
		return math.ceil(input - 0.5)
	end
end

function math.truncate(input, num)
	if ((input == nil or num == nil) or ((type(input) ~= 'number') or type(num) ~= 'number')) then return nil end
	return math.round(input * (10 ^ num)) / (10 ^ num);
end

function math.bool(input)
	if input then
		return 1
	end
	return 0
end

--string
function string.split(input, delimiter)
	local output = {}
	if ((input == nil or delimiter == nil) or (type(input) ~= 'string' or type(delimiter) ~= 'string')) then return output end
    for match in input:gmatch("([^"..delimiter.."]+)") do
        table.insert(output, match)
    end
    return output
end

--table
function table.shallowcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else
		copy = orig
	end
	return copy
end

function table.sub(t2, t1)
    local t = {}
    local ret = table.shallowcopy(t2)
    for i = 1, #t1 do
        t[t1[i]] = true;
    end
    for i = #ret, 1, -1 do
        if t[ret[i]] then
            table.remove(ret, i);
        end
    end
    return ret
end

--CBaseEntity
--Returns true for Creeps, Heroes, Couriers
--Useful for Crits, Cleave attacks etc.
--due to OnAttackStart working with items, runes and probably other non CDOTA_BaseNPC entities disallowing use of IsCreep, IsBuilding and throwing errors.
function CBaseEntity:IsRealUnit(buildings)
	if UnitFilter( self, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_COURIER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0 ) == 0 then
		if buildings and self:IsBuilding() or not self:IsBuilding() then
			return true
		end
	end
	return false
end

--debug
function debug.PrintTable(debugOver, prefix)
	prefix = prefix or ""
	
	if type(debugOver) == "table" then
		print("Printing Table: "..tostring(debugOver))
		print("vvvvvvvvvvvvvv")
		local indexedtable = false
		for name, _ in pairs(debugOver) do
			if type(name) ~= "number" then
				indexedtable = true
				break
			end
		end
		for idx, data_value in pairs(debugOver) do
			if (indexedtable and type(idx) ~= "number") or indexedtable == false then
				if type(data_value) == "string" then 
					print( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
				else 
					print( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
				end
			end
		end
		print("--------------")
	else
		print(tostring(debugOver).." is not a Table")
	end
end

function debug.ReadVar(f)
	local v = _G    -- start with the table of globals
	for w in string.gfind(f, "[%w_]+") do
		v = v[w]
	end
	return v
end

GameRules.Extensions = Extensions