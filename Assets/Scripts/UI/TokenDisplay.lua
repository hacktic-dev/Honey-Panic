--!Type(UI)

--!Bind
local _tokenLabel : UILabel = nil

playerTracker = require("PlayerTracker")

function self:ClientAwake()
    _tokenLabel:SetPrelocalizedText("0")

    playerTracker.NotifyScoreChangedEvent:Connect(function(newVal)
        _tokenLabel:SetPrelocalizedText(tostring(newVal))
    end)
end