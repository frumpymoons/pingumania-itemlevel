local _E
local hook
local selectedRecipeID

local function update(self)
	if (not TradeSkillFrame:IsVisible()) then return end
	local recipeID = self.RecipeList:GetSelectedRecipeID()
	selectedRecipeID = recipeID and recipeID or nil
	if not selectedRecipeID then return end

	local itemLink = C_TradeSkillUI.GetRecipeItemLink(selectedRecipeID)
	SyLevel:CallFilters("tradeskill", TradeSkillFrame.DetailsFrame.Contents.ResultIcon, _E and itemLink)

	local numReagents = C_TradeSkillUI.GetRecipeNumReagents(selectedRecipeID)
	for reagentIndex = 1, numReagents do
		local reagentFrame = TradeSkillFrame.DetailsFrame.Contents.Reagents[reagentIndex]
		local reagentLink = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipeID, reagentIndex)
		SyLevel:CallFilters("tradeskill", reagentFrame, _E and reagentLink)
	end
end

local function doHook()
	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end

		hooksecurefunc(TradeSkillFrame, "OnRecipeChanged", hook)
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == "Blizzard_TradeSkillUI") then
		doHook()
		self:UnregisterEvent(event, ADDON_LOADED)
	end
end

local function enable(self)
	_E = true

	if (IsAddOnLoaded("Blizzard_TradeSkillUI")) then
		doHook()
	else
		self:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable(self)
	_E = nil
	self:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
end

SyLevel:RegisterPipe("tradeskill", enable, disable, update, "Profession Window", nil)