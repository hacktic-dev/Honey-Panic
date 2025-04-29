--!Type(UI)

--!Bind
local _container : VisualElement = nil

local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

queue = {}

NOTIFICATION_OFFSET = 160

notificationShown = false
currentNotification = nil

function AddNotification(notificationId, playerName)
    table.insert(queue, {id = notificationId, name = playerName})
    if #queue == 1 then
        ShowNotification(notificationId, playerName)
    end
end

function ShowNotification(notificationId, playerName)
    notificationShown = true

    notificationLabel = UILabel.new()
    notificationLabel:AddToClassList("notification-label")
    notificationLabel:SetPrelocalizedText(GetNotificationText(notificationId, playerName))
    _container:Add(notificationLabel)
    currentNotification = notificationLabel

    local ShowTween = Tween:new(
        NOTIFICATION_OFFSET, -- Start pos
        0, -- End pos
        0.5, -- Duration in seconds
        false, -- Loop flag
        false, -- Yoyo flag
        Easing.easeOutBack, -- Easing function
        function(value, t)
            -- Update notification position
            _container.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(value)))
        end,
        function()
            -- Ensure final position is set
            _container.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(0)))
        end
    )

    ShowTween:start()

    Timer.new(5, function()
        if notificationShown then
            local HideTween = Tween:new(
                0, -- Start pos
                NOTIFICATION_OFFSET, -- End pos
                0.5, -- Duration in seconds
                false, -- Loop flag
                false, -- Yoyo flag
                Easing.easeOutBack, -- Easing function
                    function(value, t)
                    -- Update slot machine container scale
                    _container.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(value)))
            end,
            function()
                -- Ensure final scale is set
                _container.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(NOTIFICATION_OFFSET)))
                currentNotification = nil
                _container:Clear()
                notificationShown = false
                table.remove(queue, 1)
                if #queue > 0 then
                    ShowNotification(queue[1].id, queue[1].name)
                else
                    _container:Clear()
                end
            end
            )

            HideTween:start()
        end
    end, false)
end

function GetNotificationText(notificationId, playerName)
    if playerName == client.localPlayer.name then
        playerName = "You"
    end 

    if notificationId == "magnet_purchased" then
        return playerName .. " purchased a magnet!"
    elseif notificationId == "multiplier_purchased" then
        return playerName .. " purchased a multiplier!"
    elseif notificationId == "test" then
        return playerName .. " is testing!"
    end
end

function self:ClientAwake()
    AddNotification("test", "Player 1")
    AddNotification("test", "Player 2")
    AddNotification("test", "Player 3")
    AddNotification("test", "Player 4")
    AddNotification("test", "Player 5")
end