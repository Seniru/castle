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
            module.subRoomAdmins[name] = true
        end
    end
else
    if module.roomAdmin ~= "" then module.subRoomAdmins = {[module.roomAdmin] = true} end
end

for admin in next, module.admins do
    module.subRoomAdmins[admin] = true
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

table.merge = function(tbl1, tbl2)
    local res = {}
    for _, tbl in ipairs({tbl1, tbl2}) do
        for k, v in next, tbl do
            res[#res + 1] = v
        end
    end
    return res
end


-- [[ translations ]] --
local translations = {}

translations.en = {
    welcome = "<br><N><p align='center'>Welcoem to <b><D>#castle</D></b> - King`s living lounge and lab<br>Report any bugs or new features to <b><O>King_seniru</O><G><font size='8'>#5890</font></G></b><br><br>Type <b><BV>!modes</BV></b> to check out submodes of this module</p></N><br>",
    modestitle = "<p align='center'><D><font size='16' face='Lucida console'>Castle - submodes</font></D><br><br>",
    modebrief = "<b>castle0${name}</b> <CH><a href='event:modeinfo:${name}'>ⓘ</a></CH>\t<a href='event:play:${name}'><T>( Play )</T></a><br>",
    modeinfo = "<p align='center'><D><font size='16' face='Lucida console'>#castle0${name}</font></D></p><br><i><font color='#ffffff' size='14'>“<br>${description}<br><p align='right'>”</p></font></i><b>Author: </b> ${author}<br><b>Version: </b> ${version}</font><br><br><p align='center'><b><a href='event:play:${name}'><T>( Play )</T></a></b></p><br><br><a href='event:modes'>« Back</a>",
    new_roomadmin = "<N>[</N><D>•</D><N>] </N><D>${name}</D> <N>is now a room admin!</N>",
    error_adminexists = "<N>[</N><R>•</R><N>] <R>Error: ${name} is already an admin</R>",
    error_gameonprogress = "<N>[</N><R>•</R><N>] <R>Error: Game in progress!</R>",
    error_invalid_input = "<N>[</N><R>•</R><N>] <R>Error: Invlid input!</R>",
    error_auth = "<N>[</N><R>•</R><N>] <R>Error: Authorisation</R>",
    admins = "<N>[</N><D>•</D><N>] </N><D>Admins: </D>",
    welcome0graphs = "<br><N><p align='center'>Welcoem to <b><D>#castle0graphs</D></b><br>Report any bugs or suggest interesting functions to <b><O>King_seniru</O><G><font size='8'>#5890</font></G></b><br><br>Type <b><BV>!commands</BV></b> to check out the available commands</p></N><br>",
    cmds0graphs = "<BV>!admin <name></BV> - Makes a player admin <R><i>(admin only command)</i></R>",
    configmenu = "<p align='center'><font size='20' color='#ffcc00'><b>Config menu</b></font></p><br>" ..
        "<b>Title</b>: <a href='event:fs:title'>${title}</a><br>" ..
        "<b>Description</b>: <a href='event:fs:desc'>${desc}</a><br>" ..
        "<b>Prize</b>: <a href='event:fs:prize'>${prize}<br><br></a>" ..
        "<b>Participants</b>: ${participants}<a href='event:fs:participants'> (See all)</a><br><p align='center'><G>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</G><br>" ..
        "<b><font size='13'><D>Room settings</D></font></b></p>" ..
        "<b>Map</b>: <a href='event:fs:map'>${map}</a><br>" ..
        "<b>Password</b>: <a href='event:fs:password'>${pw}</a><br>" ..
        "<b>Max participants</b>: <a href='event:fs:maxplayers'>${maxPlayers}</a><br>" ..
        "<b>Consumables</b>: <a href='event:fs:consumables'>${consumables}</a><br>" ..
        "<br><b><D>Mouse spawn locations</D></b><br>" ..
        "<b>Spectator spawn</b>: <a href='event:fs:specSpawn'> X: ${specX}, Y: ${specY}</a>\t\t<a href='event:fs:showSpecSpawn'>[ Show ]</a><br>" ..
        "<b>Participant spawn</b>: <a href='event:fs:playerSpawn'> X: ${playerX}, Y: ${playerY}</a>\t\t<a href='event:fs:showPlayerSpawn'>[ Show ]</a><br>" ..
        "<b>Player (out) spawn</b>: <a href='event:fs:outSpawn'> X: ${outX}, Y: ${outY}\t\t<a href='event:fs:showOutSpawn'>[ Show ]</a><br>",
    fs_title_popup = "Please enter the title of the fashion show!",
    fs_desc_popup = "Please enter the description of the fashion show!",
    fs_prize_popup = "Please enter the prize of the fashion show!",
    fs_maxp_popup = "Please specify the maximum amount of players for the fashion show!",
    fs_pw_popup = "Please enter the password, leave it blank to unset it <i>(alias command: !pw)</i>",
    fs_participants = "<p align='center'><b><D>Participants</D></b></p><br>",
    fs_map_popup = "Please enter the map code!",
    fs_consumable_popup = "Do you need to enable consumables?",
    fs_set_coords = "<N>[</N><D>•</D><N>] Please click on the map to set coordinates</N>",
    fs_start = "<p align='center'><a href='event:start'><b>Start</b></a></p>",
    fs_starting = "<N>[</N><D>•</D><N>]</N> <b><D>Starting the fashion show!</D></b>",
    fs_round_config = "<p align='center'><font size='20' color='#ffcc00'><b>Config menu - round ${round}</b></font></p><br>" ..
        "<br><br><br><br><br><br><b>Theme</b>: <a href='event:fs:theme'>${theme}</a><br>" ..
        "<b>Duration</b>: <a href='event:fs:dur'>${dur}</a><br><br>" ..
        "<b>Players</b>: ${players} <a href='event:fs:participants'> (See all)</a>",
    fs_round_title = "Please enter the title for the round!",
    fs_round_dur = "Please specify the duration of the round in minutes <i>(eg: 2)</i><br>Enter 0 to set it unlimited</i>",
    fs_solo_btn = "<p align='center'><a href='event:fs:solo'><b>Solo</b></a></p>",
    fs_duo_btn = "<p align='center'><a href='event:fs:duo'><b>Duo</b></a></p>",
    fs_trio_btn = "<p align='center'><a href='event:fs:trio'><b>Trio</b></a></p>",
    fs_newround = "<N>[</N><D>•</D><N>] <b><D>Round ${round} started!</D></b><br>\t<FC>• Theme:</FC> <N>${theme} (${type})</N><br>\t<FC>• Duration:</FC> <N>${dur}</N><br>\t<FC>• Players left:</FC> <N>${players}</N>",
    fs_round_end = "<N>[</N><D>•</D><N>] Round <D>${round}</D> ended! Judging in progress...</N>",
    fs_maxplayers_error = "<N>[</N><R>•</R><N>] Sorry, the fashion show already got enough participants :(",
    fs_elimination_confirm = "Eliminate ${name}?",
    fs_error_not_playing = "<R>The selected player is not a participant!"
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

modes.castle.main = function()

    system.disableChatCommandDisplay()
    tfm.exec.disableAfkDeath()
    tfm.exec.disableAutoNewGame()
    tfm.exec.disableAutoShaman()
    tfm.exec.newGame(0)


    -- [[variables]] --
    local closeSequence = {}

    -- [[helper functions]] --
    addTextArea = function(id, content, target, x, y, w, h, fixed)
        if not closeSequence[id] then closeSequence[id] = {} end
        closeSequence[id][target or "*"] = {
            images = {
                tfm.exec.addImage("155cbe99c72.png", "&1", x - 10,      y - 10,     target),
                tfm.exec.addImage("155cbea943a.png", "&1", x + w - 18,  y - 10,     target),
                tfm.exec.addImage("171e178660d.png", ":0", x + w + 15,  y - 10,     target),
                tfm.exec.addImage("155cbe97a3f.png", "&1", x - 10,      y + h - 18, target),
                tfm.exec.addImage("155cbe9bc9b.png", "&1", x + w - 18,  y + h - 18, target)
            },
            txtareas = {id * 1000, id * 1000 + 1, id * 1000 + 2}
        }
        ui.addTextArea(id * 1000 + 1, "", target, x - 4, y - 4, w + 8, h + 8, 0x7f492d, 0x7f492d, 1, fixed)
        ui.addTextArea(id * 1000 + 2, "\n" .. content, target, x, y, w, h, 0x152d30, 0x0f1213, 1, fixed)
        ui.addTextArea(id * 1000, "<a href='event:close'>\n\n\n</a>", target, x + w + 18, y - 10, 15, 20, nil, nil, 0, fixed)
    end

    handleCloseButton = function(id, target)
        if not closeSequence[id] then return end
        local sequence = closeSequence[id][target or "*"]
        for _, imgid in next, sequence.images do
            tfm.exec.removeImage(imgid)
        end
        for _, txtareaid in next, sequence.txtareas do
            ui.removeTextArea(txtareaid, target)
        end
    end

    -- [[main functions]] --
    displayModes = function(target)
        local commu = tfm.get.room.playerList[target].community
        local res = module.translate("modestitle", commu)
        for name, mode in next, modes do
            if name ~= "castle" then
                res = res .. module.translate("modebrief", commu, nil, {name = name})
            end
        end
        handleCloseButton(1, target)
        addTextArea(1, res .. "</p>", target, 200, 100, 400, 200, true)
    end

    displayMode = function(target, mode)
        local commu = tfm.get.room.playerList[target].community
        local name = mode
        local mode = modes[mode]
        local res = module.translate("modeinfo", commu, nil, {name = name, author = mode.author, version = mode.version, description = mode.description})
        handleCloseButton(1, target)
        addTextArea(1, res, target, 200, 100, 400, 200, true)
    end

    -- [[events]] --

    eventNewGame = function(name)
        for k, v in next, tfm.get.room.playerList do eventNewPlayer(k) end
    end

    eventNewPlayer = function(name)
        local commu = tfm.get.room.playerList[name].community
        tfm.exec.chatMessage(module.translate("welcome", commu), name)
        tfm.exec.respawnPlayer(name)
    end 

    eventChatCommand = function(name, cmd)
        local args = string.split(cmd, " ")
        if args[1] == "modes" then
            displayModes(name)
        end
    end

    eventTextAreaCallback = function(id, name, evt)
        if evt == "close" then
            handleCloseButton(id / 1000, name)
        elseif evt == "modes" then
            displayModes(name)
        elseif evt:find("%w+:%w+") then
            local key, value = table.unpack(string.split(evt, ":"))
            if key == "play" then
                tfm.exec.chatMessage("<N>[</N><D>•</D><N>]</N><D> /room #castle0" .. value .. "@" .. name .. "</D>", name)
            elseif key == "modeinfo" then
                displayMode(name, value)
            end
        end
    end

    eventPlayerDied = tfm.exec.respawnPlayer

end


modes.fashion = {
	version = "v0.0.1",
	description = "Fashion show!",
	author = "King_seniru#5890"
}

modes.fashion.main = function()
    
    -- [[ dependencies]] --
    --[ timers4tfm ]--
    local a={}a.__index=a;a._timers={}setmetatable(a,{__call=function(b,...)return b.new(...)end})function a.process()local c=os.time()local d={}for e,f in next,a._timers do if f.isAlive and f.mature<=c then f:call()if f.loop then f:reset()else f:kill()d[#d+1]=e end end end;for e,f in next,d do a._timers[f]=nil end end;function a.new(g,h,i,j,...)local self=setmetatable({},a)self.id=g;self.callback=h;self.timeout=i;self.isAlive=true;self.mature=os.time()+i;self.loop=j;self.args={...}a._timers[g]=self;return self end;function a:setCallback(k)self.callback=k end;function a:addTime(c)self.mature=self.mature+c end;function a:setLoop(j)self.loop=j end;function a:setArgs(...)self.args={...}end;function a:call()self.callback(table.unpack(self.args))end;function a:kill()self.isAlive=false end;function a:reset()self.mature=os.time()+self.timeout end;Timer=a

    system.disableChatCommandDisplay()
    tfm.exec.disableAfkDeath()
    tfm.exec.disableAutoNewGame()
    tfm.exec.disableAutoShaman()
    tfm.exec.disablePhysicalConsumables()
    tfm.exec.disableAfkDeath()
    tfm.exec.newGame(0)

    -- [[ game variables ]] --
    local players = {}
    -- copied shamelessly from Utility (https://github.com/imliam/Transformice-Utility/blob/master/utility.lua#L5128)
    local omos = {"omo","@_@","@@","è_é","e_e","#_#",";A;","owo","(Y)(omo)(Y)","©_©","OmO","0m0","°m°","(´°?°`)","~(-_-)~","{^-^}", "uwu", "o3o"}
    
    local themes = {
        [1] = {"Beach/Ocean", "No Fur", "No Customizations", "Nature", "Neon", "Anime", "Cartoons", "Celebrity", "Ice Cream", "Monochrome", "Food", "Animal", "Candy", "Pastel", "Seasons", "Futuristic", "Music", "Television/Movie", "Weather", "Pokemon", "My Little Pony", "Wizard of Oz", "Alice in Wonderland", "Social Media Logo", "Greyscale", "Elements", "Holiday", "Valentines Day", "Christmas", "Halloween", "Easter", "Outer Space", "Gemstones", "Zodiac Signs", "Pirate", "Zombie", "St. Patrick’s Day", "Circus", "Steampunk", "Masked", "Disney", "Goth", "Pastel goth", "Meme", "Jobs", "Cowboy/Western", "Birthday", "LGBTQ+ Pride", "Summer", "Sunset", "Floral", "Marvel", "Scientist", "Toy Story", "Avengers", "Mythical Creatures", "Farmer", "Garden", "Earth Day", "Countries", "Egyptian", "Ancient Rome/Greece", "Detective", "Cookies", "Snowstorm", "Dinosaur", "Alien", "Robot", "Breakfast", "Winter", "Spring", "Autumn", "Birds", "Fishing", "Unicorn", "African Savannah", "Ninja", "Medieval", "Rainbow", "Shaman", "Video game", "Camo/Army", "Star Wars", "Dragon", "Viking", "Aviation", "Back to School", "Hawaiian", "Nerd", "Gamer", "Witches/Wizards", "Vampire", "Tourist", "Fairy", "Mermaid", "Prom", "Frozen", "Bugs", "Elegant/Fancy", "Scooby Doo", "Harry Potter", "Priest", "Sailor", "Fashion Designer", "50s", "60s", "70s", "80s", "90s", "Victorian Era", "New Years", "Primary Colors", "Sports/Athlete", "Artist", "Pajamas", "Fairytale", "Chocolate", "Greek Mythology", "Hippie", "Aladdin", "Beauty and the Beast", "Fluffy", "Cheerleader", "Chinese New Year", "Hollywood", "Jungle/Rainforest", "League of Legends", "Planets", "Tribal", "Vintage", "Disco", "Camping", "Doctor", "Mickey Mouse Clubhouse", "The Incredibles", "Peter Pan", "Police", "Rapper"},
        [2] = {"Angels and demons", "Cheese and Fraise", "Black and White", "Opposite", "Hero and Villain", "Wedding", "Fruit and Vegetable", "Disney", "Old and Young", "Cat and Dog", "Cop and Robber", "Queen and King", "Sun and Moon", "Cowboy and Cowgirl", "Predator and Prey", "Witch and Wizard", "Ketchup and Mustard", "Zombie and Survivor", "Popstar and Rockstar"},
        [3] = {"Alvin and the chipmunks", "Power Puff Girls", "Spongebob, Patrick and Sandy"}
    }

    local keys = {
        SHIFT   = 16,
        E       = 69
    }

    local closeSequence = {}
    local started = false
    local participants = {}
    local participantCount = 0

    local settings = {
        title = "",
        desc = "",
        prize = "",
        maxPlayers = 100,
        pw = "",
        map = 0,
        consumablesEnabled = false,
        specSpawn = {},
        playerSpawn = {},
        outSpawn = {}
    }

    local round = {
        id = 1,
        started = false,
        theme = "",
        dur = 0,
        type = 1
    }
    
    round.types = {
        SOLO        = 1,
        DUO         = 2,
        TRIO        = 3
    }
    
    -- [[onkeypress function lookups]]
    local onkey = {
        [keys.E] = function(name, down, x, y)
            if not started then return end
            players[name].checkpoint = {x = x, y = y}
            ui.addTextArea(5, "", name, x, y, 2, 2, 0x00ff00, 0x00ff00, 0.5, false)
        end,
        [keys.SHIFT] = function(name, down, x, y)
            players[name].activeKeys[keys.SHIFT] = down
        end,
    }

    -- [[chat commands]] --
    local chatCmds = {
        
        admin = function(name, commu, args)
            if players[args[1]] then
                if module.subRoomAdmins[name] then
                    if module.subRoomAdmins[args[1]] then return tfm.exec.chatMessage(module.translate("error_adminexists", commu, nil, {name = args[1]}), name) end
                    module.subRoomAdmins[args[1]] = true
                    tfm.exec.chatMessage(module.translate("new_roomadmin", tfm.get.room.community, nil, {name = args[1]}))
                    if not started then displayConfigMenu(args[1]) end
                else
                    tfm.exec.chatMessage(module.translate("error_auth", commu), name)
                end
            end
        end,

        admins = function(name, commu, args)
            local res = module.translate("admins", commu) .. "<N>"
            for admin in next, module.subRoomAdmins do
                if players[admin] then res = res .. admin .. " " end
            end
            tfm.exec.chatMessage(res .. "</N>", name)
        end,

        s = function(name, commu, args)
            if module.subRoomAdmins[name] then
                if players[args[1]] then 
                    tfm.exec.setShaman(args[1])
                elseif args[1] == "me" then
                    tfm.exec.setShaman(name)
                elseif args[1] == "all" then
                    for player in next, players do
                        tfm.exec.setShaman(player)
                    end
                elseif args[1] == "admins" then
                    for admin in next, module.subRoomAdmins do
                        tfm.exec.setShaman(admin)
                    end
                end
            else
                tfm.exec.chatMessage(module.translate("error_auth", commu), name)
            end
        end,

        tp = function(name, commu, args)
            if module.subRoomAdmins[name] then
                system.bindMouse(name)
                players[name].clicks = { tp = args[1] }
            else
                tfm.exec.chatMessage(module.translate("error_auth", commu), name)
            end
        end,

        omo = function(name, commu, args)
            if module.subRoomAdmins[name] then
                players[name].clicks = { omo = #args > 0 and table.concat(args, " ") or omos[math.random(1, #omos)]}
                system.bindMouse(name)
            else
                tfm.exec.chatMessage(module.translate("error_auth", commu), name)
            end
        end,

        join = function(name, commu, args)
            if not participants[name] then
                if settings.maxPlayers <= participantCount then
                    tfm.exec.chatMessage(module.translate("fs_maxplayers_error", commu), name)
                elseif started then
                    tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), name)
                else
                    participants[name] = true
                    participantCount = participantCount + 1
                    tfm.exec.movePlayer(name, settings.playerSpawn.x, settings.playerSpawn.y)
                    tfm.exec.setNameColor(name, 0x0000ff)
                end
            end
        end,

        checkpoint = function(name, commu, args)
            if args[1] == "me" or not args[1] then
                onkey[keys.E](name, true, tfm.get.room.playerList[name].x, tfm.get.room.playerList[name].y)
            elseif args[1] == "all" and module.subRoomAdmins[name] then
                for player in next, tfm.get.room.playerList do
                    onkey[keys.E](player, true, tfm.get.room.playerList[player].x, tfm.get.room.playerList[player].y)
                end
            end
        end,

        stop = function(name, commu, args)
            if round.started and module.subRoomAdmins[name] then
                round.stop()
            end
        end
        
    }
    
    -- [[ fashion show config functions]] --
    local config = {
        -- title config
        [100] = function(value, target, commu)
            settings.title = value
            displayConfigMenu(target)
        end,
        -- description config
        [101] = function(value, target, commu)
            settings.desc = value
            displayConfigMenu(target)
        end,
        -- prize config
        [102] = function(value, target, commu)
            settings.prize = value
            displayConfigMenu(target)
        end,
        -- max participants config
        [103] = function(value, target, commu)
            settings.maxPlayers = value
            tfm.exec.setRoomMaxPlayers(value)
            displayConfigMenu(target)
        end,
        -- password popup
        [104] = function(value, target, commu)
            settings.pw = value
            tfm.exec.setRoomPassword(value)
            displayConfigMenu(target)
        end,
        -- map popup
        [105] = function(value, target, commu)
            settings.map = value
            tfm.exec.newGame(value)
            displayConfigMenu(target)
        end,
        -- consumables popup
        [106] = function(value, target, commu)
            settings.consumablesEnabled = value == "yes"
            tfm.exec.disablePhysicalConsumables(settings.consumablesEnabled)
            displayConfigMenu(target)
        end,
        -- title popup
        [107] = function(value, target, commu)
            round.theme = value
            round.displayConfigMenu(target)
        end,
        -- duration popup
        [108] = function(value, target, commu)
            value = tonumber(value)
            if value then
                round.dur = value
            else
                tfm.exec.chatMessage(module.translate("error_invalid_input", commu), target)
            end
            round.displayConfigMenu(target)
        end,
        -- elimination popup
        [150] = function(value, target, commu)
            if value == "yes" then
                local out = players[target].selectedPlayer
                if participants[out] then
                    tfm.exec.setNameColor(out, 0xff0000)
                    tfm.exec.movePlayer(out, settings.outSpawn.x, settings.outSpawn.y)
                    onkey[keys.E](out, true, settings.outSpawn.x, settings.outSpawn.y)
                    participants[out] = nil
                    participantCount = participantCount - 1
                else
                    tfm.exec.chatMessage(module.translate("fs_error_not_playing", commu), target)
                end
            end
        end,
        title = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(100, 2, module.translate("fs_title_popup", commu), target, nil, nil, nil, true)
        end,
        desc = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(101, 2, module.translate("fs_desc_popup", commu), target, nil, nil, nil, true)
        end,
        prize = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(102, 2, module.translate("fs_prize_popup", commu), target, nil, nil, nil, true)
        end,
        participants = function(target, commu)
            handleCloseButton(1, target)
            handleCloseButton(3, target)
            local res = module.translate("fs_participants", commu)
            for name in next, participants do
                res = res .. name .. ", "
            end
            addTextArea(2, res:sub(1, -2), target, 275, 100, 250, 200, true, false)
            table.insert(closeSequence[2][target].txtareas, ui_addTextArea(2000, "<p align='center'><a href='event:close'>OK</a></p>", target, 290, 260, 225, 20, nil, 0x324650, 1, true))
            closeSequence[2][target].onclose = function(target)
                if module.subRoomAdmins[target] then
                    if not started then
                        displayConfigMenu(target)
                    elseif not round.started then
                        round.displayConfigMenu(target)
                    end
                end
            end
        end,
        maxplayers = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(103, 2, module.translate("fs_maxp_popup", commu), target, nil, nil, nil, true)
        end,
        password = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(104, 2, module.translate("fs_pw_popup", commu), target, nil, nil, nil, true)
        end,
        map = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(105, 2, module.translate("fs_map_popup", commu), target, nil, nil, nil, true)
        end,
        consumables = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(106, 1, module.translate("fs_consumable_popup", commu), target, nil, nil, nil, true)
        end,
        theme = function(target, commu)
            if round.started then return tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), target) end
            handleCloseButton(3, target)
            ui.addPopup(107, 2, module.translate("fs_round_title", commu), target, nil, nil, nil, true)
        end,
        dur = function(target, commu)
            if round.started then return tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), target) end
            handleCloseButton(3, target)
            ui.addPopup(108, 2, module.translate("fs_round_dur", commu), target, nil, nil, nil, true)
        end,
        specSpawn = function(target, commu)
            handleCloseButton(1, target)
            system.bindMouse(target, true)
            tfm.exec.chatMessage(module.translate("fs_set_coords", commu), target)
            players[target].clicks = { specSpawn = true }
        end,
        playerSpawn = function(target, commu)
            handleCloseButton(1, target)
            system.bindMouse(target, true)
            tfm.exec.chatMessage(module.translate("fs_set_coords", commu), target)
            players[target].clicks = { playerSpawn = true }
        end,
        outSpawn = function(target, commu)
            handleCloseButton(1, target)
            system.bindMouse(target, true)
            tfm.exec.chatMessage(module.translate("fs_set_coords", commu), target)
            players[target].clicks = { outSpawn = true }
        end,
        showSpecSpawn = function(target, commu)
            if not settings.specSpawn.x then return end
            handleCloseButton(1, target)
            if not closeSequence[1.1] then closeSequence[1.1] = {} end
            closeSequence[1.1][target] = {
                images = {
                    tfm.exec.addImage("16c18dff3ab.png", "&0", settings.specSpawn.x - 5, settings.specSpawn.y - 5, target) -- mouse standing sprite}
                },
                txtareas = {
                    ui_addTextArea(1100, "<b><a href='event:close'>[ Hide ]</a></b>", target, settings.specSpawn.x + 40, settings.specSpawn.y + 10, 100, 20, 0x00ff00, 0x00ff00, 0, false)
                },
                onclose = function()
                    displayConfigMenu(target)
                end
            }
        end,
        showPlayerSpawn = function(target, commu)
            if not settings.playerSpawn.x then return end
            handleCloseButton(1, target)
            if not closeSequence[1.1] then closeSequence[1.1] = {} end
            closeSequence[1.1][target] = {
                images = {
                    tfm.exec.addImage("16c18dff3ab.png", "&0", settings.playerSpawn.x - 5, settings.playerSpawn.y - 5, target) -- mouse standing sprite}
                },
                txtareas = {
                    ui_addTextArea(1100, "<b><a href='event:close'>[ Hide ]</a></b>", target, settings.playerSpawn.x + 40, settings.playerSpawn.y + 10, 100, 20, 0x00ff00, 0x00ff00, 0, false)
                },
                onclose = function()
                    displayConfigMenu(target)
                end
            }
        end,
        showOutSpawn = function(target, commu)
            if not settings.outSpawn.x then return end
            handleCloseButton(1, target)
            if not closeSequence[1.1] then closeSequence[1.1] = {} end
            closeSequence[1.1][target] = {
                images = {
                    tfm.exec.addImage("16c18dff3ab.png", "&0", settings.outSpawn.x - 5, settings.outSpawn.y - 5, target) -- mouse standing sprite}
                },
                txtareas = {
                    ui_addTextArea(1100, "<b><a href='event:close'>[ Hide ]</a></b>", target, settings.outSpawn.x + 40, settings.outSpawn.y + 10, 100, 20, 0x00ff00, 0x00ff00, 0, false)
                },
                onclose = function()
                    displayConfigMenu(target)
                end
            }
        end,
        solo = function(target, commu)
            if round.started then return tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), target) end
            round.type = round.types.SOLO
            round.displayConfigMenu(target)
        end,
        duo = function(target, commu)
            if round.started then return tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), target) end
            round.type = round.types.DUO
            round.displayConfigMenu(target)
        end,
        trio = function(target, commu)
            if round.started then return tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), target) end
            round.type = round.types.TRIO
            round.displayConfigMenu(target)
        end
    }
    
    -- [[ helper functions ]] --
    omo = function(id, content, target, x, y, w, h, size, border, fixed)
        ui.addTextArea(id * 1000 + 1,"<p align='center'><b><font color='#000000' size='" .. size .. "' face='Soopafresh,Segoe,Verdana'>" .. content .. "</font></b></p>", target, x - border, y, w, h, nil, nil, 0, fixed)
        ui.addTextArea(id * 1000 + 2,"<p align='center'><b><font color='#000000' size='" .. size .. "' face='Soopafresh,Segoe,Verdana'>" .. content .. "</font></b></p>", target, x, y - border, w, h, nil, nil, 0, fixed)
        ui.addTextArea(id * 1000 + 3,"<p align='center'><b><font color='#000000' size='" .. size .. "' face='Soopafresh,Segoe,Verdana'>" .. content .. "</font></b></p>", target, x + border, y, w, h, nil, nil, 0, fixed)
        ui.addTextArea(id * 1000 + 4,"<p align='center'><b><font color='#000000' size='" .. size .. "' face='Soopafresh,Segoe,Verdana'>" .. content .. "</font></b></p>", target, x, y + border, w, h, nil, nil, 0, fixed)
        ui.addTextArea(id * 1000,"<p align='center'><b><font size='" .. size .. "' face='Soopafresh,Segoe,Verdana'>" .. content .. "</font></b></p>", target, x, y, w, h, nil, nil, 0, fixed)
    end
    
    ui_addTextArea = function(...)
        local id = ...
        ui.addTextArea(...)
        return id
    end

    addTextArea = function(id, content, target, x, y, w, h, fixed, closeButton)
        handleCloseButton(id, target, true)
        if not closeSequence[id] then closeSequence[id] = {} end
        closeSequence[id][target or "*"] = {
            images = {
                tfm.exec.addImage("155cbe99c72.png", "&1", x - 10,      y - 10,     target),
                tfm.exec.addImage("155cbea943a.png", "&1", x + w - 18,  y - 10,     target),
                tfm.exec.addImage("155cbe97a3f.png", "&1", x - 10,      y + h - 18, target),
                tfm.exec.addImage("155cbe9bc9b.png", "&1", x + w - 18,  y + h - 18, target),
                closeButton and tfm.exec.addImage("171e178660d.png", ":0", x + w + 15,  y - 10, target) or nil
            },
            txtareas = {
                ui_addTextArea(id * 1000 + 1, "", target, x - 4, y - 4, w + 8, h + 8, 0x7f492d, 0x7f492d, 1, fixed),
                ui_addTextArea(id * 1000 + 2, "\n" .. content, target, x, y, w, h, 0x152d30, 0x0f1213, 1, fixed),
                closeButton and ui_addTextArea(id * 1000, "<a href='event:close'>\n\n\n</a>", target, x + w + 18, y - 10, 15, 20, nil, nil, 0, fixed) or nil
            }
        }
    end
    
    handleCloseButton = function(id, target, force)
        if not closeSequence[id] then return end
        local sequence = closeSequence[id][target or "*"]
        if not sequence then return end
        for _, imgid in next, sequence.images do
            tfm.exec.removeImage(imgid)
        end
        for _, txtareaid in next, sequence.txtareas do
            ui.removeTextArea(txtareaid, target)
        end
        if sequence.onclose and not force then sequence.onclose(target) end
    end

    getMouseSpawnLocation = function(map)
        local x, y = map:match("<DS X=\"(%d+)\" Y=\"(%d+)\" />")
        return x, y
    end

    getNearestPlayer = function(x, y)
        for name, player in next, tfm.get.room.playerList do
            if 
                (player.x <= x + 10 and x - 10 <= player.x) and
                (player.y <= y + 10 and y - 10 <= player.y) then
                    return name
            end
        end
    end

    displayConfigMenu = function(target, updated)
        if not updated then
            for admin in next, module.subRoomAdmins do
                handleCloseButton(1, admin)
                displayConfigMenu(admin, true)
            end
            return
        end            
        local commu = tfm.get.room.playerList[target].community
        local defaultX, defaultY = getMouseSpawnLocation(tfm.get.room.xmlMapInfo and tfm.get.room.xmlMapInfo.xml or "")
        defaultX, defaultY = defaultX or "-", defaultY or "-"
        local specSpawn, playerSpawn, outSpawn = settings.specSpawn, settings.playerSpawn, settings.outSpawn
        addTextArea(1, module.translate("configmenu", commu, nil, {
            title = settings.title == "" and "[ Set ]" or settings.title,
            desc = settings.desc == "" and "[ Set ]" or settings.desc,
            prize = settings.prize == "" and "[ Set ] " or settings.prize,
            participants = participantCount,
            map = settings.map == 0 and "@0" or settings.map,
            pw = settings.pw == "" and "[ Set ]" or settings.pw,
            maxPlayers = settings.maxPlayers,
            consumables = settings.consumablesEnabled and "Enabled" or "Disabled",
            specX = specSpawn.x or defaultX, specY = specSpawn.y or defaultY,
            playerX = playerSpawn.x or defaultX, playerY = playerSpawn.y or defaultY,
            outX = outSpawn.x or defaultX, outY = outSpawn.y or defaultY
        }), target, 100, 50, 600, 320, true, true)
        if module.roomAdmin == target and not started then
            table.insert(closeSequence[1][target].txtareas, ui_addTextArea(200, module.translate("fs_start", commu), target, 110, 345, 580, 16, nil, 0x324650, 1, true))
        end
    end
    
    start = function()
        if not started then
            tfm.exec.chatMessage(module.translate("fs_starting", tfm.get.room.community))
            started = true
            tfm.exec.newGame(settings.map)
            local playerX, playerY, specsX, specsY = settings.playerSpawn.x, settings.playerSpawn.y, settings.specSpawn.x, settings.specSpawn.y
            for player in next, tfm.get.room.playerList do
                if not module.subRoomAdmins[player] then
                    if participants[player] then
                        tfm.exec.movePlayer(player, playerX, playerY)
                    else
                        tfm.exec.movePlayer(player, specX, specY)
                    end
                else
                    handleCloseButton(1, player)
                    round.displayConfigMenu(player)
                end
            end
        elseif started and not round.started then
            round.start()
        end
    end
    
    round.start = function()
        round.started = true
        tfm.exec.disableMortCommand(false)
        for admin in next, module.subRoomAdmins do
            handleCloseButton(3, admin)
            system.bindMouse(admin, false)
            system.bindKeyboard(admin, keys.SHIFT, true, false)
            system.bindKeyboard(admin, keys.SHIFT, false, false)
        end
        round.theme = round.theme == "" and themes[round.type][math.random(#themes[round.type])] or round.theme
        local type = ({"Solo", "Duo", "Trio"})[round.type]
        tfm.exec.chatMessage(module.translate("fs_newround", tfm.get.room.community, nil, {
            dur = round.dur == 0 and "Unlimited" or round.dur .. " minute(s)",
            theme = round.theme,
            players = participantCount,
            round = round.id,
            type = type
        }))
        tfm.exec.setGameTime(round.dur * 60)
        ui.setMapName("<D>Theme: </D><N>" .. round.theme .. " (" .. type .. ")")
        local timer
        if round.dur > 0 then
            print("Creating the timer")
            timer = Timer("round_timer", round.stop, 1000 * 60 * round.dur, false)    
        end
    end

    round.stop = function()
        tfm.exec.chatMessage(module.translate("fs_round_end", tfm.get.room.community, nil, {round = round.id}))
        for player in next, tfm.get.room.playerList do
            tfm.exec.killPlayer(player)
        end
        tfm.exec.disableMortCommand()
        for admin in next, module.subRoomAdmins do
            system.bindMouse(admin, true)
            system.bindKeyboard(admin, keys.SHIFT, true, true)
            system.bindKeyboard(admin, keys.SHIFT, false, true)
        end
    end

    round.displayConfigMenu = function(target, updated)
        if not updated then
            for admin in next, module.subRoomAdmins do
                handleCloseButton(3, admin)
                round.displayConfigMenu(admin, true)
            end
            return
        end            
        local commu = tfm.get.room.playerList[target].community
        addTextArea(3, module.translate("fs_round_config", commu, nil, {
            round = round.id,
            theme = round.theme == "" and "Random" or round.theme,
            dur = round.dur == 0 and "Unlimited" or round.dur .. " minute(s)",
            players = participantCount
        }), target, 100, 50, 600, 320, true, true)
        closeSequence[3][target].txtareas[4] = ui_addTextArea(3050, (round.type == round.types.SOLO and "<D>" or "") .. module.translate("fs_solo_btn", commu), target, 150, 120, 150, 30, nil, 0x324650, 1, true)
        closeSequence[3][target].txtareas[5] = ui_addTextArea(3051, (round.type == round.types.DUO and "<D>" or "") .. module.translate("fs_duo_btn", commu), target, 320, 120, 150, 30, nil, 0x324650, 1, true)
        closeSequence[3][target].txtareas[6] = ui_addTextArea(3052, (round.type == round.types.TRIO and "<D>" or "") .. module.translate("fs_trio_btn", commu), target, 490, 120, 150, 30, nil, 0x324650, 1, true)
        if module.roomAdmin == target and not round.started then
            closeSequence[3][target].txtareas[7] = ui_addTextArea(3053, module.translate("fs_start", commu), target, 110, 345, 580, 16, nil, 0x324650, 1, true)
        end
    end


    -- [[ events]] --

    eventMouse = function(name, x, y)
        local commu = tfm.get.room.playerList[name].community
        if players[name].clicks.tp then
            local tpType = players[name].clicks.tp
            if players[tpType] then 
                tfm.exec.movePlayer(tpType, x, y)
            elseif tpType == "me" then
                tfm.exec.movePlayer(name, x, y)
            elseif tpType == "all" then
                for player in next, players do
                    tfm.exec.movePlayer(player, x, y)
                end
            elseif tpType == "admins" then
                for admin in next, module.subRoomAdmins do
                    tfm.exec.movePlayer(admin, x, y)
                end
            end
            players[name].clicks = {}
            system.bindMouse(name, false)
        elseif players[name].clicks.omo then
            omo(0, players[name].clicks.omo, nil, x, y, nil, nil, 40, 2, false)
            players[name].clicks = {}
            system.bindMouse(name, false)
        elseif players[name].clicks.specSpawn then
            ui.addTextArea(10, " ", name, x, y, 1, 1, 0x00ff00, 0x00ff00, 0.6, false)
            settings.specSpawn = {x = x, y = y}
            players[name].clicks = {}
            system.bindMouse(name, false)
            displayConfigMenu(name)
            Timer.new("checkpoint_remove", function() ui.removeTextArea(10, name) end, 1500, false)
        elseif players[name].clicks.playerSpawn then
            ui.addTextArea(10, " ", name, x, y, 1, 1, 0x0000ff, 0x0000ff, 0.6, false)
            settings.playerSpawn = {x = x, y = y}
            players[name].clicks = {}
            system.bindMouse(name, false)
            displayConfigMenu(name)
            Timer.new("checkpoint_remove", function() ui.removeTextArea(10, name) end, 1500, false)
        elseif players[name].clicks.outSpawn then
            ui.addTextArea(10, " ", name, x, y, 1, 1, 0xff0000, 0xff0000, 0.6, false)
            settings.outSpawn = {x = x, y = y}
            players[name].clicks = {}
            system.bindMouse(name, false)
            displayConfigMenu(name)
            Timer.new("checkpoint_remove", function() ui.removeTextArea(10, name) end, 1500, false)
        elseif players[name].activeKeys[keys.SHIFT] then
            local target = getNearestPlayer(x, y)
            if target then
                players[name].selectedPlayer = target
                ui.addPopup(150, 1, module.translate("fs_elimination_confirm", commu, nil, {name = target}), name, nil, nil, nil, true)
            end
        end
    end

    eventKeyboard = function(name, key, down, x, y)
        if onkey[key] then
            onkey[key](name, down, x, y)
        end
    end

    eventChatCommand = function(name, cmd)
        local commu = tfm.get.room.playerList[name].community
        local args = string.split(cmd, " ")
        if chatCmds[args[1]] then
            local cmd = args[1]
            table.remove(args, 1)
            chatCmds[cmd](name, commu, args)
        end
    end

    eventTextAreaCallback =  function(id, name, evt)
        local commu = tfm.get.room.playerList[name].community
        if evt == "close" then
            handleCloseButton(id / 1000, name)
        elseif evt == "config" and module.subRoomAdmins[name] then
            if started then round.displayConfigMenu(name) else displayConfigMenu(name) end            
        elseif evt == "start" and name == module.roomAdmin then
            start()
        elseif evt:find("^%w+:.+") then
            local key, value = table.unpack(string.split(evt, ":"))
            if key == "fs" then
                if module.subRoomAdmins[name] and config[value] then
                    config[value](name, commu)
                end
            end
        end
    end

    eventPopupAnswer = function(id, name, answer)
        local commu = tfm.get.room.playerList[name].community
        if id >= 100 and id < 200 and module.subRoomAdmins[name] and config[id] then-- admin config stuff
            config[id](answer, name, commu)
        end
    end

    eventPlayerDied = function(name)
        tfm.exec.respawnPlayer(name)
        if players[name].checkpoint then
            local cp = players[name].checkpoint
            tfm.exec.movePlayer(name, cp.x, cp.y)
        elseif participants[name] then
            tfm.exec.movePlayer(name, settings.playerSpawn.x, settings.playerSpawn.y)
        else
            tfm.exec.movePlayer(name, settings.specSpawn.x, settings.specSpawn.y)
        end
    end

    eventNewPlayer = function(name)
        players[name] = {clicks = {}, activeKeys = {}}
        system.bindKeyboard(name, keys.E, true, true)
    end

    eventPlayerLeft = function(name)
        players[name] = nil
    end

    eventNewGame = function()
        for name, player in next, tfm.get.room.playerList do
            eventNewPlayer(name)
        end
        if not started then
            for admin in next, module.subRoomAdmins do
                displayConfigMenu(admin)
                tfm.exec.addImage("170f8ccde22.png", ":1", 750, 320, admin) -- cogwheel icon
                ui.addTextArea(4, "<a href='event:config'>\n\n\n\n</a>", admin, 750, 320, 50, 50, nil, nil, 0, true)
            end
        end
    end

    eventLoop = function()
        Timer.process()
    end

end

modes.graphs = {
	version = "v0.0.1",
	description = "Play with graphs! Feel the beauty of math",
	author = "King_seniru#5890"
}

modes.graphs.main = function()
    --[[ dependencies]]--
    --[ linegraph-tfm ]--
    local a,b,c,d,e,f;local g='0123456789abcdef'function num2hex(h)local i=''while h>0 do local j=math.fmod(h,16)i=string.sub(g,j+1,j+1)..i;h=math.floor(h/16)end;return string.upper(i==''and'0'or i)end;function split(i,k)result={}for l in(i..k):gmatch("(.-)"..k)do table.insert(result,l)end;return result end;function c(m)local n=m[1]for o=1,#m do o=m[o]if o<n then n=o end end;return n end;function d(m)local p=m[1]for o=1,#m do o=m[o]if o>p then p=o end end;return p end;function e(m,q)local r={}for s,o in next,m do r[s]=q(o)end;return r end;function f(t,u,v)local w=table.insert;local r={}for x=t,u,v do w(r,x)end;return r end;local function y(z)return 400-z end;a={}a.__index=a;setmetatable(a,{__call=function(A,...)return A.new(...)end})function a.new(B,C,D,E)assert(#B==#C,"Expected same number of data for both axis")local self=setmetatable({},a)self.name=D;self:setData(B,C)self.col=E or math.random(0x000000,0xFFFFFF)return self end;function a:getName()return self.name end;function a:getDX()return self.dx end;function a:getDY()return self.dy end;function a:getColor()return self.col end;function a:getMinX()return self.minX end;function a:getMinY()return self.minY end;function a:getMaxX()return self.maxX end;function a:getMaxY()return self.maxY end;function a:getDataLength()return#self.dx end;function a:getLineWidth()return self.lWidth or 3 end;function a:setName(D)self.name=D end;function a:setData(B,C)self.dx=B;self.dy=C;self.minX=c(B)self.minY=c(C)self.maxX=d(B)self.maxY=d(C)end;function a:setColor(E)self.col=E end;function a:setLineWidth(F)self.lWidth=F end;b={}b.__index=b;b._joints=10000;setmetatable(b,{__call=function(A,...)return A.new(...)end})function b.init()tfm.exec.addPhysicObject(-1,0,0,{type=14,miceCollision=false,groundCollision=false})end;function b.handleClick(G,H,I)if I:sub(0,("lchart:data:["):len())=='lchart:data:['then local J=split(I:sub(("lchart:data:["):len()+1,-2),",")local K,L,M,N=split(J[1],":")[2],split(J[2],":")[2],split(J[3],":")[2],split(J[4],":")[2]ui.addTextArea(18000,"<a href='event:chart_close'>X: "..M.."<br>Y: "..N.."</a>",H,K,L,80,30,nil,nil,0.5,false)elseif I=="chart_close"then ui.removeTextArea(G,H)end end;function b.new(G,O,z,F,P)local self=setmetatable({},b)self.id=G;self.x=O;self.y=z;self.w=F;self.h=P;self.showing=false;self.joints=b._joints;b._joints=b._joints+10000;self.series={}return self end;function b:getId()return self.id end;function b:getDimension()return{x=self.x,y=self.y,w=self.w,h=self.h}end;function b:getMinX()return self.minX end;function b:getMaxX()return self.maxX end;function b:getMinY()return self.minY end;function b:getMaxY()return self.maxY end;function b:getXRange()return self.xRange end;function b:getYRange()return self.yRange end;function b:getGraphColor()return{bgColor=self.bg or 0x324650,borderColor=self.border or 0x212F36}end;function b:getAlpha()return self.alpha or 0.5 end;function b:isShowing()return self.showing end;function b:getDataLength()local Q=0;for R,i in next,self.series do Q=Q+i:getDataLength()end;return Q end;function b:show()self:refresh()local S,T=math.floor,math.ceil;ui.addTextArea(10000+self.id,"",nil,self.x,self.y,self.w,self.h,self.bg,self.border,self:getAlpha(),false)ui.addTextArea(11000+self.id,"<b>["..S(self.minX)..", "..S(self.minY).."]</b>",nil,self.x-15,self.y+self.h+5,50,50,nil,nil,0,false)ui.addTextArea(12000+self.id,"<b>"..T(self.maxX).."</b>",nil,self.x+self.w+10,self.y+self.h+5,50,50,nil,nil,0,false)ui.addTextArea(13000+self.id,"<b>"..T(self.maxY).."</b>",nil,self.x-15,self.y-10,50,50,nil,nil,0,false)ui.addTextArea(14000+self.id,"<b>"..T((self.maxX+self.minX)/2).."</b>",nil,self.x+self.w/2,self.y+self.h+5,50,50,nil,nil,0,false)ui.addTextArea(15000+self.id,"<br><br><b>"..T((self.maxY+self.minY)/2).."</b>",nil,self.x-15,self.y+(self.h-self.y)/2,50,50,nil,nil,0,false)local U=self.joints;local V=self.w/self.xRange;local W=self.h/self.yRange;for G,X in next,self.series do for Y=1,X:getDataLength(),1 do local Z=S(X:getDX()[Y]*V+self.x-self.minX*V)local _=S(y(X:getDY()[Y]*W)+self.y-y(self.h)+self.minY*W)local a0=S((X:getDX()[Y+1]or X:getDX()[Y])*V+self.x-self.minX*V)local a1=S(y((X:getDY()[Y+1]or X:getDY()[Y])*W)+self.y-y(self.h)+self.minY*W)tfm.exec.addJoint(self.id+6+U,-1,-1,{type=0,point1=Z..",".._,point2=a0 ..","..a1,damping=0.2,line=X:getLineWidth(),color=X:getColor(),alpha=1,foreground=true})if self.showDPoints then ui.addTextArea(16000+self.id+U,"<font color='#"..num2hex(X:getColor()).."'><a href='event:lchart:data:[x:"..Z..",y:".._..",dx:"..X:getDX()[Y]..",dy:"..X:getDY()[Y].."]'>█</a></font>",nil,Z,_,10,10,nil,nil,0,false)end;U=U+1 end end;self.showing=true end;function b:setGraphColor(a2,a3)self.bg=a2;self.border=a3 end;function b:setShowDataPoints(a4)self.showDPoints=a4 end;function b:setAlpha(a5)self.alpha=a5 end;function b:addSeries(X)table.insert(self.series,X)self:refresh()end;function b:removeSeries(D)for x=1,#self.series do if self.series[x]:getName()==D then table.remove(self.series,x)break end end;self:refresh()end;function b:refresh()self.minX,self.minY,self.maxX,self.maxY=nil;for s,i in next,self.series do self.minX=math.min(i:getMinX(),self.minX or i:getMinX())self.minY=math.min(i:getMinY(),self.minY or i:getMinY())self.maxX=math.max(i:getMaxX(),self.maxX or i:getMaxX())self.maxY=math.max(i:getMaxY(),self.maxY or i:getMaxY())end;self.xRange=self.maxX-self.minX;self.yRange=self.maxY-self.minY end;function b:resize(F,P)self.w=F;self.h=P end;function b:move(O,z)self.x=O;self.y=z end;function b:hide()for G=10000,17000,1000 do ui.removeTextArea(G+self.id)end;for G=self.id+16000,self.joints,1 do ui.removeTextArea(G+self.id)end;for Y=self.joints,self.joints+self:getDataLength()+5,1 do tfm.exec.removeJoint(Y)end;self.showing=false end;function b:showLabels(a4)if a4 or a4==nil then local a6=""for R,X in next,self.series do a6=a6 .."<font color='#"..num2hex(X:getColor()).."'> ▉<b> "..X:getName().."</b></font><br>"end;ui.addTextArea(16000+self.id,a6,nil,self.x+self.w+15,self.y,100,18*#self.series,self:getGraphColor().bgColor,self:getGraphColor().borderColor,self:getAlpha(),false)else ui.removeTextArea(16000+self.id,nil)end end;function b:displayGrids(a4)if a4 or a4==nil then local a7=self.h/5;for G,z in next,f(self.y+a7,self.y+self.h-a7,a7)do tfm.exec.addJoint(self.id+G,-1,-1,{type=0,point1=self.x..","..z,point2=self.x+self.w..","..z,damping=0.2,line=1,alpha=1,foreground=true,color=0xFFFFFF})end;tfm.exec.addJoint(self.id+5,-1,-1,{type=0,point1=self.x+self.w/2 ..","..self.y,point2=self.x+self.w/2 ..","..self.y+self.h,damping=0.2,line=2,alpha=1,foreground=true,color=0xFFFFFF})tfm.exec.addJoint(self.id+6,-1,-1,{type=0,point1=self.x..","..self.y+self.h/2,point2=self.x+self.w..","..self.y+self.h/2,damping=0.2,line=2,alpha=1,foreground=true,color=0xFFFFFF})end end;Series=a;LineChart=b;getMin=c;getMax=d;map=e;range=f
    --[ timers4tfm ]--
    local a={}a.__index=a;a._timers={}setmetatable(a,{__call=function(b,...)return b.new(...)end})function a.process()local c=os.time()local d={}for e,f in next,a._timers do if f.isAlive and f.mature<=c then f:call()if f.loop then f:reset()else f:kill()d[#d+1]=e end end end;for e,f in next,d do a._timers[f]=nil end end;function a.new(g,h,i,j,...)local self=setmetatable({},a)self.id=g;self.callback=h;self.timeout=i;self.isAlive=true;self.mature=os.time()+i;self.loop=j;self.args={...}a._timers[g]=self;return self end;function a:setCallback(k)self.callback=k end;function a:addTime(c)self.mature=self.mature+c end;function a:setLoop(j)self.loop=j end;function a:setArgs(...)self.args={...}end;function a:call()self.callback(table.unpack(self.args))end;function a:kill()self.isAlive=false end;function a:reset()self.mature=os.time()+self.timeout end;Timer=a

    local gameMap = [[<C><P Ca=""/><Z><S><S X="401" Y="400" T="16" L="807" H="28" P="0,0,0.3,0.2,0,0,0,0"/><S X="398" Y="-17" T="16" L="807" H="28" P="0,0,0.3,0.2,0,0,0,0"/><S X="-19" Y="198" T="16" L="35" H="458" P="0,0,0.3,0.2,0,0,0,0"/><S X="817" Y="197" T="16" L="28" H="453" P="0,0,0.3,0.2,0,0,0,0"/></S><D/><O/><L/></Z></C>]]

    system.disableChatCommandDisplay()
    tfm.exec.disableAfkDeath()
    tfm.exec.disableAutoNewGame()
    tfm.exec.disableAutoShaman()
    tfm.exec.newGame(gameMap)

    LineChart.init()

        
    local chart = LineChart(1, 180, 50, 480, 250)
    local series = Series(
        {
            0, 0, 20, 20, 40, 40, 60, 60, 80, 80, 80, 100, 100, 100, 400, 400, 420, 430, 430, 450, 450, 470, 470, 490, 490, 510, 510
        }, {
            0, 50, 50, 40, 40, 50, 50, 40, 40, 50, 50, 50, 50, 30, 30, 50, 50, 50, 40, 40, 50, 50, 40, 40, 50, 50, 0
        },
    "Castle", 0xFFCC00)
    local timer = Timer(1, function() end, 500, true)
    chart:addSeries(series)
    chart:showLabels(true)
    
    local graphs = {
        ["y = sin x"] = function()
            local currX = 0
            timer:setCallback(function()
                local x = range(currX, currX + 10, 0.3)
	            local y = map(x, function(x) return  math.sin(x) end )
                series:setData(x, y)
                series:setName("y = sin x")
                series:setColor(0xFF0000)
                chart:show()
                chart:showLabels(true)
	            currX = currX + 0.5
            end)
            timer:setLoop(true)
            timer:call()
        end,
        ["y = cos x"] = function()
            local currX = 0
            timer:setCallback(function()
                local x = range(currX, currX + 10, 0.3)
	            local y = map(x, function(x) return  math.cos(x) end )
                series:setData(x, y)
                series:setColor(0x00FF00)
                chart:show()
                chart:showLabels(true)
	            currX = currX + 0.5
            end)
            timer:setLoop(true)
            timer:call()
        end,
        ["y = tan x"] = function()
            local currX = 0
            timer:setCallback(function()
                local x = range(currX, currX + 10, 0.3)
	            local y = map(x, function(x) return math.tan(x) end )
                series:setData(x, y)
                series:setColor(0x0000FF)
                chart:show()
                chart:showLabels(true)
	            currX = currX + 0.5
            end)
            timer:setLoop(true)
            timer:call()
        end,
        ["Untitled"] = function()
            local currX = 0
            timer:setCallback(function()
                local x = range(currX, currX + 10, 0.3)
                local y = map(x, function(x) return math.sin(2 * math.sin(2 * math.sin(2 * math.sin(x)))) end )
                series:setData(x, y)
                series:setColor(0x00FFFF)
                chart:show()
                chart:showLabels(true)
                currX = currX + 0.5
            end)
            timer:setLoop(true)
            timer:call()
        end,
        ["Castle"] = function()
            chart:hide()
            timer:setCallback(function()
                series:setData({
                    0, 0, 20, 20, 40, 40, 60, 60, 80, 80, 80, 100, 100, 100, 400, 400, 420, 430, 430, 450, 450, 470, 470, 490, 490, 510, 510
                }, {
                    0, 50, 50, 40, 40, 50, 50, 40, 40, 50, 50, 50, 50, 30, 30, 50, 50, 50, 40, 40, 50, 50, 40, 40, 50, 50, 0
                })
                series:setColor(0xFFCC00)
                chart:show()
            end)
            timer:setLoop(true)
            timer:call()
            chart:showLabels(true)
        end
    }

    -- [[ events ]] --
    eventNewPlayer = function(name)
        local commu = tfm.get.room.playerList[name].community
        tfm.exec.chatMessage(module.translate("welcome0graphs", commu), name)
        chart:show()
        local isRoomAdmin = module.subRoomAdmins[name]
        local counter = 0
        for graph in next, graphs do
            ui.addTextArea(counter, "<b><p align='center'>" .. (isRoomAdmin and "<a href='event:graph:" .. graph .. "'>" or "<N2>") .. graph .. (isRoomAdmin and "</a>" or "</N2>") .. "</p></b>", name, 50, 50 + counter * 30, 100, 20, nil, nil, 1, true)
            counter = counter + 1
        end
    end
    
    eventNewGame = function()
        for name, player in next, tfm.get.room.playerList do eventNewPlayer(name) end
    end

    eventLoop = function(tc, tr)
        Timer.process()
    end

    eventTextAreaCallback = function(id, name, evt)
        if evt:find("%w+:.+") then
            local key, value = table.unpack(string.split(evt, ":"))
            if key == "graph" and module.subRoomAdmins[name] then
                graphs[value]()
                series:setName(value)
            end
        end
    end

    eventChatCommand = function(name, cmd)
        local commu = tfm.get.room.playerList[name].community
        local args = string.split(cmd, " ")
        print(table.tostring(args))
        if args[1] == "commands" then
            tfm.exec.chatMessage(module.translate("cmds0graphs"), name)
        elseif args[1] == "admin" and tfm.get.room.playerList[args[2]] then
            if module.subRoomAdmins[name] then
                if module.subRoomAdmins[args[2]] then return tfm.exec.chatMessage(module.translate("error_adminexists", commu, nil, {name = args[2]}), name) end
                module.subRoomAdmins[args[2]] = true
                tfm.exec.chatMessage(module.translate("new_roomadmin", tfm.get.room.community, nil, {name = args[2]}))
                local counter = 0
                for graph in next, graphs do
                    ui.addTextArea(counter, "<b><p align='center'><a href='event:graph:" .. graph .. "'>" .. graph .. "</a></p></b>", args[2], 50, 50 + counter * 30, 100, 20, nil, nil, 1, true)
                    counter = counter + 1
                end
            else
                tfm.exec.chatMessage(module.translate("error_auth", commu), name)
            end
        end
    end

end



if modes[module.mode] then
    modes[module.mode].main()
else
    modes.castle.main()
end
