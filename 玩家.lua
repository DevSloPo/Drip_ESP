local survivoresp = {}
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local raycastConnection = nil
local raycastLines = {}

function survivoresp.EnableRaycastInfo()
    if raycastConnection then return end

    raycastConnection = game:GetService("RunService").RenderStepped:Connect(function()
        for _, line in pairs(raycastLines) do
            if line then line:Remove() end
        end
        raycastLines = {}

        for _, model in ipairs(workspace.Players.Survivors:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                local hrp = model.HumanoidRootPart
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    line.Color = Color3.fromRGB(0, 255, 255) 
                    line.Thickness = 1.5
                    line.Transparency = 1
                    line.Visible = true
                    table.insert(raycastLines, line)
                end
            end
        end
    end)
end

function survivoresp.DisableRaycastInfo()
    if raycastConnection then
        raycastConnection:Disconnect()
        raycastConnection = nil
    end

    for _, line in pairs(raycastLines) do
        if line then line:Remove() end
    end
    raycastLines = {}
end

return survivoresp