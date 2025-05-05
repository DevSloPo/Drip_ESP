local settings = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/Drip_ESP/main/Settings.lua"))()
local applyESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/Drip_ESP/main/ApplyESP.lua"))()
local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/Drip_ESP/main/Utils.lua"))()

local DripESP = {}
local connection

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

function DripESP.Enable()
    for _, v in ipairs(workspace:GetDescendants()) do
        local nameMatch = v.Name:lower() == settings.ModelName
        local classMatch = settings.CheckForHumanoid and v:FindFirstChildOfClass("Humanoid")
        if v:IsA("Model") and (nameMatch or classMatch) then
            applyESP(v, settings, utils)
        end
    end

    connection = workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Model") then
            local nameMatch = v.Name:lower() == settings.ModelName
            local classMatch = settings.CheckForHumanoid and v:FindFirstChildOfClass("Humanoid")
            if nameMatch or classMatch then
                task.wait(0.5)
                applyESP(v, settings, utils)
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
        if v:IsA("Model") and not utils.IsPlayerCharacter(v) then
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

print('作者:du78_小玄')
print('ESP_Libray')