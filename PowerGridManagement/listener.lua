local modemSide = "bottom"
local redstoneSide = "back"
local listenProtocol = "PowerLevel"
local offThreshold = 0.25
local onThreshold = 0.33

rednet.open(modemSide)
local last = "none"
while true do
  term.clear()
  term.setCursorPos(1,1)
  local status = "nothin"
  if redstone.getOutput(redstoneSide) then
    status = "Power Disabled"
  else
    status = "Power Enabled"
  end
  print("Current Redstone Status: "..status)
  print("Last Contact: "..last)
  local senderId, message, protocol = rednet.receive(listenProtocol)
  last = message
  local pow = tonumber(message)
  if pow < offThreshold then
    redstone.setOutput(redstoneSide,true)
  elseif pow > onThreshold then
    redstone.setOutput(redstoneSide,false)
  end
end
