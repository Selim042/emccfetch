local theme = {
    label_text = colors.red,
    info_text = colors.white
}
local x,y = term.getSize()

local logo = {
    {
        chars = "        ",
        fg = "00000000",
        bg = "ffffffff"
    },
    {
        chars = "        ",
        fg = "        ",
        bg = "f444444f"
    },
    {
        chars = "  > _   ",
        fg = "        ",
        bg = "f4ffff4f"
    },
    {
        chars = "        ",
        fg = "        ",
        bg = "f4ffff4f"
    },
    {
        chars = "        ",
        fg = "        ",
        bg = "f4ffff4f"
    },
    {
        chars = "     \140  ",
        fg = "     e  ",
        bg = "f444444f"
    },
    {
        chars = "        ",
        fg = "        ",
        bg = "ffffffff"
    },
    {
        chars = "        ",
        fg = "        ",
        bg = "ffffffff"
    }
}

local info = {}

local label = os.getComputerLabel() or 'Unlabeled'
info[#info+1] = {label=label}
local labelPadding = ''
for i=1,#label do
    labelPadding = labelPadding..'-'
end
info[#info+1] = {info=labelPadding}
info[#info+1] = {label="OS",info=os.version()}

local systemType = ""
if (command ~= nil) then
    systemType = "Command"
elseif (paintutils ~= nil) then
    systemType = "Advanced"
end

if (turtle ~= nil) then
    systemType = systemType..' Turtle'
elseif (pocket ~= nil) then
    systemType = systemType..' Pocket'
elseif (peipheral.getType('back') == 'neuralInterface') then
    systemType = 'Neural Interface'
else
    systemType = systemType..' Computer'
end
info[#info+1] = {label='System',info=systemType}

info[#info+1] = {label='Host',info=_G._HOST}
info[#info+1] = {label='Lua',info=_G._VERSION}

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
info[#info+1] = {label='Uptime',info=getUptime(os.clock())}

local displays = {term}
for k,v in pairs({peripheral.find('monitor')}) do
    displays[#displays] = v
end
for k,v in pairs(displays) do
    local x,y = v.getSize()
    local displayName
    if (k == 1) then
        displayName = 'term'
    else
        displayName = peripheral.getName(v)
    end
    info[#info+1] = {label='Display ('..displayName..')',info=x..'x'..y..' @ 20tps'}
end
-- info[#info+1] = {label='Display',info=x..'x'..y..' @ 20tps'}

local disks = {'/','/rom'}
local drives = {peripheral.find('drive')}
for k,v in pairs(drives) do
    disks[#disks+1] = v.getMountPath()
end

local function formatSize(size)
    local kb = size / 1024
    local mb = kb / 1024
    local gb = mb / 1024
    local tb = gb / 1024
    local pb = tb / 1024
    if (pb > 10) then
        return pb.."PB"
    end
    if (tb > 10) then
        return tb.."TB"
    end
    if (gb > 10) then
        return gb.."GB"
    end
    if (mb > 10) then
        return mb.."MB"
    end
    if (kb > 10) then
        return kb.."KB"
    end
    return size.."B"
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
    info[#info+1] = {label='Disk ('..v..')',info=formatSize(used)..' / '..formatSize(capacity)..' ('..perc..'%)'}
end

info[#info+1] = {label='Computer ID',info=tostring(os.getComputerID())}

local logoPadding = ' '
for i=1,#logo[1].chars do
    logoPadding = logoPadding..' '
end

local function writeLogoLine(line)
    if (line > #logo) then
        write(logoPadding)
    else
        term.blit(logo[line].chars,logo[line].fg,logo[line].bg)
        term.setBackgroundColor(colors.black)
        term.write(' ')
    end
end

local line = 1
for k,v in pairs(info) do
    writeLogoLine(line)
    line = line+1
    if (v.label ~= nil) then
        term.setTextColor(theme.label_text)
        write(v.label)
    end
    if (v.info ~= nil) then
        term.setTextColor(theme.info_text)
        if (v.label ~= nil) then
            write(": ")
        end
        local remainingWidth = x-term.getCursorPos()
        if (remainingWidth < #v.info) then
            write(v.info:sub(1,remainingWidth))
            print()
            writeLogoLine(line)
            line = line + 1
            write(' ')
            write(v.info:sub(remainingWidth+1,#v.info))
        else
            write(v.info)
        end
    end
    print()
end

print()
write(logoPadding)
for i=0,15 do
    term.setBackgroundColor(2^i)
    write('  ')
    if (i==7) then
        term.setBackgroundColor(colors.black)
        print()
        write(logoPadding)
    end
end
term.setBackgroundColor(colors.black)
print()
