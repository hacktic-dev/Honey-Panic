--!Type(Client)

COLLECTION_DISTANCE = 1

ClientObjectSpawner = require("ClientObjectSpawner")

--!SerializeField
local objectType : string = ""

function self:Update()
    local character = client.localPlayer.character
    characterPosition = character.transform.position
    selfPosition = self:GetComponent(Transform).position
    if Vector3.Distance(characterPosition, selfPosition) < COLLECTION_DISTANCE then
        ClientObjectSpawner.CollectObject(self:GetComponent(Transform).gameObject, objectType)
    end
end