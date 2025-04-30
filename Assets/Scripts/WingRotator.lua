--!Type(Client)

-- Define parameters for the sinusoidal rotation
rotateAmplitude = 30 -- Half the rotation range (40 degrees means it oscillates between -40 and +40)
rotateFrequency = 20.0 -- How fast the rotation oscillates (1.0 = one cycle per second)

--!SerializeField
local direction : number = 1

-- Time variable for controlling the sine wave rotation
rotationTime = 0

local currentAngle = 0

-- Function to update the rotation based on a sine wave
function UpdateRotation()
    -- Increment time
    rotationTime = rotationTime + Time.deltaTime * rotateFrequency

    -- Calculate the rotation angle using a sine wave and map it between 0 and 80 degrees
    local angle = direction * rotateAmplitude * math.sin(rotationTime) + currentAngle

    -- Apply the rotation angle to the x-axis
    self.transform.localRotation = Quaternion.Euler(angle, 90, -90)
end

-- Function to handle the update cycle
function self:Update()
    -- Update the sinusoidal rotation independently
    if self:GetComponent(Renderer).isVisible == false then
        return

    end
    UpdateRotation()
end

function self:Start()
    currentAngle = self.transform.localEulerAngles.x
end