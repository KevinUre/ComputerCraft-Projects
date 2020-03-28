waittime = 5
minFuel = 25
lineLength = 6
print("Farming Turtle v1.1")

function patientForward()
    while true do
        local success, status = turtle.forward()
        if success == true then
            return true
        else -- why couldnt we move?
            local inspectStatus = turtle.inspect()
            if inspectStatus == true then
                return false --blocks wont move out of the way eventually
            else
                sleep(0.05) -- its a mob, lets wait and try again
            end
        end
    end
end

function CalibrateFromAboveChest(tries)
    if tries > 1 then
        printf("I'm lost! Shutting down...")
        exit()
    end
    local moved = patientForward()
    if moved == true then
        local success, info = turtle.inspectDown()
        if success == true then
            -- are we above chest?
            if info["name"] == "minecraft:chest" then
                turtle.turnLeft() --ahead front and we are ready
                return true
            --are we above a crop?
            elseif info["name"] == "minecraft:wheat" then
                turtle.back() --we were already good, go back
                return true
            end
            -- #BUG# if we were above the correct spot, but it got trampled, we will be lost
        end
        -- the easy cases weren't it, so we wandered away from the farm: go back, turn, and try again
        turtle.back()
        turtle.turnLeft()
        return CalibrateFromAboveChest(tries + 1)
    else
        -- we were obstructed from leaving the chest, turn and try again
        turtle.turnLeft()
        return CalibrateFromAboveChest(tries + 1)
    end
    return false --should never get here
end

function CalibrateFromCrops()
    local tries = 0
    while tries < 10 do
        local success, info = turtle.inspectDown()
        if success == true then
            if info["name"] == "minecraft:chest" then
                turtle.turnLeft()
                patientForward()
                turtle.turnLeft()
                return
            end
        end
        patientForward()
        tries = tries + 1
    end
    printf("I'm lost! Shutting down...")
    exit()
end

function BeginCalibration()
    local success, info = turtle.inspectDown()
    if success == true then
        if info["name"] == "minecraft:chest" then
            CalibrateFromAboveChest(0)
        else
            CalibrateFromCrops()
        end
    else
        printf("I'm Probably above an unplanted crop block")
        CalibrateFromCrops()
    end
end

function findSeeds()
    for i=1,16 do 
        turtle.select(i)
        local info = turtle.getItemDetail()
        if info ~= nil then
            if info["name"]=="minecraft:wheat_seeds" then
                return i
            end
        end
    end
    printf("ran out of seeds")
    exit()
end

function findFuel()
    for i=1,16 do 
        turtle.select(i)
        local info = turtle.getItemDetail()
        if info ~= nil then
            if info["name"]=="Railcraft:fuel.coke" then
                return i
            end
        end
    end
    return 0
end

function dropoff()
    local seedIndex = findSeeds()
    local fuelIndex = findFuel()
    for i=1,16 do 
        if i ~= seedIndex then
            if i ~= fuelIndex then
                turtle.select(i)
                turtle.dropDown()
            end
        end
    end
    turtle.select(seedIndex)
end

function doFarming()
    if turtle.inspectDown() == true then
        local complete = false
        while complete ~= true do
            local success, info = turtle.inspectDown()
            if info["metadata"] == 7 then
                complete = true
            else
                sleep(waittime)
            end
        end
        turtle.digDown()
        turtle.digDown()
        turtle.suckDown()
        turtle.suckDown()
        local seedIndex = findSeeds()
        turtle.select(seedIndex)
        turtle.placeDown()
    else
        turtle.digDown()
        local seedIndex = findSeeds()
        turtle.select(seedIndex)
        turtle.placeDown()
    end
end

function manageFuel()
    if turtle.getFuelLevel() < minFuel then
        local fuelIndex = findFuel()
        if findFuel == 0 then
            print("need refueling")
            exit()
        else
            turtle.select(fuelIndex)
            turtle.refuel()
        end
    else
        print("Fuel level: "..turtle.getFuelLevel())
    end
end

function doALine()
    manageFuel()
    for i=1,lineLength do
        patientForward()
        doFarming()
        sleep(0)
    end
    patientForward()
    dropoff()
    turtle.turnLeft()
    patientForward()
    turtle.turnLeft()
    sleep(0)
end

function mainFunction()
    BeginCalibration()
    while true do
        doALine()
        sleep(0)
    end
end

mainFunction()