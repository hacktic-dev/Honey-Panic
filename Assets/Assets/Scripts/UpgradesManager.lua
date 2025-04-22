--!Type(Module)

NotifyMagnetActivated = Event.new("NotifyMagnetActivated")
NotifyMagnetDeactivated = Event.new("NotifyMagnetDeactivated")
NotifyMagnetCountdownUpdated = Event.new("NotifyMagnetCountdownUpdated")

RequestMagnetPurchaseEvent = Event.new("RequestMagnetPurchaseEvent")

magnetCounts = {}

isClientMagnetActive = false

function TryPurchaseMagnet()
    RequestMagnetPurchaseEvent:FireServer()
end

function ActivateMagnet(player)
    magnetCounts[player] = 60
    NotifyMagnetActivated:FireClient(player)
end

function self:ServerAwake()
    RequestMagnetPurchaseEvent:Connect(function(player)
        ActivateMagnet(player)
    end)

    Timer.new(1, function()
        for player, countdown in pairs(magnetCounts) do
            if countdown > 0 then
                magnetCounts[player] = countdown - 1
                NotifyMagnetCountdownUpdated:FireClient(player, magnetCounts[player])
            else
                NotifyMagnetDeactivated:FireClient(player)
                magnetCounts[player] = nil
            end
        end
    end)
end

function IsClientMagnetActive()
    return isClientMagnetActive
end

function self:ClientAwake()
    NotifyMagnetActivated:Connect(function()
        isClientMagnetActive = true
    end)

    NotifyMagnetDeactivated:Connect(function()
        isClientMagnetActive = false
    end)
end

