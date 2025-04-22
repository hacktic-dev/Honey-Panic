--!Type(UI)

--!Bind
local _beeCollectionLabel : UILabel = nil

GameplayManager = require("GameplayManager")

function self:ClientAwake()
    _beeCollectionLabel:SetPrelocalizedText("0")

    GameplayManager.NotifyBeeCountChangedEvent:Connect(function(newVal)
        _beeCollectionLabel:SetPrelocalizedText(tostring(newVal) .. "/" .. tostring(GameplayManager.BEE_THRESHOLD))
    end)
end