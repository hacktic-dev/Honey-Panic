--!Type(UI)

--!Bind
local _progressSlider : UISlider = nil
--!Bind
local _beeCollectionTitle : UILabel = nil
--!Bind
local _collectionContainer : VisualElement = nil

GameplayManager = require("GameplayManager")
local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

function self:ClientAwake()

    _progressSlider.lowValue, _progressSlider.highValue = 0, GameplayManager.BEE_THRESHOLD

    _beeCollectionTitle:SetPrelocalizedText("Collect Bees!")

    GameplayManager.NotifyBeeCountChangedEvent:Connect(function(newVal)
        _progressSlider:SetValueWithoutNotify(newVal)
    end)
end

function Init()
    _collectionContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0)))

    local ScaleTween = Tween:new(
        0, -- Start scale
        1, -- End scale
        0.5, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeOutBack, -- Easing function
            function(value, t)
            -- Update slot machine container scale
            _collectionContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
    end,
    function()
        -- Ensure final scale is set
        _collectionContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
    end
    )

    ScaleTween:start()
end
