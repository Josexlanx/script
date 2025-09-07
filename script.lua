-- UI + Local Visual Pet Spawner (sin RemoteEvents)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- ---------- UI ----------
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PetFinderUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.46, 0, 0.58, 0)
frame.Position = UDim2.new(0.27, 0, 0.21, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0

local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.Text = "🐾 Buscar nombre/ID real y clonar visual (solo cliente)"
header.BackgroundColor3 = Color3.fromRGB(45,45,45)
header.TextColor3 = Color3.fromRGB(255,255,255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14

local logBox = Instance.new("TextBox", frame)
logBox.Size = UDim2.new(1, -10, 1, -160)
logBox.Position = UDim2.new(0, 5, 0, 35)
logBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
logBox.TextColor3 = Color3.fromRGB(0,255,120)
logBox.ClearTextOnFocus = false
logBox.MultiLine = true
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.Text = "[LOG] Listo. Usa los botones para detectar tu mascota.\n"

local function log(t) logBox.Text = logBox.Text .. t .. "\n" end

local petNameInput = Instance.new("TextBox", frame)
petNameInput.Size = UDim2.new(1, -10, 0, 26)
petNameInput.Position = UDim2.new(0, 5, 1, -124)
petNameInput.PlaceholderText = "Nombre exacto (se autocompleta si se detecta). Ej: Glimmering Sprite"
petNameInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
petNameInput.TextColor3 = Color3.fromRGB(255,255,255)
petNameInput.Font = Enum.Font.Code
petNameInput.TextSize = 14
petNameInput.ClearTextOnFocus = false

local scanInvBtn = Instance.new("TextButton", frame)
scanInvBtn.Size = UDim2.new(0.5, -2, 0, 30)
scanInvBtn.Position = UDim2.new(0, 0, 1, -90)
scanInvBtn.Text = "📂 Buscar en Player (Owned/Active Pets)"
scanInvBtn.BackgroundColor3 = Color3.fromRGB(30,90,150)
scanInvBtn.TextColor3 = Color3.fromRGB(255,255,255)
scanInvBtn.Font = Enum.Font.Gotham
scanInvBtn.TextSize = 14

local scanWorldBtn = Instance.new("TextButton", frame)
scanWorldBtn.Size = UDim2.new(0.5, -2, 0, 30)
scanWorldBtn.Position = UDim2.new(0.5, 2, 1, -90)
scanWorldBtn.Text = "🛰️ Leer letrero (BillboardGui) cercano"
scanWorldBtn.BackgroundColor3 = Color3.fromRGB(100,90,30)
scanWorldBtn.TextColor3 = Color3.fromRGB(255,255,255)
scanWorldBtn.Font = Enum.Font.Gotham
scanWorldBtn.TextSize = 14

local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Size = UDim2.new(0.5, -2, 0, 30)
spawnBtn.Position = UDim2.new(0, 0, 1, -54)
spawnBtn.Text = "🐶 Clonar visualmente (sin FireServer)"
spawnBtn.BackgroundColor3 = Color3.fromRGB(40,120,60)
spawnBtn.TextColor3 = Color3.fromRGB(255,255,255)
spawnBtn.Font = Enum.Font.Gotham
spawnBtn.TextSize = 14

local copyBtn = Instance.new("TextButton", frame)
copyBtn.Size = UDim2.new(0.5, -2, 0, 30)
copyBtn.Position = UDim2.new(0.5, 2, 1, -54)
copyBtn.Text = "📋 Copiar log"
copyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
copyBtn.Font = Enum.Font.Gotham
copyBtn.TextSize = 14

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-60,0,0)
minBtn.Text = "🞃"
minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.Text = "✖"
closeBtn.BackgroundColor3 = Color3.fromRGB(90,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14

copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard(logBox.Text); log("📋 Copiado al portapapeles.") else log("❌ setclipboard no disponible.") end
end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
local minimized=false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	logBox.Visible = not minimized
	petNameInput.Visible = not minimized
	scanInvBtn.Visible = not minimized
	scanWorldBtn.Visible = not minimized
	spawnBtn.Visible = not minimized
	copyBtn.Visible = not minimized
	minBtn.Text = minimized and "🞁" or "🞃"
end)

-- ---------- Utilidades de detección ----------
local function distance(a, b)
	if not a or not b then return math.huge end
	return (a.Position - b.Position).Magnitude
end

-- lee StringValue/BoolValue con nombres de mascota dentro de carpetas que contienen "Pet"
local function scanOwnedPetNames()
	local names = {}
	for _,desc in ipairs(lp:GetDescendants()) do
		if (desc:IsA("StringValue") or desc:IsA("BoolValue") or desc:IsA("IntValue")) then
			local p = desc.Parent
			local pname = (p and p.Name:lower()) or ""
			if pname:find("pet") or pname:find("ownedpet") or pname:find("activepet") or pname:find("slot") then
				-- filtra valores que parecen nombres
				if desc:IsA("StringValue") and #desc.Value > 0 then
					table.insert(names, desc.Value)
				elseif desc.Name and #desc.Name > 0 and (desc.Value==true or desc.Value==1) then
					table.insert(names, desc.Name)
				end
			end
		end
	end
	return names
end

-- busca el BillboardGui más cercano y toma la PRIMERA LÍNEA como nombre
local function scanBillboardNameNearby()
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local best, bestDist, bestText = nil, 25, nil  -- radio 25 studs
	for _,guiObj in ipairs(workspace:GetDescendants()) do
		if guiObj:IsA("TextLabel") or guiObj:IsA("TextBox") then
			local txt = tostring(guiObj.Text or "")
			if txt and #txt > 0 and (txt:find("KG") or txt:find("Age") or txt:find("%[.+%]")) then
				local adornee = nil
				if guiObj.Parent and guiObj.Parent:IsA("BillboardGui") then
					adornee = guiObj.Parent.Adornee or guiObj.Parent.Parent
				end
				-- intenta usar el objeto físico más cercano relacionado
				local part = adornee
				if not part then
					-- fallback: subir hasta encontrar BasePart
					local n = guiObj
					while n and not n:IsA("BasePart") do n = n.Parent end
					part = n
				end
				if part and part:IsA("BasePart") then
					local d = distance(hrp, part)
					if d < bestDist then
						bestDist = d
						best = guiObj
						bestText = txt
					end
				end
			end
		end
	end
	if best and bestText then
		local firstLine = bestText:split("\n")[1]
		-- también recorta cosas después de " ["
		firstLine = firstLine:gsub("%s+$","")
		firstLine = firstLine:gsub("%s*%[.*$", "")
		return firstLine
	end
	return nil
end

-- devuelve un modelo de mascota por nombre desde ReplicatedStorage
local function getPetModelByName(name)
	if not name or name == "" then return nil end
	local folders = {ReplicatedStorage:FindFirstChild("Pets"), ReplicatedStorage:FindFirstChild("PetModels"), ReplicatedStorage:FindFirstChild("Assets")}
	for _,f in ipairs(folders) do
		if f and f:FindFirstChild(name) then
			return f:FindFirstChild(name)
		end
	end
	-- búsqueda amplia por descendientes (más lenta)
	for _,f in ipairs(folders) do
		if f then
			for _,d in ipairs(f:GetDescendants()) do
				if d.Name == name and d:IsA("Model") then return d end
			end
		end
	end
	return nil
end

-- ---------- Botones ----------
scanInvBtn.MouseButton1Click:Connect(function()
	log("\n📂 Buscando nombres en tus datos de Player…")
	local names = scanOwnedPetNames()
	if #names == 0 then
		log("⚠️ No se encontraron nombres en Owned/Active/Slots (lado cliente).")
	else
		for _,n in ipairs(names) do log("✅ Encontrado (player data): ".. n) end
		petNameInput.Text = names[1]
		log("➡️ Usando: "..names[1].." (puedes editarlo).")
	end
end)

scanWorldBtn.MouseButton1Click:Connect(function()
	log("\n🛰️ Buscando BillboardGui cercano con nombre de mascota…")
	local n = scanBillboardNameNearby()
	if n then
		log("✅ Detectado por letrero: "..n)
		petNameInput.Text = n
	else
		log("⚠️ No se encontró un letrero de mascota cerca (acércate a tu pet).")
	end
end)

spawnBtn.MouseButton1Click:Connect(function()
	local targetName = petNameInput.Text
	if targetName == "" then log("⚠️ Escribe o detecta un nombre primero."); return end

	log("🔎 Buscando modelo en ReplicatedStorage: "..targetName)
	local model = getPetModelByName(targetName)
	if not model then
		log("❌ No se encontró el modelo '"..targetName.."' en ReplicatedStorage.(Pets/PetModels/Assets)")
		return
	end

	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local clone = model:Clone()
	clone.Name = "Visual_"..targetName
	clone.Parent = workspace

	-- Asegurar PrimaryPart
	if not clone.PrimaryPart then
		for _,d in ipairs(clone:GetDescendants()) do
			if d:IsA("BasePart") then clone.PrimaryPart = d; break end
		end
	end

	if not clone.PrimaryPart then
		log("⚠️ Clonado sin PrimaryPart; no podrá seguirte.")
	else
		log("🎉 Clonado visual de '"..targetName.."' listo. (solo cliente)")
		-- seguidor simple
		task.spawn(function()
			while clone and clone.Parent do
				if hrp and clone.PrimaryPart then
					clone:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(2,0,2))
				end
				RunService.Heartbeat:Wait()
			end
		end)
	end
end)
