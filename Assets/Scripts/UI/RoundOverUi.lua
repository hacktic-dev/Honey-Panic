--!Type(UI)

--!Bind
local _roundOverContainer : VisualElement = nil

UIManager = require("UIManager")

function Init(honeyCollected, tokensEarned)
    _roundOverContainer:Clear()

    local honeyCollectedLabel = UILabel.new()
    honeyCollectedLabel:SetPrelocalizedText("Honey Collected: " .. tostring(honeyCollected))
    honeyCollectedLabel:AddToClassList("round-over-label")
    _roundOverContainer:Add(honeyCollectedLabel)

    local tokensEarnedLabel = UILabel.new()
    tokensEarnedLabel:SetPrelocalizedText("Tokens Earned: " .. tostring(tokensEarned))
    tokensEarnedLabel:AddToClassList("round-over-label")
    _roundOverContainer:Add(tokensEarnedLabel)

    local continueButton = UIButton.new()
    local continueButtonLabel = UILabel.new()
    continueButtonLabel:SetPrelocalizedText("Continue")
    continueButtonLabel:AddToClassList("round-over-label")
    continueButton:Add(continueButtonLabel)
    continueButton:AddToClassList("close-button")
    continueButton:RegisterPressCallback(function()
        UIManager.ShowBeeCollectionMode()
    end)
    _roundOverContainer:Add(continueButton)
end