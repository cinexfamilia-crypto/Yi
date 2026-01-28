local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local ativo = false
local noclipConn
local char

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 200, 0, 60)
btn.Position = UDim2.new(0, 20, 0.5, -30)
btn.Text = "OFF"
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

-- FUNÇÕES
local function invis(state)
	if not char then return end

	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			if v.Name ~= "HumanoidRootPart" then
				v.Transparency = state and 1 or 0
			end
			v.CanCollide = not state
		end
		if v:IsA("Decal") then
			v.Transparency = state and 1 or 0
		end
	end

	-- some com o cubo
	if char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.Transparency = 1
	end
end

local function noclip(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			if char then
				for _,v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConn then
			noclipConn:Disconnect()
		end
	end
end

-- BOTÃO
btn.MouseButton1Click:Connect(function()
	ativo = not ativo

	if ativo then
		btn.Text = "ON"
		btn.BackgroundColor3 = Color3.fromRGB(0,200,0)
		invis(true)
		noclip(true)
	else
		btn.Text = "OFF"
		btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
		invis(false)
		noclip(false)
	end
end)

-- RECARREGAR AO MORRER
player.CharacterAdded:Connect(function(c)
	char = c
	wait(0.5)
	if ativo then
		invis(true)
	end
end)

char = player.Character
