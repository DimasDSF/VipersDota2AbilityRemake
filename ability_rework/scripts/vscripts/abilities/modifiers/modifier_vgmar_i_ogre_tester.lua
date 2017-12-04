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
		self.crit = false
	end
end

function modifier_vgmar_i_ogre_tester:OnRefresh( kv )
	if IsServer() then
	end
end

function modifier_vgmar_i_ogre_tester:OnIntervalThink()
	if IsServer() then
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
		--self:ForceRefresh()
	end
end

function modifier_vgmar_i_ogre_tester:OnDestroy()
	if IsServer() then
		self:StartIntervalThink( -1 )
	end
end

function modifier_vgmar_i_ogre_tester:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
    return funcs
end

function modifier_vgmar_i_ogre_tester:GetActivityTranslationModifiers()
	return "injured"
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