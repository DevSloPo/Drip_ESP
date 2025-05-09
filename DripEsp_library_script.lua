local DripESP = {}
local connections = {}
local all_settings = {}
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local raycastConnection = nil
local raycastLines = {}

function DripESP.SetOptions(ESP_ID, opts)
    all_settings[ESP_ID] = {
        ModelName = opts.ModelName or "Model",
        CustomText = opts.CustomText or "模型",
        TextColor = opts.TextColor or Color3.fromRGB(0, 255, 255),
        OutlineColor = opts.OutlineColor or Color3.fromRGB(255, 0, 0),
        TextSize = opts.TextSize or 15,
        HighlightName = "ESP_Highlight_" .. ESP_ID,
        BillboardName = "ESP_Billboard_" .. ESP_ID,
        CheckForHumanoid = opts.CheckForHumanoid or false,
    }
end

local function applyESP(model, ESP_ID, settings)
    if not model:IsA("Model") or model.Name ~= settings.ModelName then return end
    if settings.CheckForHumanoid and not model:FindFirstChild("Humanoid") then return end

    local modelRoot = model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Torso")
        or model:FindFirstChild("Head")
        or model:FindFirstChildWhichIsA("BasePart")
    if not modelRoot then return end

    if not model:FindFirstChild(settings.BillboardName) then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = settings.BillboardName
        billboard.Parent = model
        billboard.Adornee = modelRoot
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Name = "ESP_Text"
        label.Parent = billboard
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = settings.TextColor
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0
        label.TextSize = settings.TextSize
        label.Font = Enum.Font.GothamBold
        label.TextWrapped = true
        label.TextYAlignment = Enum.TextYAlignment.Center

        task.spawn(function()
            while billboard and billboard.Parent and rootPart and modelRoot do
                local dist = (modelRoot.Position - rootPart.Position).Magnitude
                label.Text = string.format("%s\n[%.1f]", settings.CustomText, dist)
                task.wait(0.3)
            end
        end)
    end

    if not model:FindFirstChild(settings.HighlightName) then
        local highlight = Instance.new("Highlight")
        highlight.Name = settings.HighlightName
        highlight.Parent = model
        highlight.OutlineColor = settings.OutlineColor
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
    end
end

function DripESP.Enable(ESP_ID)
    local settings = all_settings[ESP_ID]
    if not settings then return end

    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == settings.ModelName then
            applyESP(model, ESP_ID, settings)
        end
    end

    connections[ESP_ID] = workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Model") and v.Name == settings.ModelName then
            task.wait(0.5)
            applyESP(v, ESP_ID, settings)
        end
    end)
end

function DripESP.Disable(ESP_ID)
    local settings = all_settings[ESP_ID]
    if not settings then return end

    if connections[ESP_ID] then
        connections[ESP_ID]:Disconnect()
        connections[ESP_ID] = nil
    end

    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == settings.ModelName then
            local gui = model:FindFirstChild(settings.BillboardName)
            if gui then gui:Destroy() end
            local hl = model:FindFirstChild(settings.HighlightName)
            if hl then hl:Destroy() end
        end
    end

    all_settings[ESP_ID] = nil
end

function DripESP.EnableRaycastInfo()
    if raycastConnection then return end
    local localPlayer = game.Players.LocalPlayer

    raycastConnection = game:GetService("RunService").RenderStepped:Connect(function()
        for _, line in pairs(raycastLines) do
            if line then line:Remove() end
        end
        raycastLines = {}

        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                if localPlayer.Character and model == localPlayer.Character then
                    continue 
                end

                local hrp = model:FindFirstChild("HumanoidRootPart")
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    line.Color = Color3.fromRGB(0, 255, 255)
                    line.Thickness = 1.5
                    line.Transparency = 0
                    line.Visible = true
                    table.insert(raycastLines, line)
                end
            end
        end
    end)
end

function DripESP.DisableRaycastInfo()
    if raycastConnection then
        raycastConnection:Disconnect()
        raycastConnection = nil
    end

    for _, line in pairs(raycastLines) do
        if line then line:Remove() end
    end
    raycastLines = {}
end

return DripESP