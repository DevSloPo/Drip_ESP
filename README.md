# DripESP 模块化 ESP 库

- 如果要使用，请标记ESP来源/ESP作者/ESP库
- 作者:du78_小玄
快捷、模块化的 Roblox 模型ESP ，支持模型显示文本和高亮显示

## 模块列表
- 这里不用管了，我合并在一起了
- DripEsp_library.lua：主控逻辑
- Settings.lua：配置项
- ApplyESP.lua：应用 ESP 的具体代码
- Utils.lua：判断是否为玩家模型等辅助功能

## 使用方式

```lua


    local DripESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/Drip_ESP/refs/heads/main/DripEsp_library.lua"))()

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