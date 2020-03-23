local modemSide = "right"
local pistonSide = "left"

rednet.open(modemSide)

while true do 
  local sid, msg = rednet.receive()
  redstone.setOutput(pistonSide,msg)
end
