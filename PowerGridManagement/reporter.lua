os.loadAPI("ocs/apis/sensor")

local sensorSide = "top"
local modemSide = "left"
local timeInterval = 2.5
local sendProtocol = "PowerLevel"

rednet.open(modemSide)
local mySensor = sensor.wrap(sensorSide)
local totalCapacity = 0
local currentStorage = 0
while true do
  totalCapacity = 0
  currentStorage = 0
  local targets = mySensor.getTargets()
  for k,v in pairs(targets) do
    if v["RawName"] == "ic2.mfsu" then
      local deets =  mySensor.getTargetDetails(k)
      totalCapacity = totalCapacity + deets["Capacity"]
      currentStorage = currentStorage + deets["Stored"]
    end
  end
  local currentPercentage = currentStorage / totalCapacity
  local outPercent = currentPercentage * 100
  term.clear()
  term.setCursorPos(1,1)
  print("Current Power Levels:"..outPercent.."%")
  rednet.broadcast(currentPercentage,sendProtocol)
  print("Sending "..currentPercentage)
  os.sleep(timeInterval)
end
