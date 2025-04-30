--!Type(Module)

UIManager = require("UIManager")
ClientObjectSpawner = require("ClientObjectSpawner")
PlayerTracker = require("PlayerTracker")
UpgradesManager = require("UpgradesManager")

GameStateTypes = { 
    BeeCollection = 0,
    HoneyPanic = 1,
}

local BeeCount : number = 0
local GameState = GameStateTypes.BeeCollection
local clientGameState = nil
local HoneyCollected : number = 0

BEE_THRESHOLD = 1000 -- Threshold for bee collection
HONEY_PANIC_MAX_TIME = 20 -- Maximum time for honey panic in seconds

honeyPanicTime = nil
 
RequestBeeCollectedEvent = Event.new("RequestBeeCollectedEvent") -- Event to request a bee collection
NotifyBeeCountChangedEvent = Event.new("NotifyBeeCountChangedEvent") -- Event to notify bee count changes

NotifyHoneyPanicStartedEvent = Event.new("NotifyHoneyPanicStartedEvent") -- Event to notify when honey panic starts
NotifyBeeCollectionStartedEvent = Event.new("NotifyBeeCollectionStartedEvent") -- Event to notify when bee collection starts

RequestCurrentGameStateEvent = Event.new("RequestCurrentGameStateEvent") -- Event to request the current game state
NotifyCurrentGameStateEvent = Event.new("NotifyCurrentGameStateEvent") -- Event to notify the current game state

NotifyHoneyPanicCountdownValue = Event.new("NotifyHoneyPanicCountdownValue") -- Event to notify the honey panic countdown value
NotifyRoundOverEvent = Event.new("NotifyRoundOverEvent") -- Event to notify when the round is over

RequestHoneyCollectedEvent = Event.new("RequestHoneyCollectedEvent") -- Event to request honey collected

BeeCollectionStartedEvent = Event.new("BeeCollectionStartedEvent") -- Event to notify when bee collection starts

function self:ServerAwake()
    EnterBeeCollection()

    RequestBeeCollectedEvent:Connect(function(player, value, tokenValue)
        if GameState == GameStateTypes.BeeCollection then
            PlayerTracker.GivePlayerTokens(player, tokenValue)
            BeeCount = BeeCount + value 
            if BeeCount >= BEE_THRESHOLD then 
                EnterHoneyPanic()
                return
            end
            NotifyBeeCountChangedEvent:FireAllClients(BeeCount) 
        end
    end)

    RequestCurrentGameStateEvent:Connect(function(player)
        NotifyCurrentGameStateEvent:FireClient(player, GameState)
    end)

    honeyPanicTime = IntValue.new("honeyPanicTime", 0) 

    Timer.new(1, function()
        if GameState == GameStateTypes.HoneyPanic then
            honeyPanicTime.value = honeyPanicTime.value - 1

            if honeyPanicTime.value <= 0 then
                PlayerTracker.GiveAllPlayersTokens(HoneyToTokens(HoneyCollected)) -- Give all players tokens based on the honey collected
                NotifyRoundOverEvent:FireAllClients(HoneyCollected, HoneyToTokens(HoneyCollected)) -- Notify all players that the round is over
                EnterBeeCollection()
            end
        end
    end, true)

    RequestHoneyCollectedEvent:Connect(function(player, value)
        if GameState == GameStateTypes.HoneyPanic then
            HoneyCollected = HoneyCollected + value
        end
    end)

end

function HoneyToTokens(honeyCollected)
    return  math.floor(honeyCollected * UpgradesManager.GetMultiplier()) --For now just do 1:1 conversion
end

function EnterBeeCollection()
    GameState = GameStateTypes.BeeCollection
    BeeCount = 0
    BeeCollectionStartedEvent:Fire()
    NotifyBeeCollectionStartedEvent:FireAllClients()
    NotifyBeeCountChangedEvent:FireAllClients(BeeCount)
end

function EnterHoneyPanic()
    GameState = GameStateTypes.HoneyPanic
    honeyPanicTime.value = HONEY_PANIC_MAX_TIME
    HoneyCollected = 0
    -- Notify all players about the game state change
    NotifyHoneyPanicStartedEvent:FireAllClients()
end

function SetBeeCollectionModeClient()
    ClientObjectSpawner.SetBeeCollectionMode()
end

function SetHoneyPanicModeClient()
    UIManager.ShowHoneyPanicMode()
    ClientObjectSpawner.SetHoneyPanicMode()
end

function GetClientGameState()
    return clientGameState
end

function self:ClientAwake()
    honeyPanicTime = IntValue.new("honeyPanicTime", 0)

    NotifyCurrentGameStateEvent:Connect(function(gameState)
        clientGameState = gameState
        UIManager.ShowTokenDisplay()
        print(tostring(gameState))
        if gameState == GameStateTypes.BeeCollection then
            print("GameplayManager: NotifyCurrentGameStateEvent: Player: " .. client.localPlayer.name .. " received game state: BeeCollection")
            SetBeeCollectionModeClient()
            UIManager.ShowBeeCollectionMode()
        elseif gameState == GameStateTypes.HoneyPanic then
            print("GameplayManager: NotifyCurrentGameStateEvent: Player: " .. client.localPlayer.name .. " received game state: HoneyPanic")
            SetHoneyPanicModeClient()
        end
    end)

    NotifyHoneyPanicStartedEvent:Connect(function()
        SetHoneyPanicModeClient()
    end)

    NotifyBeeCollectionStartedEvent:Connect(function()
        SetBeeCollectionModeClient()
    end)

    NotifyRoundOverEvent:Connect(function(honeyCollected, tokenValue)
        UIManager.ShowRoundOverUi(honeyCollected, tokenValue) -- Show the round over screen with the collected honey and token value
    end)

    ClientObjectSpawner.BeeCollectedEvent:Connect(function(object)
        RequestBeeCollectedEvent:FireServer(10, 10)
    end)

    ClientObjectSpawner.HoneyCollectedEvent:Connect(function(object)
        RequestHoneyCollectedEvent:FireServer(1)
    end)
end

