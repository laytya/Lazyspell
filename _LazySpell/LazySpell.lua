local HealComm 			= AceLibrary("HealComm-1.0")
local L                 = AceLibrary("AceLocale-2.2"):new("LazySpell")
local BS                = AceLibrary("Babble-Spell-2.2")
local SC				= AceLibrary("SpellCache-1.0")
local dewdrop 			= AceLibrary("Dewdrop-2.0")
local waterfall 		= AceLibrary("Waterfall-1.0")
LazySpell = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0", "AceDebug-2.0", "FuBarPlugin-2.0")
LazySpell.cast = {}

local defaults = {
	debugging = false,
	healcoef = 1,
	[BS["Healing Wave"]] = 9,
	[BS["Lesser Healing Wave"]] = 6,
	[BS["Healing Wave"].."min"] = 1,
	[BS["Lesser Healing Wave"].."min"] = 1,
	[BS["Chain Heal"]] = 3,
	[BS["Heal"]] = 4,
	[BS["Flash Heal"]] = 6,
	[BS["Greater Heal"]] = 5,
	[BS["Healing Touch"]] = 11,
	[BS["Regrowth"]] = 9,
	[BS["Healing Touch"].."min"] = 1,
	[BS["Regrowth"].."min"] = 1,
}

local hcolor = "|cFF77BBFF"
local greycolor = "|cFFCCCCCC"

local options = {
	type = 'group',
	icon = 'Interface\\AddOns\\_LazySpell\\Icon',
	name = 'LazySpell',
	args = {
	--[[	menu = {
			type = 'execute',
			name = L["Options"],
			desc = L["Open options"],
			func = function()
				waterfall:Open('LazySpell')
			end,
			order = 100,
		},
		spacer = { type = "header", order = 102 },
	]]
		maxspellranks = {
			type = 'group',
			name = hcolor .. L["Spell options"],
			desc = L["Options for min\max rank spell to subtitude and overheal coef."],
			order = 110,
args = {
				
			},
		},
		
		fubar = { 
				type = "group", name = greycolor .. L["Fubar plugin"], desc = L["Fubar plugin options."], order=-15,
				args = {}
		},
	},
}
local _, class = UnitClass("player")

if class == "SHAMAN" then
	
	
	options.args.maxspellranks.args ={
		healingwave = {
			type = 'range',
			name = L["Healing Wave Max Rank"],
			desc = L["Defines the max rank of Healing Wave spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Healing Wave"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Healing Wave"]] = v
			end,
			min = 1,
			max = 9,
			step = 1,
			isPercent = false,
			order = 100,
		},
		healingwaveminrank = {
			type = 'range',
			name = L["Min Rank for HW"],
			desc = L["Use minimum Rank for Healing Wave"],
			get = function() return LazySpell.db.profile[BS["Healing Wave"].."min"] end,
			set = function(v)
				LazySpell.db.profile[BS["Healing Wave"].."min"] = v
			end,
			min = 1,
			max = 6,
			step = 1,
			isPercent = false,
			order = 105
		},
		lesserhealingwave = {
			type = 'range',
			name = L["Lesser Healing Wave Max Rank"],
			desc = L["Defines the max rank of Lesser Healing Wave spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Lesser Healing Wave"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Lesser Healing Wave"]] = v
			end,
			min = 1,
			max = 6,
			step = 1,
			isPercent = false,
			order = 110,
		},
		leshealingwaveminrank = {
			type = 'range',
			name = L["Min Rank for LHW"],
			desc = L["Use minimum Rank for Lesser Healing Wave"],
			get = function() return LazySpell.db.profile[BS["Lesser Healing Wave"].."min"] end,
			set = function(v)
				LazySpell.db.profile[BS["Lesser Healing Wave"].."min"] = v
			end,
			min = 1,
			max = 6,
			step = 1,
			isPercent = false,
			order = 115
		},
		
		chainheal = {
			type = 'range',
			name = L["Chain Heal Max Rank"],
			desc = L["Defines the max rank of Chain Heal spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Chain Heal"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Chain Heal"]] = v
			end,
			min = 1,
			max = 3,
			step = 1,
			isPercent = false,
			order = 120,
		},
				
	
	
	}
	
elseif class == "PRIEST" then
	
	
	options.args.maxspellranks.args = {
		heal = {
			type = 'range',
			name = L["Heal Max Rank"],
			desc = L["Defines the max rank of Heal spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Heal"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Heal"]] = v
			end,
			min = 1,
			max = 4,
			step = 1,
			isPercent = false,
			order = 100,
		},
		flashheal = {
			type = 'range',
			name = L["Flash Heal Max Rank"],
			desc = L["Defines the max rank of Flash Heal spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Flash Heal"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Flash Heal"]] = v
			end,
			min = 1,
			max = 7,
			step = 1,
			isPercent = false,
			order = 100,
		},
		greaterheal = {
			type = 'range',
			name = L["Greater Heal Max Rank"],
			desc = L["Defines the max rank of Greater Heal spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Greater Heal"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Greater Heal"]] = v
			end,
			min = 1,
			max = 5,
			step = 1,
			isPercent = false,
			order = 100,
		},
	}
elseif class == "DRUID" then
	
	options.args.maxspellranks.args = {
		healingtouch = {
			type = 'range',
			name = L["Healing Touch Max Rank"],
			desc = L["Defines the max rank of Healing Touch spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Healing Touch"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Healing Touch"]] = v
			end,
			min = 1,
			max = 11,
			step = 1,
			isPercent = false,
			order = 100,
		},
		healingtouchmin = {
			type = 'range',
			name = L["Healing Touch Min Rank"],
			desc = L["Defines the min rank of Healing Touch spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Healing Touch"].."min"] end,
			set = function(v) 
				LazySpell.db.profile[BS["Healing Touch"].."min"] = v
			end,
			min = 1,
			max = 11,
			step = 1,
			isPercent = false,
			order = 110,
		},
		regrowth = {
			type = 'range',
			name = L["Regrowth Max Rank"],
			desc = L["Defines the max rank of Regrowth spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Regrowth"]] end,
			set = function(v) 
				LazySpell.db.profile[BS["Regrowth"]] = v
			end,
			min = 1,
			max = 9,
			step = 1,
			isPercent = false,
			order = 120,
		},
		regrowthmin = {
			type = 'range',
			name = L["Regrowth Min Rank"],
			desc = L["Defines the min rank of Regrowth spell used by lazyspell."],
			get = function() return LazySpell.db.profile[BS["Regrowth"].."min"] end,
			set = function(v) 
				LazySpell.db.profile[BS["Regrowth"].."min"] = v
			end,
			min = 1,
			max = 9,
			step = 1,
			isPercent = false,
			order = 130,
		},
	}
end

options.args.maxspellranks.args.healcoef = {
	type = 'range',
	name = L["Overheal ratio"],
	desc = L["Ratio of overheal of spells from 0.1 to 2"],
	get = function() return LazySpell.db.profile.healcoef end,
	set = function(v) 
		LazySpell.db.profile.healcoef = v
	end,
	min = 0.1,
	max = 2,
	step = 0.1,
	isPercent = true,
	order = 130,
}

-- stuff for FuBar:


LazySpell.hasIcon = 'Interface\\AddOns\\_LazySpell\\Icon'
LazySpell.defaultPosition = "LEFT"
LazySpell.defaultMinimapPosition = 250
LazySpell.cannotDetachTooltip = true
LazySpell.tooltipHiddenWhenEmpty = true
LazySpell.hideWithoutStandby = true
LazySpell.clickableTooltip = false
LazySpell.independentProfile = true
LazySpell.hasNoColor = true

function LazySpell:OnInitialize()
	self:RegisterDB("LazySpellDB")
	self:RegisterDefaults('profile', defaults )
	
	
	t = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(LazySpell)
	for k,v in pairs(t) do
		if not options.args.fubar.args[k] then	options.args.fubar.args[k] = v	end
	end
	
	
	self:RegisterChatCommand({'/lspellcl'}, options )
	self.OnMenuRequest = options
	self.OnMenuRequest.args.lockTooltip.hidden = true
	self.OnMenuRequest.args.detachTooltip.hidden = true
	self:SetText("Lazy spell")
	if not FuBar then
		self.OnMenuRequest.args.hide.guiName = L["Hide minimap icon"]
		self.OnMenuRequest.args.hide.desc = L["Hide minimap icon"]
	end
	waterfall:Register('LazySpell', 'aceOptions', options, 'title', L['Lazy Spell Options'])  
	
	self.OnClick = function() waterfall:Open('LazySpell') end
	self.OnMenuRequest = options
	dewdrop:InjectAceOptionsTable(self, self.OnMenuRequest)	
end


LazySpell.BOL = {
["enUS"] = "Receives up to (%d+) extra healing from Holy Light spells%, and up to (%d+) extra healing from Flash of Light spells%.",
["deDE"] = "Erh�lt bis zu (%d+) extra Heilung durch %'Heiliges Licht%' und bis zu (%d+) extra Heilung durch den Zauber %'Lichtblitz%'%.",
["frFR"] = "Les sorts de Lumiere sacr�e rendent jusqu%'a (%d+) points de vie suppl�mentaires%, les sorts d%'Eclair lumineux jusqu%'a (%d+)%."
["ruRU"] = "Благословляет дружественную цель, усиливая эффект применяемого к ней заклинания \"Свет небес\" на величину до (%d+) ед., а заклинания \"Вспышка Света\" – на величину до (%d+) ед%." --not tested
}

local fubarOptions = { "detachTooltip", "colorText", "text", "lockTooltip", "position", "minimapAttach", "hide", "icon" }

function LazySpell:OnEnable()
	DEFAULT_CHAT_FRAME:AddMessage("_Lazy Spell by ".."|cffFF0066".."Ogrisch".."|cffffffff".. " loaded")
	
	for k,v in fubarOptions do
		if self.OnMenuRequest.args[v] then 
			self.OnMenuRequest.args[v].hidden = true
		end
	end
	
	if Clique then
		Clique.CastSpell_OLD = Clique.CastSpell
		Clique.CastSpell = self.Clique_CastSpell
	end
	if CM then
		CM.CastSpell_OLD = CM.CastSpell
		CM.CastSpell = self.CM_CastSpell
	end
	
	if LunaUF then
		LunaUF.CastSpellByName_IgnoreSelfCast_OLD = LunaUF.CastSpellByName_IgnoreSelfCast
		LunaUF.CastSpellByName_IgnoreSelfCast = self.LunaUF_CastSpellByName_IgnoreSelfCast
	end
	
	if pfUI and pfUI.uf then
		pfUI.uf.ClickAction_old = pfUI.uf.ClickAction
		pfUI.uf.ClickAction = self.pfUI_uf_ClickAction
	end
	
	self:RegisterEvent("SPELLCAST_START")
	self.debugging = self:IsDebugging()
	
	
---	local _,_,_,_,_,_,_,hwmr = SC:GetSpellData("Healing Wave")
--	options.args.maxspellranks.args.healingwave.max = hwmr
	
end

function LazySpell:IsDebugging() return self.db.profile.debugging end
function LazySpell:SetDebugging(debugging) self.db.profile.debugging = debugging; self.debugging = debugging; end


function LazySpell:SPELLCAST_START()
	if self.cast.msg and self.cast.spell == arg1 then
		LazySpell:Debug(self.cast.msg)
	end	
	self.cast.msg = nil
	self.cast.spell = nil
end
--[[
function LazySpell:ExtractSpell(spell)
	local s = spell
	local _, i, r
	_, _, s = string.find(s, "^(.*);?%s*$")
	while ( string.sub( s, -2 ) == "()" ) do
		s = string.sub( s, 1, -3 )
	end
	_, _, s = string.find(s, "^%s*(.*)$")
	_, _, i, r = string.find(s, "(.*)%(.*(%d)%)$")
	if (i and r) then
		s = i
		r = tonumber(r)
		return s, r
	end
end
]]
function LazySpell:GetBuffSpellPower()
	local Spellpower = 0
	local healmod = 1
	for i=1, 16 do
		local buffTexture, buffApplications = UnitBuff("player", i)
		if not buffTexture then
			return Spellpower, healmod
		end
		healcommTip:SetUnitBuff("player", i)
		local buffName = healcommTipTextLeft1:GetText()
		if HealComm.Buffs[buffName] and HealComm.Buffs[buffName].icon == buffTexture then
			Spellpower = (HealComm.Buffs[buffName].amount * buffApplications) + Spellpower
			healmod = (HealComm.Buffs[buffName].mod * buffApplications) + healmod
		end
	end
	return Spellpower, healmod
end

function LazySpell:GetUnitSpellPower(spell, unit)
	local targetpower = 0
	local targetmod = 1
	local buffTexture, buffApplications
	local debuffTexture, debuffApplications
	for i=1, 16 do
		if UnitExists(unit) and UnitIsVisible(unit) and UnitIsConnected(unit) and UnitReaction(unit, "player") > 4 then
			buffTexture, buffApplications = UnitBuff(unit, i)
			healcommTip:SetUnitBuff(unit, i)
		else
			buffTexture, buffApplications = UnitBuff("player", i)
			healcommTip:SetUnitBuff("player", i)
		end
		if not buffTexture then
			break
		end
		local buffName = healcommTipTextLeft1:GetText()
		if (buffTexture == "Interface\\Icons\\Spell_Holy_PrayerOfHealing02" or buffTexture == "Interface\\Icons\\Spell_Holy_GreaterBlessingofLight") then
			local _,_, HLBonus, FoLBonus = string.find(healcommTipTextLeft2:GetText(),LazySpell.BOL[GetLocale()])
			HLBonus = HLBonus or 0
			FoLBonus = FoLBonus or 0
			if (spell == BS["Flash of Light"]) then
				targetpower = FoLBonus + targetpower
			elseif spell == BS["Holy Light"] then
				targetpower = HLBonus + targetpower
			end
		end
		if buffName == BS["Healing Way"] and spell == BS["Healing Wave"] then
			targetmod = targetmod * ((buffApplications * 0.06) + 1)
		end
	end
	for i=1, 16 do
		if UnitIsVisible(unit) and UnitIsConnected(unit) and UnitReaction(unit, "player") > 4 then
			debuffTexture, debuffApplications = UnitDebuff(unit, i)
			healcommTip:SetUnitDebuff(unit, i)
		else
			debuffTexture, debuffApplications = UnitDebuff("player", i)
			healcommTip:SetUnitDebuff("player", i)
		end
		if not debuffTexture then
			break
		end
		local debuffName = healcommTipTextLeft1:GetText()
		if HealComm.Debuffs[debuffName] then
			targetpower = (HealComm.Debuffs[debuffName].amount * debuffApplications) + targetpower
			targetmod = (1-(HealComm.Debuffs[debuffName].mod * debuffApplications)) * targetmod
		end
	end
	return targetpower, targetmod
end	
--[[
function LazySpell:GetMaxSpellRank(spellName)
    local i = 1;
    local List = {};
    local spellNamei, spellRank;

    while true do
        spellNamei, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
        if not spellNamei then return table.getn(List) end

        if spellNamei == spellName then
            _,_,spellRank = string.find(spellRank, " (%d+)$");
            spellRank = tonumber(spellRank);
            if not spellRank then return i end
            List[spellRank] = i;
        end
        i = i + 1;
    end

end
]]
function LazySpell:CalculateRank(spell, unit)
	local Bonus = 0
	--local max_rank = self:GetMaxSpellRank(spell)
	local _,_,_,_,_,_,_,max_rank = SC:GetSpellData(spell)
--	self:Debug("Max rank "..max_rank)
	if self.db.profile[spell] and max_rank > self.db.profile[spell] then
		max_rank = self.db.profile[spell]
	end
	
	if BonusScanner then
		Bonus = tonumber(BonusScanner:GetBonus("HEAL"))
	end		

	local minrank = 1
	if self.db.profile[spell.."min"] ~= nil then
		minrank	= self.db.profile[spell.."min"]
	end
	
	local targetpower, targetmod = self:GetUnitSpellPower(spell, unit)
	local buffpower, buffmod = self:GetBuffSpellPower()
	local Bonus = Bonus + buffpower	
	local healneed = UnitHealthMax(unit) - UnitHealth(unit);
	
	local result = minrank
	local heal = 0
	for i = max_rank,minrank,-1 do
		local amount = ((math.floor(HealComm.Spells[spell][i](Bonus))+targetpower)*buffmod*targetmod)
		if amount < healneed then
			if (i < max_rank) and ( amount < ( healneed * self.db.profile.healcoef) ) then
				
				result = i + 1
				heal = ((math.floor(HealComm.Spells[spell][i+1](Bonus))+targetpower)*buffmod*targetmod)
				
				break
			else
				result = i
				heal = amount
				break
			end
		else
			heal = amount
		end	
	end	

	self.cast.spell = spell
	self.cast.msg = spell.."(Rank "..result..") - "..GetUnitName(unit).." - Heal: "..heal.." - Deficit: "..healneed, spell
	
--	self:Debug(self.cast.msg)
	
	return result
end
function LazySpell:ValidateSpell(spell,unit)
	local s,_,_,_,r = SC:GetSpellData(spell)
	if s and HealComm.Spells[s] and r == 1 then
		local rank = LazySpell:CalculateRank(s, unit)
		return SC:GetSpellNameText(s,rank)
	end	
	return spell
end
function LazySpell:Clique_CastSpell(spell, unit)
	
	unit = unit or Clique.unit
	spell = LazySpell:ValidateSpell(spell,unit)
	
	Clique:CastSpell_OLD(spell, unit)
end

function LazySpell:CM_CastSpell(spell, unit)
	spell = LazySpell:ValidateSpell(spell,unit)
	CM:CastSpell_OLD(spell, unit)
end

function LazySpell:LunaUF_CastSpellByName_IgnoreSelfCast(spell, unit)
--	self:Debug("LUNA CastSpellByName_IgnoreSelfCast")
	if not ( type(spell) == "function") then
		local lunit = (LunaUF.db.profile.mouseover and UnitExists("mouseover") and "mouseover") or (GetMouseFocus() and GetMouseFocus().unit)
		local rosterUnit = lunit and LunaUF.roster:GetUnitIDFromUnit(lunit)
		lunit = unit or rosterUnit or lunit
		spell = LazySpell:ValidateSpell(spell,lunit)
	end
	LunaUF:CastSpellByName_IgnoreSelfCast_OLD(spell, unit)
end

function LazySpell:pfUI_uf_ClickAction(button)
	local label = this.label or ""
	local id = this.id or ""
	local unitstr = label .. id
	local modstring = ""
	modstring = IsAltKeyDown() and modstring.."alt" or modstring
	modstring = IsControlKeyDown() and modstring.."ctrl" or modstring
	modstring = IsShiftKeyDown() and modstring.."shift" or modstring
	modstring = modstring..button
	local oldspell = this.clickactions[modstring]
	if this.clickactions and this.clickactions[modstring] then
		if not (string.find(this.clickactions[modstring], "^menu") or string.find(this.clickactions[modstring], "^target") or string.find(this.clickactions[modstring], "^%/(.+)")) then
			this.clickactions[modstring] = LazySpell:ValidateSpell(this.clickactions[modstring],unitstr)
		end
	end
	pfUI.uf:ClickAction_old(button)
	this.clickactions[modstring] = oldspell
end