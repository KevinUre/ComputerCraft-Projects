local reactorLoc = "1,-1,-1"
local threshold = 65
local sensorSide = "top"
local reactorSide = "back"
local inputSide = "left"

function listener()
  while true do 
    local event = os.pullEventRaw()
    if event == "terminate" then
      term.clear()
      term.setCursorPos(1,1)
      print("Termination call detected")
      print("Powering off reactor")
      redstone.setOutput(reactorSide,false)
      print("Reactor powered off")
      return
    end
  end
end

os.loadAPI("ocs/apis/sensor")
mySens = sensor.wrap(sensorSide)
local reactorActive = false
redstone.setOutput(reactorSide,false)
function MainFunct()
  while true do 
    term.clear()
    term.setCursorPos(1,1)
    print("Nuclear Controller Active")
    local deets = mySens.getTargetDetails(reactorLoc)
    local curTemp = deets["HeatPercentage"]
    if deets["Active"] then
      print("Reactor Active")
    else
      print("Reactor Inactive")
    end
    print("Reactor Heat at "..curTemp.."%")
    local input = redstone.getInput(inputSide)
    if (not reactorActive and curTemp < threshold and input) then
      reactorActive = true
      redstone.setOutput(reactorSide,true)
    elseif ((reactorActive and curTemp > threshold) or not input) then
      reactorActive = false
      redstone.setOutput(reactorSide,false)
    end
    os.sleep(0.05)
  end
end

parallel.waitForAny(listener, MainFunct)
