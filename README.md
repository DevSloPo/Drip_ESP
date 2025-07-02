# Roblox ESP 库
- 作者:du78
支持模型显示文本和高亮显示，我这个源码没了，导致我无法更新适配Part的😡

## 删除列表
- 这里不用管了，我合并在一起了

## 使用方式

```lua


    local DripESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/Drip_ESP/refs/heads/main/DripEsp_library.lua"))()

下面配合Toggle使用

        local id = "要删除的ID"
        if state then
        DripESP.SetOptions(id, {
            ModelName = "模型",
            CustomText = "显示文本",
            TextColor = Color3.fromRGB(0, 255, 255),
            OutlineColor = Color3.fromRGB(0, 255, 255),
            TextSize = 16,
            CheckForHumanoid = false
        })
        DripESP.Enable(id)
    else
        DripESP.Disable(id)
    end
