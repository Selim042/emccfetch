local VERSION = '1.0.0'
local emccfetch = require('emccfetch-lib')

local args = {...}
if (#args ~= 0) then
    local lowerArg = string.lower(args[1])
    if (lowerArg == 'version') then
        print('EM-CC Fetch version: '..VERSION)
        print('EM-CC Fetch-Lib version: '..emccfetch.LIB_VERSION)
        return
    elseif (lowerArg == 'update') then
        print('Not yet implemented...')
    else
        print('EM-CC Fetch Help: (v '..VERSION..')')
        print(' emccfetch help - Displays this menu')
        print(' emccfetch version - Displays the current version')
        print(' emccfetch update - Updates the script')
    end
    return
end

emccfetch.addExtension({
  name = 'emccfetch:systemInfo',
  getInfo = function()
    local info = {}
    info[#info+1] = {label="OS",info=os.version()}

    -- Determine if advanced PC
    local systemType = ""
    if (command ~= nil) then
        systemType = "Command"
    elseif (paintutils ~= nil) then
        systemType = "Advanced"
    end

    -- Determine type of PC
    if (turtle ~= nil) then
        systemType = systemType..' Turtle'
    elseif (pocket ~= nil) then
        systemType = systemType..' Pocket'
    elseif (peripheral.getType('back') == 'neuralInterface') then
        systemType = 'Neural Interface'
    else
        systemType = systemType..' Computer'
    end
    info[#info+1] = {label='System',info=systemType}

    info[#info+1] = {label='Computer ID',info=tostring(os.getComputerID())}
    return info
  end
})

emccfetch.addExtension({
  name = "emccfetch:hostInfo",
  getInfo = function()
    -- Render uptime nicely
    local function getUptime(uptime)
      uptime = math.floor(uptime)
      if (uptime < 60) then
          return uptime..'s'
      end
      local mins = math.floor(uptime / 60)
      if (mins < 60) then
          return mins..'m '..getUptime(uptime % 60)
      end
      local hours = math.floor(mins / 60)
      if (hours < 24) then
          return hours..'h '..getUptime(mins % 60)
      end
      local days = math.floor(hours / 24)
      return days..'d '..getUptime(days % 24)
    end

    local info = {}
    info[#info+1] = {label='Host',info=_G._HOST}
    info[#info+1] = {label='Lua',info=_G._VERSION}

    info[#info+1] = {label='Uptime',info=getUptime(os.clock())}
    return info
  end
})

emccfetch.addExtension({
  name = 'emccfetch:displayInfo',
  getInfo = function()
    local info = {}
    -- Get all display resolutions
    local displays = {term.native()}
    for k,v in pairs({peripheral.find('monitor')}) do
        displays[#displays+1] = v
    end
    for k,v in pairs(displays) do
        local dispX,dispY = v.getSize()
        local displayName
        if (k == 1) then
            displayName = 'term'
        else
            displayName = peripheral.getName(v)
        end
        info[#info+1] = {label='Display ('..displayName..')',info=dispX..'x'..dispY..' @ 20tps'}
    end
    return info
  end
})

emccfetch.addExtension({
  name = 'emccfetch:driveInfo',
  getInfo = function()
    local function formatSize(size)
        local kb = size / 1000
        local mb = kb / 1000
        local gb = mb / 1000
        local tb = gb / 1000
        local pb = tb / 1000
        if (pb > 10) then
            return string.format('%.2f',pb).."PB"
        end
        if (tb > 10) then
            return string.format('%.2f',tb).."TB"
        end
        if (gb > 10) then
            return string.format('%.2f',gb).."GB"
        end
        if (mb > 10) then
            return string.format('%.2f',mb).."MB"
        end
        if (kb > 10) then
            return string.format('%.2f',kb).."KB"
        end
        return string.format('%.2f',size).."B"
    end

    local info = {}
    -- Get all drive usage
    local disks = {'/','/rom'}
    local drives = {peripheral.find('drive')}
    for k,v in pairs(drives) do
        disks[#disks+1] = v.getMountPath()
    end
    for k,v in pairs(disks) do
        local free = fs.getFreeSpace(v) or 0
        local capacity = fs.getCapacity(v) or 0
        local used = capacity - free
        local perc
        if (capacity == 0) then
            perc = 0
        else
            perc = used/capacity*100
        end
        info[#info+1] = {label='Disk ('..v..')',info=formatSize(used)..' / '..formatSize(capacity)..' ('..string.format('%.2f',perc)..'%)'}
    end

    return info
  end
})

emccfetch.print()
