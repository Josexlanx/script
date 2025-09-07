-- UI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ScanButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local OutputBox = Instance.new("TextBox")
local Copy1 = Instance.new("TextButton")
local Copy2 = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "ScanMascotasUI"

MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

ScanButton.Size = UDim2.new(0, 100, 0, 30)
ScanButton.Position = UDim2.new(0, 10, 0, 10)
ScanButton.Text = "Buscar Mascotas"
ScanButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
ScanButton.TextColor3 = Color3.new(1, 1, 1)
ScanButton.Parent = MainFrame

CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Parent = MainFrame

OutputBox.Size = UDim2.new(1, -20, 0, 250)
OutputBox.Position = UDim2.new(0, 10, 0, 50)
OutputBox.Text = ""
OutputBox.TextWrapped = false
OutputBox.TextXAlignment = Enum.TextXAlignment.Left
OutputBox.TextYAlignment = Enum.TextYAlignment.Top
OutputBox.ClearTextOnFocus = false
OutputBox.MultiLine = true
OutputBox.TextEditable = false
OutputBox.TextSize = 14
OutputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OutputBox.TextColor3 = Color3.new(1, 1, 1)
OutputBox.Parent = MainFrame

Copy1.Size = UDim2.new(0, 100, 0, 30)
Copy1.Position = UDim2.new(0, 10, 1, -40)
Copy1.Text = "Copiar Parte 1"
Copy1.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
Copy1.TextColor3 = Color3.new(1, 1, 1)
Copy1.Parent = MainFrame

Copy2.Size = UDim2.new(0, 100, 0, 30)
Copy2.Position = UDim2.new(0, 120, 1, -40)
Copy2.Text = "Copiar Parte 2"
Copy2.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
Copy2.TextColor3 = Color3.new(1, 1, 1)
Copy2.Parent = MainFrame

-- VARIABLES
local resultados = {}

-- ESCANEAR MASCOTAS
ScanButton.MouseButton1Click:Connect(function()
    OutputBox.Text = "[ESCANEO] Buscando posibles mascotas visuales...\n"
    resultados = {}

    local function checkInstance(obj)
        if obj:IsA("Model") or obj:IsA("Tool") then
            if tostring(obj):lower():find("pet") or tostring(obj):lower():find("mascota") then
                table.insert(resultados, obj:GetFullName())
            end
        end
        for _, child in ipairs(obj:GetChildren()) do
            checkInstance(child)
        end
    end

    checkInstance(game.Players.LocalPlayer)
    checkInstance(game.Workspace)
    checkInstance(game.ReplicatedStorage)
    checkInstance(game:GetService("Lighting"))

    -- Mostrar resultados en la caja
    OutputBox.Text = OutputBox.Text .. "[FIN] Escaneo completado.\n\n"

    for i, v in ipairs(resultados) do
        OutputBox.Text = OutputBox.Text .. "[" .. i .. "] " .. v .. "\n"
    end
end)

-- BOTONES DE COPIA (en partes)
Copy1.MouseButton1Click:Connect(function()
    local parte1 = ""
    for i = 1, math.min(#resultados, 50) do
        parte1 = parte1 .. "["..i.."] " .. resultados[i] .. "\n"
    end
    setclipboard(parte1)
end)

Copy2.MouseButton1Click:Connect(function()
    local parte2 = ""
    for i = 51, math.min(#resultados, 100) do
        parte2 = parte2 .. "["..i.."] " .. resultados[i] .. "\n"
    end
    setclipboard(parte2)
end)

-- CERRAR UI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
