--!Type(Module)

NotifyMagnetPurchasedEvent = Event.new("NotifyMagnetPurchasedEvent")
NotifyMultiplierPurchasedEvent = Event.new("NotifyMultiplierPurchasedEvent")

function PromptPurchase(id: string, succeededCallback)
    Payments:PromptPurchase(id, function(paid)
        if paid then
            print("Purchase successful")
            succeededCallback()
        else
            print("Purchase failed")
        end
    end)
end

function ServerHandlePurchase(purchase, player: Player)
    local productId = purchase.product_id

    Payments.AcknowledgePurchase(purchase, true, function(ackErr: PaymentsError)
        if ackErr ~= PaymentsError.None then
            print("Error acknowledging purchase: " .. ackErr)
            return
        end
    end)
end

function self:ServerAwake()
    Payments.PurchaseHandler = ServerHandlePurchase
end
