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
title.Size = UDim2.new(1, -90, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "📦 Escaneo Profundo de Juego (mascotas ocultas)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- Botón minimizar
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -55, 0, 5)
minimize.Text = "_"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Botón cerrar
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.new(1, 0.5, 0.5)
close.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Caja de resultados
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

-- Botón escanear
local boton = Instance.new("TextButton", frame)
boton.Size = UDim2.new(0.5, -15, 0, 40)
boton.Position = UDim2.new(0, 10, 1, -50)
boton.Text = "🔍 Escanear todo el juego"
boton.BackgroundColor3 = Color3.fromRGB(45, 45, 90)
boton.TextColor3 = Color3.new(1, 1, 1)
boton.Font = Enum.Font.SourceSansBold
boton.TextSize = 16

-- Botón copiar
local copiar = Instance.new("TextButton", frame)
copiar.Size = UDim2.new(0.5, -15, 0, 40)
copiar.Position = UDim2.new(0.5, 5, 1, -50)
copiar.Text = "📋 Copiar resultados"
copiar.BackgroundColor3 = Color3.fromRGB(45, 90, 45)
copiar.TextColor3 = Color3.new(1, 1, 1)
copiar.Font = Enum.Font.SourceSansBold
copiar.TextSize = 16

-- Función para agregar texto
local function log(text)
	box.Text = box.Text .. text .. "\n"
end

-- Palabras clave
local palabrasClave = {"Glimmer", "Sprite", "Pet", "KG", "Age", "Shovel", "Destroy"}

local function contienePalabrasClave(text)
	for _, palabra in pairs(palabrasClave) do
		if string.lower(tostring(text)):find(string.lower(palabra)) then
			return true
		end
	end
	return false
end

-- Escaneo en chunks (no congela)
local function escanearProfundamente()
	log("[ESCANEO] Buscando en todo el juego...")
	local objetos = game:GetDescendants()
	local total = #objetos
	local encontrados = 0

	local i = 0
	while i < total do
		for j = 1, 300 do -- procesa de 300 en 300
			i = i + 1
			local obj = objetos[i]
			if not obj then break end

			pcall(function()
				if obj:IsA("TextLabel") or obj:IsA("StringValue") or obj:IsA("TextBox") then
					local texto = obj.Text or obj.Value
					if contienePalabrasClave(texto) then
						encontrados += 1
						log("✅ [" .. obj.ClassName .. "] " .. obj:GetFullName())
					end
				elseif obj:IsA("ModuleScript") or obj:IsA("LocalScript") then
					if contienePalabrasClave(obj.Name) then
						encontrados += 1
						log("📘 Script con nombre clave: " .. obj:GetFullName())
					end
				elseif contienePalabrasClave(obj.Name) then
					encontrados += 1
					log("📦 Objeto con nombre clave: " .. obj:GetFullName())
				end
			end)
		end
		task.wait(0.05) -- respiro, evita freeze
	end

	log("[FIN] Escaneo terminado. Objetos encontrados: " .. encontrados)
end

-- Eventos botones
boton.MouseButton1Click:Connect(function()
	escanearProfundamente()
end)

copiar.MouseButton1Click:Connect(function()
	if setclipboard then
		pcall(function()
			setclipboard(box.Text)
			log("[INFO] Resultados copiados al portapapeles.")
		end)
	else
		log("[ERROR] setclipboard no disponible en este exploit.")
	end
end)

close.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	box.Visible = not minimized
	boton.Visible = not minimized
	copiar.Visible = not minimized
end)
