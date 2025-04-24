--!Type(Module)

GameplayManager = require("GameplayManager")

NotifyMagnetActivated = Event.new("NotifyMagnetActivated")
NotifyMagnetDeactivated = Event.new("NotifyMagnetDeactivated")
NotifyMagnetCountdownUpdated = Event.new("NotifyMagnetCountdownUpdated")

RequestMagnetPurchaseEvent = Event.new("RequestMagnetPurchaseEvent")
RequestMultiplierPurchaseEvent = Event.new("RequestMultiplierPurchaseEvent")

NotifyMultiplierChangedEvent = Event.new("NotifyMultiplierChangedEvent")

magnetCounts = {}

multiplier = 1

clientMultiplier = 1

isClientMagnetActive = false

function TryPurchaseMagnet()
    RequestMagnetPurchaseEvent:FireServer()
end

function TryPurchaseMultiplier()
    RequestMultiplierPurchaseEvent:FireServer()
end

function ActivateMagnet(player)
    magnetCounts[player] = 60
    NotifyMagnetActivated:FireClient(player)
end

function IncrementMultiplier()
    multiplier = multiplier + 0.1
    NotifyMultiplierChangedEvent:FireAllClients(multiplier)
end

function self:ServerAwake()
    RequestMagnetPurchaseEvent:Connect(function(player)
        ActivateMagnet(player)
    end)

    RequestMultiplierPurchaseEvent:Connect(function(player)
        IncrementMultiplier()
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

    GameplayManager.BeeCollectionStartedEvent:Connect(function()
        Timer.new(0.25, function()
            multiplier = 1
            NotifyMultiplierChangedEvent:FireAllClients(multiplier)
        end, false)
    end)
end

function IsClientMagnetActive()
    return isClientMagnetActive
end

function GetMultiplier()
    return multiplier
end

function self:ClientAwake()
    NotifyMagnetActivated:Connect(function()
        isClientMagnetActive = true
    end)

    NotifyMagnetDeactivated:Connect(function()
        isClientMagnetActive = false
    end)
end

