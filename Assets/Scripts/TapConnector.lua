--!Type(Client)

--!SerializeField
local role : string = ""

UIManager = require("UIManager")

function self:ClientAwake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
        if role == "rewards_wheel" then
            UIManager.ShowRewardsWheel()
        end
    end)
end