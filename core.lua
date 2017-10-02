local HMNP = LibStub("AceAddon-3.0"):NewAddon("HMNP", "AceEvent-3.0")
local LNP = LibStub('LibNameplate-1.0')

_G.HMNP = HMNP

local oldname = UnitName('player')
local newname = 'Zioraaa'

function HMNP:OnInitialize()

	local gbs	=	GetBattlefieldScore
	local muf	=	UnitName
	local kuf	=	UnitFullName
	local zuf	=	UnitPVPName
	local luf 	= 	GetGuildRosterInfo
	
	GetBattlefieldScore = function(index)
	
		local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = gbs(index)
		
		if name == oldname then
		
			return newname, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec
		
		else
		
			return gbs(index)
			
		end
		
	end
	
	UnitName = function(unit) 
	
		if UnitGUID(unit) == UnitGUID('player') then 
		
			return newname
			
		else 
		
			return muf(unit) 
			
		end 
		
	end
	
	UnitFullName = function(unit)
	
		local lastname = select(2,kuf(unit))
		
		if UnitGUID(unit) == UnitGUID('player') then 
		
			return newname, lastname
			
		else 
		
			return kuf(unit) 
			
		end 
		
	end

	UnitPVPName = function(unit)

		if UnitGUID(unit) == UnitGUID('player') then 
			return newname
		else 
			return zuf(unit) 
		end 
	end

	GetGuildRosterInfo = function(index)

		local a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17 = luf(index)
		local p1,p2 = UnitFullName('player')
	
		if a17 == UnitGUID('player') then
		
			return p1..'-'..p2,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17
		
		else
	
			return luf(index)
	
		end

	end

end

-- filter

function chatFilter(self, event, message, author, ...)

	if author == oldname and message:match(oldname) then 
	
		local newmessage = message:gsub(oldname, newname)
		return false, newmessage, newname, ...
		
	elseif author == oldname then
	
		return false, message, newname, ...
	
	elseif message:match(oldname) then

		local newmessage = message:gsub(oldname, newname)
		return false, newmessage, author, ...
	
	end

end

local chatEvents = {
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_BN_CONVERSATION",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
}

for _, v in pairs(chatEvents) do

	ChatFrame_AddMessageEventFilter(v, chatFilter)
	
end

-- recount change

local addonchange = CreateFrame("Frame")
addonchange:Hide()
addonchange:RegisterEvent("ADDON_LOADED")
addonchange:SetScript("OnEvent", function(self, event, ...)

	if event == "ADDON_LOADED" and (...) == 'Recount' then
	
		local recountfunc = _G.Recount.AddDamageData

		_G.Recount.AddDamageData = function(_, source, victim, ability, element, hittype, damage, resist, srcGUID, srcFlags, dstGUID, dstFlags, spellId, blocked, absorbed, isDot)
			
			
			local tn = select(1,source)
			
			if tn == oldname then
				recountfunc(_, newname, victim, ability, element, hittype, damage, resist, srcGUID, srcFlags, dstGUID, dstFlags, spellId, blocked, absorbed, isDot)
			else
				recountfunc(_, source, victim, ability, element, hittype, damage, resist, srcGUID, srcFlags, dstGUID, dstFlags, spellId, blocked, absorbed, isDot)
			end
			
		end
	
	end

end)
--[[
local nameplatechange = CreateFrame("Frame")
nameplatechange:Hide()
nameplatechange:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplatechange:SetScript("OnEvent", function(self, event, unit)
	
	if event == "NAME_PLATE_UNIT_ADDED" then
	
		if UnitIsUnit('player',unit) then
			
			print(123)
			
		end
		
	end

end)

function ShowNamePlateTexture(unit)
    local np = C_NamePlate.GetNamePlateForUnit(unit)
    if np and not np.tex then
        np.tex = CreateFrame("PlayerModel", nil, np)
        np.tex:SetPoint("BOTTOM", np, "TOP")
        np.tex:SetSize(200, 200)
        np.tex:SetDisplayInfo(21723) -- Murloc Costume
    end
end
]]