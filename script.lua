local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ScanDeepUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 600, 0, 350)
frame.Position = UDim2.new(0.5, -300, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "📦 Escaneo Profundo de Juego (mascotas ocultas)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.new(1, 0.5, 0.5)
close.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 1, -100)
box.Position = UDim2.new(0, 10, 0, 40)
box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
box.TextColor3 = Color3.fromRGB(0, 255, 0)
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextSize = 14
box.Font = Enum.Font.Code
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextWrapped = true
box.Text = "[LOG] Cargado. Presiona 'Escanear'.\n"

local boton = Instance.new("TextButton", frame)
boton.Size = UDim2.new(1, -20, 0, 40)
boton.Position = UDim2.new(0, 10, 1, -50)
boton.Text = "🔍 Escanear todo el juego"
boton.BackgroundColor3 = Color3.fromRGB(45, 45, 90)
boton.TextColor3 = Color3.new(1, 1, 1)
boton.Font = Enum.Font.SourceSansBold
boton.TextSize = 16

close.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local palabrasClave = {"Glimmer", "Sprite", "Pet", "KG", "Age", "Destroy", "Plants"}

local function contienePalabrasClave(text)
	for _, palabra in pairs(palabrasClave) do
		if string.lower(tostring(text)):find(string.lower(palabra)) then
			return true
		end
	end
	return false
end

-- Escaneo total
local function escanearProfundamente()
	box.Text = box.Text .. "[ESCANEO] Escaneando todos los objetos del juego...\n"

	local total = 0
	for _, obj in pairs(game:GetDescendants()) do
		pcall(function()
			if obj:IsA("TextLabel") or obj:IsA("StringValue") or obj:IsA("TextBox") then
				if contienePalabrasClave(obj.Text or obj.Value) then
					total += 1
					box.Text = box.Text .. "✅ [" .. obj.ClassName .. "] → " .. obj:GetFullName() .. "\n"
				end
			elseif obj:IsA("ModuleScript") or obj:IsA("LocalScript") then
				local src = obj.Source
				if contienePalabrasClave(src) then
					total += 1
					box.Text = box.Text .. "📘 Código con nombre clave → " .. obj:GetFullName() .. "\n"
				end
			end
		end)
	end

	box.Text = box.Text .. "\n[FIN] Resultados encontrados: " .. tostring(total) .. "\n"
end

-- Evento del botón
boton.MouseButton1Click:Connect(function()
	escanearProfundamente()
end)
