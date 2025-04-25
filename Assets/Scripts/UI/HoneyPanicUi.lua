--!Type(UI)

--!Bind
local _honeyPanicLabel : UILabel = nil
--!Bind
local _honeyPanicCountdown : UILabel = nil
--!Bind
local _countdownIcon : VisualElement = nil
--!Bind
local _titleContainer : VisualElement = nil
--!Bind
local _countdownContainer : VisualElement = nil

local GameplayManager = require("GameplayManager")
local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

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

RotateTimerTween = Tween:new(
    -15, -- Start rotation angle
    15, -- End rotation angle
    0.6, -- Duration in seconds
    true, -- Loop flag
    true, -- Yoyo flag
    Easing.linear, -- Linear easing for smooth rotation
    function(value, t)
        _countdownIcon.style.rotate = StyleRotate.new(Rotate.new(Angle.new(value)))
    end
)

function Init()

    _titleContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0)))
    _countdownContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0)))

    local ScaleTween = Tween:new(
        0, -- Start scale
        1, -- End scale
        0.5, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeOutBack, -- Easing function
            function(value, t)
            -- Update slot machine container scale
            _titleContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
    end,
    function()
        -- Ensure final scale is set
        _titleContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
    end
    )

    Timer.new(0.25, function()
        local CountdownScaleTween = Tween:new(
            0, -- Start scale
            1, -- End scale
            0.5, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                -- Update countdown container scale
                _countdownContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end,
            function()
                -- Ensure final scale is set
                _countdownContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
            end
        )

        CountdownScaleTween:start()
    end, false)

    ScaleTween:start()
    RotateTimerTween:start()
end
