--ESPlibrary 丨 No obf
--BY du78
local DripESP = {}
local connection

local settings = {
    TextColor = Color3.new(0, 1, 1),
    OutlineColor = Color3.new(0, 1, 1),
    TextSize = 15,
    ModelName = "target_model",
    HighlightName = "Drip_Highlight",
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

    if not model:FindFirstChild("BillboardGui") then
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = model
        billboard.Adornee = model
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = billboard
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = model.Name
        nameLabel.TextColor3 = settings.TextColor
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextSize = settings.TextSize
        nameLabel.Font = Enum.Font.GothamBold
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