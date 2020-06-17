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
-- [[ {%require src/utils} ]] --

-- [[ translations ]] --
local translations = {}
-- [[ {%require src/translations} ]] --

module.translate = function(term, language, page, kwargs)
    local translation = translations[lang] and translations[lang][term] or translations.en[term]
    return string.format((page and translation[page] or translation), kwargs)
end


-- [[ modes ]] --
local modes = {}
-- [[ {%require src/modes} ]] --

if modes[module.mode] then
    modes[module.mode].main(modes)
else
    modes.castle.main()
end
