local component = require("component")
local turret = component.os_energyturret
--for k, v in pairs(component.os_energyturret) do print(k) end

local function fire()
    turret.setArmed(true)
    while not turret.isOnTarget() do os.sleep(0) end
    for i = 0, 2, 1 do
        result = turret.fire()
        while not turret.isReady() do os.sleep(0) end
    end
    turret.setArmed(false)
end

local function findTarget()
    local target = component.os_entdetector.scanEntities()[1]
    if not target then return end
    print(target.name..": "..target.range.." blocks away")
    --Find 2d distance from 3d: (math.sqrt(math.pow(target.range, 2)-math.pow(target.y, 2)))
    return (math.deg(math.atan((target.x/target.z)*-1)) + 0), math.acos(target.range/math.abs(target.y))
end

turret.powerOn()

local yaw, pitch = findTarget()
if yaw then
    turret.moveTo(yaw, 0)
    fire()
    print(pitch)
end
turret.moveTo(0, 0)
while not turret.isOnTarget() do os.sleep(0) end
turret.powerOff()
