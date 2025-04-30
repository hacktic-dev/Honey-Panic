--!Type(Client)

--!SerializeField
local COLLECTION_DISTANCE : number = 2
MAGNET_DISTANCE = 6.5
MAGNET_STRENGTH = 2

ClientObjectSpawner = require("ClientObjectSpawner")
UpgradesManager = require("UpgradesManager")

--!SerializeField
local objectType : string = ""

function self:Update()
    local character = client.localPlayer.character
    characterPosition = character.transform.position
    selfPosition = self:GetComponent(Transform).position
    if Vector3.Distance(characterPosition, selfPosition) < COLLECTION_DISTANCE then
        ClientObjectSpawner.CollectObject(self:GetComponent(Transform).gameObject, objectType)
    end

    if UpgradesManager.IsClientMagnetActive() then
        local distance = Vector3.Distance(characterPosition, selfPosition)
        if distance < MAGNET_DISTANCE then
            local direction = (characterPosition - selfPosition).normalized
            self:GetComponent(Transform).position = self:GetComponent(Transform).position + direction * MAGNET_STRENGTH * (MAGNET_DISTANCE - distance) * Time.deltaTime
        end
    end
end