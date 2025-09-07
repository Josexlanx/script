-- Enhanced futuristic UI with neon effects, glassmorphism, and smooth animations
-- UI principal futurista
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "FuturisticPetScannerUI"

-- Crear efectos de partículas de fondo
local backgroundFrame = Instance.new("Frame", screenGui)
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.ZIndex = -1

-- Gradiente de fondo futurista
local backgroundGradient = Instance.new("UIGradient", backgroundFrame)
backgroundGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(26, 26, 46)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 33, 62))
}
backgroundGradient.Rotation = 45

-- Frame principal con efecto glassmorphism
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.5, 0, 0.7, 0)
frame.Position = UDim2.new(0.25, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 145, 178)
frame.BackgroundTransparency = 0.85
frame.BorderSizePixel = 0

-- Efecto de brillo en el borde
local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(0, 212, 255)
frameStroke.Thickness = 2
frameStroke.Transparency = 0.3

-- Esquinas redondeadas
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

-- Efecto de sombra brillante
local frameShadow = Instance.new("ImageLabel", frame)
frameShadow.Size = UDim2.new(1, 20, 1, 20)
frameShadow.Position = UDim2.new(0, -10, 0, -10)
frameShadow.BackgroundTransparency = 1
frameShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
frameShadow.ImageColor3 = Color3.fromRGB(0, 212, 255)
frameShadow.ImageTransparency = 0.7
frameShadow.ZIndex = frame.ZIndex - 1

-- Título con efecto neón
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🚀 FUTURISTIC PET EVENT SCANNER"
title.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
title.BackgroundTransparency = 0.2
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(0, 212, 255)

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 8)

local titleStroke = Instance.new("UIStroke", title)
titleStroke.Color = Color3.fromRGB(139, 92, 246)
titleStroke.Thickness = 1
titleStroke.Transparency = 0.4

-- Área de log con efecto holográfico
local scrolling = Instance.new("TextBox", frame)
scrolling.Size = UDim2.new(1, -20, 1, -180)
scrolling.Position = UDim2.new(0, 10, 0, 50)
scrolling.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
scrolling.BackgroundTransparency = 0.3
scrolling.TextColor3 = Color3.fromRGB(0, 255, 127)
scrolling.ClearTextOnFocus = false
scrolling.MultiLine = true
scrolling.TextWrapped = false
scrolling.TextXAlignment = Enum.TextXAlignment.Left
scrolling.TextYAlignment = Enum.TextYAlignment.Top
scrolling.Font = Enum.Font.Code
scrolling.TextSize = 13
scrolling.Text = "[SISTEMA INICIADO] UI Futurista Lista.\n[MATRIZ] Conexión establecida...\n"

local scrollingCorner = Instance.new("UICorner", scrolling)
scrollingCorner.CornerRadius = UDim.new(0, 8)

local scrollingStroke = Instance.new("UIStroke", scrolling)
scrollingStroke.Color = Color3.fromRGB(0, 255, 127)
scrollingStroke.Thickness = 1
scrollingStroke.Transparency = 0.6

-- Función de log mejorada
local function log(text)
	local timestamp = os.date("[%H:%M:%S]")
	scrolling.Text = scrolling.Text .. timestamp .. " " .. text .. "\n"
end

-- Campo de entrada futurista
local petNameInput = Instance.new("TextBox", frame)
petNameInput.Size = UDim2.new(1, -20, 0, 35)
petNameInput.Position = UDim2.new(0, 10, 1, -120)
petNameInput.PlaceholderText = "▶ INGRESE NOMBRE DE MASCOTA (ej: Kappa)"
petNameInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
petNameInput.BackgroundTransparency = 0.9
petNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
petNameInput.Font = Enum.Font.GothamMedium
petNameInput.TextSize = 14
petNameInput.ClearTextOnFocus = false
petNameInput.Text = ""

local inputCorner = Instance.new("UICorner", petNameInput)
inputCorner.CornerRadius = UDim.new(0, 8)

local inputStroke = Instance.new("UIStroke", petNameInput)
inputStroke.Color = Color3.fromRGB(8, 145, 178)
inputStroke.Thickness = 2
inputStroke.Transparency = 0.4

-- Función para crear botones futuristas
local function createFuturisticButton(parent, size, position, text, color, textColor)
	local button = Instance.new("TextButton", parent)
	button.Size = size
	button.Position = position
	button.Text = text
	button.BackgroundColor3 = color
	button.BackgroundTransparency = 0.2
	button.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", button)
	stroke.Color = color
	stroke.Thickness = 2
	stroke.Transparency = 0.3
	
	-- Efecto hover
	button.MouseEnter:Connect(function()
		button.BackgroundTransparency = 0.1
		stroke.Transparency = 0.1
		button.TextStrokeTransparency = 0.5
		button.TextStrokeColor3 = color
	end)
	
	button.MouseLeave:Connect(function()
		button.BackgroundTransparency = 0.2
		stroke.Transparency = 0.3
		button.TextStrokeTransparency = 1
	end)
	
	return button
end

-- Botones con diseño futurista
local copyBtn = createFuturisticButton(
	frame,
	UDim2.new(0.48, 0, 0, 35),
	UDim2.new(0, 10, 1, -40),
	"📡 COPIAR DATOS",
	Color3.fromRGB(107, 114, 128)
)

local scanBtn = createFuturisticButton(
	frame,
	UDim2.new(0.48, 0, 0, 35),
	UDim2.new(0, 10, 1, -160),
	"🔍 ESCANEAR EVENTOS",
	Color3.fromRGB(8, 145, 178)
)

local testBtn = createFuturisticButton(
	frame,
	UDim2.new(0.48, 0, 0, 35),
	UDim2.new(0.52, 0, 1, -160),
	"⚡ EJECUTAR PROTOCOLO",
	Color3.fromRGB(99, 102, 241)
)

local scanNamesBtn = createFuturisticButton(
	frame,
	UDim2.new(0.48, 0, 0, 35),
	UDim2.new(0.52, 0, 1, -40),
	"🎯 ANALIZAR MASCOTAS",
	Color3.fromRGB(139, 92, 246)
)

-- Botones de control con efectos especiales
local toggleBtn = createFuturisticButton(
	frame,
	UDim2.new(0, 35, 0, 35),
	UDim2.new(1, -75, 0, 5),
	"◐",
	Color3.fromRGB(75, 85, 99)
)

local closeBtn = createFuturisticButton(
	frame,
	UDim2.new(0, 35, 0, 35),
	UDim2.new(1, -35, 0, 5),
	"✕",
	Color3.fromRGB(255, 77, 77)
)

-- Eventos con mensajes futuristas
local replicated = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents")
local petEvents = {}

copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(scrolling.Text)
		log("[TRANSFERENCIA] Datos copiados al buffer cuántico.")
	else
		log("[ERROR] Fallo en transferencia de datos.")
	end
end)

scanBtn.MouseButton1Click:Connect(function()
	petEvents = {}
	log("\n[INICIANDO] Escaneo de matriz de eventos...")
	log("[RADAR] Buscando señales de mascotas...")
	
	for _, child in pairs(replicated:GetChildren()) do
		if child:IsA("RemoteEvent") and (child.Name:lower():find("pet") or child.Name:lower():find("egg")) then
			table.insert(petEvents, child)
			log("[DETECTADO] ▶ " .. child.Name .. " ◀ Señal capturada")
		end
	end
	log("[COMPLETADO] Total de eventos detectados: " .. tostring(#petEvents))
	log("[SISTEMA] Listo para ejecutar protocolos.")
end)

testBtn.MouseButton1Click:Connect(function()
	local petName = petNameInput.Text
	if petName == "" then
		log("[ADVERTENCIA] Nombre de mascota requerido para continuar.")
		return
	end

	if #petEvents == 0 then
		log("[ERROR] No hay eventos en memoria. Ejecute escaneo primero.")
		return
	end

	log("[EJECUTANDO] Protocolo de activación con objetivo: " .. petName)
	log("[TRANSMITIENDO] Enviando señales cuánticas...")
	
	for _, evt in ipairs(petEvents) do
		pcall(function()
			evt:FireServer(petName)
			log("[ENVIADO] ▶ " .. evt.Name .. " ◀ Protocolo transmitido")
		end)
	end
	log("[COMPLETADO] Secuencia de activación finalizada.")
end)

scanNamesBtn.MouseButton1Click:Connect(function()
	log("\n[ANALIZANDO] Explorando base de datos de mascotas...")
	local folder = game:GetService("ReplicatedStorage"):FindFirstChild("Pets")
	if folder then
		log("[ACCESO] Conexión establecida con ReplicatedStorage.Pets")
		for _, pet in pairs(folder:GetChildren()) do
			log("[REGISTRO] ▶ " .. pet.Name .. " ◀ Mascota catalogada")
		end
		log("[ANÁLISIS] Exploración de base de datos completada.")
	else
		log("[ERROR] No se pudo acceder a ReplicatedStorage.Pets")
		log("[SUGERENCIA] Verifique la conexión con la matriz.")
	end
end)

-- Minimizar / Maximizar con animación
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	-- Animación suave
	local targetSize = minimized and UDim2.new(0.5, 0, 0, 45) or UDim2.new(0.5, 0, 0.7, 0)
	
	frame:TweenSize(targetSize, "Out", "Quad", 0.3, true)
	
	scrolling.Visible = not minimized
	copyBtn.Visible = not minimized
	scanBtn.Visible = not minimized
	testBtn.Visible = not minimized
	petNameInput.Visible = not minimized
	scanNamesBtn.Visible = not minimized
	
	toggleBtn.Text = minimized and "◑" or "◐"
	
	if minimized then
		log("[SISTEMA] Interfaz minimizada - Modo stealth activado.")
	else
		log("[SISTEMA] Interfaz restaurada - Todos los sistemas operativos.")
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	log("[DESCONECTANDO] Cerrando conexión con la matriz...")
	wait(0.5)
	screenGui:Destroy()
end)

-- Efecto de parpadeo en el título
spawn(function()
	while screenGui.Parent do
		titleStroke.Transparency = 0.2
		wait(0.8)
		titleStroke.Transparency = 0.6
		wait(0.8)
	end
end)

-- Mensaje de bienvenida futurista
log("[BIENVENIDO] Sistema de Scanner Futurista v2.0")
log("[ESTADO] Todos los sistemas operativos.")
log("[CONSEJO] Use 'ESCANEAR EVENTOS' antes de ejecutar protocolos.")
