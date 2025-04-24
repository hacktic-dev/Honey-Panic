--!Type(UI)

--!SerializeField
local EggIcons : {Texture} = nil

--!Bind
local _mainContainer : VisualElement = nil

local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing
local UIManager = require("UIManager")

eggImage = nil

local idToTex = {
    ["egg_red"] = EggIcons[1],
    ["egg_orange"] = EggIcons[2],
    ["egg_yellow"] = EggIcons[3],
    ["egg_green"] = EggIcons[4],
    ["egg_purple"] = EggIcons[5],
    ["egg_pink"] = EggIcons[6],
    ["egg_white"] = EggIcons[7],
    ["egg_golden"] = EggIcons[8],
}

local eggIdToName = {
    ["egg_red"] = "Red Egg",
    ["egg_orange"] = "Orange Egg",
    ["egg_yellow"] = "Yellow Egg",
    ["egg_green"] = "Green Egg",
    ["egg_purple"] = "Purple Egg",
    ["egg_pink"] = "Pink Egg",
    ["egg_white"] = "White Egg",
    ["egg_golden"] = "Golden Egg",
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
        eggImage.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
    end,
    function()
        -- Ensure final scale is set
        eggImage.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
    end
)

function Init(egg_id : string)
    _mainContainer:Clear()

    highlightImage = VisualElement.new()
    highlightImage:AddToClassList("highlight-image")
    _mainContainer:Add(highlightImage)

    eggImage = Image.new()
    eggImage:AddToClassList("egg-image")
    eggImage.image = idToTex[egg_id]
    _mainContainer:Add(eggImage)

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
        obtainLabel:SetPrelocalizedText("You obtained a " .. eggIdToName[egg_id] .. "!")
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

    Timer.new(1.5, function()
        -- Close the UI after the animation
        closeButton = UIButton.new()
        closeLabel = UILabel.new()
        closeLabel:SetPrelocalizedText("Close")
        closeLabel:AddToClassList("title")
        closeButton:Add(closeLabel)
        closeButton:AddToClassList("close-button")
        closeButton.style.opacity = 0 -- Set initial opacity to 0
        closeButton:RegisterPressCallback(function()
            UIManager.CloseEggObtainUi()
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