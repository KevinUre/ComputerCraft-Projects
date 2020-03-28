routines = {}
aliveStatus = "Alive"
terminateStatus = "Terminate"
OTAStatus = aliveStatus
appName = "app"
appCode = ""
messageCount = 0
modemSide = "left"

-- +----------------------+
-- |     PARALLEL API     |
-- +----------------------+

local function create( first, ... )
	if first ~= nil then
	    if type( first ) ~= "function" then
    		error( "Expected function, got "..type( first ), 3 )
    	end
 		return coroutine.create(first), create( ... )
    end
    return nil
end

local function runUntilLimit(_limit )
    local count = #routines
    local living = count
    
    local tFilters = {}
    local eventData = {}
    while true do
        if OTAStatus == terminateStatus then
            return 0
        end
    	for n=1,count do
    		local r = routines[n]
    		if r then
    			if tFilters[r] == nil or tFilters[r] == eventData[1] or eventData[1] == "terminate" then
	    			local ok, param = coroutine.resume( r, table.unpack(eventData) )
					if not ok then
						error( param, 0 )
					else
						tFilters[r] = param
					end
					if coroutine.status( r ) == "dead" then
						routines[n] = nil
						living = living - 1
						if living <= _limit then
							return n
						end
					end
				end
    		end
    	end
		for n=1,count do
    		local r = routines[n]
			if r and coroutine.status( r ) == "dead" then
				routines[n] = nil
				living = living - 1
				if living <= _limit then
					return n
				end
			end
		end
    	eventData = { os.pullEventRaw() }
    end
end

function waitForAll( ... )
    routines = { create( ... ) }
	runUntilLimit( 0 )
    routines = {}
    return 0
end

function reset()
    routines = {}
    OTAStatus = aliveStatus
    appCode = ""
end

function bootload()
    while true do
        reset()
        waitForAll(runApp,listener)
        wlog("new image command received: "..appCode)
        loadNewImage(appCode)
    end
    return 0
end

function runApp()
    shell.run(appName)
end

function wlog(msg)
    print(msg)
end

function loadNewImage(code)
    shell.run("delete "..appName)
    shell.run("pastebin get "..code.." "..appName)
    wlog("loaded a new image from "..code)
end


-- +------------------+
-- |     APP CODE     |
-- +------------------+


function listener() 
  while true do 
    local id, msg, prot = rednet.receive("OTA")
    if msg ~= null then
      term.setCursorPos(1,1)
      print("got a message ["..messageCount.."]: "..msg)
      messageCount = messageCount + 1
      OTAStatus = terminateStatus
      appCode = msg
      return
    end
  end
end

local computerLabel = os.getComputerLabel()
if computerLabel == nil then
    print("OTA Bootloader Requires the Computer has a Label")
    return 1
end

term.clear()
rednet.open(modemSide)
rednet.host("OTA", computerLabel)
bootload()
print("bootload returned")
