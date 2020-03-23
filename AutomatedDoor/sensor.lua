os.loadAPI("ocs/apis/sensor")
 
-- the location of the redstone lamp relative to the sensor
local offset = {
  X = 0,
  Y = 3,
  Z = -2
}
 
-- how close a player has to be to activate the lamp
local radius = 4

 -- find the distance from the player position to the offset
function distance(pos)
  local xd = pos.X - offset.X
  local yd = pos.Y - offset.Y
  local zd = pos.Z - offset.Z
  return math.sqrt(xd*xd + yd*yd + zd*zd)
end

rednet.open("back")
local proximity = sensor.wrap("top")
while true do 
  local signal = false
  local targets = proximity.getTargets()
  for k, v in pairs(targets) do
    if v.IsPlayer then
      if distance(v.Position) < radius then
        signal = true
      end   
    end
  end
  rednet.broadcast(not signal)
end
