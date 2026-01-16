-- HUB ÚNICO: Scanner + Testador de Códigos (Legal)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- CONFIG (AJUSTE AO JOGO)
local REDEEM_TEXTBOX_NAME = "CodeBox"   -- nome do TextBox
local REDEEM_BUTTON_NAME  = "Redeem"    -- nome do botão

-- PADRÕES DE CÓDIGO
local patterns = {
	"%w%w%w%w%-%w%w%w%w",
	"%u%u%d%d%-%u%u%d%d"
}

local codes = {}
local tested = {}
local count = 0

-- UI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "CodeHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 340)
frame.Position = UDim2.new(0.02,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,5)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-10,0,30)
title.Text = "CODE HUB"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- ADD CÓDIGO
local function addCode(code)
	if tested[code] then return end
	for _,v in ipairs(codes) do
		if v == code then return end
	end

	count += 1
	codes[#codes+1] = code

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-10,0,26)
	lbl.BackgroundColor3 = Color3.fromRGB(35,35,35)
	lbl.TextColor3 = Color3.fromRGB(255,255,0)
	lbl.Text = "cod"..count..": "..code.." [PENDENTE]"
	lbl:SetAttribute("Code", code)
	lbl.Parent = frame
end

-- SCAN UI
local function scan(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		for _,p in ipairs(patterns) do
			for code in string.gmatch(obj.Text, p) do
				addCode(code)
			end
		end
	end
	for _,c in ipairs(obj:GetChildren()) do
		scan(c)
	end
end

-- LOOP SCAN
task.spawn(function()
	while true do
		scan(player.PlayerGui)
		task.wait(2)
	end
end)

-- LOOP TESTE
task.spawn(function()
	while true do
		for _,lbl in ipairs(frame:GetChildren()) do
			if lbl:IsA("TextLabel") and lbl:GetAttribute("Code") then
				local code = lbl:GetAttribute("Code")
				if not tested[code] then
					tested[code] = true

					local box = player.PlayerGui:FindFirstChild(REDEEM_TEXTBOX_NAME, true)
					local btn = player.PlayerGui:FindFirstChild(REDEEM_BUTTON_NAME, true)

					if box and btn and box:IsA("TextBox") then
						box.Text = code
						task.wait(0.2)
						btn:Activate()

						lbl.Text = lbl.Text:gsub("%[PENDENTE%]", "[TESTADO]")
						lbl.TextColor3 = Color3.fromRGB(0,255,0)
					else
						lbl.Text = lbl.Text:gsub("%[PENDENTE%]", "[ERRO UI]")
						lbl.TextColor3 = Color3.fromRGB(255,0,0)
					end

					task.wait(1)
				end
			end
		end
		task.wait(2)
	end
end)
