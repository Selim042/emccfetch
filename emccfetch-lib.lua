local theme = {
    label_text = colors.red,
    info_text = colors.white
}
local x,y = term.getSize()

-- CraftOS Logo
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

local api = {}
local extensions = {}
api.addExtension = function(ext)
    extensions[#extensions+1] = ext
end
api.print = function()
    local info = {}

    -- Basic Header
    local label = os.getComputerLabel() or 'Unlabeled'
    info[#info+1] = {label=label}
    local labelPadding = ''
    for i=1,#label do
        labelPadding = labelPadding..'-'
    end
    info[#info+1] = {info=labelPadding}

    for k,v in ipairs(extensions) do
        if (v.getInfo ~= nil) then
            local extLines = v.getInfo()
            -- info = {table.unpack(info),table.unpack(extLines)}
            for k,v in ipairs(extLines) do
                info[#info+1] = v
            end
        end
    end

    local line = 1
    for k,v in ipairs(info) do
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
    writeLogoLine(line)
    line = line + 1
    print()
    writeLogoLine(line)
    line = line + 1
    for i=0,15 do
        term.setBackgroundColor(2^i)
        write('  ')
        if (i==7) then
            term.setBackgroundColor(colors.black)
            print()
            writeLogoLine(line)
            line = line + 1
        end
    end
    term.setBackgroundColor(colors.black)
    print()
end

return api