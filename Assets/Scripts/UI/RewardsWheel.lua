--!Type(UI)

--!Bind
local _wheel : VisualElement = nil
--!Bind
local _spinButton : UIButton = nil
--!Bind
local _spinButtonLabel : UILabel = nil
--!Bind
local _closeButton : UIButton = nil
--!Bind
local _closeButtonLabel : UILabel = nil
--!Bind
local _title : UILabel = nil
--!Bind
local _cardContainer : VisualElement = nil

local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing
local UIManager = require("UIManager")
local UpgradesManager = require("UpgradesManager")
local PlayerTracker = require("PlayerTracker")

local _prizeId = nil

local SPIN_COST = 1000

--!SerializeField
local ItemIcons : {Texture} = nil
--!SerializeField
local SpinEasing : AnimationCurve = nil

prizes = 
{
    "magnet",
    "multiplier",
    "gold_1",
    "gold_5",
    "gold_25",
}

weights =
{
    magnet = 40,
    multiplier = 40,
    gold_1 = 12.5,
    gold_5 = 4.5,
    gold_25 = 1.5,
}

function self:ClientAwake()
    _spinButton:RegisterPressCallback(function()
        local function ChoosePrize()
            local adjustedWeights = {}
            local totalWeight = 0

            -- Adjust weights based on gold pool
            local goldPool = UpgradesManager.GetGoldPool()
            print("Gold Pool: " .. goldPool)
            for prize, weight in pairs(weights) do
                if (prize == "gold_1" and goldPool < 1) or
                   (prize == "gold_5" and goldPool < 5) or
                   (prize == "gold_25" and goldPool < 25) then
                    adjustedWeights[prize] = 0
                else
                    adjustedWeights[prize] = weight
                end
                totalWeight = totalWeight + adjustedWeights[prize]
            end

            -- Generate a random value between 0 and totalWeight
            local randomValue = math.random() * totalWeight
            local cumulative = 0

            for prize, weight in pairs(adjustedWeights) do
                cumulative = cumulative + weight
                if randomValue <= cumulative then
                    for i, prizeName in ipairs(prizes) do
                        if prizeName == prize then
                            print("Prize chosen: " .. prizeName)
                            _prizeId = prizeName
                            return i
                        end
                    end
                end
            end

            _prizeId = "magnet" -- Default prize if none is chosen
            return 1 -- Default to the first prize if none is chosen
        end

        local prizeId = ChoosePrize()
        Spin(prizeId)
    end)

    _spinButtonLabel:SetPrelocalizedText("SPIN\nx"..tostring(SPIN_COST))
    _closeButton:RegisterPressCallback(function()
        UIManager.HideRewardsWheel()
    end)
    _closeButtonLabel:SetPrelocalizedText("Close")
    _title:SetPrelocalizedText("Spin to win a prize!")
end

function AddItems(prizeId : number)
    _wheel:Clear()
    _wheel.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(-1410)))
    for i=1, 20 do 
        if i == 2 then
            -- Add the prize item at position 2
            local new_final_item = CreateItem(prizeId, _wheel)
            Timer.After(1.25, function()
                -- Highlight the final item
                new_final_item:AddToClassList("Slot__Item--Main")
            end)
        else
            -- Add random items
            CreateItem(math.random(1, #ItemIcons), _wheel)
        end
    end
end

-- Creates a slot item with the specified ID
function CreateItem(itemID: number, wheel: VisualElement)
    local _item = Image.new()
    _item:AddToClassList("Slot__Item")
    -- Set item icon
    _item.image = ItemIcons[itemID]
    -- Add item to the wheel
    wheel:Add(_item)
    return _item
end

function SpinWheelAnimations(wheel : VisualElement)
    local SpinTween = Tween:new(
        -1400, -- Start position (pixels)
        -10, -- End position
        .75, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        function(t)
            -- Use custom easing curve
            return SpinEasing:Evaluate(t)
        end,
        function(value, t)
            -- Update wheel vertical position
            wheel.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(value)))
        end,
        function()
            -- Reset wheel position
            wheel.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(-10)))
        end
    )
    SpinTween:start()
end

function Spin(prizeId : number)
    if PlayerTracker.GetPlayerTokens() < 1000 then
        return
    end

    PlayerTracker.RequestGiveClientTokens(-SPIN_COST)

    AddItems(prizeId)
    SpinWheelAnimations(_wheel)
    _spinButton.visible = false

    UpgradesManager.GiveReward(_prizeId)

    Timer.new(1.25, function()
        _spinButton.visible = true
    --    UIManager.OpenEggObtainUi(_prizeId)
    end, false)
end

function Init()
    _spinButton.visible = true
    AddItems(math.random(1, #ItemIcons))

    local ScaleTween = Tween:new(
        .2, -- Start scale
        1, -- End scale
        0.25, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeOutBack, -- Easing function
            function(value, t)
            -- Update slot machine container scale
            _cardContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
    end,
    function()
        -- Ensure final scale is set
        _cardContainer.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
    end
    )

    ScaleTween:start()
end