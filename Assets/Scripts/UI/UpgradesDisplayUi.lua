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
--!Bind
local _magnetActiveIcon : VisualElement = nil
--!Bind
local _magnetDisabledIcon : VisualElement = nil

UpgradesManager = require("UpgradesManager")
TweenModule = require("TweenModule")
Tween = TweenModule.Tween
Easing = TweenModule.Easing

RotateMagnetTween = Tween:new(
    -25, -- Start rotation angle
    5, -- End rotation angle
    0.6, -- Duration in seconds
    true, -- Loop flag
    true, -- Yoyo flag
    Easing.linear, -- Linear easing for smooth rotation
    function(value, t)
        _magnetActiveIcon.style.rotate = StyleRotate.new(Rotate.new(Angle.new(value)))
    end
)

function ShowMagnet()
    --_magnetContainer:RemoveFromClassList("hidden")
end

function HideMagnet()
   -- _magnetContainer:AddToClassList("hidden")
end

function self:ClientAwake()

    _magnetActiveIcon:AddToClassList("hidden")
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

    UpgradesManager.NotifyMagnetActivatedEvent:Connect(function(player)

        if player ~= client.localPlayer then
            return
        end

        _magnetButton:AddToClassList("hidden")
        _magnetDisabledIcon:AddToClassList("hidden")
        _magnetActiveIcon:RemoveFromClassList("hidden")
        _magnetCountdown:RemoveFromClassList("hidden")
        _magnetCountdown:SetPrelocalizedText(60)
        RotateMagnetTween:start()
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
        _magnetDisabledIcon:RemoveFromClassList("hidden")
        _magnetActiveIcon:AddToClassList("hidden")
        _magnetCountdown:AddToClassList("hidden")
    end)

    UpgradesManager.NotifyMultiplierChangedEvent:Connect(function(newVal, player)
        local roundedVal = math.floor(newVal * 10 + 0.5) / 10
        _multiplierLabel:SetPrelocalizedText("x" .. tostring(roundedVal))

        local labelTween = Tween:new(
            0, -- Start scale
            1, -- End scale
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                _multiplierLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
                local rotationValue = -30 + (30 * value) -- Interpolates between -30 and 0
                _multiplierLabel.style.rotate = StyleRotate.new(Rotate.new(Angle.new(rotationValue)))
            end
        )
        labelTween:start() -- Start the tween

    end)
end