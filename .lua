-- HUB SIMPLES - INVIS + NOCLIP
-- Funciona em Player e Vehicle

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ativo = false
local noclipConn

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "HubInvis"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 200, 0, 60)
btn.Position = UDim2.new(0, 20, 0.5, -30)
btn.Text = "OFF"
btn.TextSize = 24
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.BorderSizePixel = 0
btn.Font = Enum.Font.SourceSansBold
btn.Draggable = true
btn.Active = true

-- FUNÇÕES
local function setInvisible(state)
	local char = player.Character
	if not char then return end

	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = state and 1 or 0
			v.CanCollide = not state
		end
		if v:IsA("Decal") then
			v.Transparency = state and 1 or 0
		end
	end
end

local function noclip(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			local char = player.Character
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
			noclipConn = nil
		end
	end
end

local function invisVehicle(state)
	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum and hum.SeatPart and hum.SeatPart.Parent then
		for _,v in pairs(hum.SeatPart.Parent:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = state and 1 or 0
				v.CanCollide = not state
			end
		end
	end
end

-- BOTÃO
btn.MouseButton1Click:Connect(function()
	ativo = not ativo

	if ativo then
		btn.Text = "ON"
		btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		setInvisible(true)
		noclip(true)
		invisVehicle(true)
	else
		btn.Text = "OFF"
		btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		setInvisible(false)
		noclip(false)
		invisVehicle(false)
	end
end)
