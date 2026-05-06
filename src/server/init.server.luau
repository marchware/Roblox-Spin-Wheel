local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")

local coinTake = ServerScriptService.Security.StageUpdater.CoinTake
local Remotes = ReplicatedStorage.RemoteEvents
local spinWheelEvent = Remotes:WaitForChild("SpinWheel")

local DataStore2 = require(ReplicatedStorage.Module.DataStore2)
local skipHandler = require(ServerScriptService.SkipHandler)
local invHandler = require(ServerScriptService.InventoryHandler)

DataStore2.Combine("DATA", "MinutesLeft")

local RewardsPercentage = {
	["1"] = 31,
	["2"] = 1,
	["3"] = 17,
	["4"] = 29,
	["5"] = 22,
}

local function getRandomReward(player)
	local ownsLuckPass = false
	local success, result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1195177091)
	end)
	if success and result then
		ownsLuckPass = true
	end

	local adjustedWeights = {}
	local totalWeight = 0

	for reward, weight in pairs(RewardsPercentage) do
		local adjustedWeight = weight
		if ownsLuckPass and (reward == "2" or reward == "3") then
			adjustedWeight = adjustedWeight * 2
		end
		adjustedWeights[reward] = adjustedWeight
		totalWeight += adjustedWeight
	end

	local randomNumber = math.random() * totalWeight
	local accumulatedWeight = 0

	for reward, weight in pairs(adjustedWeights) do
		accumulatedWeight += weight
		if accumulatedWeight >= randomNumber then
			return reward
		end
	end
end

local function giveSpins(player, amount)
	player:WaitForChild("hidden"):WaitForChild("Spins").Value = player:WaitForChild("hidden"):WaitForChild("Spins").Value + amount
end

spinWheelEvent.OnServerEvent:Connect(function(player)
	local spinData = player:WaitForChild("hidden"):WaitForChild("Spins")

	if spinData.Value < 1 then return end

	local reward = getRandomReward(player)
	if not reward then return end

	spinData.Value -= 1
	spinWheelEvent:FireClient(player, reward)

	task.wait(4.5)

	local rewardHandlers = {
		["1"] = function() coinTake:Fire(player, 250) end,
		["2"] = function() invHandler.AddItemToInventory(player, "Capybara") end,
		["3"] = function() skipHandler.AddSkips(player, 1) end,
		["4"] = function() coinTake:Fire(player, 1000) end,
		["5"] = function() giveSpins(player, 1) end,
	}

	if rewardHandlers[reward] then
		rewardHandlers[reward]()
	end
end)

script.GiveSpin.Event:Connect(function(player, amount)
	giveSpins(player, amount)
end)
