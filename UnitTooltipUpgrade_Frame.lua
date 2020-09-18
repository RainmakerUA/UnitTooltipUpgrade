--[=====[
		## Unit Tooltip Upgrade ver. @@release-version@@
		## UnitTooltipUpgrade_Frame.lua - module
		Frame (Status Bar) module for UnitTooltipUpgrade addon
--]=====]

local addonName = ...
local UnitTooltipUpgrade = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Frame = UnitTooltipUpgrade:NewModule("Frame", "AceHook-3.0")

local F = Frame
local Bar = {}

UnitTooltipUpgradeStatusMixin = Bar

_G["UTU_STATUS_BACKDROP"] = {
								edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
								edgeSize = 10,
								insets = { left = 5, right = 5, top = 5, bottom = 5 },
							}

function Bar:OnLoad()
	self:SetFrameLevel(2)

	local level = self:GetFrameLevel()
	self.status:SetFrameLevel(level + 1)
	self.border:SetFrameLevel(level + 2)
end

function F:OnInitialize()
end

function F:OnEnable()
end

local function AddStatusBarFrame(tt, pool, min, max, value)
	local frame = pool:Acquire();
	local bar = frame.status

	bar:SetMinMaxValues(min, max)
	bar:SetValue(value)

	local fullHeight = GameTooltip_InsertFrame(tt, frame)
	local _, relative = frame:GetPoint(1)
	local freeHeight = fullHeight - frame:GetHeight()

	GameTooltip:SetMinimumWidth(160)
	frame:SetPoint("RIGHT", tt, "RIGHT", -10, 0)
	frame:SetPoint("TOPLEFT", relative, "TOPLEFT", 0, - freeHeight / 2)
	frame:Show()

	return frame
end

function F:CreateHealthBarFrame(parent, hp, maxhp, color)
	if not self.healthBarPool then
		self.healthBarPool = CreateFramePool("FRAME", nil, "UnitTooltipUpgradeStatus")
	else
		self.healthBarPool:ReleaseAll()
		self.frame = nil
	end

	local frame = AddStatusBarFrame(parent, self.healthBarPool, 0, maxhp, hp)
	GameTooltipStatusBar:Hide();

	local bar = frame.status
	local border = frame.border

	bar:SetStatusBarColor(unpack(color))
	border:SetBackdropBorderColor(unpack(color))

	local abbr = AbbreviateLargeNumbers

	border.leftText:SetText(("%.1f%%"):format(maxhp > 0 and ((hp / maxhp) * 100) or 0))
	border.rightText:SetText(("%s/%s"):format(abbr(hp), abbr(maxhp)));

	--@debug@
	self.frame = frame
	--@end-debug@

	return frame
end

function F:RemoveHealthBarFrame()
	if self.healthBarPool then
		self.healthBarPool:ReleaseAll()
		self.frame = nil
	end
end
