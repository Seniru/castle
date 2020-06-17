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

-- [[ translations ]] --
local translations = {}
-- [[ {%require src/translations} ]] --

-- [[ modes ]] --
local modes = {}
-- [[ {%require src/modes} ]] --

if modes[module.mode] then
    modes[module.mode].main()
else
    print("no mode")
end
