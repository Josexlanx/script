local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "LocalPetClonerUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.4, 0, 0.45, 0)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔍 Buscar y clonar mascota propia (solo cliente)"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Log Box
local logBox = Instance.new("TextBox", frame)
logBox.Size = UDim2.new(1, -10, 1, -100)
logBox.Position = UDim2.new(0, 5, 0, 35)
logBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
logBox.TextColor3 = Color3.fromRGB(0, 255, 0)
logBox.ClearTextOnFocus = false
logBox.MultiLine = true
logBox.TextWrapped = false
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.Text = "[LOG] UI cargada. Presiona buscar.\n"

local function log(text)
	logBox.Text = logBox.Text .. text .. "\n"
end

-- Botón Buscar mascotas
local scanBtn = Instance.new("TextButton", frame)
scanBtn.Size = UDim2.new(0.5, -2, 0, 30)
scanBtn.Position = UDim2.new(0, 0, 1, -30)
scanBtn.Text = "🔍 Buscar mascota en inventario"
scanBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.Gotham
scanBtn.TextSize = 13

-- Botón Clonar visual
local cloneBtn = Instance.new("TextButton", frame)
cloneBtn.Size = UDim2.new(0.5, -2, 0, 30)
cloneBtn.Position = UDim2.new(0.5, 2, 1, -30)
cloneBtn.Text = "🐶 Clonar visualmente"
cloneBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
cloneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cloneBtn.Font = Enum.Font.Gotham
cloneBtn.TextSize = 13

-- Minimizar y cerrar
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "✖"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -60, 0, 0)
toggleBtn.Text = "🞃"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14

-- Setup
title.Parent = frame
logBox.Parent = frame
scanBtn.Parent = frame
cloneBtn.Parent = frame
closeBtn.Parent = frame
toggleBtn.Parent = frame
frame.Parent = screenGui

local lastPetModel = nil

-- Buscar mascota en inventario
scanBtn.MouseButton1Click:Connect(function()
	log("🔎 Escaneando inventario del jugador...")
	lastPetModel = nil

	for _, container in pairs({player:FindFirstChild("Backpack"), player:FindFirstChild("Pets"), player:FindFirstChild("Inventory")}) do
		if container then
			for _, item in pairs(container:GetChildren()) do
				if item:IsA("Model") or item:IsA("Tool") then
					log("✅ Mascota encontrada: " .. item.Name)
					lastPetModel = item
					break
				end
			end
		end
	end

	if not lastPetModel then
		log("⚠️ No se encontró ninguna mascota model accesible.")
	end
end)

-- Clonar mascota visual
cloneBtn.MouseButton1Click:Connect(function()
	if not lastPetModel then
		log("❌ No hay mascota seleccionada. Haz una búsqueda primero.")
		return
	end

	local clone = lastPetModel:Clone()
	clone.Name = "Visual_" .. lastPetModel.Name
	clone.Parent = workspace

	log("🎉 Mascota '" .. lastPetModel.Name .. "' clonada en Workspace.")

	-- Seguir al jugador
	local char = player.Character or player.CharacterAdded:Wait()
	task.spawn(function()
		while clone and clone:FindFirstChild("PrimaryPart") and char and char:FindFirstChild("HumanoidRootPart") do
			clone:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.new(3, 0, 2))
			task.wait(0.15)
		end
	end)
end)

-- Minimizar
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	logBox.Visible = not minimized
	scanBtn.Visible = not minimized
	cloneBtn.Visible = not minimized
	toggleBtn.Text = minimized and "🞁" or "🞃"
end)

-- Cerrar
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
