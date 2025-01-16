function GetIndex(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return i
        end
    end

    return nil
end

function HasValue(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

function Debug(message)
    if Config.Debug then
        print(message)
    end
end

function StringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    local i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function RemovePrefixes(str)
    local regex = "~[a-zA-Z0-9]+~"
    local result = str:gsub(regex, "")
    result = result:gsub("^~", ""):gsub("~$", "")
    return result
end