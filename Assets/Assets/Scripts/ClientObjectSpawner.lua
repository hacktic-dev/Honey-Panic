--!Type(Module)

--!SerializeField
local SpawnZones : {BoxCollider} = nil
--!SerializeField
local BeePrefab : GameObject = nil
--!SerializeField
local HoneyPrefab : GameObject = nil

GameplayStateTypes = 
{
    BeeCollection = 1,
    HoneyPanic = 2,
}

GameplayState = GameplayStateTypes.BeeCollection

MAX_OBJECTS_COUNT = 100

spawnedPrefabs = {}

function SelectSpawnPosition()
    local spawnZone = SpawnZones[math.random(1, #SpawnZones)]
    local spawnPosition = Vector3.new(
        spawnZone.center.x + (math.random() - 0.5) * spawnZone.size.x,
        spawnZone.center.y + (math.random() - 0.5) * spawnZone.size.y,
        spawnZone.center.z + (math.random() - 0.5) * spawnZone.size.z
    )
    spawnPosition = spawnPosition + spawnZone.transform.position
    return spawnPosition
end

function CleanObjects()
    print("Cleaning objects")
    for _, prefab in ipairs(spawnedPrefabs) do
        Object.Destroy(prefab)
    end
    spawnedPrefabs = {}
end

function SetBeeCollectionMode()
    GameplayState = GameplayStateTypes.BeeCollection
    CleanObjects()
end

function SetHoneyPanicMode()
    GameplayState = GameplayStateTypes.HoneyPanic
    CleanObjects()
end

function SpawnObject(prefab)
    local spawnPosition = SelectSpawnPosition()
    local spawnedObject = Object.Instantiate(prefab, spawnPosition, Quaternion.identity)
    table.insert(spawnedPrefabs, spawnedObject)
end

function self:ClientAwake()
    Timer.new(1, function()
        if GameplayState == GameplayStateTypes.BeeCollection then
            if #spawnedPrefabs < MAX_OBJECTS_COUNT then
                SpawnObject(BeePrefab)
            end
        elseif GameplayState == GameplayStateTypes.HoneyPanic then
            if #spawnedPrefabs < MAX_OBJECTS_COUNT then
                SpawnObject(HoneyPrefab)
            end
        end
    end, true)
end