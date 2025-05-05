-- DripESP Library | BY du7
local DripESP = {}
local connection

local settings = {
    TextColor = Color3.new(0, 1, 1),
    OutlineColor = Color3.new(0, 1, 1),
    TextSize = 15,
    ModelName = "target_model",
    HighlightName = "Drip_Highlight",
    CustomText = nil,
    CheckForHumanoid = true
}

function DripESP.SetOptions(opts)
    for k, v in pairs(opts) do
        if settings[k] ~= nil then
            if k == "ModelName" then
                settings[k] = v:lower()
            else
                settings[k] = v
            end
        end
    end
end

local function isPlayerCharacter(model)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character == model then
            return true
        end
    end
    return false
end

local function applyESP(model)
    if isPlayerCharacter(model) then return end

    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local modelRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
    if not modelRoot then return end

    if not model:FindFirstChild("BillboardGui") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "BillboardGui"
        billboard.Parent = model
        billboard.Adornee = modelRoot
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "ESP_Text"
        nameLabel.Parent = billboard
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = settings.TextColor
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextSize = settings.TextSize
        nameLabel.Font = Enum.Font.GothamBold

        task.spawn(function()
            while billboard and billboard.Parent and modelRoot and rootPart do
                local dist = (modelRoot.Position - rootPart.Position).Magnitude
                nameLabel.Text = string.format("%s [%.1f]", settings.CustomText or model.Name, dist)
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

function DripESP.Enable()
    for _, v in ipairs(workspace:GetDescendants()) do
        local nameMatch = v.Name:lower() == settings.ModelName
        local classMatch = settings.CheckForHumanoid and v:FindFirstChildOfClass("Humanoid")

        if v:IsA("Model") and (nameMatch or classMatch) then
            applyESP(v)
        end
    end

    connection = workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Model") then
            local nameMatch = v.Name:lower() == settings.ModelName
            local classMatch = settings.CheckForHumanoid and v:FindFirstChildOfClass("Humanoid")

            if nameMatch or classMatch then
                task.wait(0.5)
                applyESP(v)
            end
        end
    end)
end

function DripESP.Disable()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and not isPlayerCharacter(v) then
            if v:FindFirstChild("BillboardGui") then
                v.BillboardGui:Destroy()
            end
            local highlight = v:FindFirstChild(settings.HighlightName)
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

return DripESP