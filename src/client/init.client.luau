local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage").RemoteEvents
local spinwheelEvent = Remotes:WaitForChild("SpinWheel")

local wheelSpinGui = script.Parent
local rewardText = wheelSpinGui.Message
local exitButton = wheelSpinGui.Back
local Spin1 = wheelSpinGui.Spin1
local Spin10 = wheelSpinGui.Spin10
local Spin100 = wheelSpinGui.Spin100
local doubleLuck = wheelSpinGui.DoubleLuck
local rewardText = wheelSpinGui.Message
local rewardsName = {
	["1"] = "+250 coins",
	["2"] = "Capybara",
	["3"] = "+1 skip",
	["4"] = "+1000 coins",
	["5"] = "+1 extra spin",
}

local function animateSize(object, targetSize, duration)
	TweenService:Create(object, TweenInfo.new(duration), {Size = targetSize}):Play()
end

local function handleHover(button)
	local originalSize = button.Size
	local hoverSize = originalSize + UDim2.new(0.02, 0, 0.02, 0)

	button.MouseEnter:Connect(function()
		animateSize(button, hoverSize, 0.1)
	end)

	button.MouseLeave:Connect(function()
		animateSize(button, originalSize, 0.1)
	end)
end

local function handleClick(button, action)
	local originalSize = button.Size
	local clickSize = originalSize - UDim2.new(0.02, 0, 0.02, 0)

	if SoundService.SFX:FindFirstChild("ClickSound") then
		SoundService.SFX.ClickSound:Play()
	end

	animateSize(button, clickSize, 0.1)
	task.wait(0.1)
	animateSize(button, originalSize, 0.1)
end

exitButton.Button.Activated:Connect(function()
	handleClick(exitButton)
	TweenService:Create(wheelSpinGui.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 2, 0)}):Play()
	wheelSpinGui.Parent:SetAttribute("Up", false)
end)

local db = false
Spin1.Button.Activated:Connect(function()
	if db == false then
		handleClick(Spin1)
		db = true
		local spins = player:WaitForChild("hidden"):WaitForChild("Spins")
		if spins.Value >= 1 then
			Spin1.Button.Label.Text = "SPINNING"
			spinwheelEvent:FireServer()
		else
			MarketplaceService:PromptProductPurchase(player, 3280017553)
		end
		task.wait(5)
		db = false
		Spin1.Button.Label.Text = "SPIN"
	end
end)

Spin10.Button.Activated:Connect(function()
	handleClick(Spin10)
	MarketplaceService:PromptProductPurchase(player, 3279999904)
end)

Spin100.Button.Activated:Connect(function()
	handleClick(Spin100)
	MarketplaceService:PromptProductPurchase(player, 3279999903)
end)

doubleLuck.Button.Activated:Connect(function()
	handleClick(doubleLuck)
	MarketplaceService:PromptGamePassPurchase(player, 1195177091)
end)

spinwheelEvent.OnClientEvent:Connect(function(Reward)
	local spinFrame = wheelSpinGui.Main.SpinFrame
	local rewardAngles = {
		["1"] = 180,
		["2"] = 108,
		["3"] = 324,
		["4"] = 36,
		["5"] = 252,
	}

	local Rotation = rewardAngles[Reward]
	spinFrame.Rotation = 0
	SoundService.SFX.Wheel:Play()

	local baseRotations = 360 * 5
	local finalRotation = baseRotations + Rotation

	TweenService:Create(spinFrame, TweenInfo.new(4.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Rotation = finalRotation
	}):Play()

	task.wait(5)

	SoundService.SFX.Wheel:Stop()

	local baseSize = rewardText.Size
	rewardText.Text = "You got " .. tostring(rewardsName[Reward]) .. "!"
	rewardText.Size = baseSize
	rewardText.Visible = true
	rewardText.TextTransparency = 1
	rewardText.TextStrokeTransparency = 1
	SoundService.SFX.Reward:Play()

	TweenService:Create(rewardText, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		TextTransparency = 0,
		TextStrokeTransparency = 0,
		Size = UDim2.new(0.31, 0, 0.05, 0)
	}):Play()

	task.delay(2.5, function()
		TweenService:Create(rewardText, TweenInfo.new(0.3), {
			TextTransparency = 1,
			TextStrokeTransparency = 1,
			Size = baseSize
		}):Play()
	end)
end)

for _, button in ipairs(wheelSpinGui:GetChildren()) do
	if button:IsA("Frame") and button:FindFirstChild("Button") then
		handleHover(button)
	end
end

local function update()
	Spin1.Spins.Text = player.hidden.Spins.Value .. " SPINS"
end
player:WaitForChild("hidden"):WaitForChild("Spins").Changed:Connect(update)
update()