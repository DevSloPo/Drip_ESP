--ESPlibrary 丨 No obf
--BY du78

local utils = {}

function utils.IsPlayerCharacter(model)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character == model then
            return true
        end
    end
    return false
end

return utils