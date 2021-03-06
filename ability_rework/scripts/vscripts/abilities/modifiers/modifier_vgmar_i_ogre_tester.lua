--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_ogre_tester = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_ogre_tester:GetTexture()
	return "custom/AIThinking"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_ogre_tester:IsHidden()
    return false
end

function modifier_vgmar_i_ogre_tester:IsPurgable()
	return false
end

function modifier_vgmar_i_ogre_tester:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_ogre_tester:DestroyOnExpire()
	return false
end

--[[
		Event KV Values
	OnRefresh
		duration	int(-1 if infinite)
		stack_count	int
	OnCreated
		creationtime
		
	EVENTS KV	
		new_pos	Vector 000000000043F9F0 [0.000000 0.000000 5.500000]
		process_procs	false
		order_type	0
		issuer_player_index	32
		fail_type	0
		damage_category	0
		reincarnate	false
		damage	0
		ignore_invis	false
		cost	0
		ranged_attack	false
		record	3745
		unit	table: 0x001af358
		do_not_consume	false
		damage_type	0
		activity	-1
		heart_regen_applied	false
		diffusal_applied	false
		no_attack_cooldown	false
		damage_flags	0
		original_damage	0
		mkb_tested	false
		gain	1
		basher_tested	false
		distance	0
]]--

function modifier_vgmar_i_ogre_tester:statprint(...)
	Msg("[TestModifier] ".. ... .."\n")
end

function modifier_vgmar_i_ogre_tester:OnCreated(kv) 
	if IsServer() then
		self:StartIntervalThink( 1 )
		local destroy_mods = {
			"modifier_vgmar_i_multidimension_cast"
		}
		for _, mod in ipairs(destroy_mods) do
			local modif = self:GetParent():FindModifierByName(mod)
			if modif then
				modif:Destroy()
			end
		end
		--self.mci = 0.5
		--self.p1 = nil
		--self.p2 = nil
		--self.p3 = nil
	end
end

function modifier_vgmar_i_ogre_tester:OnRefresh( kv )
	--if IsServer() then
	--end
end

--[[function modifier_vgmar_i_ogre_tester:OnSpentMana( event )
	if IsServer() then
		debug.PrintTable(event)
	end
end--]]

function modifier_vgmar_i_ogre_tester:OnIntervalThink()
	if IsServer() then
		--[[local modifiers = self:GetParent():FindAllModifiers()
		for i=1,#modifiers do
			print(modifiers[i]:GetName())
		end--]]
		local parent = self:GetParent()
		if self.oldmana == nil then
			self.oldmana = self:GetParent():GetMana()
		end
		if self.oldmana ~= self:GetParent():GetMana() then
			if self:GetParent():GetMana() - self.oldmana > math.ceil(self:GetParent():GetManaRegen()*1.5) or self:GetParent():GetMana() - self.oldmana < 0 then
				if self.oldmana > self:GetParent():GetMana() then
					self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Lost "..math.floor(self.oldmana - self:GetParent():GetMana()).." Mana")
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, self:GetParent(), self.oldmana - self:GetParent():GetMana(), nil)
				elseif self.oldmana < self:GetParent():GetMana() then
					self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Gained "..math.floor(self:GetParent():GetMana() - self.oldmana).." Mana")
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self:GetParent(), self:GetParent():GetMana() - self.oldmana, nil)
				end
			end
			self.oldmana = self:GetParent():GetMana()
		end
		if self.oldhealth == nil then
			self.oldhealth = self:GetParent():GetHealth()
		end
		if self.oldhealth ~= self:GetParent():GetHealth() then
			if self:GetParent():GetHealth() - self.oldhealth > math.ceil(self:GetParent():GetHealthRegen()*1.5) or self:GetParent():GetHealth() - self.oldhealth < 0 then
				if self.oldhealth > self:GetParent():GetHealth() then
					self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Lost "..math.floor(self.oldhealth - self:GetParent():GetHealth()).." Health")
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, self:GetParent(), self.oldhealth - self:GetParent():GetHealth(), nil)
				elseif self.oldhealth < self:GetParent():GetHealth() then
					self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Gained "..math.floor(self:GetParent():GetHealth() - self.oldhealth).." Health")
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetParent():GetHealth() - self.oldhealth, nil)
				end
			end
			self.oldhealth = self:GetParent():GetHealth()
		end
		if self.oldgold == nil then
			self.oldgold = PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID())
		end
		if self.oldgold ~= PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID()) then
			if self.oldgold - PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID()) < -2 or self.oldgold - PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID()) > 2 then
				if self.oldgold > PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID()) then
					self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Lost "..math.floor(self.oldgold - PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID())).." Gold")
				elseif self.oldgold < PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID()) then
					self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Gained "..math.floor(PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID()) - self.oldgold).." Gold")
				end
			end
			self.oldgold = PlayerResource:GetGold(self:GetParent():GetPlayerOwnerID())
		end
		if self.oldxp == nil then
			self.oldxp = self:GetParent():GetCurrentXP()
		end
		if self.oldxp ~= self:GetParent():GetCurrentXP() then
			if self.oldxp < self:GetParent():GetCurrentXP() then
				self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Gained "..math.floor(self:GetParent():GetCurrentXP() - self.oldxp).." XP")
			elseif self.oldxp > self:GetParent():GetCurrentXP() then
				self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." Lost "..math.floor(self.oldxp - self:GetParent():GetCurrentXP()).." XP")
			end
			self.oldxp = self:GetParent():GetCurrentXP()
		end
		for _,j in ipairs(GridNav:GetAllTreesAroundPoint(self:GetParent():GetAbsOrigin(), 600, true)) do
			DebugDrawText(j:GetAbsOrigin(), tostring(j:entindex()).."\n"..tostring(GetEntityIndexForTreeId(j:entindex())).."\n"..tostring(GetTreeIdForEntityIndex(j:entindex())), false, 1)
		end
		local wards = Entities:FindAllByClassname("npc_dota_ward_base")
		for _,ward in ipairs (Entities:FindAllByClassname("npc_dota_ward_base_truesight")) do table.insert(wards, ward) end
		for _,j in ipairs(wards) do
			if j:GetClassname() == "npc_dota_ward_base" or j:GetClassname() == "npc_dota_ward_base_truesight" then
				local ward_buff = j:FindModifierByName("modifier_item_buff_ward")
				local warder = j
				if ward_buff then
					warder = ward_buff:GetCaster()
				end
				Extensions:AddEntText(j:entindex(), j:GetOwner():GetAssignedHero():GetName())
				Extensions:AddEntText(j:entindex(), j:GetOwner():GetClassname())
				Extensions:AddEntText(j:entindex(), warder:GetName())
			end
		end
		local fowenemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, parent:GetCurrentVisionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local allenemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, parent:GetCurrentVisionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,j in ipairs(allenemies) do
			local dummy = CreateModifierThinker(j, nil, "modifier_extensions_dummy_timer", {}, j:GetAbsOrigin(), j:GetTeamNumber(), false)
			Extensions:AddEntText(j:entindex(), "FoW Visible: "..tostring(parent:CanEntityBeSeenByMyTeam(dummy)))
			Extensions:AddEntText(j:entindex(), "Ext FoW Visible: "..tostring(Extensions:IsPositionFoWVisible(j:GetAbsOrigin(), parent)))
			Extensions:AddEntText(j:entindex(), "Is Invisible: "..tostring(j:IsInvisible()))
			UTIL_Remove(dummy)
		end
		--Extensions:AddEntText(self:GetParent():entindex(), Extensions:QueryHeroDamage(self:GetParent():entindex(), 2, 1+4+(2*math.bool(self:GetParent():HasModifier("modifier_black_king_bar_immune"))), true, false))
		--print("AttackRange: "..self:GetParent():Script_GetAttackRange())
		--self:statprint("AttackDMG: "..self:GetParent():GetAttackDamage().."\nAverage AttackDMG: "..self:GetParent():GetAverageTrueAttackDamage(self:GetParent()))
		--OrientationTest
		--local orientation = -self:GetParent():GetForwardVector()
		--self:statprint(HeroNamesLib:ConvertInternalToHeroName(self:GetParent():GetName()).." -FVector: "..orientation[1]..","..orientation[2]..","..orientation[3])
		--ParticleTest
		--Complex Particle Test
		--if self.p1 == nil then
			--self.p1 = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			--ParticleManager:SetParticleControlEnt( self.p1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
			--ParticleManager:SetParticleControlEnt( self.p1, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
			--ParticleManager:SetParticleControlEnt( self.p1, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
			--ParticleManager:SetParticleControl(self.p1, 16, Vector(1,0,0))
		--end
		--[[if self.p1 == nil then
			self.p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_rain_storm.vpcf", PATTACH_WORLDORIGIN, parent)
			ParticleManager:SetParticleControl(self.p1, 0, parent:GetAbsOrigin() + Vector(0,0,200))
			ParticleManager:SetParticleControl(self.p1, 2, parent:GetAbsOrigin() + Vector(0,0,200))
			self:GetParent():EmitSound("Hero_Razor.Storm.Loop")
		end
		if self.p2 == nil then
			self.p2 = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile_gold/od_shards_exile_prison_top_orb_gold.vpcf", PATTACH_WORLDORIGIN, parent)
			ParticleManager:SetParticleControl(self.p2, 0, parent:GetAbsOrigin() + Vector(0,0,500))
		end--]]
		--if self.p3 == nil then --"particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
		--local p3 = ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_spell.vpcf", PATTACH_POINT_FOLLOW, parent)
		--ParticleManager:SetParticleControl(p3, 0, parent:GetAbsOrigin() + Vector(0,0,0))
		--ParticleManager:SetParticleControl(p3, 1, parent:GetAbsOrigin() + Vector(0,0,70))
		--ParticleManager:SetParticleControl(p3, 2, parent:GetAbsOrigin() + Vector(0,0,100))
		--ParticleManager:ReleaseParticleIndex(p3)
		--end
		--self:ForceRefresh()
	end
end

--Quick Particle Test
--[[function modifier_vgmar_i_ogre_tester:GetEffectName()
	return "particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl2_a5.vpcf"
end

--[[
	AttachTypes:
	PATTACH_ABSORIGIN
	PATTACH_ABSORIGIN_FOLLOW
	PATTACH_OVERHEAD_FOLLOW
	PATTACH_ROOTBONE_FOLLOW
]]--
function modifier_vgmar_i_ogre_tester:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end--]]

--[[function modifier_vgmar_i_ogre_tester:OnAttackLanded(kv)
	if kv.attacker == self:GetParent() then
		local aAO = kv.attacker:GetOrigin()
		local tAO = kv.target:GetOrigin()
		DebugDrawLine(aAO, tAO, 128, 255, 255, true, 2)
		local AtTV = (tAO-aAO):Normalized()
		DebugDrawLine(tAO, tAO + AtTV*150, 255, 0, 0, true, 2)
		local particle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, kv.attacker)
		ParticleManager:SetParticleControlEnt( pfx, 0, kv.target, PATTACH_POINT_FOLLOW, "attach_hitloc", kv.target:GetOrigin(), true )
		ParticleManager:SetParticleControl( pfx, 1, kv.target:GetOrigin() )
		ParticleManager:SetParticleControlForward( pfx, 1, -AtTV )
		ParticleManager:SetParticleControlEnt( pfx, 10, kv.target, PATTACH_ABSORIGIN_FOLLOW, nil, kv.target:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( pfx )
	end
end--]]

function modifier_vgmar_i_ogre_tester:OnTakeDamage( event )
	if IsServer() then
		if event.victim == self:GetParent() or event.attacker == self:GetParent() then
			debug.PrintTable(event)
		end
	end
end

function modifier_vgmar_i_ogre_tester:OnRemoved()
	if IsServer() then
		if self.p1 ~= nil then
			ParticleManager:DestroyParticle(self.p1, false)
			ParticleManager:ReleaseParticleIndex(self.p1)
			self.p1 = nil
		end
		--ParticleManager:DestroyParticle(self.p1, false)
		--self:GetParent():StopSound("Hero_Razor.Storm.Loop")
		--ParticleManager:DestroyParticle(self.p2, false)
		--ParticleManager:DestroyParticle(self.p3, false)
		--ParticleManager:ReleaseParticleIndex(self.p1)
		--ParticleManager:ReleaseParticleIndex(self.p2)
		--ParticleManager:ReleaseParticleIndex(self.p3)
	end
end

function modifier_vgmar_i_ogre_tester:OnDestroy()
	if IsServer() then
		self:StartIntervalThink( -1 )
	end
end

function modifier_vgmar_i_ogre_tester:OnAttackStart(kv)
	if IsServer() then
		if kv.attacker == self:GetParent() then
			print("Printing AttackStart kv")
			debug.PrintTable(kv)
			if kv.target:IsRealUnit(true) then
				print("Predicting "..math.truncate(Extensions:PredictAttackDamage(kv.attacker, kv.target),2).." Damage")
			end
		end
	end
end

function modifier_vgmar_i_ogre_tester:OnAttackLanded(kv)
	if IsServer() then
		if kv.attacker == self:GetParent() then
			if kv.target:IsRealUnit(true) then
				print("Hit Target Name: "..tostring(kv.target:GetName()))
			end
			print("Printing AttackLanded kv")
			debug.PrintTable(kv)
		end
	end
end

function modifier_vgmar_i_ogre_tester:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_START,
		--MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		--MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
    return funcs
end

function modifier_vgmar_i_ogre_tester:GetActivityTranslationModifiers()
	return "injured"
end

function modifier_vgmar_i_ogre_tester:OnOrder(event)
	if IsServer() then
		if event.unit == self:GetParent() then
			debug.PrintTable(event)
		end
	end
end

--[[ManaCost Modification
function modifier_vgmar_i_ogre_tester:OnAbilityExecuted(kv)
	if kv.ability:IsItem() == false then
		kv.unit:ReduceMana((kv.ability:GetManaCost(-1) * self.mci) - kv.ability:GetManaCost(-1))
	end
end--]]

--[[function modifier_vgmar_i_ogre_tester:OnAbilityStart(kv)
	if kv.ability:IsItem() == false then
		print("Ability: "..kv.ability:GetName().."\nRequired Mana: "..kv.ability:GetManaCost(-1) * self.mci.."\nAvailable Mana: "..kv.unit:GetMana())
		if kv.ability:GetManaCost(-1) * self.mci > kv.unit:GetMana() then
			print("Not Enough Mana, Interrupting")
			kv.unit:Interrupt()
			GameRules.VGMAR:DisplayClientError(kv.unit:GetPlayerID(), "Not Enough Mana")
		end
	end
end--]]

--[[
OnAbilityStart
vvvvvvvvvvvvvv
new_pos                         	= Vector 0000000000366CD8 [0.000000 -nan 0.000000] (userdata)
process_procs                   	= false (boolean)
order_type                      	= 0 (number)
issuer_player_index             	= 0 (number)
fail_type                       	= 0 (number)
damage_category                 	= 0 (number)
reincarnate                     	= false (boolean)
damage                          	= 0 (number)
ignore_invis                    	= false (boolean)
ability                         	= table: 0x00301e80 (table)
ranged_attack                   	= false (boolean)
record                          	= -8208 (number)
unit                            	= table: 0x0041cd50 (table)
do_not_consume                  	= false (boolean)
damage_type                     	= -976879620 (number)
activity                        	= -1 (number)
heart_regen_applied             	= false (boolean)
diffusal_applied                	= false (boolean)
mkb_tested                      	= false (boolean)
no_attack_cooldown              	= false (boolean)
damage_flags                    	= 0 (number)
original_damage                 	= 0 (number)
gain                            	= 0 (number)
cost                            	= 0 (number)
basher_tested                   	= false (boolean)
distance                        	= 0 (number)
--------------
OnAbilityExecuted
vvvvvvvvvvvvvv
new_pos                         	= Vector 0000000000313B78 [0.000000 1.007813 0.000000] (userdata)
process_procs                   	= false (boolean)
order_type                      	= 0 (number)
issuer_player_index             	= -158072448 (number)
fail_type                       	= 187 (number)
damage_category                 	= 0 (number)
reincarnate                     	= false (boolean)
damage                          	= 0 (number)
ignore_invis                    	= false (boolean)
ability                         	= table: 0x00301e80 (table)
ranged_attack                   	= false (boolean)
record                          	= -30583 (number)
unit                            	= table: 0x0041cd50 (table)
do_not_consume                  	= false (boolean)
damage_type                     	= 91 (number)
activity                        	= -1 (number)
heart_regen_applied             	= false (boolean)
diffusal_applied                	= false (boolean)
mkb_tested                      	= false (boolean)
no_attack_cooldown              	= false (boolean)
damage_flags                    	= 0 (number)
original_damage                 	= 0 (number)
gain                            	= 0 (number)
cost                            	= 0 (number)
basher_tested                   	= false (boolean)
distance                        	= 0 (number)
--------------
OnAbilityFullyCast
vvvvvvvvvvvvvv
new_pos                         	= Vector 00000000003B17C0 [0.000000 0.000000 0.000000] (userdata)
process_procs                   	= false (boolean)
order_type                      	= 0 (number)
issuer_player_index             	= 0 (number)
fail_type                       	= 32762 (number)
damage_category                 	= 0 (number)
reincarnate                     	= false (boolean)
damage                          	= 0 (number)
ignore_invis                    	= false (boolean)
ability                         	= table: 0x00301e80 (table)
ranged_attack                   	= false (boolean)
record                          	= 396 (number)
unit                            	= table: 0x0041cd50 (table)
do_not_consume                  	= false (boolean)
damage_type                     	= -107328192 (number)
activity                        	= -1 (number)
heart_regen_applied             	= false (boolean)
diffusal_applied                	= false (boolean)
mkb_tested                      	= false (boolean)
no_attack_cooldown              	= false (boolean)
damage_flags                    	= 0 (number)
original_damage                 	= 0 (number)
gain                            	= 0 (number)
cost                            	= 110 (number)
basher_tested                   	= false (boolean)
distance                        	= 0 (number)
]]--

function modifier_vgmar_i_ogre_tester:OnAbilityExecuted(event)
	if IsServer() then
		if event.unit == self:GetParent() then
			print("OnAbilityExecuted")
			debug.PrintTable(event)
		end
	end
end

function modifier_vgmar_i_ogre_tester:OnAbilityStart(event)
	if IsServer() then
		if event.unit == self:GetParent() then
			print("OnAbilityStart")
			debug.PrintTable(event)
		end
	end
end



function modifier_vgmar_i_ogre_tester:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetParent() then
			print("OnAbilityFullyCast")
			debug.PrintTable(event)
		end
	end
end

function modifier_vgmar_i_ogre_tester:OnDeath(kv)
	local function nonnilprint(var)
		if var ~= nil then
			print(var)
		else
			print("Is Nil")
		end
	end
	
	if IsServer() then
        -- Only apply if the caster is the unit that died
        if self:GetParent() == kv.unit then
			for i,v in pairs(kv) do
				print(i, v)
			end
        end
    end
	
	--[[print("kv.attacker")
	nonnilprint(kv.attacker)
	print("kv.inflictor")
	nonnilprint(kv.inflictor)
	print("kv.unit")
	nonnilprint(kv.unit)
	print("kv.victim")
	nonnilprint(kv.victim)
	print("kv.ability")
	nonnilprint(kv.ability)--]]
end
--------------------------------------------------------------------------------