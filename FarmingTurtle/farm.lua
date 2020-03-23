waittime = 30

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
    if turtle.getFuelLevel() < 25 then
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
    for i=1,7 do
        turtle.forward()
        doFarming()
    end
    turtle.forward()
    dropoff()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
end

function mainFunction()
    while true do
        doALine()
    end
end

mainFunction()