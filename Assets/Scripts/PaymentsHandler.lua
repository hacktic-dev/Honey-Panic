--!Type(Module)

NotifyMagnetPurchasedEvent = Event.new("NotifyMagnetPurchasedEvent")
NotifyMultiplierPurchasedEvent = Event.new("NotifyMultiplierPurchasedEvent")

UpgradesManager = require("UpgradesManager")

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

        transaction = InventoryTransaction.new():Give("GoldPool", "gold_spent", 3)
        Inventory.CommitTransaction(transaction)
    end)
end

function GiveGold(player: Player, amount: number)
    Wallet.TransferGoldToPlayer(player, amount, function(response, err)
        if err ~= WalletError.None then
            error("Something went wrong while transferring gold: " .. WalletError[err])
            return
        end

        print(amount .. " gold transferred to player " .. player.name)
        transaction = InventoryTransaction.new():Take("GoldPool", "gold_spent", amount)
        Inventory.CommitTransaction(transaction)
    end)
end

function self:ServerAwake()
    Payments.PurchaseHandler = ServerHandlePurchase

    UpgradesManager.RequestGivePlayerGoldEvent:Connect(function(player, amount)
        GiveGold(player, amount)
    end)
end
