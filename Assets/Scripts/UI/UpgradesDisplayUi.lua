--!Type(UI)

--!Bind
local _magnetContainer : VisualElement = nil
--!Bind
local _magnetButton : UIButton = nil
--!Bind
local _magnetLabel : UILabel = nil
--!Bind
local _magnetCountdown : UILabel = nil
--!Bind
local _multiplierContainer : VisualElement = nil
--!Bind
local _multiplierLabel : UILabel = nil
--!Bind
local _multiplierPurchaseLabel : UILabel = nil
--!Bind
local _multiplierPurchaseButton : UIButton = nil

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
    _multiplierPurchaseLabel:SetPrelocalizedText("+")
    _multiplierLabel:SetPrelocalizedText("x1")

    _magnetButton:RegisterPressCallback(function()
        UpgradesManager.TryPurchaseMagnet()
    end)

    _multiplierPurchaseButton:RegisterPressCallback(function()
        UpgradesManager.TryPurchaseMultiplier()
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

    UpgradesManager.NotifyMultiplierChangedEvent:Connect(function(newVal)
        local roundedVal = math.floor(newVal * 10 + 0.5) / 10
        _multiplierLabel:SetPrelocalizedText("x" .. tostring(roundedVal))
    end)
end