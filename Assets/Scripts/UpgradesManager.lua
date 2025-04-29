--!Type(Module)

GameplayManager = require("GameplayManager")
PaymentsHandler = require("PaymentsHandler")

NotifyMagnetActivatedEvent = Event.new("NotifyMagnetActivatedEvent")
NotifyMagnetDeactivated = Event.new("NotifyMagnetDeactivated")
NotifyMagnetCountdownUpdated = Event.new("NotifyMagnetCountdownUpdated")

RequestMagnetPurchaseEvent = Event.new("RequestMagnetPurchaseEvent")
RequestMultiplierPurchaseEvent = Event.new("RequestMultiplierPurchaseEvent")

RequestGivePlayerGoldEvent = Event.new("RequestGivePlayerGoldEvent")

NotifyMultiplierChangedEvent = Event.new("NotifyMultiplierChangedEvent")
NotifyGoldPoolChangedEvent = Event.new("NotifyGoldPoolChangedEvent")

magnetCounts = {}

local multiplier = 1
local goldPool = 0

clientMultiplier = 1

isClientMagnetActive = false

function TryPurchaseMagnet()
    PaymentsHandler.PromptPurchase("magnet", function() RequestMagnetPurchaseEvent:FireServer() end)
end

function TryPurchaseMultiplier()
    PaymentsHandler.PromptPurchase("multiplier", function() RequestMultiplierPurchaseEvent:FireServer() end)
end

function ActivateMagnet(player, won)
    magnetCounts[player] = 60
    NotifyMagnetActivatedEvent:FireAllClients(player, won)
end

function IncrementMultiplier(player, won)
    multiplier = multiplier + 0.1
    NotifyMultiplierChangedEvent:FireAllClients(multiplier, player, won)
end

function self:ServerAwake()
    goldPool = IntValue.new("gold_spent", 0)

    RequestMagnetPurchaseEvent:Connect(function(player, won)
        ActivateMagnet(player, won)
    end)

    RequestMultiplierPurchaseEvent:Connect(function(player, won)
        IncrementMultiplier(player, won)
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

    Timer.new(5, function()
        Inventory.GetItem("GoldPool", "gold_spent", function(item)
            if(item == nil) then
                goldPool.value = 0
                return
            end

            goldPool.value = item.amount

        end)
    end, true)
end

function IsClientMagnetActive()
    return isClientMagnetActive
end

function GetMultiplier()
    return multiplier
end

function GetGoldPool()
    return goldPool.value
end

function GiveReward(rewardId)
    Timer.new(1.5, function()
        if rewardId == "magnet" then
            RequestMagnetPurchaseEvent:FireServer(true)
        elseif rewardId == "multiplier" then
            RequestMultiplierPurchaseEvent:FireServer(true)
        elseif rewardId == "gold_1" then
            RequestGivePlayerGoldEvent:FireServer(1)
        elseif rewardId == "gold_5" then
            RequestGivePlayerGoldEvent:FireServer(5)
        elseif rewardId == "gold_25" then
            RequestGivePlayerGoldEvent:FireServer(25)
        else
            print("ERROR - Invalid reward ID: " .. rewardId)
        end
    end, false)
end

function self:ClientAwake()
    goldPool = IntValue.new("gold_spent", 0)

    NotifyMagnetActivatedEvent:Connect(function(player)
        if player == client.localPlayer then
            isClientMagnetActive = true
        end
    end)

    NotifyMagnetDeactivated:Connect(function()
        isClientMagnetActive = false
    end)
end

