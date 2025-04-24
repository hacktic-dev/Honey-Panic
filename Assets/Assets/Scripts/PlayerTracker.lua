--!Type(Module)

players = {} -- a table variable to store current players  and info

batchedInventoryTransactions = {} -- a table variable to store batched inventory transactions

NotifyScoreChangedEvent = Event.new("NotifyScoreChangedEvent") -- Event to notify score changes

GameplayManager = require("GameplayManager")
UIManager = require("UIManager")

local function TrackPlayers(game, characterCallback, disconnectedCallback)
    scene.PlayerJoined:Connect(function(scene, player) -- When a player joins a scene add them to the players table
        players[player] = {
            player = player,
            score = IntValue.new("score" .. tostring(player.id), 0) --Score is a Network integer with an ID built of the player's ID to ensure uniqueness
        }
        -- Each player is a `Key` in the table, with the values `player` and `score`

        player.CharacterChanged:Connect(function(player, character) 
            local playerinfo = players[player] -- After the player's character is instantiated store their info from the player table (`player`,`score`)
            if (character == nil) then
                return --If no character instantiated return
            end 

            if characterCallback then -- If there is a character callback provided call it with a reference to the player info
                characterCallback(playerinfo)
            end
        end)

        if client ~= nil and client.localPlayer == player then
            players[player].score.Changed:Connect(function(newVal, oldVal)
            NotifyScoreChangedEvent:Fire(newVal)
          end)
  
          GameplayManager.RequestCurrentGameStateEvent:FireServer() -- Request the current game state from the server when the player joins
      end
    end)

    game.PlayerDisconnected:Connect(function(player) -- Remove player from the current table if they disconnect
        if disconnectedCallback then
            disconnectedCallback(player)
        end
        players[player] = nil
    end)
end

--[[
    Client
]]
function self:ClientAwake()
    -- Track players on Client with a callback
    TrackPlayers(client)
end

function GivePlayerTokens(player, amount)
    local newScore = players[player].score.value + amount
    players[player].score.value = newScore

    -- Batch inventory transactions and commit them every 3 seconds
    if batchedInventoryTransactions[player] == nil then
        batchedInventoryTransactions[player] = InventoryTransaction.new():GivePlayer(player, "tokens", amount)
        Timer.new(3, function()
            Inventory.CommitTransaction(batchedInventoryTransactions[player])
            batchedInventoryTransactions[player] = nil
        end, false)
    else
        batchedInventoryTransactions[player]:GivePlayer(player, "tokens", amount)
    end
end

function GiveAllPlayersTokens(amount)
    for player, playerInfo in pairs(players) do
        GivePlayerTokens(player, amount)
    end
end

--[[
    Server
]]
function self:ServerAwake()
    
    function InitTokens(playerInfo)
        Inventory.GetPlayerItem(playerInfo.player, "tokens", function(item)
            if item == nil then
                playerInfo.score.value = 0
            else
                playerInfo.score.value = item.amount
            end
        end)
    end

    TrackPlayers(server, InitTokens)
end