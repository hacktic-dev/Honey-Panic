--!Type(Module)

UIManager = require("UIManager")
ClientObjectSpawner = require("ClientObjectSpawner")
PlayerTracker = require("PlayerTracker")

local GameStateTypes = { 
    BeeCollection = 0,
    HoneyPanic = 1,
}

local BeeCount : number = 0
local GameState = GameStateTypes.BeeCollection

BEE_THRESHOLD = 1000 -- Threshold for bee collection
HONEY_PANIC_MAX_TIME = 10 -- Maximum time for honey panic in seconds

honeyPanicTime = nil
 
RequestBeeCollectedEvent = Event.new("RequestBeeCollectedEvent") -- Event to request a bee collection
NotifyBeeCountChangedEvent = Event.new("NotifyBeeCountChangedEvent") -- Event to notify bee count changes

NotifyHoneyPanicStartedEvent = Event.new("NotifyHoneyPanicStartedEvent") -- Event to notify when honey panic starts
NotifyBeeCollectionStartedEvent = Event.new("NotifyBeeCollectionStartedEvent") -- Event to notify when bee collection starts

RequestCurrentGameStateEvent = Event.new("RequestCurrentGameStateEvent") -- Event to request the current game state
NotifyCurrentGameStateEvent = Event.new("NotifyCurrentGameStateEvent") -- Event to notify the current game state

NotifyHoneyPanicCountdownValue = Event.new("NotifyHoneyPanicCountdownValue") -- Event to notify the honey panic countdown value

function self:ServerAwake()
    InitBeeCollection()

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
                InitBeeCollection()
            end
        end
    end, true)

end

function InitBeeCollection()
    GameState = GameStateTypes.BeeCollection
    BeeCount = 0
    NotifyBeeCollectionStartedEvent:FireAllClients()
    NotifyBeeCountChangedEvent:FireAllClients(BeeCount)
end

function EnterHoneyPanic()
    GameState = GameStateTypes.HoneyPanic
    honeyPanicTime.value = HONEY_PANIC_MAX_TIME
    -- Notify all players about the game state change
    NotifyHoneyPanicStartedEvent:FireAllClients()
end

function SetBeeCollectionModeClient()
    UIManager.ShowBeeCollectionMode()
    ClientObjectSpawner.SetBeeCollectionMode()
end

function SetHoneyPanicModeClient()
    UIManager.ShowHoneyPanicMode()
    ClientObjectSpawner.SetHoneyPanicMode()
end

function self:ClientAwake()
    honeyPanicTime = IntValue.new("honeyPanicTime", 0)

    NotifyCurrentGameStateEvent:Connect(function(gameState)
        UIManager.ShowTokenDisplay()
        print(tostring(gameState))
        if gameState == GameStateTypes.BeeCollection then
            print("GameplayManager: NotifyCurrentGameStateEvent: Player: " .. client.localPlayer.name .. " received game state: BeeCollection")
            SetBeeCollectionModeClient()
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

    Timer.new(0.1, function()
        RequestBeeCollectedEvent:FireServer(10, 10) -- Request a bee collection from the server
    end, true)
end

