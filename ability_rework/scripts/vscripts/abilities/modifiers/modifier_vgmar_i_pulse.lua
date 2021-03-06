--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_pulse = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_pulse:GetTexture()
	return "necrolyte_death_pulse"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_pulse:IsHidden()
    return self:GetStackCount() <= 0
end

function modifier_vgmar_i_pulse:IsPurgable()
	return false
end

function modifier_vgmar_i_pulse:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_pulse:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_pulse:IsPermanent()
	return true
end

function modifier_vgmar_i_pulse:OnCreated(kv)
	if IsServer() then
		self.stackspercreep = kv.stackspercreep
		self.stacksperhero = kv.stacksperhero
		self.duration = kv.duration
		self.hpregenperstack = kv.hpregenperstack
		self.manaregenperstack = kv.manaregenperstack
		self.maxstacks = kv.maxstacks
		self:SetDuration( -1, true )
		self:StartIntervalThink( 0.1 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_pulse")
	end
end

function modifier_vgmar_i_pulse:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
    return funcs
end

function modifier_vgmar_i_pulse:OnDeath(kv)
	if IsServer() then
		if kv.attacker == self:GetCaster() and self:GetParent():PassivesDisabled() == false then
			if kv.unit:IsRealHero() then
				if (self:GetStackCount() + self.stacksperhero) < self.maxstacks then
					self:SetStackCount( self:GetStackCount() + self.stacksperhero )
				else
					self:SetStackCount( self.maxstacks )
				end
				self:SetDuration( self.duration, true )
			else
				if (self:GetStackCount() + self.stackspercreep) < self.maxstacks then
					self:SetStackCount( self:GetStackCount() + self.stackspercreep )
				else
					self:SetStackCount( self.maxstacks )
				end
				self:SetDuration( self.duration, true )
			end
		end
	end
end

function modifier_vgmar_i_pulse:OnIntervalThink()
	if self:GetRemainingTime() <= 0 then
		if self:GetStackCount() >= 1 then
			self:SetStackCount( self:GetStackCount() - 1 )
			self:SetDuration( 0.5, true )
		else
			self:SetDuration( -1, true )
		end
	end
end

function modifier_vgmar_i_pulse:GetModifierConstantHealthRegen()
	if IsServer() then
		return self:GetStackCount() * self.hpregenperstack
	else
		return self:GetStackCount() * self.clientvalues.hpregenperstack
	end
end

function modifier_vgmar_i_pulse:GetModifierConstantManaRegen()
	if IsServer() then
		return self:GetStackCount() * self.manaregenperstack
	else
		return self:GetStackCount() * self.clientvalues.manaregenperstack
	end
end
--------------------------------------------------------------------------------