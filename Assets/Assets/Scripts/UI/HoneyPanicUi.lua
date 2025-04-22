--!Type(UI)

--!Bind
local _honeyPanicLabel : UILabel = nil
--!Bind
local _honeyPanicCountdown : UILabel = nil

GameplayManager = require("GameplayManager")

function self:ClientAwake()
    _honeyPanicLabel:SetPrelocalizedText("Honey Panic!")
    _honeyPanicCountdown:SetPrelocalizedText("60")

    GameplayManager.honeyPanicTime.Changed:Connect(function(newVal)
        if newVal > 0 then
            _honeyPanicCountdown:SetPrelocalizedText(tostring(newVal))
        else
            _honeyPanicCountdown:SetPrelocalizedText("0")
        end
    end)
end