-- Servicios
local player = game.Players.LocalPlayer
local starterGui = game:GetService("StarterGui")
local ts = game:GetService("TextService")

-- Crear UI principal
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PetScannerUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Visible = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🔍 Escaneo de mascotas visuales (cliente)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimizar
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -50, 0, 5)
minimize.Text = "_"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimize.AutoButtonColor = false

-- Cerrar
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.new(1, 0.5, 0.5)
close.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
close.AutoButtonColor = false

-- Caja de texto de resultados
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 1, -100)
box.Position = UDim2.new(0, 10, 0, 40)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
box.TextColor3 = Color3.fromRGB(0, 255, 0)
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextSize = 14
box.Font = Enum.Font.Code
box.MultiLine = true
box.TextWrapped = true
box.Text = "[LOG] UI cargada. Presiona buscar.\n"

-- Botón buscar
local buscar = Instance.new("TextButton", frame)
buscar.Size = UDim2.new(0.5, -15, 0, 40)
buscar.Position = UDim2.new(0, 10, 1, -50)
buscar.Text = "🔍 Buscar mascotas"
buscar.BackgroundColor3 = Color3.fromRGB(45, 45, 90)
buscar.TextColor3 = Color3.new(1, 1, 1)
buscar.Font = Enum.Font.SourceSansBold
buscar.TextSize = 16

-- Botón copiar
local copiar = Instance.new("TextButton", frame)
copiar.Size = UDim2.new(0.5, -15, 0, 40)
copiar.Position = UDim2.new(0.5, 5, 1, -50)
copiar.Text = "📋 Copiar resultados"
copiar.BackgroundColor3 = Color3.fromRGB(45, 90, 45)
copiar.TextColor3 = Color3.new(1, 1, 1)
copiar.Font = Enum.Font.SourceSansBold
copiar.TextSize = 16

-- Función para detectar textos que parezcan de mascota
local function contieneKGyEdad(text)
	return text and text:find("KG") and text:find("Age")
end

-- Buscar mascotas visibles
local function buscarMascotas()
	box.Text = box.Text .. "[ESCANEO] Buscando mascotas visuales...\n"
	local yaDetectados = {}

	local function escanear(nombre, contenedor)
		if not contenedor then return end
		for _, obj in pairs(contenedor:GetDescendants()) do
			if obj:IsA("BillboardGui") then
				for _, child in pairs(obj:GetChildren()) do
					if child:IsA("TextLabel") and contieneKGyEdad(child.Text) then
						local model = obj:FindFirstAncestorWhichIsA("Model")
						if model and not yaDetectados[model] then
							yaDetectados[model] = true
							box.Text = box.Text .. "✅ Mascota en [" .. nombre .. "]: " .. model:GetFullName() .. "\n"
						end
					end
				end
			end
		end
	end

	escanear("Workspace", workspace)
	escanear("Backpack", player:FindFirstChild("Backpack"))
	escanear("Inventory", player:FindFirstChild("Inventory"))
	escanear("PlayerGui", player:FindFirstChild("PlayerGui"))
	escanear("Character", player.Character or player.CharacterAdded:Wait())
	escanear("ReplicatedStorage", game:GetService("ReplicatedStorage"))
	box.Text = box.Text .. "[FIN] Escaneo completo.\n"
end

-- Acciones botones
buscar.MouseButton1Click:Connect(buscarMascotas)

copiar.MouseButton1Click:Connect(function()
	setclipboard(box.Text)
	box.Text = box.Text .. "[INFO] Resultados copiados al portapapeles.\n"
end)

close.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	box.Visible = not minimized
	buscar.Visible = not minimized
	copiar.Visible = not minimized
end)
