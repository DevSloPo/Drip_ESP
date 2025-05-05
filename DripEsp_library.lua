-- CustomESP Library | BY du78
local CustomESP = {}
local connection

local settings = {
    ModelName = "在Toggle自定义透视模型",
    Text = "在Toggle中自定义显示文本",
    TextColor = Color3.fromRGB(0, 255, 255),
    OutlineColor = Color3.fromRGB(255, 0, 0),
    TextSize = 15,
    HighlightName = "CustomESP_Highlight"
}

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

function CustomESP.SetOptions(opts)
    for k, v in pairs(opts) do
        if settings[k] ~= nil then
            settings[k] = v
        end
    end
end

local function applyESP(model)
    if not model:IsA("Model") or model.Name ~= settings.ModelName then return end

    local modelRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
    if not modelRoot then return end

    if not model:FindFirstChild("BillboardGui") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "BillboardGui"
        billboard.Parent = model
        billboard.Adornee = modelRoot
        billboard.Size = UDim2.new(0, 100, 0, 30)
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

        task.spawn(function()
            while billboard and billboard.Parent and rootPart and modelRoot do
                local dist = (modelRoot.Position - rootPart.Position).Magnitude
                label.Text = string.format("%s [%.1f]", settings.Text, dist)
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

function CustomESP.Enable()
    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == settings.ModelName then
            applyESP(model)
        end
    end

    connection = workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Model") and v.Name == settings.ModelName then
            task.wait(0.5)
            applyESP(v)
        end
    end)
end

function CustomESP.Disable()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == settings.ModelName then
            local gui = model:FindFirstChild("BillboardGui")
            if gui then gui:Destroy() end

            local hl = model:FindFirstChild(settings.HighlightName)
            if hl then hl:Destroy() end
        end
    end
end

return CustomESP