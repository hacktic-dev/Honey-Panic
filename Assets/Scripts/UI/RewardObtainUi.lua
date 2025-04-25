--!Type(UI)

--!SerializeField
local RewardIcons : {Texture} = nil

--!Bind
local _mainContainer : VisualElement = nil

local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing
local UIManager = require("UIManager")

rewardImage = nil

local idToTex = {
    ["magnet"] = RewardIcons[1],
    ["multiplier"] = RewardIcons[2],
    ["gold_1"] = RewardIcons[3],
    ["gold_5"] = RewardIcons[4],
    ["gold_25"] = RewardIcons[5],

}

local rewardIdToName = {
    ["magnet"] = { name = "an Item Magnet", description = "Pulls in bees and honey from afar for 60 seconds." },
    ["multiplier"] = { name = "a Honey Multiplier", description = "Increases the honey multiplier in the next Honey Panic round." },
    ["gold_1"] = { name = "1 Gold", description = "Spend it wisely!" },
    ["gold_5"] = { name = "5 Gold", description = "Nice!" },
    ["gold_25"] = { name = "25 Gold", description = "You're rich now!" },
}

local popInTween = Tween:new(
    .4, -- Start scale
    1, -- End scale
    .3, -- Duration in seconds
    false, -- Loop flag
    false, -- Yoyo flag
    Easing.easeOutBack, -- Ease-out-back for a bouncy effect
    function(value, t)
        -- Update slot machine container scale
        rewardImage.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
    end,
    function()
        -- Ensure final scale is set
        rewardImage.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
    end
)

function Init(reward_id : string)
    print("Obtaining reward: " .. reward_id)
    _mainContainer:Clear()

    highlightImage = VisualElement.new()
    highlightImage:AddToClassList("highlight-image")
    _mainContainer:Add(highlightImage)

    rewardImage = Image.new()
    rewardImage:AddToClassList("reward-image")
    rewardImage.image = idToTex[reward_id]
    _mainContainer:Add(rewardImage)

    highlightImage.style.opacity = 0 -- Set initial opacity to 0

    Timer.new(0.25, function()
        -- Fade in the highlight image
        local highlightFadeInTween = Tween:new(
            0, -- Start opacity
            1, -- End opacity
            0.3, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.linear, -- Linear easing for smooth fade-in
            function(value, t)
                highlightImage.style.opacity = value
            end,
            function()
                -- Ensure final opacity is set
                highlightImage.style.opacity = 1
            end
        )
        highlightFadeInTween:start()
    end, false)

    -- Rotate the highlight image
    local highlightRotateTween = Tween:new(
        0, -- Start rotation angle
        360, -- End rotation angle
        5.5, -- Duration in seconds
        true, -- Loop flag
        false, -- Yoyo flag
        Easing.linear, -- Linear easing for smooth rotation
        function(value, t)
            highlightImage.style.rotate = StyleRotate.new(Rotate.new(Angle.new(value)))
        end
    )
    highlightRotateTween:start()

    popInTween:start()

    Timer.new(0.2, function()
        obtainLabel = UILabel.new()
        obtainLabel:SetPrelocalizedText("You obtained " .. rewardIdToName[reward_id].name .. "!")
        obtainLabel:AddToClassList("obtain-title")
        _mainContainer:Add(obtainLabel)
        local fadeInTween = Tween:new(
            0, -- Start opacity
            1, -- End opacity
            0.3, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Linear easing for smooth fade-in
            function(value, t)
            obtainLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end,
            function()
            -- Ensure final opacity is set
            obtainLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
            end
        )
        fadeInTween:start()

    end, false)

    Timer.new(0.35, function()
        descriptionLabel = UILabel.new()
        descriptionLabel:SetPrelocalizedText(rewardIdToName[reward_id].description)
        descriptionLabel:AddToClassList("obtain-description")
        descriptionLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(0, 0))) -- Set initial scale to 0
        _mainContainer:Add(descriptionLabel)

        -- Scale in the description
        local descriptionScaleInTween = Tween:new(
            0, -- Start scale
            1, -- End scale
            0.3, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.easeOutBack, -- Ease-out-back for smooth scaling
            function(value, t)
                descriptionLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
            end,
            function()
                -- Ensure final scale is set
                descriptionLabel.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
            end
        )
        descriptionScaleInTween:start()
    end, false)

    Timer.new(1, function()
        -- Close the UI after the animation
        closeButton = UIButton.new()
        closeLabel = UILabel.new()
        closeLabel:SetPrelocalizedText("Continue")
        closeLabel:AddToClassList("title")
        closeButton:Add(closeLabel)
        closeButton:AddToClassList("close-button")
        closeButton.style.opacity = 0 -- Set initial opacity to 0
        closeButton:RegisterPressCallback(function()
            UIManager.HideRewardObtainUi()
        end, true, true, true)
        _mainContainer:Add(closeButton)
    
        -- Fade in the button
        local buttonFadeInTween = Tween:new(
            0, -- Start opacity
            1, -- End opacity
            0.25, -- Duration in seconds
            false, -- Loop flag
            false, -- Yoyo flag
            Easing.linear, -- Linear easing for smooth fade-in
            function(value, t)
                closeButton.style.opacity = value
            end,
            function()
                -- Ensure final opacity is set
                closeButton.style.opacity = 1
            end
        )
        buttonFadeInTween:start()
    end, false)
    
end