--!Type(Client)

startVelocity = nil
squashStretchFactor = 0
isBouncing = false
canTriggerSquash = true

BOUNCE_HEIGHT = 0.5
BOUNCE_VELOCITY_THRESHOLD = 0.5

function self:ClientAwake()
    self.transform.position = self.transform.position + Vector3.new(0, 12, 0)

    local randomX = math.random(-2, 2)
    local randomZ = math.random(-2, 2)
    startVelocity = Vector3.new(randomX, 0, randomZ)
    self.transform.localScale = Vector3.new(0, 0, 0)
end

function self:Update()
    if self.transform.localScale.x < 1 and not isBouncing then
        self.transform.localScale = Vector3.Lerp(self.transform.localScale, Vector3.new(1, 1, 1), Time.deltaTime * 1.34)
    end

    local gravity = Vector3.new(0, -9.8, 0) * Time.deltaTime
    local windResistance = 0.9975

    if self.transform.position.y > 0 or startVelocity.y > 0 then
        -- Apply gravity
        startVelocity = startVelocity + gravity

        -- Apply wind resistance
        startVelocity = Vector3.new(startVelocity.x * windResistance, startVelocity.y, startVelocity.z * windResistance)

        -- Update position
        self.transform.position = self.transform.position + startVelocity * Time.deltaTime

        -- Check for bounce animation trigger
        if self.transform.position.y < BOUNCE_HEIGHT + 0.4 and canTriggerSquash and startVelocity.y < 0 and math.abs(startVelocity.y) > BOUNCE_VELOCITY_THRESHOLD then
            isBouncing = true
            canTriggerSquash = false
        end

        -- Check for bounce
        if self.transform.position.y <= BOUNCE_HEIGHT and startVelocity.y < 0 then
            if math.abs(startVelocity.y) < BOUNCE_VELOCITY_THRESHOLD then
            -- Stop bouncing if y velocity is too low
                startVelocity = Vector3.new(0, 0, 0)
                self.transform.position = Vector3.new(self.transform.position.x, 0.5, self.transform.position.z)
            else
                self.transform.position = Vector3.new(self.transform.position.x, 0.5, self.transform.position.z)
                startVelocity = Vector3.new(startVelocity.x, -startVelocity.y * 0.6, startVelocity.z) -- Reduce energy on bounce
            end
        end

        -- Allow squash to trigger again if height exceeds 1
        if self.transform.position.y > 1 then
            canTriggerSquash = true
        end
    else
        -- Object has come to rest
        startVelocity = Vector3.new(0, 0, 0)
    end

    -- Handle squash and stretch animation
    if isBouncing then
        local targetScale
        if not squashStretchState then
            -- Squashing phase
            targetScale = Vector3.new(1.5, 0.5, 1.5)
            self.transform.localScale = Vector3.Lerp(self.transform.localScale, targetScale, Time.deltaTime * 13)

            if math.abs(self.transform.localScale.y - targetScale.y) < 0.05 then
            squashStretchState = true
            end
        else
            -- Stretching phase
            targetScale = Vector3.new(1, 1, 1)
            self.transform.localScale = Vector3.Lerp(self.transform.localScale, targetScale, Time.deltaTime * 13)

            if math.abs(self.transform.localScale.y - targetScale.y) < 0.05 then
            isBouncing = false
            squashStretchState = false
            end
        end
    end
end