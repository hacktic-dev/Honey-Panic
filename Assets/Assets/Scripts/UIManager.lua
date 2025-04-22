--!Type(Module)

--!SerializeField
local TokenDisplayObject : GameObject = nil
--!SerializeField
local BeeCollectionUiObject : GameObject = nil
--!SerializeField
local HoneyPanicUiObject : GameObject = nil

local uiMap = {
    TokenDisplay = TokenDisplayObject,
    BeeCollectionUi = BeeCollectionUiObject,
    HoneyPanicUi = HoneyPanicUiObject,
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
    ToggleUI("BeeCollectionUi", true)
    ToggleUI("HoneyPanicUi", false)
end

function ShowHoneyPanicMode()
    ToggleUI("BeeCollectionUi", false)
    ToggleUI("HoneyPanicUi", true)
end