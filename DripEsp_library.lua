-- DripESP_Library | BY du78
local DripESP = {}
local connections = {}
local settings = {}
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

local DEFAULT = {
    TextColor = Color3.fromRGB(0, 255, 255),
    OutlineColor = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.Gotham,
    ShowDistance = true,
    RefreshRate = 0.3,
    MaxDistance = 1000
}

function DripESP.SetOptions(id, opts)
    settings[id] = {
        TargetName = opts.TargetName or "Part",
        Text = opts.Text or "目标",
        TextColor = opts.TextColor or DEFAULT.TextColor,
        OutlineColor = opts.OutlineColor or DEFAULT.OutlineColor,
        TextSize = opts.TextSize or DEFAULT.TextSize,
        Font = opts.Font or DEFAULT.Font,
        ShowDistance = opts.ShowDistance ~= false,
        RefreshRate = opts.RefreshRate or DEFAULT.RefreshRate,
        MaxDistance = opts.MaxDistance or DEFAULT.MaxDistance
    }
end

local function createESP(target, id)
    local config = settings[id]
    if not config then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight_"..id
    highlight.OutlineColor = config.OutlineColor
    highlight.FillTransparency = 1
    highlight.Parent = target

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard_"..id
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Parent = target

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = config.TextColor
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0.5
    label.TextSize = config.TextSize
    label.Font = config.Font
    label.Parent = billboard

    local function update()
        local humanoidRoot = target:FindFirstChild("HumanoidRootPart") or target:IsA("BasePart") and target
        if not humanoidRoot or not rootPart then return end
        
        local distance = (humanoidRoot.Position - rootPart.Position).Magnitude
        if distance > config.MaxDistance then
            billboard.Enabled = false
            highlight.Enabled = false
            return
        end

        billboard.Adornee = humanoidRoot
        billboard.Enabled = true
        highlight.Enabled = true
        
        label.Text = config.ShowDistance and string.format("%s\n[%dm]", config.Text, math.floor(distance)) or config.Text
    end

    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        if not target.Parent then
            conn:Disconnect()
            return
        end
        update()
    end)
end

function DripESP.Enable(id)
    if not settings[id] then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and obj.Name == settings[id].TargetName then
            createESP(obj, id)
        end
    end

    connections[id] = workspace.DescendantAdded:Connect(function(obj)
        if (obj:IsA("Model") or obj:IsA("BasePart")) and obj.Name == settings[id].TargetName then
            createESP(obj, id)
        end
    end)
end

function DripESP.Disable(id)
    if connections[id] then
        connections[id]:Disconnect()
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("ESP_Highlight_"..id) then
            obj:FindFirstChild("ESP_Highlight_"..id):Destroy()
        end
        if obj:FindFirstChild("ESP_Billboard_"..id) then
            obj:FindFirstChild("ESP_Billboard_"..id):Destroy()
        end
    end
end

return DripESP