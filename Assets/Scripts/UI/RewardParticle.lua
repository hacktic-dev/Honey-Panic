--!Type(UI)
-- (C) 2025 PocketzWorld. Used with permission. Modified by hacktic.
-- Specifies that this script is a UI component for reward particle animations.

--!SerializeField
local tokenSprite : Texture = nil
 
--!Bind
local reward_particles : VisualElement = nil -- Visual element for the reward particles container
--!Bind
local root : VisualElement = nil

-- Required modules for audio, utilities, and tweening
local utils = require("Utils")
local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

-- Animates an element to a destination element with an offset
function MoveElementToElement(_element, _offset, _destination, _duration)
    -- Exit if element or destination is missing
    if not _element or not _destination then return end

    -- Get the world position of the destination
    local destWorld = _destination.worldBound.position 

    -- Convert to local space of the element
    local localPos = _element:WorldToLocal(destWorld) 

    -- Create a tween to animate the movement
    local moveTween = Tween:new(
        0, -- Start value
        1, -- End value
        _duration, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeInQuad, -- Ease-in for acceleration
        function(value)
            -- Update position and rotation
            _element.style.translate = StyleTranslate.new(Translate.new(Length.new(_offset.x + localPos.x * value), Length.new(_offset.y + localPos.y * value)))
            _element.style.rotate = StyleRotate.new(Rotate.new(Angle.new(360 * value)))
        end,
        function()
            -- Remove element on completion
            _element:RemoveFromHierarchy()
        end
    )
    moveTween:start()
end

-- Animates an element to a local offset, then to a destination
function MoveElementToLocalOffset(_element, _offset, _destination, _duration)
    -- Exit if element or offset is missing
    if not _element or not _offset then return end

    -- Create a tween to animate to the offset
    local moveTween = Tween:new(
        0, -- Start value
        1, -- End value
        _duration, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeOutQuad, -- Ease-out for deceleration
        function(value)
            -- Update position and rotation
            _element.style.translate = StyleTranslate.new(Translate.new(Length.new(_offset.x * value), Length.new(_offset.y * value)))
            _element.style.rotate = StyleRotate.new(Rotate.new(Angle.new(-360 + (360 * value))))
        end,
        function()
            -- Chain to move to destination
            MoveElementToElement(_element, _offset, _destination, .5)
        end
    )
    moveTween:start()
end

-- Creates animated star particles
function CreatAnimatedStarElements(stars: number, startElement: VisualElement, sprite : Texture, destination : VisualElement)
    -- Default to star sprite if none provided
    sprite = sprite or starSprite
    -- Reset particles container position
    reward_particles.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(0)))
    -- Get start element's world position
    local startWorld = startElement.worldBound.position 
    -- Convert to local space for particles
    local localPos = reward_particles:WorldToLocal(startWorld) 
    print(tostring(startWorld))
    reward_particles.style.translate = StyleTranslate.new(Translate.new(Length.new(localPos.x), Length.new(localPos.y)))

    -- Create the specified number of star particles
    for i=1, stars do
        Timer.After(i * .05, function()
            -- Play pop sound effect
            --auidoManager.playPop()
            -- Create a new star particle image
            local _starParticle = Image.new()
            -- Schedule removal after 1 second
            Timer.After(1, function()
                _starParticle:RemoveFromHierarchy()
            end)
            _starParticle:AddToClassList("star-particle")

            -- Add particle to the container
            reward_particles:Add(_starParticle)

            -- Set particle sprite
            _starParticle.image = sprite

            -- Default destination to score icon if none provided
            local destinationElement = destination or UI.hud:Q("score_icon")
            -- Generate random offset for particle spread
            local offset = Vector2.new(math.random(-100, 100), math.random(-100, 100))
            -- Animate particle movement
            MoveElementToLocalOffset(_starParticle, offset, destinationElement, .5)
        end)
    end
end

function PlayTokenAnimation(cellElement : VisualElement, amount: number)
    print("PlayTokenAnimation")
    root:BringToFront()
    CreatAnimatedStarElements(math.min(10, amount), cellElement, tokenSprite, UI.hud:Q("_roundOverTokenIcon"))
end