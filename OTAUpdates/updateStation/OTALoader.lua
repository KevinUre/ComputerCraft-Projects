-- spin ET8mS6v2
-- bob ArB5MbL8

modemSide = "top"
rednet.open(modemSide)

local inputs = {...}
local code = ""
local hosts = {}

for i, v in ipairs(inputs) do  
  if i == 1 then
    code = v
  else
    table.insert(hosts,v)
  end 
end

for i=1,#hosts do
  remote = rednet.lookup("OTA", hosts[i]) 
  if remote == nil then
    print("No such OTA Host: "..hosts[i])
  else
    rednet.send(remote, code, "OTA")
  end
end

  rednet.close() 



