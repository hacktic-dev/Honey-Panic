--!Type(UI)

--!Bind
local _roundOverContainer : VisualElement = nil

UIManager = require("UIManager")
PlayerTracker = require("PlayerTracker")
TweenModule = require("TweenModule")
Tween = TweenModule.Tween
Easing = TweenModule.Easing

function Init(honeyCollected, tokensEarned)
    _roundOverContainer:Clear()

    local tokenContainer = VisualElement.new()
    tokenContainer:AddToClassList("token-container")

    local tokenLabel = UILabel.new()
    tokenLabel:AddToClassList("token-label")
    tokenLabel.name = "_tokenLabel"
    tokenLabel:SetPrelocalizedText(PlayerTracker.GetPlayerTokens())
    tokenContainer:Add(tokenLabel)

    local tokenIcon = VisualElement.new()
    tokenIcon:AddToClassList("token-icon")
    tokenContainer:Add(tokenIcon)

    _roundOverContainer:Add(tokenContainer)

    local honeyPanicCompleteLabel = UILabel.new()
    honeyPanicCompleteLabel:SetPrelocalizedText("Round Over!")
    honeyPanicCompleteLabel:AddToClassList("title-label")
    honeyPanicCompleteLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Initial scale
    Timer.new(0.4, function()
        local labelTween = Tween:new(
            0.2, -- Start scale
            1, -- End scale
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                honeyPanicCompleteLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end
        )
        labelTween:start() -- Start the tween
    end, false)
    _roundOverContainer:Add(honeyPanicCompleteLabel)

    local honeyContainer = VisualElement.new()
    honeyContainer:AddToClassList("horizontal-container")

    local honeyCollectedLabel = UILabel.new()
    honeyCollectedLabel:SetPrelocalizedText("Honey Collected: ")
    honeyCollectedLabel:AddToClassList("round-over-label")
    honeyContainer:Add(honeyCollectedLabel)

    local honeyAmountContainer = VisualElement.new()
    honeyAmountContainer:AddToClassList("reward-container")

    local honeyAmountLabel = UILabel.new()
    honeyAmountLabel:SetPrelocalizedText(tostring(honeyCollected))
    honeyAmountLabel:AddToClassList("round-over-label")
    honeyAmountContainer:Add(honeyAmountLabel)

    local honeyIcon = VisualElement.new()
    honeyIcon:AddToClassList("honey-icon")
    honeyAmountContainer:Add(honeyIcon)

    honeyContainer:Add(honeyAmountContainer)

    honeyContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Initial scale
    Timer.new(0.55, function()
        local labelTween = Tween:new(
            0.2, -- Start scale
            1, -- End scale
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                honeyContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end
        )
        labelTween:start() -- Start the tween
    end, false)
    _roundOverContainer:Add(honeyContainer)

    local horizontalContainer = VisualElement.new()
    horizontalContainer:AddToClassList("horizontal-container")

    local tokensEarnedLabel = UILabel.new()
    tokensEarnedLabel:SetPrelocalizedText("Reward: ")
    tokensEarnedLabel:AddToClassList("round-over-label")

    horizontalContainer:Add(tokensEarnedLabel)

    local rewardContainer = VisualElement.new()
    rewardContainer:AddToClassList("reward-container")

    local rewardLabel = UILabel.new()
    rewardLabel:SetPrelocalizedText(tostring(tokensEarned))
    rewardLabel:AddToClassList("round-over-label")

    rewardContainer:Add(rewardLabel)

    local rewardIcon = VisualElement.new()
    rewardIcon:AddToClassList("token-icon")
    rewardContainer:Add(rewardIcon)

    horizontalContainer:Add(rewardContainer)

    horizontalContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Initial scale
    Timer.new(0.7, function()
        local labelTween = Tween:new(
            0.2, -- Start scale
            1, -- End scale
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Easing function
            function(value, t)
                horizontalContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end,
        false)
        labelTween:start() -- Start the tween
    end, false)
    _roundOverContainer:Add(horizontalContainer)

    local continueButton = UIButton.new()
    local continueButtonLabel = UILabel.new()
    continueButtonLabel:SetPrelocalizedText("Continue")
    continueButtonLabel:AddToClassList("continue-label")
    continueButton:Add(continueButtonLabel)
    continueButton:AddToClassList("close-button")
    continueButton:RegisterPressCallback(function()
        UIManager.ShowBeeCollectionMode()
    end)
    continueButton.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Initial scale
    Timer.new(0.85, function()
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