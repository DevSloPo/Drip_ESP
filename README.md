# DripESP 模块化 ESP 库

- 如果要使用，请标记ESP来源/ESP作者/ESP库

一个轻量、高度模块化的 Roblox ESP 工具，支持模型标记和高亮显示。

## 模块列表

- DripEsp_library.lua：主控逻辑
- Settings.lua：配置项
- ApplyESP.lua：应用 ESP 的具体代码
- Utils.lua：判断是否为玩家模型等辅助功能

## 使用方式

```lua
local DripESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/Drip_ESP/main/DripEsp_library.lua"))()

DripESP.SetOptions({
    ModelName = "enemy",
    CheckForHumanoid = false
})

DripESP.Enable()