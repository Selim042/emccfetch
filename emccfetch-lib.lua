local OPTION_KEYS = {
    THEME = 'emccfetch.theme'
}
local themes = {
    logo = nil,
    pride_horz = {
        'eeeeeeee',
        'eeeeeeee',
        '11111111',
        '44444444',
        '55555555',
        'bbbbbbbb',
        'aaaaaaaa',
        'aaaaaaaa',
    },
    pride_flag = {
        'c7eeeeee',
        '3c7eeeee',
        '63c71111',
        '063c7444',
        '063c7555',
        '63c7bbbb',
        '3c7aaaaa',
        'c7aaaaaa',
    },
    trans = {
        '33333333',
        '33333333',
        '33333333',
        '66666666',
        '66666666',
        '66666666',
        '00000000',
        '00000000',
    },
}
local themeOptions = ''
for k,v in pairs(themes) do
    themeOptions = themeOptions .. k .. ', '
end
settings.define(OPTION_KEYS.THEME, {
    description = "A possible theme to pick from. Options are: "..themeOptions,
    default = "logo",
    type = "string",
})

local themeSet = settings.get(OPTION_KEYS.THEME)
local invalidTheme = true
for k,v in pairs(themes) do
    if (k == themeSet) then invalidTheme = false end
end
if (invalidTheme) then
    print("Invalid theme selected:",themeSet)
    print("Using default theme: logo")
    themeSet = 'logo'
end

local theme = {
    label_text = colors.red,
    info_text = colors.white
}
themeOptions:sub(1,#themeOptions-3)
local x,y = term.getSize()

-- CraftOS Logo
local logo = {
    {
        chars = "        ",
        fg = "        ",
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
}

local logoPadding = ' '
for i=1,#logo[1].chars do
    logoPadding = logoPadding..' '
end
local function getThemedBackground(line)
    local out = ''
    for i=1,#logo[line].bg do
        if (logo[line].bg:sub(i,i) ~= colors.toBlit(colors.black)) then
            out = out .. themes[themeSet][line]:sub(i,i)
        else
            out = out .. colors.toBlit(colors.black)
        end
    end
    return out
end
local function writeLogoLine(line)
    if (line == 1) then
        write(logoPadding)
        return
    end
    line = line - 1
    if (line > #logo) then
        write(logoPadding)
    else
        if (themeSet == 'logo') then
            term.blit(logo[line].chars,logo[line].fg,logo[line].bg)
        else
            term.blit(logo[line].chars,logo[line].fg,getThemedBackground(line))
        end
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
