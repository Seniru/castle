local module = {}

module.admins = {
    ["King_seniru#5890"] = true
}

module.room = tfm.get.room.name
module.isTribeHouse = module.room:byte(2) == 3
module.community = tfm.get.room.community

module.metadata = module.isTribeHouse
    and ""
    or module.room:sub(module.community == "xx" and 9 or 11)

module.roomNumber, module.mode, module.roomAdmin = module
    .metadata
    :match("(%d*)(%w*)@?(.*#?%d*)")

module.subRoomAdmins = {}

if module.isTribeHouse then
    for name, player in next, tfm.get.room.playerList do
        if player.tribeName == module.room then
            module.subRoomAdmins[#module.subRoomAdmins + 1] = name
        end
    end
else
    module.subRoomAdmins = {module.roomAdmin}
end

-- [[ utilites]] --
local utils = {}
string.format = function(s, tab) return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end)) end

string.split = function(s, delimiter)
    result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

table.tostring = function(tbl, depth)
    local res = "{"
    local prev = 0
    for k, v in next, tbl do
        if type(v) == "table" then
            if depth == nil or depth > 0 then
                res =
                    res ..
                    ((type(k) == "number" and prev and prev + 1 == k) and "" or k .. ": ") ..
                        table.tostring(v, depth and depth - 1 or nil) .. ", "
            else
                res = res .. k .. ":  {...}, "
            end
        else
            res = res .. ((type(k) == "number" and prev and prev + 1 == k) and "" or k .. ": ") .. tostring(v) .. ", "
        end
        prev = type(k) == "number" and k or nil
    end
    return res:sub(1, res:len() - 2) .. "}"
end


-- [[ translations ]] --
local translations = {}

translations.en = {
    welcome = "\n<N><p align='center'>Welcome to <b><D>#castle</D></b> - Kings' living lounge and lab\nReport any bugs or new features to <b><O>King_seniru</O><G><font size='8'>#5890</font></G></b>\n\nType <b><BV>!modes</BV></b> to check out submodes of this module</N></p>\n"
}


module.translate = function(term, language, page, kwargs)
    local translation = translations[lang] and translations[lang][term] or translations.en[term]
    return string.format((page and translation[page] or translation), kwargs)
end


-- [[ modes ]] --
local modes = {}

modes.castle = {
	version = "v0.0.1",
	description = "",
	author = "King_seniru#5890"
}

modes.castle.main = function(modes)

    tfm.exec.disableAfkDeath()
    tfm.exec.disableAutoNewGame()
    tfm.exec.disableAutoShaman()
    tfm.exec.newGame(0)

    eventNewGame = function(name)
        for k, v in next, tfm.get.room.playerList do eventNewPlayer(k) end
    end

    eventNewPlayer = function(name)
        local commu = tfm.get.room.playerList[name].community
        tfm.exec.chatMessage(module.translate("welcome", commu), name)
    end 

end

modes.graphs = {
	version = "v0.0.1",
	description = "",
	author = "King_seniru#5890"
}

modes.graphs.main = function() end



if modes[module.mode] then
    modes[module.mode].main(modes)
else
    modes.castle.main()
end
