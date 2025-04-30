--!Type(Client)

-- Store the initial spawn location
spawnPosition = nil

--!SerializeField
local mainCam : GameObject = nil


-- Define parameters for wandering behavior
moveSpeed = 2.0       -- Movement speed of the object
rotateSpeed = 5.0     -- Rotation speed of the object
pauseDuration = 2.0   -- Duration to pause after reaching a target
targetPosition = nil  -- Current target position
timer = 0             -- Timer for pauses
moving = false        -- Is the object currently moving?

-- Define parameters for bobbing behavior
baseBobFrequency = 1.0 -- Base frequency of bobbing (how fast the bee bobs up and down)
baseBobAmplitude = 0.35 -- Amplitude of bobbing (range of motion in Y)
yOffset = 1.5         -- Base Y value (midpoint between 0.5 and 2.0)
bobFrequency = nil     -- Frequency for individual bees (randomized)
bobOffset = nil        -- Random phase offset for each bee

-- Time variable for controlling the sine wave
bobTime = 0

wanderDistance = 8

function self:ClientAwake()
    SetSpawnPosition(self.transform.position)
    self.transform.localScale = Vector3.new(0,0,0) -- Scale the bee to half its size
end

function SetSpawnPosition(position, _wanderDistance)
    spawnPosition = position
    wanderDistance = _wanderDistance or 8

    -- Randomize bobFrequency and bobOffset for each bee
    bobFrequency = baseBobFrequency + math.random() * 0.5 -- Slightly randomize frequency (within 0.5 of base)
    bobOffset = math.random() * math.pi * 2 -- Random initial phase offset (0 to 2π)
end

-- Randomly choose a new target position within a 16x16 area (X and Z)
function ChooseNewTarget()
    local randomX = math.random(-wanderDistance, wanderDistance)
    local randomZ = math.random(-wanderDistance, wanderDistance)
    -- Ignore Y-axis for wandering (X and Z only)
    targetPosition = spawnPosition + Vector3.new(randomX, 0, randomZ)
end

-- Rotate towards the target position
function RotateTowardsTarget()
    local direction = Vector3.new(targetPosition.x, self.transform.position.y, targetPosition.z) - self.transform.position
    local targetRotation = Quaternion.LookRotation(direction)
    self.transform.rotation = Quaternion.Slerp(self.transform.rotation, targetRotation, rotateSpeed * Time.deltaTime)
end

-- Move towards the target position in X and Z
function MoveTowardsTarget()
    if targetPosition then
        -- Ignore the Y axis for movement, move only in X and Z
        local direction = Vector3.new(targetPosition.x, self.transform.position.y, targetPosition.z) - self.transform.position
        local step = moveSpeed * Time.deltaTime

        -- Move towards the target position in X and Z only
        local newPosition = Vector3.MoveTowards(self.transform.position, targetPosition, step)

        -- Set the new position with updated X and Z
        self.transform.position = Vector3.new(newPosition.x, self.transform.position.y, newPosition.z)
    end
end

-- Update the Y position for bobbing movement
function UpdateBobbing()
    -- Advance bobbing time
    bobTime = bobTime + Time.deltaTime * bobFrequency

    -- Calculate bobbing Y value using sine wave, with randomized offset and amplitude
    local bobbingY = yOffset + math.sin(bobTime + bobOffset) * baseBobAmplitude

    -- Update the Y position of the object
    self.transform.position = Vector3.new(self.transform.position.x, bobbingY, self.transform.position.z)
end

-- Check if the object has reached the target position (ignore Y-axis)
function HasReachedTarget()
    if targetPosition then
        -- Only check X and Z distance
        local currentPositionXZ = Vector3.new(self.transform.position.x, 0, self.transform.position.z)
        local targetPositionXZ = Vector3.new(targetPosition.x, 0, targetPosition.z)
        return Vector3.Distance(currentPositionXZ, targetPositionXZ) < 0.1
    end
    return false
end

-- Function to handle wandering behavior inside Update
function self:Update()       
    if mainCam == nil then mainCam = GameObject.FindGameObjectWithTag("MainCamera") end

    if Vector3.Distance(self:GetComponent(Transform).position, mainCam:GetComponent(Transform).position) > 125 then
        return
    end

    if self.transform.localScale.x < 1 then
        self.transform.localScale = Vector3.Lerp(self.transform.localScale, Vector3.new(1,1,1), Time.deltaTime * 1.34)
    end


    -- Update the bobbing behavior independently of movement
    UpdateBobbing()

    -- If currently moving towards the target
    if moving then
        -- Rotate towards and move to the target position
        RotateTowardsTarget()
        MoveTowardsTarget()

        -- If the target is reached, start the pause
        if HasReachedTarget() then
            moving = false
            timer = pauseDuration
        end
    else
        -- Handle pausing
        timer = timer - Time.deltaTime
        if timer <= 0 then
            -- Choose a new target and start moving again
            ChooseNewTarget()
            moving = true
        end
    end
end
