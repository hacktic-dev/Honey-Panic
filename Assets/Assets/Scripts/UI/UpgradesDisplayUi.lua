--!Type(UI)

--!Bind
local _magnetContainer : VisualElement = nil
--!Bind
local _magnetButton : UIButton = nil
--!Bind
local _magnetLabel : UILabel = nil
--!Bind
local _magnetCountdown : UILabel = nil

UpgradesManager = require("UpgradesManager")

function ShowMagnet()
    _magnetContainer:RemoveFromClassList("hidden")
end

function HideMagnet()
    _magnetContainer:AddToClassList("hidden")
end

function self:ClientAwake()

    _magnetCountdown:AddToClassList("hidden")
    _magnetButton:RemoveFromClassList("hidden")
    _magnetLabel:SetPrelocalizedText("+")

    _magnetButton:RegisterPressCallback(function()
        UpgradesManager.TryPurchaseMagnet()
    end)

    UpgradesManager.NotifyMagnetActivated:Connect(function()
        _magnetButton:AddToClassList("hidden")
        _magnetCountdown:RemoveFromClassList("hidden")
        _magnetCountdown:SetPrelocalizedText(60)
    end)

    UpgradesManager.NotifyMagnetCountdownUpdated:Connect(function(newVal)
        if newVal > 0 then
            _magnetCountdown:SetPrelocalizedText(tostring(newVal))
        else
            _magnetCountdown:SetPrelocalizedText("0")
        end
    end)

    UpgradesManager.NotifyMagnetDeactivated:Connect(function()
        _magnetButton:RemoveFromClassList("hidden")
        _magnetCountdown:AddToClassList("hidden")
    end)
end