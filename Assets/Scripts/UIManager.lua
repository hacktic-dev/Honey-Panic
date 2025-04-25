--!Type(Module)

--!SerializeField
local TokenDisplayObject : GameObject = nil
--!SerializeField
local BeeCollectionUiObject : GameObject = nil
--!SerializeField
local HoneyPanicUiObject : GameObject = nil
--!SerializeField
local RoundOverUiObject : GameObject = nil
--!SerializeField
local UpgradesDisplayUiObject : GameObject = nil
--!SerializeField
local RewardsWheelObject : GameObject = nil
--!SerializeField
local RewardObtainUiObject : GameObject = nil  

GameplayManager = require("GameplayManager")

local uiMap = {
    TokenDisplay = TokenDisplayObject,
    BeeCollectionUi = BeeCollectionUiObject,
    HoneyPanicUi = HoneyPanicUiObject,
    RoundOverUi = RoundOverUiObject,
    UpgradesDisplayUi = UpgradesDisplayUiObject,
    RewardsWheel = RewardsWheelObject,
    RewardObtainUi = RewardObtainUiObject,
}

-- Activate the object if it is not active
function ActivateObject(object)
    if not object.activeSelf then
        object:SetActive(true)
        --print("UI activated")
    end
end

-- Deactivate the object if it is active
function DeactivateObject(object)
    if object.activeSelf then
        object:SetActive(false)
        --print("UI deactivated")
    end
end

--- Toggles visibility for all UI components, with an optional exclusion list
function ToggleAll(visible: boolean, except)
    for ui, component in pairs(uiMap) do
        if not (except and except[ui]) then
            if visible then
                ActivateObject(component)
            else
                DeactivateObject(component)
            end
        end
    end
end

function IsActive(ui : string)
    return uiMap[ui].activeSelf
end

--- Toggles the visibility of a specific UI component
function ToggleUI(ui: string, visible: boolean)
    local uiComponent = uiMap[ui]
    if not uiComponent then
        --print("[ToggleUI] UI component not found: " .. ui)
        return
    end

    if visible then
       --print("[ToggleUI] UI component activated " .. ui)
       ActivateObject(uiComponent)
    else
        --print("[ToggleUI] UI component deactivated " .. ui)
       DeactivateObject(uiComponent)
    end
end

function HideAll()
    for ui, component in pairs(uiMap) do
        DeactivateObject(component)
    end
end

function self:ClientAwake()
    HideAll()
end

--[[UI SCREEN SPECIFIC FUNCTIONS]]--

function ShowTokenDisplay()
    ToggleUI("TokenDisplay", true)
end

function ShowBeeCollectionMode()

    if IsActive("RewardsWheel") then
        return
    end

    ToggleUI("BeeCollectionUi", true)
    ToggleUI("UpgradesDisplayUi", true)
    ToggleUI("HoneyPanicUi", false)
    ToggleUI("RoundOverUi", false)

    UpgradesDisplayUiObject:GetComponent(UpgradesDisplayUi).ShowMagnet()
end

function ShowHoneyPanicMode()

    if IsActive("RewardsWheel") then
        return
    end

    ToggleUI("BeeCollectionUi", false)
    ToggleUI("HoneyPanicUi", true)
    HoneyPanicUiObject:GetComponent(HoneyPanicUi).Init()

    UpgradesDisplayUiObject:GetComponent(UpgradesDisplayUi).HideMagnet()
end

function ShowRoundOverUi(honeyCollected, tokensEarned)

    if IsActive("RewardsWheel") then
        return
    end

    ToggleUI("RoundOverUi", true)
    ToggleUI("HoneyPanicUi", false)
    RoundOverUiObject:GetComponent(RoundOverUi).Init(honeyCollected, tokensEarned)
end

function ShowRewardsWheel()
    ToggleUI("RewardsWheel", true)
    ToggleUI("BeeCollectionUi", false)
    ToggleUI("HoneyPanicUi", false)
    ToggleUI("UpgradesDisplayUi", false)
    ToggleUI("TokenDisplay", false)
    RewardsWheelObject:GetComponent(RewardsWheel).Init(true)
end

function HideRewardsWheel()
    ToggleUI("RewardsWheel", false)
    ToggleUI("UpgradesDisplayUi", true)
    ToggleUI("TokenDisplay", true)
    
    if GameplayManager.GetClientGameState() == GameplayManager.GameStateTypes.BeeCollection then
        ShowBeeCollectionMode()
    elseif GameplayManager.GetClientGameState() == GameplayManager.GameStateTypes.HoneyPanic then
        ShowHoneyPanicMode()
    end
end

function ShowRewardObtainUi(reward_id : string)
    ToggleUI("RewardObtainUi", true)
    ToggleUI("RewardsWheel", false)

    RewardObtainUiObject:GetComponent(RewardObtainUi).Init(reward_id)
end

function HideRewardObtainUi()
    ToggleUI("RewardObtainUi", false)
    ToggleUI("RewardsWheel", true)
    RewardsWheelObject:GetComponent(RewardsWheel).Init(false)
end