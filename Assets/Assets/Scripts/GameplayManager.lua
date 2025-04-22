--!Type(Module)

UIManager = require("UIManager")
ClientObjectSpawner = require("ClientObjectSpawner")

local GameStateTypes = { 
    BeeCollection = 0,
    HoneyPanic = 1,
}

local BeeCount : number = 0
local GameState = GameStateTypes.BeeCollection

BEE_THRESHOLD = 1000 -- Threshold for bee collection
HONEY_PANIC_MAX_TIME = 60 -- Maximum time for honey panic in seconds

local honeyPanicTime = nil
 
RequestBeeCollectedEvent = Event.new("RequestBeeCollectedEvent") -- Event to request a bee collection
NotifyBeeCountChangedEvent = Event.new("NotifyBeeCountChangedEvent") -- Event to notify bee count changes

NotifyHoneyPanicStartedEvent = Event.new("NotifyHoneyPanicStartedEvent") -- Event to notify when honey panic starts
NotifyBeeCollectionStartedEvent = Event.new("NotifyBeeCollectionStartedEvent") -- Event to notify when bee collection starts

RequestCurrentGameStateEvent = Event.new("RequestCurrentGameStateEvent") -- Event to request the current game state
NotifyCurrentGameStateEvent = Event.new("NotifyCurrentGameStateEvent") -- Event to notify the current game state

function self:ServerAwake()
    InitBeeCollection()

    RequestBeeCollectedEvent:Connect(function(player, value)
        if GameState == GameStateTypes.BeeCollection then
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

function self:ClientAwake()
    honeyPanicTime = IntValue.new("honeyPanicTime", 0)

    Timer.new(1, function()
        if GameState == GameStateTypes.HoneyPanic then
            honeyPanicTime.value = honeyPanicTime.value - 1
            if honeyPanicTime.value <= 0 then
                InitBeeCollection()
            end
        end
    end, true)

    NotifyCurrentGameStateEvent:Connect(function(gameState)
        UIManager.ShowTokenDisplay()
        print(tostring(gameState))
        if gameState == GameStateTypes.BeeCollection then
            print("GameplayManager: NotifyCurrentGameStateEvent: Player: " .. client.localPlayer.name .. " received game state: BeeCollection")
            UIManager.ShowBeeCollectionMode()
            ClientObjectSpawner.SetBeeCollectionMode()
        elseif gameState == GameStateTypes.HoneyPanic then
            print("GameplayManager: NotifyCurrentGameStateEvent: Player: " .. client.localPlayer.name .. " received game state: HoneyPanic")
            UIManager.ShowHoneyPanicMode()
            ClientObjectSpawner.SetHoneyPanicMode()
        end
    end)
end

