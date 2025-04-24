--!Type(UI)

--!Bind
local _roundOverContainer : VisualElement = nil

UIManager = require("UIManager")
TweenModule = require("TweenModule")
Tween = TweenModule.Tween
Easing = TweenModule.Easing

function Init(honeyCollected, tokensEarned)
    _roundOverContainer:Clear()

    local honeyCollectedLabel = UILabel.new()
    honeyCollectedLabel:SetPrelocalizedText("Honey Collected: " .. tostring(honeyCollected))
    honeyCollectedLabel:AddToClassList("round-over-label")
    honeyCollectedLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Initial scale
    Timer.new(0.4, function()
        local labelTween = Tween:new(
            0.2, -- Start scale
            1, -- End scale
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                honeyCollectedLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end
        )
        labelTween:start() -- Start the tween
    end, false)
    _roundOverContainer:Add(honeyCollectedLabel)

    local tokensEarnedLabel = UILabel.new()
    tokensEarnedLabel:SetPrelocalizedText("Tokens Earned: " .. tostring(tokensEarned))
    tokensEarnedLabel:AddToClassList("round-over-label")
    tokensEarnedLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Initial scale
    Timer.new(0.55, function()
        local labelTween = Tween:new(
            0.2, -- Start scale
            1, -- End scale
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                tokensEarnedLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end,
        false)
        labelTween:start() -- Start the tween
    end, false)
    _roundOverContainer:Add(tokensEarnedLabel)

    local continueButton = UIButton.new()
    local continueButtonLabel = UILabel.new()
    continueButtonLabel:SetPrelocalizedText("Continue")
    continueButtonLabel:AddToClassList("round-over-label")
    continueButton:Add(continueButtonLabel)
    continueButton:AddToClassList("close-button")
    continueButton:RegisterPressCallback(function()
        UIManager.ShowBeeCollectionMode()
    end)
    continueButton.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Initial scale
    Timer.new(0.7, function()
        local buttonTween = Tween:new(
            0.2, -- Start scale
            1, -- End scale
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                continueButton.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end
        )
        buttonTween:start() -- Start the tween
    end, false)
    _roundOverContainer:Add(continueButton)

    local ScaleTween = Tween:new(
        .2, -- Start scale
        1, -- End scale
        0.25, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeOutBack, -- Easing function
        function(value, t)
            -- Update slot machine container scale
            _roundOverContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
        end,
        function()
            -- Ensure final scale is set
            _roundOverContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
        end
    )

    ScaleTween:start() -- Start the tween
end