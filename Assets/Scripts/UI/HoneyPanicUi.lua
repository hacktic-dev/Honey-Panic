--!Type(UI)

--!Bind
local _honeyPanicLabel : UILabel = nil
--!Bind
local _honeyPanicCountdown : UILabel = nil
--!Bind
local _honeyPanicLabelSubtitle : UILabel = nil

local GameplayManager = require("GameplayManager")
local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

function self:ClientAwake()
    _honeyPanicLabel:SetPrelocalizedText("Honey Panic!")
    _honeyPanicLabelSubtitle:SetPrelocalizedText("Collect as much honey as you can before time runs out!")
    _honeyPanicCountdown:SetPrelocalizedText("60")

    GameplayManager.honeyPanicTime.Changed:Connect(function(newVal)
        if newVal > 0 then
            _honeyPanicCountdown:SetPrelocalizedText(tostring(newVal))
        else
            _honeyPanicCountdown:SetPrelocalizedText("0")
        end
    end)
end

function Init()
    local ScaleTween = Tween:new(
        .2, -- Start scale
        1, -- End scale
        0.25, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeOutBack, -- Easing function
            function(value, t)
            -- Update slot machine container scale
            _honeyPanicLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            _honeyPanicLabelSubtitle.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            _honeyPanicCountdown.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
    end,
    function()
        -- Ensure final scale is set
        _honeyPanicLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
        _honeyPanicLabelSubtitle.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
        _honeyPanicCountdown.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
    end
    )

    ScaleTween:start()
end
