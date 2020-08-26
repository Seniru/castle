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
    welcome = "<br><N><p align='center'>Welcome to <b><D>#castle</D></b> - King`s living lounge and lab<br>Report any bugs or new features to <b><O>King_seniru</O><G><font size='8'>#5890</font></G></b><br><br>Type <b><BV>!modes</BV></b> to check out submodes of this module</p></N><br>",
    modestitle = "<p align='center'><D><font size='16' face='Lucida console'>Castle - submodes</font></D><br><br>",
    modebrief = "<b>castle0${name}</b> <CH><a href='event:modeinfo:${name}'>ⓘ</a></CH>\t<a href='event:play:${name}'><T>( Play )</T></a><br>",
    modeinfo = "<p align='center'><D><font size='16' face='Lucida console'>#castle0${name}</font></D></p><br><i><font color='#ffffff' size='14'>“<br>${description}<br><p align='right'>”</p></font></i><b>Author: </b> ${author}<br><b>Version: </b> ${version}</font><br><br><p align='center'><b><a href='event:play:${name}'><T>( Play )</T></a></b></p><br><br><a href='event:modes'>« Back</a>",
    new_roomadmin = "<N>[</N><D>•</D><N>] </N><D>${name}</D> <N>is now a room admin!</N>",
    error_adminexists = "<N>[</N><R>•</R><N>] <R>Error: ${name} is already an admin</R>",
    error_gameonprogress = "<N>[</N><R>•</R><N>] <R>Error: Game in progress!</R>",
    error_invalid_input = "<N>[</N><R>•</R><N>] <R>Error: Invlid input!</R>",
    error_auth = "<N>[</N><R>•</R><N>] <R>Error: Authorisation</R>",
    admins = "<N>[</N><D>•</D><N>] </N><D>Admins: </D>",
    password = "<N>[</N><D>•</D><N>] </N><D>Password: </D><N>${pw}</N>",
    ban = "<N>[</N><R>•</R><N>] <R>${player} has been banned!</R>",
    unban = "<N>[</N><D>•</D><N>] </N><D>${player}</D> <N>has been unbanned!</N>",
    welcome0graphs = "<br><N><p align='center'>Welcome to <b><D>#castle0graphs</D></b><br>Report any bugs or suggest interesting functions to <b><O>King_seniru</O><G><font size='8'>#5890</font></G></b><br><br>Type <b><BV>!commands</BV></b> to check out the available commands</p></N><br>",
    cmds0graphs = "<BV>!admin <name></BV> - Makes a player admin <R><i>(admin only command)</i></R>",
    fs_welcome = "<br><N><p align='center'>Welcome to <b><D>#castle0fashion</D></b> - the Fashion show!<br><br><br>Type <b><BV>!join</BV></b> to participate the game or <b><BV>!help</BV></b> to see more things about this module!</p></N><br>",
    fs_info = "<p align='center'><font size='15' color='#ffcc00'><b>${owner} Fashion Show!</b></font><br><D><b>${title}</b></D></p><br><b>Description</b>: ${desc}<br><b>Prize</b>: ${prize}",
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
    fs_newroundprior = "<N>[</N><D>•</D><N>] Starting a new round...</N>",
    fs_newround = "<N>[</N><D>•</D><N>] <b><D>Round ${round} started!</D></b><br>\t<FC>• Theme:</FC> <N>${theme} (${type})</N><br>\t<FC>• Duration:</FC> <N>${dur}</N><br>\t<FC>• Players left:</FC> <N>${players}</N>",
    fs_round_end = "<N>[</N><D>•</D><N>] Round <D>${round}</D> ended! Judging in progress...</N>",
    fs_eliminated = "<N>[</N><D>•</D><N>] ${player} has been eliminated from the fashion show >:(</N>",
    fs_elimination_end = "<p align='center'><b><a href='event:newround'>End round!</a></b></p>",
    fs_maxplayers_error = "<N>[</N><R>•</R><N>] Sorry, the fashion show already got enough participants :(",
    fs_elimination_confirm = "Eliminate ${name}?",
    fs_error_not_playing = "<R>The selected player is not a participant!",
    fs_players_not_enough = "<N>[</N><R>•</R><N>] <R>Error: Not enough players!</R>",
    fs_all_participants_left = "<N>[</N><R>•</R><N>] <R>All the participants left, couldn`t determine a winner!</R>",
    fs_winner = "<N>[</N><D>•</D><N>] <b><D>Fashion show ended!</D><br>... and the winner is <D>${winner}</D>! Good job!</b></N>",
    fs_help = {
        ["main"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help</b></font></p><br>" ..
            "This is a submode of semi-official module #castle which lets players to host fashion shows easily, while keeping most of the old styles to make it close to you.<br>" ..
            "Create a room with your name included in the room name to host a fashion show as you the admin <i>(/room *#castle0fashion@Yourname#0000)</i><br>" ..
            "<br><b><D>Index</D></b><br><a href='event:help:commands'>• Commands</a><br><a href='event:help:keys'>• Key bindings</a><br><a href='event:help:credits'>• Credits</a>",
        ["commands"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help - Commands</b></font></p><br>" ..
            "<b>!admin [name]</b> - make a player an admin (admin only command)<br>" ..
            "<b>!admins</b> - shows a list of admins<br>" ..
            "<b>!ban [name]</b> - bans the mentioned player (admin only command)<br>" ..
            "<b>!c [message]</b> - chat with other room admins</b><br>" ..
            "<b>!checkpoint [all|<me>]</b> - set checkpoints (E)<br>" ..
            "<b>!eliminate [name]</b> - eliminates the player from the round (admin only command) (Shift + click)<br>" ..
            "<b>!help</b> - displays this help menu<br>" ..
            "<b>!join</b> - joins the fashion show, if you haven`t participated yet<br>" ..
            "<b>!omo <text></b> - displays an omo - like in utility (admin only command)<br>" ..
            "<b>!pw <pw></b> - sets a password, send empty password to unset it (admin only command)</b><br>" ..
            "<b>!s [me|admins|all|name]</b> - make players shaman according to the arguments provided or the name (admin only command)<br>" ..
            "<b>!stop</b> - force stop the current round<br>" ..
            "<b>!tp [me|admins|all|name]</b> - teleports a players according to the arguments provided or the name (admin only command)<br>" ..
            "<b>!unban [name]</b> - unbans the mentioned user (admin only command)</b>" ..
            "<br><br><a href='event:help:main'><BV>« Back</BV></a>",
        ["keys"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help - Keys</b></font></p><br>" ..
            "<b>E</b> - set a checkpoint<br>" ..
            "<b>Shift + Click (on player)</b> - eliminates a player after the round <i>(admin only)</i><br><br><a href='event:help:main'><BV>« Back</BV></a>",
        ["credits"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help - Credits</b></font></p><br>" ..
            "<b><D>Testing</D></b><br>" ..
            "• Snowvlokje#4925<br>• Michelleding#0000<br>• Lpspopcorn#0000<br>• Light#5990<br>• Lilylolarose#0000<br><br>Also thanks for <b>Snowvlokje#4925</b>, <b>Michelleding#0000</b> and the tribe <b>We Talk a Lot</b> to encouraging me and supporting me to do this work!<br><br><a href='event:help:main'><BV>« Back</BV></a>"
    }
}


module.translate = function(term, language, page, kwargs)
    local translation = translations[lang] and translations[lang][term] or translations.en[term]
    translation = page and translation[page] or translation
    if not translation then return end
    return string.format(translation, kwargs)
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
    tfm.exec.disableAutoTimeLeft()
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
    local over = false
    local participants = {}
    local participantCount = 0
    local leftPlayers = {}
    local banned = {}

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
                    tfm.exec.addImage("170f8ccde22.png", ":1", 750, 320, args[1]) -- cogwheel icon
                    ui.addTextArea(4, "<a href='event:config'>\n\n\n\n</a>", args[1], 750, 320, 50, 50, nil, nil, 0, true)
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
            if banned[name] then return end
            if not participants[name] then
                if settings.maxPlayers <= participantCount then
                    tfm.exec.chatMessage(module.translate("fs_maxplayers_error", commu), name)
                elseif started then
                    tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), name)
                else
                    participants[name] = true
                    participantCount = participantCount + 1
                    tfm.exec.movePlayer(name, settings.playerSpawn.x, settings.playerSpawn.y)
                    tfm.exec.setNameColor(name, 0x00E5EE)
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
        end,

        eliminate = function(name, commu, args)
            local commu = tfm.get.room.playerList[name].community
            if not module.subRoomAdmins[name] then return tfm.exec.chatMessage(module.translate("error_auth"), commu) end
            players[name].selectedPlayer = args[1]
            if args[1] and participants[args[1]] then
                eliminatePlayer(args[1])
            end
        end,

        help = function(name, commu, args)
            addTextArea(7, module.translate("fs_help", commu, type(args) == "table" and "main" or args), name, 100, 50, 600, 320, true, true)
        end,
        
        c = function(name, commu, args)
            if not module.subRoomAdmins[name] then return tfm.exec.chatMessage(module.translate("error_auth"), commu) end
            if #args == 0 then return end
            local n, d = name:match("(.-)#(%d+)")
            local msg = "<D>•</D><N> [</N><D>" .. n .. "</D><font size='8'><G>" .. d .. "</G></font><N>] " .. table.concat(args, " ") .. "</N>"
            for admin in next, module.subRoomAdmins do
                tfm.exec.chatMessage(msg, admin)
            end
        end,

        pw = function(name, commu, args)
            if not module.subRoomAdmins[name] then return tfm.exec.chatMessage(module.translate("error_auth"), commu) end
            local pw = table.concat(args, " ")
            tfm.exec.setRoomPassword(pw)
            tfm.exec.chatMessage(module.translate("password", commu, nil, {pw = pw}))
        end,

        spec = function(name, commu, args)
            if participants[name] then
                participants[name] = nil
                participantCount = participantCount - 1
                tfm.exec.killPlayer(name)
                tfm.exec.setNameColor(name, 0xffffff)
                checkWinners()
            end
        end,

        ban = function(name, commu, args)
            local toBan = args[1]
            if (not module.subRoomAdmins[name]) or module.subRoomAdmins[toBan] then return tfm.exec.chatMessage(module.translate("error_auth", commu), name) end
            banned[toBan] = true
            tfm.exec.chatMessage(module.translate("ban", tfm.get.room.community, nil, {player = toBan}))
            if tfm.get.room.playerList[toBan] then
                tfm.exec.killPlayer(toBan)
                if participants[toBan] then
                    participants[toBan] = nil
                    participantCount = participantCount - 1
                    checkWinners()
                end
            end
        end,

        unban = function(name, commu, args)
            if not module.subRoomAdmins[name] then return tfm.exec.chatMessage(module.translate("error_auth"), commu) end
            local toUnban = args[1]
            if banned[toUnban] then
                banned[toUnban] = nil
                tfm.exec.respawnPlayer(toUnban)
            end
        end,

        info = function(name, commu, args)
            addTextArea(8, module.translate("fs_info", commu, nil, {
                owner = module.roomAdmin and module.roomAdmin .. "`s " or "",
                title = settings.title == "" and "" or ("« " .. settings.title .. " »"),
                desc = settings.desc == "" and "-" or settings.desc,
                prize = settings.prize == "" and "-" or settings.prize
            }), name, 275, 100, 250, 200, true, true)
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
            local max = tonumber(value)
            if not max then return tfm.exec.chatMessage(module.translate("error_invalid_input", commu), target) end
            settings.maxPlayers = max
            tfm.exec.setRoomMaxPlayers(max)
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
            local map = value:match("^@?(%d+)$")
            if not map then return tfm.exec.chatMessage(module.translate("error_invalid_input", ommu), target) end
            settings.map = map
            tfm.exec.newGame(map)
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
            if not value then return tfm.exec.chatMessage(module.translate("error_invalid_input", commu), target) end
            round.dur = value
            round.displayConfigMenu(target)
        end,
        -- elimination popup
        [150] = function(value, target, commu)
            if value == "yes" then
                local out = players[target].selectedPlayer
                eliminatePlayer(out)
            end
        end,
        title = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(100, 2, module.translate("fs_title_popup", commu), target, 250, 40, 300, true)
        end,
        desc = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(101, 2, module.translate("fs_desc_popup", commu), target, 250, 40, 300, true)
        end,
        prize = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(102, 2, module.translate("fs_prize_popup", commu), target, 250, 40, 300, true)
        end,
        participants = function(target, commu)
            handleCloseButton(1, target)
            handleCloseButton(3, target)
            local res = module.translate("fs_participants", commu)
            for name in next, participants do
                res = res .. name .. ", "
            end
            addTextArea(2, res:sub(1, -3), target, 275, 100, 250, 200, true, false)
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
            ui.addPopup(103, 2, module.translate("fs_maxp_popup", commu), target, 250, 40, 300, true)
        end,
        password = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(104, 2, module.translate("fs_pw_popup", commu), target, 250, 40, 300, true)
        end,
        map = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(105, 2, module.translate("fs_map_popup", commu), target, 250, 40, 300, true)
        end,
        consumables = function(target, commu)
            handleCloseButton(1, target)
            ui.addPopup(106, 1, module.translate("fs_consumable_popup", commu), target, 250, 40, 300, true)
        end,
        theme = function(target, commu)
            if round.started then return tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), target) end
            handleCloseButton(3, target)
            ui.addPopup(107, 2, module.translate("fs_round_title", commu), target, 250, 40, 300, true)
        end,
        dur = function(target, commu)
            if round.started then return tfm.exec.chatMessage(module.translate("error_gameonprogress", commu), target) end
            handleCloseButton(3, target)
            ui.addPopup(108, 2, module.translate("fs_round_dur", commu), target, 250, 40, 300, true)
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
        if (not closeSequence[id]) or (not tfm.get.room.playerList[target]) then return end
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
        if not tfm.get.room.playerList[target] then return end
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
            local commu = tfm.get.room.playerList[module.roomAdmin] and tfm.get.room.playerList[module.roomAdmin].community or "en"
            if participantCount < 3 then return tfm.exec.chatMessage(module.translate("fs_players_not_enough", commu), module.roomAdmin) end
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

    eliminatePlayer = function(out)
        if participants[out] then
            tfm.exec.setNameColor(out, 0xff0000)
            tfm.exec.movePlayer(out, settings.outSpawn.x, settings.outSpawn.y)
            onkey[keys.E](out, true, settings.outSpawn.x, settings.outSpawn.y)
            participants[out] = nil
            participantCount = participantCount - 1
            tfm.exec.chatMessage(module.translate("fs_eliminated", tfm.get.room.community, nil, {player = out}))
            checkWinners()
        else
            tfm.exec.chatMessage(module.translate("fs_error_not_playing", commu), target)
        end
    end

    checkWinners = function()
        if not started then return end
        if participantCount == 0 then
            over = true
            tfm.exec.chatMessage(module.translate("fs_all_participants_left", tfm.get.room.community))
        elseif participantCount == 1 then
            local winner = next(participants)
            tfm.exec.chatMessage(module.translate("fs_winner",  tfm.get.room.community, nil, {winner = winner}))
            over = true
        end
        if over then
            for player in next, tfm.get.room.playerList do
                system.bindMouse(player, false)
            end
            ui.removeTextArea(4)
            ui.removeTextArea(6)
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
        round.id = round.id + 1
    end

    round.stop = function()
        tfm.exec.chatMessage(module.translate("fs_round_end", tfm.get.room.community, nil, {round = round.id}))
        for player in next, tfm.get.room.playerList do
            tfm.exec.killPlayer(player)
        end
        tfm.exec.disableMortCommand()
        for admin in next, module.subRoomAdmins do
            local commu = tfm.get.room.playerList[admin].community
            system.bindMouse(admin, true)
            system.bindKeyboard(admin, keys.SHIFT, true, true)
            system.bindKeyboard(admin, keys.SHIFT, false, true)
            ui.addTextArea(6, module.translate("fs_elimination_end", admin), admin, 650, 330, 80, 20, nil, 0x00ff00, 0.6, true)
        end
        for left in next, leftPlayers do
            participantCount = participantCount - 1
            participants[left] = nil
        end
        -- handling things after removing left players
        checkWinners()
    end

    round.displayConfigMenu = function(target, updated)
        if not tfm.get.room.playerList[target] then return end
        ui.removeTextArea(6)
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
        if over then return end
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
        if over then return end
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
        if over then return end
        local commu = tfm.get.room.playerList[name].community
        if evt == "close" then
            handleCloseButton(id / 1000, name)
        elseif evt == "config" and module.subRoomAdmins[name] then
            if started then round.displayConfigMenu(name) else displayConfigMenu(name) end            
        elseif evt == "start" and name == module.roomAdmin then
            start()
        elseif evt == "newround" and module.subRoomAdmins[name] then
            tfm.exec.chatMessage(module.translate("fs_newroundprior", tfm.get.room.community))
            round.started = false
            round.theme = ""
            round.dur = 0
            round.type = round.types.SOLO
            ui.removeTextArea(6)
            round.displayConfigMenu(name)
        elseif evt:find("^%w+:.+") then
            local key, value = table.unpack(string.split(evt, ":"))
            if key == "fs" then
                if module.subRoomAdmins[name] and config[value] then
                    config[value](name, commu)
                end
            elseif key == "help" then
                chatCmds["help"](name, commu, value)
            end
        end
    end

    eventPopupAnswer = function(id, name, answer)
        if over then return end
        local commu = tfm.get.room.playerList[name].community
        if answer:match("https?") or answer:match("</?%w+>") then return tfm.exec.chatMessage(module.translate("error_invalid_input", commu), name) end
        if id >= 100 and id < 200 and module.subRoomAdmins[name] and config[id] then-- admin config stuff
            config[id](answer, name, commu)
        end
    end

    eventPlayerDied = function(name)
        if banned[name] then return end
        tfm.exec.respawnPlayer(name)
        if players[name].checkpoint then
            local cp = players[name].checkpoint
            tfm.exec.movePlayer(name, cp.x, cp.y)
        elseif participants[name] then
            tfm.exec.movePlayer(name, settings.playerSpawn.x, settings.playerSpawn.y)
            tfm.exec.setNameColor(name, 0x00E5EE)
        else
            tfm.exec.movePlayer(name, settings.specSpawn.x, settings.specSpawn.y)
        end
    end

    eventNewPlayer = function(name)
        players[name] = {clicks = {}, activeKeys = {}}
        system.bindKeyboard(name, keys.E, true, true)
        eventPlayerDied(name)
        tfm.exec.chatMessage(module.translate("fs_welcome", tfm.get.room.playerList[name].community), name)
        if module.subRoomAdmins[name] then
            if not started then displayConfigMenu(admin) end
            tfm.exec.addImage("170f8ccde22.png", ":1", 750, 320, name) -- cogwheel icon
            ui.addTextArea(4, "<a href='event:config'>\n\n\n\n</a>", name, 750, 320, 50, 50, nil, nil, 0, true)
        end
        if leftPlayers[name] then
            leftPlayers[name] = nil
        end
    end

    eventPlayerLeft = function(name)
        if participants[name] then
            leftPlayers[name] = true
        end
    end

    --[[eventNewGame = function()
        if not started then
            for admin in next, module.subRoomAdmins do
                displayConfigMenu(admin)
                tfm.exec.addImage("170f8ccde22.png", ":1", 750, 320, admin) -- cogwheel icon
                ui.addTextArea(4, "<a href='event:config'>\n\n\n\n</a>", admin, 750, 320, 50, 50, nil, nil, 0, true)
            end
        end
    end]]

    eventLoop = function()
        Timer.process()
    end

    do
        for name, player in next, tfm.get.room.playerList do
            eventNewPlayer(name)
        end
    end

end

modes.frost = {
	version = "v0.0.1",
	description = "Early prototype of the frost module",
	author = "Aron#6810"
}

modes.frost.main = function()
    
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoScore(true)
New_maps = {"@7695182","@7748121","@7697419","@7697119","@7711812","@7748125","@7748126","@7719350","@7726206","@7730512"}
tfm.exec.newGame(New_maps[math.random(#New_maps)])
playerr = {}
admins = {
    ["Aron#6810"] = true
}
mods = {
    [""] = true
}
lifes = {
    lifee = {},
    h6 = {},
    h5 = {},
    h4 = {},
    h3 = {},
    h2 = {},
    timmer = {}
}
powers = {
    meep = {},
    fly = {},
}
function life_mouse()
    for name in next, tfm.get.room.playerList do
        if playerr[name] then
            if playerr[name].life == 6 then
                if not lifes.lifee[name] then lifes.lifee[name] = tfm.exec.addImage("173097d50f3.png", "&1",-1, 18 , name) end
                if not lifes.h2[name] then lifes.h2[name] = tfm.exec.addImage("173097d50f3.png", "&2",29, 18.000003814697266, name) end
                if not lifes.h3[name] then lifes.h3[name] = tfm.exec.addImage("173097d50f3.png", "&3", 60, 18.000003814697266, name) end
                if not lifes.h4[name] then lifes.h4[name] = tfm.exec.addImage("173097d50f3.png", "&4", 90, 18.000003814697266, name) end
                if not lifes.h5[name] then lifes.h5[name] = tfm.exec.addImage("173097d50f3.png", "&5", 120, 18.000003814697266, name) end
                if not lifes.h6[name] then lifes.h6[name] = tfm.exec.addImage("173097d50f3.png", "&6", 150, 18.000003814697266, name) end
            elseif playerr[name].life == 5 then
                if lifes.h6[name] then tfm.exec.removeImage(lifes.h6[name],name) lifes.h6[name]=nil end
            elseif playerr[name].life == 4 then
                if lifes.h5[name] then tfm.exec.removeImage(lifes.h5[name],name) lifes.h5[name]=nil end
            elseif playerr[name].life == 3 then
                if lifes.h4[name] then tfm.exec.removeImage(lifes.h4[name],name) lifes.h4[name]=nil end
            elseif playerr[name].life == 2 then
                if lifes.h3[name] then tfm.exec.removeImage(lifes.h3[name],name) lifes.h3[name]=nil end
            elseif playerr[name].life == 1 then
                if lifes.h2[name] then tfm.exec.removeImage(lifes.h2[name],name) lifes.h2[name]=nil end
            elseif playerr[name].life <= 0 then
                if lifes.lifee[name] then tfm.exec.removeImage(lifes.lifee[name],name) lifes.lifee[name]=nil end
                tfm.exec.killPlayer(name)
            end
        end
    end
end
life_mouse()    
function powers_pic(name)
    if playerr[name].meep_pic+10000 < os.time() and not playerr[name].meep_actived then
        playerr[name].meep_actived = true
        powers.meep[name] = tfm.exec.addImage("17313328c7d.png", "&7", 769, 27.000003814697266, name)
        tfm.exec.chatMessage("<fc>[•] Meep power has been activated : press Space to use it :D",name)
    end
    if playerr[name].fly_pic+25000 < os.time() and not playerr[name].fly_actived then
        playerr[name].fly_actived = true
        powers.fly[name] = tfm.exec.addImage("1731332a3ee.png", "&8", 718, 12.000003814697266, name)
        tfm.exec.chatMessage("<fc>[•] Double Jump power has been activated : press F to use it :D",name)
    end
end
 
timer = 0
he = 0
time_to = os.time()
function eventLoop(past,left)
    if left<1000 then
        tfm.exec.newGame(New_maps[math.random(#New_maps)])
        for name in next, tfm.get.room.playerList do
            playerr[name].life = 6
        end
    end
    if time_to+2000 < os.time() then
        timer = timer + 1
        time_to = os.time()
        ui.addTextArea(1, "<p align='center'><font size='29'>" .. timer, nil,347, 30, 88, 40, 0x000000, 0x000000, 1, true)
    end
    if timer == 5 then
        timer = 5
        for name , player in next, tfm.get.room.playerList do
            if not player.isDead then
                local x = tfm.get.room.playerList[name].x
                local y = tfm.get.room.playerList[name].y
                tfm.exec.displayParticle(1,x,y,math.random(-1,1),math.random(-1,-0.5),0,0,nil)
                tfm.exec.displayParticle(9,x-math.random(-1,1),y,math.random(-1,1),math.random(-1,-0.5),0,0,nil)
                tfm.exec.freezePlayer(name,true)
            end
        end
    elseif timer == 7 then
        for name , player in next, tfm.get.room.playerList do
            if not player.isDead then
                tfm.exec.freezePlayer(name,false)
            end
            playerr[name].life = playerr[name].life - 1
            life_mouse()
        end
        timer = 0
    end
    for name in next, tfm.get.room.playerList do
        powers_pic(name)
    end
end
 
function eventNewPlayer(name)
    tfm.exec.chatMessage("<p align='center'><N>Welcome to </N><b><ch>#Frost !</ch></b><N>\nFor more information please type <b><ch>!help</ch></b></N><r>\n if you encountered any error please contact<b> Aron#6810</b></r></p>", name)
    tfm.exec.addImage("1730d48bf7b.png", ":1", 316, 19.000003814697266, nil)
    for _,binds in next,{32,70} do
        tfm.exec.bindKeyboard(name,binds, true, true)
    end
    playerr[name] = {life = 6 , wins = 0 , died = 0 , meep_pic = os.time() , meep_power = 0, meep_actived = false , fly_pic = os.time() , fly_power = 0, fly_actived = false}
end
 
function eventNewGame()
    tfm.exec.newGame(New_maps[math.random(#New_maps)])
    timer = 0
    life_mouse()
    for name in next, tfm.get.room.playerList do
        playerr[name].life = 6
    end
end
function eventChatCommand(name,command)
    local args = {}
    for name in command:gmatch("%S+") do
        table.insert(args, name)
    end
    if args[1] == "profile" then
        local p = args[2] or name
        if inRoom(p) then
            if playerr[name] then
                ui.addTextArea(3, "", name, 240, 157, 315, 175, 0x001d2b, 0x000000, 1, true)
                ui.addTextArea(4, "<font size='19'><p align='center'> Wins :\n\n\nDeaths :\n\n", name, 244, 190, 110, 104, 0x001d2b, 0x001d2b, 1, true)
                ui.addTextArea(6, "<font size='19'><p align='center'><ch><b> "..playerr[name].wins.." \n\n\n"..playerr[name].died.."\n", name, 438, 190, 110, 104, 0x001d2b, 0x001d2b, 1, true)
                ui.addTextArea(2, "<p align='center'><font size='15'><ch><b>"..name.."", name, 223, 139, 356, 24, 0x003a57, 0x000000, 1, true)
                ui.addTextArea(5, "<a href='event:close_profile'><p align='center'><font color='#FF0000'><b>X", name, 556, 142, 18, 18, 0x003a57, 0x003a57, 1, true)
            end
        end
    end
    if command == "help" then
        ui.addTextArea(11, "<font size='18'><p align='center'> \nIn this <ch>module </ch> you have to get the cheese in the fastest time possible without losing <ch>6 hearts </ch> of your life completely\n\nyou'll get some <ch>powers</ch> that will show after some time , you can use it to make the game easier. </font>\n\n<font size='12'><a href='event:help'> Help </a> - <a href='event:commands'>commands </a>- <a href='event:staff'>staff</a>", name, 193, 146, 408, 217, 0x001d2b, 0x000000, 1, true)
        ui.addTextArea(10, "<p align='center'><font size='15'><ch><b>#Frost - Help", name, 155, 117, 480, 24, 0x003a57, 0x000000, 1, true)
        ui.addTextArea(12, "<a href='event:close_help'><p align='center'><font color='#FF0000'><b>X", name, 613, 120, 20, 18, 0x003a57, 0x003a57, 1, true)
    end
end
function inRoom(playerName)
    return not not tfm.get.room.playerList[playerName]
end
function eventPlayerWon(name)
    local alive = 0
    for name, player in next, tfm.get.room.playerList do
        if not player.isDead then
            alive = alive + 1
        end
    end
    if alive == 0 then
        tfm.exec.newGame(New_maps[math.random(#New_maps)])
    end
    if playerr[name] and playerr[name].wins then
        playerr[name].wins = playerr[name].wins + 1
    end
end
function eventPlayerDied(name)
    local alive = 0
    for name, player in next, tfm.get.room.playerList do
        if not player.isDead then
            alive = alive + 1
        end
    end
    if alive == 0 then
        tfm.exec.newGame(New_maps[math.random(#New_maps)])
    end
    if playerr[name] and playerr[name].died then
        playerr[name].died = playerr[name].died + 1
    end
end
function eventKeyboard(name,key,x,y)
    if playerr[name].meep_actived then
        if key == 32 then
            tfm.exec.removeImage(powers.meep[name])
            tfm.exec.giveMeep(name)
            playerr[name].meep_powers = os.time()
            playerr[name].meep_pic = os.time()
            playerr[name].meep_actived = false
        end
    end
    if playerr[name].fly_actived then
        if key == 70 then
            tfm.exec.removeImage(powers.fly[name])
            tfm.exec.movePlayer(name,0,0,true,0,-50,false)
            playerr[name].fly_powers = os.time()
            playerr[name].fly_pic = os.time()
            playerr[name].fly_actived = false
        end
    end
end
 
 
function eventTextAreaCallback (id,name,callback)
    if callback == "close_profile" then
        for _,close_pf in next,{2,3,4,5,6} do
            ui.removeTextArea(close_pf,name)
        end
    elseif callback == "close_help" then
        for _,close_hp in next,{10,11,12} do
            ui.removeTextArea(close_hp,name)
        end
    elseif callback == "help" then
        ui.addTextArea(11, "<font size='18'><p align='center'> \nIn this <ch>module </ch> you have to get the cheese in the fastest time possible without losing <ch>6 hearts </ch> of your life completely\n\nyou'll get some <ch>powers</ch> that will show after some time , you can use it to make the game easier. </font>\n\n<font size='12'><a href='event:help'> Help </a> - <a href='event:commands'>commands </a>- <a href='event:staff'>staff</a>", name, 193, 146, 408, 217, 0x001d2b, 0x000000, 1, true)
        ui.addTextArea(10, "<p align='center'><font size='15'><ch><b>#Frost - Help", name, 155, 117, 480, 24, 0x003a57, 0x000000, 1, true)
        ui.addTextArea(12, "<a href='event:close_help'><p align='center'><font color='#FF0000'><b>X", name, 613, 120, 20, 18, 0x003a57, 0x003a57, 1, true)
    elseif callback == "commands" then
        ui.addTextArea(11, "<font size='18'><p align='center'> \n<b>Commands : </b>\n\n<ch>!help</ch> - to open the help window\n\n<ch>!profile</ch> - to see your profile\n</font>\n<font size='12'><a href='event:help'> Help </a> - <a href='event:commands'>commands </a>- <a href='event:staff'>staff</a>", name, 193, 146, 408, 217, 0x001d2b, 0x000000, 1, true)       
        ui.addTextArea(10, "<p align='center'><font size='15'><ch><b>#Frost - Commands", name, 155, 117, 480, 24, 0x003a57, 0x000000, 1, true)
        ui.addTextArea(12, "<a href='event:close_help'><p align='center'><font color='#FF0000'><b>X", name, 613, 120, 20, 18, 0x003a57, 0x003a57, 1, true)
    elseif callback == "staff" then
        ui.addTextArea(11, "<font size='18'><p align='center'> \n<b>Staff : </b>\n\n<ch>Aron#6810</ch> - Developer\n\n<ch>King_seniru#5890</ch> - Hoster\n</font>\n<font size='12'><a href='event:help'> Help </a> - <a href='event:commands'>commands </a>- <a href='event:staff'>staff</a>", name, 193, 146, 408, 217, 0x001d2b, 0x000000, 1, true)
        ui.addTextArea(10, "<p align='center'><font size='15'><ch><b>#Frost - Staff", name, 155, 117, 480, 24, 0x003a57, 0x000000, 1, true)
        ui.addTextArea(12, "<a href='event:close_help'><p align='center'><font color='#FF0000'><b>X", name, 613, 120, 20, 18, 0x003a57, 0x003a57, 1, true)
    end
end
table.foreach(tfm.get.room.playerList, eventNewPlayer)

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

modes.lavarun = {
	version = "v1.0.0",
	description = "Beta version of #lavarun module<br>/room #lavarun",
	author = "Aron#6810"
}

modes.lavarun.main = function()

tfm.exec.disableAutoShaman(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoScore(true)
start = false
maps = {"@7711812","@7712575","@7712598","@7719350","@7719524","@7726206","@7727560","@7727868", "@7730512","@7731011", "@6158764", "@7731679", "@6195684","@7731981" , "@6159770","@7731505","@7728158","@7732564","@6195529","@6195408","@7736712","@6195101","@7739224","@7732006","@7736314","@7741183"}
local admins = {["Aron#6810"] = true, ["King_seniru#5890"]=true} -- 1 admins
local mods = {["King_seniru#5890"] = true} -- 1 mods
players = {} -- players
banned = {}
menu={open={},powers={},help={},news={},remove={},helpbk={},commandsbk={},commandsbk={},profilebk={},leader={},newsbk={},laaderbk={},}
powers = {page1={},page2={},}
lavaph = {left={},}
translation = {
    en = {
        help = "<p align='center'><font size='19'>In this module <b><fc>#LavaRun</fc></b> you must becareful of the lava that <b><fc>ascends</fc></b>, you should get the <b><fc> cheese</fc></b> and <b><fc>win</fc></b> as soon as possible and never give a chance to the <b><fc>lava</fc></b> to approach you. type <b><fc>!commands</fc></b> to see all commands in the module , <b><r> [Warning] : </r></b><n>  Please turn on the FULLSCREEN to see the whole of the maps!</n>\n",
        command_title = "<p align='center'><font size='29'><b><fc>commands",
        commands_row1 = "<p align='center'><font size='13'><b> to open the help window\n\nto see all commands\n",
        commands_row2 = "<p align='center'><font size='10'><b> to see someone's profile/to see your profile",
        commands_row3 ="<p align='center'><font size='13'><b> to see the powers list\n\n to see your points",
        wins ="<font size='19'><b> wins :",
        died ="<font size='19'><b> deaths :",
        communitys ="<font size='19'><b> community :",
        close_button = "<a href='event:closeprofile'><p align='center'><font size='16'><r><b> [Close]",
        powerss = "<a href='event:powers'><p align='center'><font size='16'><vp><b> [Powers]",
    },
    ar = {
        help = "<p align='center'><font size='19'> في هذا النمط يجب عليك الحذر من اللاافا  التي تصعد ويجب عليك التقاط الجبن والفوز في اقرب وقت ممكن وعدم منح اللاافا فرصة التقرب منك اكتب ايعاز \n <b><fc>!commands </b></fc> \n لرؤية الايعازات الموجودة في النمط",
        command_title = "<p align='center'><font size='29'><b><fc>الأيعازات",
        commands_row1 = "<p align='center'><font size='13'><b> لفتح المساعدة\n\nلرؤية الايعازات\n",
        commands_row2 = "<p align='center'><font size='10'><b> رؤية بروفايلك / بروفايل شخص ما",
        commands_row3 = "<p align='center'><font size='13'><b> لرؤية القوى المتاحة\n\n لرؤية عدد نقاطك",
        wins ="<font size='19'><b> مرات الفوز : ",
        died ="<font size='19'><b> مرات الموت : ",
        communitys ="<font size='19'><b> المجتمع :",
        close_button = "<a href='event:closeprofile'><p align='center'><font size='16'><r><b> [اغلاق]",
        powerss = "<a href='event:powers'><p align='center'><font size='16'><vp><b> [القوى]",
        warning = "<ch> PasswordMode : </ch><b><vp> تفعيل !</vp></b>",
    },
    es = {
        help="<p align='center'><font size='19'>En este módulo,<b><fc> #lavarun</fc></b>, deberás tener cuidado con la <b><fc>lava</fc></b> que asciende. Tienes que coger el queso y ganar lo antes posible sin que la <b><fc>lava</fc></b> te alcance. \n tipo <b><fc> !commands</fc></b> para mostrar todos los comandos",
        command_title="<p align='center'><font size='29'><b><fc>Comandos",
        commands_row1="<p align='center'><font size='13'><b> para mostrar la ventana de ayuda\n\npara mostrar todos los comandos\n",
        commands_row2="<p align='center'><font size='10'><b>Para ver el perfil de alguien/Para ver tu perfil",
        commands_row3="<p align='center'><font size='13'><b>para ver la lista de poderes\n\npara ver tus puntos",
        wins="<font size='19'><b>gana :",
        died="<font size='19'><b>muertes :",
        communitys="<font size='19'><b>comunidad :",
        close_button="<a href='event:closeprofile'><p align='center'><font size='17'><r><b> [cerca]",
        powerss="<a href='event:powers'><p align='center'><font size='17'><vp><b> [potestades]",
    },
    hu = {
        help ="<p align='center'><font size='19'>A <b><fc>#LavaRun</fc></b> modulban óvakodnod kell a <b><fc>folyamatosan emelkedő</fc></b> lávától, meg kell szerezned a <b><fc> sajtot</fc></b>, majd minél hamarabb <b><fc>nyerni</fc></b>. Soha se adj esélyt a <b><fc>lávának</fc></b>, hogy elérjen téged. Használd a <b><fc>!commands</fc></b> parancsot, hogy megtekintsd az összes modulhoz kapcsolódó parancsot , <b><r> [Figyelmeztetés] : </r></b><n>  Kérlek, kapcsold be a teljes képernyős módot, hogy az egész pályát átlásd!</n>\n",
        command_title = "<p align='center'><font size='29'><b><fc>Parancsok",
        commands_row1 = "<p align='center'><font size='13'><b> megnyitja a segítség ablakot\n\nmegmutatja az összes parancsot\n",
        commands_row2 = "<p align='center'><font size='10'><b> Megjelenik valaki profilja/megmutatja a profilod",
        commands_row3 ="<p align='center'><font size='13'><b> lista az összes erőről\n\n hogy megnézhesse a pontokat ",
        wins ="<font size='19'> győzelmek :",
        died ="<font size='19'> halálok :",
        communitys ="<font size='19'> közösség :",
        close_button = "<a href='event:closeprofile'><p align='center'><font size='16'><r><b> [Bezárás]",
        powerss = "<a href='event:powers'><p align='center'><font size='16'><vp><b> [Erők]",
    },
}
for _,staffcommands in next,{"kill","tp","tpoff","time","map","ban","unban","pw","skip","c","profile"} do
    system.disableChatCommandDisplay(staffcommands)
end
tran = function(n, id)
    if translation[tfm.get.room.playerList[n].community] then
      return translation[tfm.get.room.playerList[n].community][id]
    else
      return translation["en"][id]
    end
end
function starts()
    for name in next, tfm.get.room.playerList do
        menu.open[name] = tfm.exec.addImage("1727575506d.png", ":3", -5, 26.000003814697266, name) -- open
        ui.addTextArea(103, "<a href='event:openmenu'>                                                                \n                                                                                      ", name, 5, 31, 28, 26, 0x000000, 0x000000, 1, true)    
        tfm.exec.setNameColor(name,0xFF6500)
        if players[name] then
            tfm.exec.setPlayerScore(name,players[name].score)
        end
    end
    tfm.exec.newGame(maps[math.random(#maps)])
    tfm.exec.setRoomMaxPlayers(20)
end
starts()
eventPlayerWon = function(name)
    local alive = 0
    for p, n in pairs(banned) do 
        if n == name then
            ui.addTextArea(100, "", name, -369, -54, 1543, 794, 0x0c0e0f, 0x000000, 1, true)
            ui.addTextArea(99, "<font size='49'><b><r>banned :(", name, 135, 128, 516, 194, 0x0c0e0f, 0x000000, 1, true)
        end
    end
    for name, player in next, tfm.get.room.playerList do
      if not player.isDead then
        alive = alive + 1
      end
  end
  if alive == 0 then
        tfm.exec.newGame(maps[math.random(#maps)])
  end
    if players[name] and players[name].score then
        players[name].score = players[name].score + 4
        tfm.exec.setPlayerScore(name,players[name].score)
    end
    if players[name] and players[name].wins then
        players[name].wins = players[name].wins + 1
    end
end
eventPlayerDied = function(name)
    for p, n in pairs(banned) do 
        if n == name then
            ui.addTextArea(100, "", name, -369, -54, 1543, 794, 0x0c0e0f, 0x000000, 1, true)
            ui.addTextArea(99, "<font size='49'><b><r>banned :(", name, 135, 128, 516, 194, 0x0c0e0f, 0x000000, 1, true)
        end
    end
    if players[name] and players[name].score then
        players[name].score = players[name].score + 1
        tfm.exec.setPlayerScore(name,players[name].score)
    end
    local alive = 0
    for name, player in next, tfm.get.room.playerList do
        if not player.isDead then
            alive = alive + 1
        end
    end
    if alive == 0 then
        tfm.exec.newGame(maps[math.random(#maps)])
    end
    if players[name] and players[name].dead then
        players[name].dead = players[name].dead + 1
    end
end
eventPlayerGetCheese = function(name)
    x = tfm.get.room.playerList[name].x
    y = tfm.get.room.playerList[name].y
    tfm.exec.chatMessage("<vp>Cheeese *-*", name)        
    tfm.exec.displayParticle(15,x-10,y,0,0,0,0,nil)
    if players[name] and players[name].score then
        players[name].score = players[name].score + 1
        tfm.exec.setPlayerScore(name,players[name].score)
    end
end
function eventKeyboard(name,key,down,x,y)
    if key==70  then
        if players[name].time+500 < os.time() then
            if players[name].score > 0 then
                tfm.exec.movePlayer(name,0,0,true,0,-50,false)
                tfm.exec.displayParticle(26,x-10,y,0,0,0,0,nil)
        if players[name] and players[name].score then
                players[name].score = players[name].score - 1
                tfm.exec.setPlayerScore(name,players[name].score)
                players[name].time = os.time()
        end
    end
end
    elseif key==32  then
        if players[name].score >= 5 and not players[name].hasMeep then
            tfm.exec.giveMeep(name, true)
            if players[name] and players[name].score then
                players[name].score = players[name].score - 5
                tfm.exec.setPlayerScore(name,players[name].score)
            end
            players[name].hasMeep = true
        end
    elseif key== 71  then
    if players[name].score >= 10 then
        tfm.exec.movePlayer(name, 0, 0, false, 80, 0, false)
        tfm.exec.displayParticle(13,x-10,y,0,0,0,0,nil)
    if players[name] and players[name].score then
        players[name].score = players[name].score - 10
        tfm.exec.setPlayerScore(name,players[name].score)
      end 
 end
elseif key==69  then
    if players[name].score >= 20 and not tfm.get.room.playerList[name].hasCheese then
        tfm.exec.giveCheese(name)
        tfm.exec.displayParticle(11,x-10,y,0,0,0,0,nil)
    if players[name] and players[name].score then
        players[name].score = players[name].score - 20
        tfm.exec.setPlayerScore(name,players[name].score)
      end
    end
  end
end
eventPlayerMeep = function(name, x, y)
    tfm.exec.giveMeep(name,false)
	players[name].hasMeep = false
end
lava_start = 0
lavay = 407
killzone = 434
eventLoop = function(past,left)
    lavay = lavay - 4
    lava_start = lava_start + 1
    killzone = killzone - 4
    if left<1000 then
        tfm.exec.newGame(maps[math.random(#maps)])
        lava_start = 0
        lavay = 407
        killzone = 434
    end
        tfm.exec.removeImage(lavaph.left)
        lavaph.left = tfm.exec.addImage ("1727b68eeb9.png", "!0",-390,lavay, nil)
        for n, p in pairs(tfm.get.room.playerList) do
            if  p.y > killzone  then
                tfm.exec.killPlayer(n)
        end
    end
end
eventNewGame = function()
    local author = tfm.get.room.xmlMapInfo.author
    local mapCode = tfm.get.room.xmlMapInfo.mapCode
    local community = string.upper(tfm.get.room.community)
    tfm.exec.setUIMapName(""..author.." <fc>- @"..mapCode.." </fc>   <g>|   </g><n>Community :</n><v>   "..community.."</v>")
    for p, n in pairs(banned) do 
        if n == name then
            ui.addTextArea(100, "", name, -369, -54, 1543, 794, 0x0c0e0f, 0x000000, 1, true)
            ui.addTextArea(99, "<font size='49'><b><r>banned :(", name, 135, 128, 516, 194, 0x0c0e0f, 0x000000, 1, true)
        end
    end
    start = true
    lava_start = 0
    lavay = 407
    killzone = 434
    ui.removeTextArea(0,nil)
	for name, player in next, players do
		players[name].hasMeep = false
	end
end

eventNewPlayer = function(name)
    players[name] = {score=0 , wins=0 , dead=0, hasMeep=false,time = 0}
    menu.open[name] = tfm.exec.addImage("1727575506d.png", ":3", -5, 26.000003814697266, name)
    ui.addTextArea(103, "<a href='event:openmenu'>                                                                \n                                                                                      ", name, 5, 31, 28, 26, 0x000000, 0x000000, 1, true)    
    for p, n in pairs(banned) do 
        if n == name then
            ui.addTextArea(100, "", name, -369, -54, 1543, 794, 0x0c0e0f, 0x000000, 1, true)
            ui.addTextArea(99, "<font size='49'><b><r>banned :(", name, 135, 128, 516, 194, 0x0c0e0f, 0x000000, 1, true)
        end
    end
    menu.newsbk[name] = tfm.exec.addImage("1729994fd46.png", ":9", 117, 57.000003814697266, name)
    ui.addTextArea(70, "<a href='event:closenews'>                                      ", name, 624, 80, 34, 32, 0x000000, 0x000000, 1, true)
    tfm.exec.setNameColor(name,0xFF6500)
    tfm.exec.setPlayerScore(name, players[name].score)
    tfm.exec.bindKeyboard(name,69,true,true)
    tfm.exec.bindKeyboard(name,70,true,true)
    tfm.exec.bindKeyboard(name,71,true,true)
    tfm.exec.bindKeyboard(name,32,true,true)
    tfm.exec.chatMessage("<p align='center'><N>Welcome to </N><b><FC>#lavarun!</FC></b><br>Don`t forget to visit our Discord server at</br> <b><BV>https://discord.gg/FwxVAbw</BV></b><r>\n if you encountered any error please contact<b> Aron#6810</b></r></p>", name)
end
eventChatCommand = function(name,command)
    local args = {}
    for name in command:gmatch("%S+") do
        table.insert(args, name)
    end
    for admin in next, admins do
        tfm.exec.chatMessage("<r>[</r><G>Logs</G><r>] :</r><n> "..name.." use this command > " ..command,admin)
    end
    if command == "help" then
        for _,helpbar in next,{5,6,900,8,7,18,21,23,24,50,27,28,29,30,34,31,32,33,14,15,16,13,17,19,20,36,37,38,30,40,41,42,70} do
            ui.removeTextArea(helpbar,name) 
        end
        tfm.exec.removeImage(menu.helpbk[name])
        tfm.exec.removeImage(powers.page1[name])
        tfm.exec.removeImage(powers.page2[name])
        tfm.exec.removeImage(menu.newsbk[name])
        tfm.exec.removeImage(menu.profilebk[name])
        tfm.exec.removeImage(menu.commandsbk[name])
        ui.addTextArea(5, "<p align='center'><font size='29'><b><fc>#LavaRun", name, 311, 65, 184, 44, 0x000000, 0x000000, 1, true)
        ui.addTextArea(6, tran(name,"help"), name,160, 110, 485, 280, 0x000000, 0x000000, 1, true)
        menu.helpbk[name] = tfm.exec.addImage("17275db04cb.png", ":5",130, 47.000003814697266, name)
        ui.addTextArea(900, "<a href='event:closehelp'>                                                                   \n             ", name, 637, 57, 34, 32, 0x000000, 0x000000, 1, true)
    elseif command == "points" then
        if players[name] then
            tfm.exec.chatMessage("<n> You have : </n><fc>" .. players[name].score .. " " .. "points !", name)
        end
    elseif command == "commands" then
        for _,commandsbar in next,{5,6,900,8,7,21,18,23,24,50,27,28,29,30,31,32,33,34,14,15,16,13,17,19,20,36,37,38,30,40,41,42,70} do
            ui.removeTextArea(commandsbar,name)
        end
        tfm.exec.removeImage(menu.helpbk[name])
        tfm.exec.removeImage(powers.page1[name])
        tfm.exec.removeImage(powers.page2[name])
        tfm.exec.removeImage(menu.newsbk[name])
        tfm.exec.removeImage(menu.profilebk[name])
        tfm.exec.removeImage(menu.commandsbk[name])
        menu.commandsbk[name] = tfm.exec.addImage("17275db04cb.png", ":5",130, 47.000003814697266, name)
        ui.addTextArea(8, tran(name,"command_title"), name, 315, 71, 184, 44, 0x000000, 0x000000, 1, true)
        ui.addTextArea(7, "<a href='event:closecommands'>                               ", name, 645, 68, 28, 26, 0x000000, 0x000000, 1, true)
        ui.addTextArea(21, "<p align='center'><font size='16'><fc><b> !help <p align='center'>\n\n!commands\n\n!profile[name]\n\n!powers\n\n!points", name, 191, 127, 183, 199, 0x000000, 0x000000, 1, true)
        ui.addTextArea(23, tran(name,"commands_row1"), name, 424, 119, 184, 170, 0x000000, 0x000000, 1, true)
        ui.addTextArea(24, tran(name,"commands_row2"), name, 430, 204, 180, 152, 0x000000, 0x000000, 1, true)
        ui.addTextArea(50, tran(name,"commands_row3"), name, 445, 239, 152, 90, 0x000000, 0x000000, 1, true)
end
   -- mods and admins
   if admins[name] or mods[name] then
       if args[1] == "time" then
           tfm.exec.setGameTime(tonumber(args[2]),true)
       elseif args[1] == "map" then
           tfm.exec.newGame(tonumber(args[2]))
       elseif args[1]  == "pw" then
           tfm.exec.setRoomPassword(args[2])
           tfm.exec.chatMessage("<ch> PasswordMode : </ch><b><vp> ON !</vp></b>",nil)   
       elseif args[1] == "kill" then
           tfm.exec.killPlayer((args[2]))
       elseif args[1] == "ban"  then
           tfm.exec.chatMessage("<ch>" .. args[2] .. " " .. "is banned from this room", nil)   
           print("<ch>" .. args[2] .. " " .. "is banned from this room")     
           table.insert(banned, args[2])
           tfm.exec.killPlayer((args[2]))
       elseif args[1] == "unban" then
           for i=1, #banned do
               if banned[i] == args[2] then
                   table.remove(banned, i)
                break
            end
        end
            ui.removeTextArea(99,args[2])
            ui.removeTextArea(100,args[2]) 
      end
    if admins[name] then
        local member = args[2]
        if args[1] == "p+" then
            if players[member] and players[member].score then
                players[member].score = players[member].score + args[3]
                tfm.exec.setPlayerScore(member,players[member].score)
            end
        end
        if args[1] == "c" then
            tfm.exec.chatMessage("<b><fc>[" .. name .. "][Module] : </fc></b><n>" .. table.concat(args, " ","2"))
        end
    end
end
  if args[1] == "profile" then
    tfm.exec.removeImage(menu.helpbk[name])
    tfm.exec.removeImage(powers.page1[name])
    tfm.exec.removeImage(powers.page2[name])
    tfm.exec.removeImage(menu.newsbk[name])
    tfm.exec.removeImage(menu.profilebk[name])
    tfm.exec.removeImage(menu.commandsbk[name])
    for _,profilebar in next,{5,6,900,8,7,18,21,23,24,50,34,27,28,29,30,31,32,33,14,15,16,13,17,19,20,36,37,38,30,40,41,42,70} do
        ui.removeTextArea(profilebar,name)
    end
    local p = args[2] or name
    if isExist(p) then
        community = string.upper(tfm.get.room.playerList[p].community)
        if players[name] then
            tfm.exec.removeImage(menu.profilebk[name])
            menu.profilebk[name] = tfm.exec.addImage("17284f1a142.png", ":8",195,11, name)
            ui.addTextArea(14, tran(name,"died"), name, 254, 132, 132, 28, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(15, tran(name,"wins"), name, 255, 194, 132, 28, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(16, tran(name,"communitys"), name, 255, 250, 144, 28, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(13, "<font size='19'><p align='center'><v>" .. p, name, 279, 60, 192, 27, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(17, "<font size='19'><b><j>"..players[p].dead.." ", name, 411, 129, 89, 28, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(18, "<font size='19'><b><j>"..players[p].wins.." ", name, 412, 193, 88, 28, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(19, "<font size='19'><b><j>"..community.." ", name, 411, 249, 88, 28, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(20, "<a href='event:closeprofile'>                                  ", name, 480, 52,28, 40, 0x000000, 0x000000, 1, true)
        end
   else
         print("<r>".. p .. " " .. "is a wrong name")
        tfm.exec.chatMessage("<r>".. p .. " " .. "is a wrong name", name)
      end
   end
end
eventTextAreaCallback = function(id,name,callback)
    if callback=="help" then
        for _,closecommands in next,{7,8,9,21,22,23,24,25,50} do
            ui.removeTextArea(closecommands,name)
        end
        for _,helpbar in next,{5,6,900,8,18,7,21,23,24,34,50,27,28,29,30,31,32,33,14,15,16,13,17,19,20,36,37,38,30,40,41,42,70} do
            ui.removeTextArea(helpbar,name)
        end
        tfm.exec.removeImage(menu.helpbk[name])
        tfm.exec.removeImage(powers.page1[name])
        tfm.exec.removeImage(powers.page2[name])
        tfm.exec.removeImage(menu.newsbk[name])
        tfm.exec.removeImage(menu.profilebk[name])
        tfm.exec.removeImage(menu.commandsbk[name])
        ui.addTextArea(5, "<p align='center'><font size='29'><b><fc>#LavaRun", name, 311, 65, 184, 44, 0x000000, 0x000000, 1, true)
        ui.addTextArea(6, tran(name,"help"), name,160, 110, 485, 280, 0x000000, 0x000000, 1, true)
        menu.helpbk[name] = tfm.exec.addImage("17275db04cb.png", ":5",130, 47.000003814697266, name)
        ui.addTextArea(900, "<a href='event:closehelp'>                                                                   \n             ", name, 637, 57, 34, 32, 0x000000, 0x000000, 1, true)
    elseif callback =="openmenu" then
        tfm.exec.removeImage(menu.powers[name])
        tfm.exec.removeImage(menu.remove[name])
        tfm.exec.removeImage(menu.news[name])
        tfm.exec.removeImage(menu.help[name])
        tfm.exec.removeImage(menu.leader[name])
        menu.leader[name] = tfm.exec.addImage("172863aba55.png", ":9", 13, 93.9749984741211, name)
        ui.addTextArea(90, "<a href='event:leaderb'>                                                            \n                                                                                         ", name, 19, 97, 37, 34, 0x000000, 0x000000, 1, true)
        menu.remove[name] = tfm.exec.addImage("17275b711a0.png", ":6", -5, 26.000003814697266, name) -- remove
        menu.powers[name] = tfm.exec.addImage("1727576779d.png", ":4", 29, 26.000003814697266, name)
        ui.addTextArea(106, "<a href='event:powers'>                                                               \n                                                                     ", name, 47, 32, 24, 25, 0x000000, 0x000000, 1, true)
        ui.addTextArea(105, "<a href='event:news'>                                                                       \n                        ", name, 47, 68, 24, 25, 0x000000, 0x000000, 1, true)
        menu.news[name] = tfm.exec.addImage("172757b05cd.png", ":2", 29, 62.000003814697266, name) 
        ui.addTextArea(104, "<a href='event:help'>                                                                 \n                    ", name, 7, 68, 24, 25, 0x000000, 0x000000, 1, true)
        menu.help[name] = tfm.exec.addImage("17275799be4.png", ":1", -6, 62.000003814697266, name)
        ui.addTextArea(103, "<a href='event:closemenu'>                                                                \n                                                                                      ", name, 5, 31, 28, 26, 0x000000, 0x000000, 1, true)
    elseif callback =="leaderb" then
        tfm.exec.chatMessage("<b><fc>[#Lavarun][LeaderBoard] :</fc></b><n> Soon...</n> ",name)   
    elseif callback =="closemenu" then
        menu.open[name] = tfm.exec.addImage("1727575506d.png", ":3", -5, 26.000003814697266, name) -- open
        tfm.exec.removeImage(menu.powers[name])
        tfm.exec.removeImage(menu.remove[name])
        tfm.exec.removeImage(menu.news[name])
        tfm.exec.removeImage(menu.help[name])
        tfm.exec.removeImage(menu.leader[name])
        ui.addTextArea(103, "<a href='event:openmenu'>                                                                \n                                                                                      ", name, 5, 31, 28, 26, 0x000000, 0x000000, 1, true)
    elseif callback =="closehelp" then
        tfm.exec.removeImage(menu.helpbk[name])
        for _,closehelp in next,{4,5,6,10,11,900} do
            ui.removeTextArea(closehelp,name)
        end
    elseif callback =="closecommands" then
        for _,closecommands in next,{7,8,9,21,22,23,24,25,50} do
            tfm.exec.removeImage(menu.commandsbk[name])
            ui.removeTextArea(closecommands,name)
        end
    elseif callback=="closeprofile" then
        tfm.exec.removeImage(menu.profilebk[name])
        for _,closeprofile in next,{13,14,15,16,17,18,19,20} do
            ui.removeTextArea(closeprofile,name)
        end
    elseif callback=="news" then
        for _,newsbar in next,{5,6,900,8,18,7,21,23,34,24,50,27,28,29,30,31,32,33,14,15,16,13,17,19,20,36,37,38,30,40,41,42,70} do
            ui.removeTextArea(newsbar,name)
        end
        tfm.exec.removeImage(menu.helpbk[name])
        tfm.exec.removeImage(powers.page1[name])
        tfm.exec.removeImage(powers.page2[name])
        tfm.exec.removeImage(menu.newsbk[name])
        tfm.exec.removeImage(menu.profilebk[name])
        tfm.exec.removeImage(menu.commandsbk[name])
        menu.newsbk[name] = tfm.exec.addImage("1729994fd46.png", ":9", 117, 57.000003814697266, name)
        ui.addTextArea(70, "<a href='event:closenews'>                                      ", name, 624, 80, 34, 32, 0x000000, 0x000000, 1, true)
    elseif callback=="closenews" then
        tfm.exec.removeImage(menu.newsbk[name])
        ui.removeTextArea(70,name)
    elseif callback=="powers" then
        if powers.page2[name] ~= nil then
            tfm.exec.removeImage(powers.page2[name])
            powers.page2[name] = nil
        end
        for _,powersbar in next,{5,6,900,8,7,18,21,23,34,24,50,27,28,29,30,31,32,33,14,15,16,13,17,19,20,36,37,38,30,40,41,42,70} do
            ui.removeTextArea(powersbar,name)
        end
        tfm.exec.removeImage(menu.helpbk[name])
        tfm.exec.removeImage(powers.page1[name])
        tfm.exec.removeImage(powers.page2[name])
        tfm.exec.removeImage(menu.newsbk[name])
        tfm.exec.removeImage(menu.profilebk[name])
        tfm.exec.removeImage(menu.commandsbk[name])
        if players[name] then
        powers.page1[name] = tfm.exec.addImage("17281b51041.png", ":7", 112, 57.000003814697266, name)
        ui.addTextArea(27, "<p align='center'><font size='30'><b> Powers", name, 289, 77, 196, 44, 0x152d30, 0x152d30, 1, true)
        ui.addTextArea(28, "<p align='center'><font size='20'><b> Fly !", name, 143, 284, 156, 39, 0x152d30, 0x152d30, 1, true)
        ui.addTextArea(29, "<p align='center'><font size='20'><b> Meep !", name, 488, 281, 156, 40, 0x152d30, 0x152d30, 1, true)
        ui.addTextArea(34, "<a href='event:page2'><p align='center'><font size='10'><b>Next»", name, 342, 316, 90, 20, 0x152d30, 0x152d30, 1, true)
        ui.addTextArea(31, "<a href='event:closepowers'>                                                         \n                              \n                                                                                                                                                                       ", name, 600, 70, 60, 53, 0x000000, 0x000000, 1, true)
        ui.addTextArea(32, "<font size='12'><p align='center'><b><r> 1 point", name, 137, 108, 167, 22, 0x152d30, 0x152d30, 1, true)
        ui.addTextArea(33, "<font size='12'><p align='center'><b><r> 5 points", name, 486, 110, 156, 21, 0x152d30, 0x152d30, 1, true)        
        if players[name].score >= 1 then
            ui.addTextArea(32, "<p align='center'><font size='12'><b><vp> press F", name, 137, 108, 167, 22, 0x152d30, 0x152d30, 1, true)
        if players[name].score >= 5 then
            ui.addTextArea(33, "<p align='center'><font size='12'><b><vp> press Space", name, 486, 110, 156, 21, 0x152d30, 0x152d30, 1, true)
        end
    end
    for _,page2 in next,{37,38,30,40,41,42} do
        ui.removeTextArea(page2,name)
    end
end           
    elseif callback=="closepowers" then
        for _,closepowers in next,{27,28,29,30,31,32,33,34,35,36} do
            ui.removeTextArea(closepowers,name)
        end
        tfm.exec.removeImage(powers.page1[name])
        tfm.exec.removeImage(powers.page2[name])
    elseif callback=="page2" then
        for _,page2bar in next,{5,6,34,900,8,18,7,21,23,24,50,27,28,29,30,31,32,33,14,15,16,13,17,19,20,36,37,38,30,40,41,42,70} do
            ui.removeTextArea(page2bar,name)
        end
        if powers.page1[name] ~= nil then
            tfm.exec.removeImage(powers.page1[name])
            powers.page1[name] = nil
        end
        if players[name] then
            if powers.page2[name] == nil then
            powers.page2[name] = tfm.exec.addImage("17281b527b4.png", ":7", 112, 57.000003814697266, name)
            end
            ui.addTextArea(36, "<p align='center'><font size='30'><b> Powers", name, 289, 77, 196, 44, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(37, "<p align='center'><font size='20'><b> Speed !", name, 143, 284, 156, 39, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(38, "<p align='center'><font size='20'><b> Cheese !", name, 488, 281, 156, 40, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(30, "<a href='event:powers'><p align='center'><font size='10'><b>«Back ", name, 342, 316, 90, 20, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(40, "<a href='event:closepowers2'>                                                                                               ", name,600, 70, 60, 53, 0x000000, 0x000000, 1, true)
            ui.addTextArea(41, "<font size='12'><p align='center'><b><r> 15 points", name, 137, 108, 167, 22, 0x152d30, 0x152d30, 1, true)
            ui.addTextArea(42, "<font size='12'><p align='center'><b><r> 20 points", name, 479, 108, 167, 22, 0x152d30, 0x152d30, 1, true)
        if players[name].score >= 10 then
            ui.addTextArea(41, "<p align='center'><font size='12'><b><vp> Press G", name, 137, 108, 167, 22, 0x152d30, 0x152d30, 1, true)
        if players[name].score >= 20 then
            ui.addTextArea(42, "<p align='center'><font size='12'><b><vp> Press E", name, 479, 108, 167, 22, 0x152d30, 0x152d30, 1, true)
        end
    end 
end
    elseif callback=="closepowers2" then
        for _,closepowers2 in next,{30,34,36,37,38,30,40,41,42} do
            ui.removeTextArea(closepowers2,name)
        end
        if powers.page2[name] ~= nil then
            tfm.exec.removeImage(powers.page2[name])
            powers.page2[name] = nil
        end
        tfm.exec.removeImage(powers.page1[name])
    end
end
function isExist(playerName)
    return not not tfm.get.room.playerList[playerName]
end
table.foreach(tfm.get.room.playerList, eventNewPlayer)

end

modes.pewpew = {
	version = "v0.0.1-beta",
	description = "Pewpew (new) BETA",
	author = "King_seniru#5890"
}

modes.pewpew.main = function()

--==[[ libs ]]==--

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

local Panel = {}
local Image = {}

do


    local string_split = function(s, delimiter)
        result = {}
        for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
            table.insert(result, match)
        end
        return result
    end

    local table_tostring

    table_tostring = function(tbl, depth)
        local res = "{"
        local prev = 0
        for k, v in next, tbl do
            if type(v) == "table" then
                if depth == nil or depth > 0 then
                    res =
                        res ..
                        ((type(k) == "number" and prev and prev + 1 == k) and "" or k .. ": ") ..
                            table_tostring(v, depth and depth - 1 or nil) .. ", "
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

    local table_copy = function(tbl)
        local res = {}
        for k, v in next, tbl do res[k] = v end
        return res
    end



    -- [[ class Image ]] --

    Image.__index = Image
    Image.__tostring = function(self) return table_tostring(self) end

    Image.images = {}

    setmetatable(Image, {
        __call = function(cls, ...)
            return cls.new(...)
        end
    })

    function Image.new(imageId, target, x, y, parent)

        local self = setmetatable({
            id = #Image.images + 1,
            imageId = imageId,
            target = target,
            x = x,
            y = y,
            instances = {},
        }, Image)

        Image.images[self.id] = self

        return self

    end

    function Image:show(target)
		if target == nil then error("Target cannot be nil") end
        if self.instances[target] then return self end
        self.instances[target] = tfm.exec.addImage(self.imageId, self.target, self.x, self.y, target)
        return self
    end

    function Image:hide(target)
		if target == nil then error("Target cannot be nil") end
        tfm.exec.removeImage(self.instances[target])
        self.instances[target] = nil
        return self
    end

    -- [[ class Panel ]] --

    Panel.__index = Panel
    Panel.__tostring = function(self) return table_tostring(self) end

    Panel.panels = {}

    setmetatable(Panel, {
        __call = function (cls, ...)
            return cls.new(...)
        end,
    })

    function Panel.new(id, text, x, y, w, h, background, border, opacity, fixed, hidden)
    
        local self = setmetatable({
            id = id,
            text = text,
            x = x,
            y = y,
            w = w,
            h = h,
            background = background,
            border = border,
            opacity = opacity,
            fixed = fixed,
            hidden = hidden,
            isCloseButton = false,
            closeTarget = nil,
            parent = nil,
            onhide = nil,
            onclick = nil,
            children = {},
            temporary = {}
        }, Panel)

        Panel.panels[id] = self

        return self

    end

    function Panel.handleActions(id, name, event)
        local panelId = id - 10000
        local panel = Panel.panels[panelId]
        if not panel then return end
        if panel.isCloseButton then
            if not panel.closeTarget then return end
            panel.closeTarget:hide(name)
            if panel.onhide then panel.onhide(panelId, name, event) end
        else
            if panel.onclick then panel.onclick(panelId, name, event) end
        end
    end

    function Panel:show(target)
        ui.addTextArea(10000 + self.id, self.text, target, self.x, self.y, self.w, self.h, self.background, self.border, self.opacity, self.opacity)
        self.visible = true

        for name in next, (target and { [target] = true } or tfm.get.room.playerList) do
            for id, child in next, self.children do
                child:show(name)
            end
        end

        return self

    end

    function Panel:update(text, target)
        ui.updateTextArea(10000 + self.id, text, target)
        return self
    end

    function Panel:hide(target)
        
        ui.removeTextArea(10000 + self.id, target)

        for name in next, (target and { [target] = true } or tfm.get.room.playerList) do
            
            for id, child in next, self.children do
				child:hide(name)
            end

            if self.temporary[name] then
                for id, child in next, self.temporary[name] do
                    child:hide(name)
                end
                self.temporary[name] = {}
            end
            
        end

        
        if self.onclose then self.onclose(target) end
        return self

    end

    function Panel:addPanel(panel)
        self.children[panel.id] = panel
        panel.parent = self.id
        return self
    end

    function Panel:addImage(image)
        self.children["i_" .. image.id] = image
        return self
    end

    function Panel:addPanelTemp(panel, target)
        if not self.temporary[target] then self.temporary[target] = {} end
        panel:show(target)
        self.temporary[target][panel.id] = panel
    end

    function Panel:addImageTemp(image, target)
        if not self.temporary[target] then self.temporary[target] = {} end
        image:show(target)
        self.temporary[target]["i_" .. image.id] = image
    end

    function Panel:setActionListener(fn)
        self.onclick = fn
        return self
    end

    function Panel:setCloseButton(id, callback)
        local button = Panel.panels[id]
        if not button then return self end
        self.closeTarget = button
        self.onclose = callback
        button.isCloseButton = true
        button.closeTarget = self
        return self
    end

end

-- [[Timers4TFM]] --
local a={}a.__index=a;a._timers={}setmetatable(a,{__call=function(b,...)return b.new(...)end})function a.process()local c=os.time()local d={}for e,f in next,a._timers do if f.isAlive and f.mature<=c then f:call()if f.loop then f:reset()else f:kill()d[#d+1]=e end end end;for e,f in next,d do a._timers[f]=nil end end;function a.new(g,h,i,j,...)local self=setmetatable({},a)self.id=g;self.callback=h;self.timeout=i;self.isAlive=true;self.mature=os.time()+i;self.loop=j;self.args={...}a._timers[g]=self;return self end;function a:setCallback(k)self.callback=k end;function a:addTime(c)self.mature=self.mature+c end;function a:setLoop(j)self.loop=j end;function a:setArgs(...)self.args={...}end;function a:call()self.callback(table.unpack(self.args))end;function a:kill()self.isAlive=false end;function a:reset()self.mature=os.time()+self.timeout end;Timer=a

--[[DataHandler v22]]
local a={}a.VERSION='1.5'a.__index=a;function a.new(b,c,d)local self=setmetatable({},a)assert(b,'Invalid module ID (nil)')assert(b~='','Invalid module ID (empty text)')assert(c,'Invalid skeleton (nil)')for e,f in next,c do f.type=f.type or type(f.default)end;self.players={}self.moduleID=b;self.moduleSkeleton=c;self.moduleIndexes={}self.otherOptions=d;self.otherData={}self.originalStuff={}for e,f in pairs(c)do self.moduleIndexes[f.index]=e end;if self.otherOptions then self.otherModuleIndexes={}for e,f in pairs(self.otherOptions)do self.otherModuleIndexes[e]={}for g,h in pairs(f)do h.type=h.type or type(h.default)self.otherModuleIndexes[e][h.index]=g end end end;return self end;function a.newPlayer(self,i,j)assert(i,'Invalid player name (nil)')assert(i~='','Invalid player name (empty text)')self.players[i]={}self.otherData[i]={}j=j or''local function k(l)local m={}for n in string.gsub(l,'%b{}',function(o)return o:gsub(',','\0')end):gmatch('[^,]+')do n=n:gsub('%z',',')if string.match(n,'^{.-}

if modes[module.mode] then
    modes[module.mode].main()
else
    modes.castle.main()
end
)then table.insert(m,k(string.match(n,'^{(.-)}

if modes[module.mode] then
    modes[module.mode].main()
else
    modes.castle.main()
end
)))else table.insert(m,tonumber(n)or n)end end;return m end;local function p(c,q)for e,f in pairs(c)do if f.index==q then return e end end;return 0 end;local function r(c)local s=0;for e,f in pairs(c)do if f.index>s then s=f.index end end;return s end;local function t(b,c,u,v)local w=1;local x=r(c)b="__"..b;if v then self.players[i][b]={}end;local function y(n,z,A,B)local C;if z=="number"then C=tonumber(n)or B elseif z=="string"then C=string.match(n and n:gsub('\\"','"')or'',"^\"(.-)\"$")or B elseif z=="table"then C=string.match(n or'',"^{(.-)}$")C=C and k(C)or B elseif z=="boolean"then if n then C=n=='1'else C=B end end;if v then self.players[i][b][A]=C else self.players[i][A]=C end end;if#u>0 then for n in string.gsub(u,'%b{}',function(o)return o:gsub(',','\0')end):gmatch('[^,]+')do n=n:gsub('%z',','):gsub('\9',',')local A=p(c,w)local z=c[A].type;local B=c[A].default;y(n,z,A,B)w=w+1 end end;if w<=x then for D=w,x do local A=p(c,D)local z=c[A].type;local B=c[A].default;y(nil,z,A,B)end end end;local E,F=self:getModuleData(j)self.originalStuff[i]=F;if not E[self.moduleID]then E[self.moduleID]='{}'end;t(self.moduleID,self.moduleSkeleton,E[self.moduleID]:sub(2,-2),false)if self.otherOptions then for b,c in pairs(self.otherOptions)do if not E[b]then local G={}for e,f in pairs(c)do local z=f.type or type(f.default)if z=='string'then G[f.index]='"'..tostring(f.default:gsub('"','\\"'))..'"'elseif z=='table'then G[f.index]='{}'elseif z=='number'then G[f.index]=f.default elseif z=='boolean'then G[f.index]=f.default and'1'or'0'end end;E[b]='{'..table.concat(G,',')..'}'end end end;for b,u in pairs(E)do if b~=self.moduleID then if self.otherOptions and self.otherOptions[b]then t(b,self.otherOptions[b],u:sub(2,-2),true)else self.otherData[i][b]=u end end end end;function a.dumpPlayer(self,i)local m={}local function H(I)local m={}for e,f in pairs(I)do local J=type(f)if J=='table'then m[#m+1]='{'m[#m+1]=H(f)if m[#m]:sub(-1)==','then m[#m]=m[#m]:sub(1,-2)end;m[#m+1]='}'m[#m+1]=','else if J=='string'then m[#m+1]='"'m[#m+1]=f:gsub('"','\\"')m[#m+1]='"'elseif J=='boolean'then m[#m+1]=f and'1'or'0'else m[#m+1]=f end;m[#m+1]=','end end;if m[#m]==','then m[#m]=''end;return table.concat(m)end;local function K(i,b)local m={b,'=','{'}local L=self.players[i]local M=self.moduleIndexes;local N=self.moduleSkeleton;if self.moduleID~=b then M=self.otherModuleIndexes[b]N=self.otherOptions[b]b='__'..b;L=self.players[i][b]end;if not L then return''end;for D=1,#M do local A=M[D]local z=N[A].type;if z=='string'then m[#m+1]='"'m[#m+1]=L[A]:gsub('"','\\"')m[#m+1]='"'elseif z=='number'then m[#m+1]=L[A]elseif z=='boolean'then m[#m+1]=L[A]and'1'or'0'elseif z=='table'then m[#m+1]='{'m[#m+1]=H(L[A])m[#m+1]='}'end;m[#m+1]=','end;if m[#m]==','then m[#m]='}'else m[#m+1]='}'end;return table.concat(m)end;m[#m+1]=K(i,self.moduleID)if self.otherOptions then for e,f in pairs(self.otherOptions)do local u=K(i,e)if u~=''then m[#m+1]=','m[#m+1]=u end end end;for e,f in pairs(self.otherData[i])do m[#m+1]=','m[#m+1]=e;m[#m+1]='='m[#m+1]=f end;return table.concat(m)..self.originalStuff[i]end;function a.get(self,i,A,O)if not O then return self.players[i][A]else assert(self.players[i]['__'..O],'Module data not available ('..O..')')return self.players[i]['__'..O][A]end end;function a.set(self,i,A,C,O)if O then self.players[i]['__'..O][A]=C else self.players[i][A]=C end;return self end;function a.save(self,i)system.savePlayerData(i,self:dumpPlayer(i))end;function a.removeModuleData(self,i,O)assert(O,"Invalid module name (nil)")assert(O~='',"Invalid module name (empty text)")assert(O~=self.moduleID,"Invalid module name (current module data structure)")if self.otherData[i][O]then self.otherData[i][O]=nil;return true else if self.otherOptions and self.otherOptions[O]then self.players[i]['__'..O]=nil;return true end end;return false end;function a.getModuleData(self,l)local m={}for b,u in string.gmatch(l,'([0-9A-Za-z_]+)=(%b{})')do local P=self:getTextBetweenQuotes(u:sub(2,-2))for D=1,#P do P[D]=P[D]:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0")u=u:gsub(P[D],P[D]:gsub(',','\9'))end;m[b]=u end;for e,f in pairs(m)do l=l:gsub(e..'='..f:gsub('\9',','):gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0")..',?','')end;return m,l end;function a.convertFromOld(self,Q,R)assert(Q,'Old data is nil')assert(R,'Old skeleton is nil')local function S(l,T)local m={}for U in string.gmatch(l,'[^'..T..']+')do m[#m+1]=U end;return m end;local E=S(Q,'?')local m={}for D=1,#E do local O=E[D]:match('([0-9a-zA-Z]+)=')local u=S(E[D]:gsub(O..'=',''):gsub(',,',',\8,'),',')local G={}for V=1,#u do if R[O][V]then if R[O][V]=='table'then G[#G+1]='{'if u[V]~='\8'then local I=S(u[V],'#')for W=1,#I do G[#G+1]=I[W]G[#G+1]=','end;if G[#G]==','then table.remove(G)end end;G[#G+1]='},'elseif R[O][V]=='string'then G[#G+1]='"'if u[V]~='\8'then G[#G+1]=u[V]end;G[#G+1]='"'G[#G+1]=','else if u[V]~='\8'then G[#G+1]=u[V]else G[#G+1]=0 end;G[#G+1]=','end end end;if G[#G]==','then table.remove(G)end;m[#m+1]=O;m[#m+1]='='m[#m+1]='{'m[#m+1]=table.concat(G)m[#m+1]='}'m[#m+1]=','end;if m[#m]==','then table.remove(m)end;return table.concat(m)end;function a.convertFromDataManager(self,Q,R)assert(Q,'Old data is nil')assert(R,'Old skeleton is nil')local function S(l,T)local m={}for U in string.gmatch(l,'[^'..T..']+')do m[#m+1]=U end;return m end;local E=S(Q,'§')local m={}for D=1,#E do local O=E[D]:match('%[(.-)%]')local u=S(E[D]:gsub('%['..O..'%]%((.-)%)','%1'),'#')local G={}for V=1,#u do if R[V]=='table'then local I=S(u[V],'&')G[#G+1]='{'for W=1,#I do if tonumber(I[W])then G[#G+1]=I[W]G[#G+1]=','else G[#G+1]='"'G[#G+1]=I[W]G[#G+1]='"'G[#G+1]=','end end;if G[#G]==','then table.remove(G)end;G[#G+1]='}'G[#G+1]=','else if R[V]=='string'then G[#G+1]='"'G[#G+1]=u[V]G[#G+1]='"'else G[#G+1]=u[V]end;G[#G+1]=','end end;if G[#G]==','then table.remove(G)end;m[#m+1]=O;m[#m+1]='='m[#m+1]='{'m[#m+1]=table.concat(G)m[#m+1]='}'end;return table.concat(m)end;function a.getTextBetweenQuotes(self,l)local m={}local X=1;local Y=0;local Z=false;for D=1,#l do local _=l:sub(D,D)if _=='"'then if l:sub(D-1,D-1)~='\\'then if Y==0 then X=D;Y=Y+1 else Y=Y-1;if Y==0 then m[#m+1]=l:sub(X,D)end end end end end;return m end;DataHandler=a


--==[[ init ]]==--

tfm.exec.disableAutoNewGame()
tfm.exec.disableAutoScore()
tfm.exec.disableAutoShaman()
tfm.exec.disableAutoTimeLeft()

local maps = {521833, 401421, 541917, 541928, 541936, 541943, 527935, 559634, 559644, 888052, 878047, 885641, 770600, 770656, 772172, 891472, 589736, 589800, 589708, 900012, 901062, 754380, 901337, 901411, 892660, 907870, 910078, 1190467, 1252043, 1124380, 1016258, 1252299, 1255902, 1256808, 986790, 1285380, 1271249, 1255944, 1255983, 1085344, 1273114, 1276664, 1279258, 1286824, 1280135, 1280342, 1284861, 1287556, 1057753, 1196679, 1288489, 1292983, 1298164, 1298521, 1293189, 1296949, 1308378, 1311136, 1314419, 1314982, 1318248, 1312411, 1312589, 1312845, 1312933, 1313969, 1338762, 1339474, 1349878, 1297154, 644588, 1351237, 1354040, 1354375, 1362386, 1283234, 1370578, 1306592, 1360889, 1362753, 1408124, 1407949, 1407849, 1343986, 1408028, 1441370, 1443416, 1389255, 1427349, 1450527, 1424739, 869836, 1459902, 1392993, 1426457, 1542824, 1533474, 1561467, 1563534, 1566991, 1587241, 1416119, 1596270, 1601580, 1525751, 1582146, 1558167, 1420943, 1466487, 1642575, 1648013, 1646094, 1393097, 1643446, 1545219, 1583484, 1613092, 1627981, 1633374, 1633277, 1633251, 1585138, 1624034, 1616785, 1625916, 1667582, 1666996, 1675013, 1675316, 1531316, 1665413, 1681719, 1699880, 1688696, 623770, 1727243, 1531329, 1683915, 1689533, 1738601, 3756146}

local items = {
    1,  -- small box
    2,  -- large box
    3,  -- small plank
    4,  -- large plank
    6,  -- ball
    10, -- anvil
    23, -- bomb
    24, -- spirit
    28, -- blueBaloon
    32, -- rune
    34, -- snow ball
    35, -- cupid arrow
    39, -- apple
    40, -- sheep
    45, -- small ice plank
    46, -- small choco plank
    54, -- ice cube
    57, -- cloud
    59, -- bubble
    60, -- tiny plank
    62, -- stable rune
    65, -- puffer fish
    90  -- tombstone
}

local assets = {
    banner = "173f1aa1720.png",
    count1 = "173f211056a.png",
    count2 = "173f210937b.png",
    count3 = "173f210089f.png",
    newRound = "173f2113b5e.png",
    heart = "173f2212052.png",
    items = {
        [1] = "17406985997.png", -- small box
        [2] = "174068e3bca.png", -- large box
        [3] = "174069a972e.png", -- small plank
        [4] = "174069c5a7a.png", -- large plank
        [6] = "174069d7a29.png", -- ball
        [10] = "174069e766a.png", -- anvil
        [17] = "17406bf2f70.png", -- cannon
        [23] = "17406bf6ffc.png", -- bomb
        [24] = "17406a23cd0.png", -- spirit
        [28] = "17406a41815.png", -- blue balloon
        [32] = "17406a58032.png", -- rune
        [34] = "17406a795f4.png", -- snowball
        [35] = "17406a914a3.png", -- cupid arrow
        [39] = "17406aa2daf.png", -- apple
        [40] = "17406ac8ab7.png", -- sheep
        [45] = "17406aefb88.png", -- small ice plank
        [46] = "17406b00239.png", -- small choco plank
        [54] = "17406b15725.png", -- ice cube
        [57] = "17406b22bd6.png", -- cloud
        [59] = "17406b32d1f.png", -- bubble
        [60] = "17406b59bd6.png", -- tiny plank
        [62] = "17406b772b7.png", -- stable rune
        [65] = "17406b8c9f2.png", -- puffer fish
        [90] = "17406b9eda9.png" -- tombstone
    },
    widgets = {
        borders = {
            topLeft = "155cbe99c72.png",
            topRight = "155cbea943a.png",
            bottomLeft = "155cbe97a3f.png",
            bottomRight = "155cbe9bc9b.png"
        },
        closeButton = "171e178660d.png"
    },
    community = {
        xx = "1651b327097.png",
        ar = "1651b32290a.png",
        bg = "1651b300203.png",
        br = "1651b3019c0.png",
        cn = "1651b3031bf.png",
        cz = "1651b304972.png",
        de = "1651b306152.png",
        ee = "1651b307973.png",
        en = "1723dc10ec2.png",
        e2 = "1723dc10ec2.png",
        es = "1651b309222.png",
        fi = "1651b30aa94.png",
        fr = "1651b30c284.png",
        gb = "1651b30da90.png",
        hr = "1651b30f25d.png",
        hu = "1651b310a3b.png",
        id = "1651b3121ec.png",
        il = "1651b3139ed.png",
        it = "1651b3151ac.png",
        jp = "1651b31696a.png",
        lt = "1651b31811c.png",
        lv = "1651b319906.png",
        nl = "1651b31b0dc.png",
        ph = "1651b31c891.png",
        pl = "1651b31e0cf.png",
        ro = "1651b31f950.png",
        ru = "1651b321113.png",
        tr = "1651b3240e8.png",
        vk = "1651b3258b3.png"
    },    
    dummy = "17404561700.png"
}

local closeSequence = {
    [1] = {}
}

local dHandler = DataHandler.new("pew", {
    rounds = {
        index = 1,
        type = "number",
        default = 0
    },
    survived = {
        index = 2,
        type = "number",
        default = 0
    },
    won = {
        index = 3,
        type = "number",
        default = 0
    }
})

local profileWindow, leaderboardWindow

local initialized, newRoundStarted, suddenDeath = false
local currentItem = 17 -- cannon

local leaderboard


--==[[ translations ]]==--

local translations = {}

translations["en"] = {	
	LIVES_LEFT =	"<ROSE>You have <N>${lives} <ROSE>lives left. <VI>Respawning in 3...",	
	LOST_ALL =	"<ROSE>You have lost all your lives!",	
	SD =		"<VP>Sudden death! Everyone has <N>1 <VP>life left",	
	WELCOME =	"<VP>Welcome to pewpew, <N>duck <VP>or <N>spacebar <VP>to shoot items!",	
	SOLE =		"<ROSE>${player} is the sole survivor!"
}

translations["br"] = {        
	LIVES_LEFT =    "<ROSE>Você possuí<N>${lives} <ROSE>vidas restantes. <VI>Renascendo em 3...",        
	LOST_ALL =      "<ROSE>Você perdeu todas as suas vidas!",        
	SD =            "<VP>Morte Súbita! Todos agora possuem <N>1 <VP>vida restante",        
	WELCOME =       "<VP>Bem vindo ao pewpew, <N>use a seta para baixo <VP>ou <N> a barra de espaço <VP>para atirar itens!",        
	SOLE =          "<ROSE>${player} é o último sobrevivente!"
}

translations["es"] = {        
	LIVES_LEFT =    "<ROSE>Te quedan <N>${lives} <ROSE>vidas restantes. <VI>Renaciendo en 3...",        
	LOST_ALL =      "<ROSE>¡Has perdido todas tus vidas!",        
	SD =            "<VP>¡Muerte súbita! A todos le quedan <N>1 <VP>vida restante",        
	WELCOME =       "<VP>¡Bienvenido a pewpew, <N>agáchate <VP>o presiona <N>la barra de espacio <VP>para disparar ítems!",        
	SOLE =          "<ROSE>¡${player} es el único superviviente!"
}

translations["fr"] = {        
	LIVES_LEFT =    "<ROSE>Il te reste <N>${lives} <ROSE>vies. <VI>Réapparition dans 3...",        
	LOST_ALL =      "<ROSE>Tu as perdu toutes tes vies !",        
	SD =            "<VP>Mort subite ! Il ne reste plus qu'<N>1 <VP>vie à tout le monde",        
	WELCOME =       "<VP>Bienvenue sur pewpew, <N>baisse toi <VP>ou utilise <N>la barre d'espace <VP>pour tirer des objets !",        
	SOLE =          "<ROSE>${player} est le seul survivant !"
}

translations["tr"] = {        
	LIVES_LEFT =    "<N>${lives} <ROSE> can?n?z kald?. <VI>3 saniye içinde yeniden do?acaks?n?z...",        
	LOST_ALL =      "<ROSE>Bütün can?n?z? kaybettiniz!",        
	SD =            "<VP>Ani ölüm! Art?k herkesin <N>1<VP> can? kald?",        
	WELCOME =       "<VP>pewpew odas?na ho?geldiniz, e?yalar f?rlatmak için <N>e?ilin <VP>ya da <N>spacebar <VP>'a bas?n!",        
	SOLE =          "<ROSE>Ya?ayan ki?i ${player}!"
}

local translate = function(term, lang, page, kwargs)
    local translation
    if translations[lang] then 
        translation = translations[lang][term] or translations.en[term] 
    else
        translation = translations.en[term]
    end
    translation = page and translation[page] or translation
    if not translation then return end
    return string.format(translation, kwargs)
end


--==[[ classes ]]==--

local Player = {}

Player.players = {}
Player.alive = {}
Player.playerCount = 0
Player.aliveCount = 0

Player.__index = Player
Player.__tostring = function(self)
    return table.tostring(self)
end

setmetatable(Player, {
    __call = function (cls, name)
        return cls.new(name)
    end,
})

function Player.new(name)
	local self = setmetatable({}, Player)
	
    self.name = name
	self.alive = false
	self.lives = 0
	self.inCooldown = true
	self.community = tfm.get.room.playerList[name].community
	self.hearts = {}

	self.rounds = 0
	self.survived = 0
	self.won = 0
	self.score = 0

	system.bindKeyboard(name, 32, true, true) -- space
	system.bindKeyboard(name, 0, true, true) -- left / a
	system.bindKeyboard(name, 2, true, true) -- right / d
	system.bindKeyboard(name, 3, true, true) -- down / s

	Player.players[name] = self
	Player.playerCount = Player.playerCount + 1

    return self
end

function Player:refresh()
	self.alive = true
	self.inCooldown = false
	self:setLives(3)
	Player.alive[self.name] = self
	Player.aliveCount = Player.aliveCount + 1
end

function Player:setLives(lives)
	self.lives = lives
	tfm.exec.setPlayerScore(self.name, lives)
	for _, id in next, self.hearts do tfm.exec.removeImage(id) end
	self.hearts = {}
	local heartCount = 0
	while heartCount < lives do
		heartCount = heartCount + 1
		self.hearts[heartCount] = tfm.exec.addImage(assets.heart, "$" .. self.name, -45 + heartCount * 15, -45)
	end
end

function Player:shoot(x, y)
	if newRoundStarted and self.alive and not self.inCooldown then
		
		self.inCooldown = true

		local stance = self.stance
		local pos = getPos(currentItem, stance)
		local rot = getRot(currentItem, stance)
		local xSpeed = currentItem == 34 and 60 or 40

		Timer("shootCooldown_" .. self.name, function(object)
			tfm.exec.removeObject(object)
			self.inCooldown = false
		end, 1500, false, tfm.exec.addShamanObject(
			currentItem,
			x + pos.x,
			y + pos.y,
			rot,
			stance == -1 and -xSpeed or xSpeed,
			0,
			currentItem == 32 or currentItem == 62
		))

	end	
end

function Player:savePlayerData()
	-- TODO: Uncomment the line below
	-- if tfm.get.room.uniquePlayers < 3 then return end
	local name = self.name
    dHandler:set(name, "rounds", self.rounds)
    dHandler:set(name, "survived", self.survived)
	dHandler:set(name, "won", self.won)
    system.savePlayerData(name, "v2" .. dHandler:dumpPlayer(name))
end


--==[[ events ]]==--

function eventNewPlayer(name)
    local player = Player.new(name)
    tfm.exec.chatMessage(translate("WELCOME", player.community), name)   
    Timer("banner_" .. name, function(image)
        tfm.exec.removeImage(image)
    end, 5000, false, tfm.exec.addImage(assets.banner, ":1", 120, -85, name))
    system.loadPlayerData(name)
end

function eventLoop(tc, tr)
	
	Timer.process()

	if tr < 0 and initialized then
		if not suddenDeath then			
			suddenDeath = true		
			tfm.exec.chatMessage(translate("SD", tfm.get.room.community))
			for name, player in next, Player.alive do
				player:setLives(1)
			end
			tfm.exec.setGameTime(30, true)
		else
			local aliveCount = Player.aliveCount
			if aliveCount > 1 then
				local winnerString = ""
				for name, player in next, Player.alive do
					player.rounds = player.rounds + 1
					player.survived = player.survived + 1
					player:savePlayerData()
					if aliveCount == 1 then
						winnerString = winnerString:sub(1, -3) .. " and " .. name
						break
					end
					winnerString = winnerString .. name .. ", "
					aliveCount = aliveCount - 1			
				end
				tfm.exec.chatMessage("we have some loads of winners this time: " .. winnerString)
			end
			tfm.exec.chatMessage("starting a new round")
			Timer("newRound", newRound, 3 * 1000)
			tfm.exec.setGameTime(4, true)
		end
	end

end
function eventKeyboard(name, key, down, x, y)
	if key == 32 or key == 3 then -- space / duck
		Player.players[name]:shoot(x, y)
	elseif key == 0 then-- left
		Player.players[name].stance = -1
	elseif key == 2 then-- right
		Player.players[name].stance = 1
	end	
end

function eventNewGame()
	if initialized then
		Timer("pre", function()
			Timer("count3", function(count3)
				tfm.exec.removeImage(count3)
				Timer("count2", function(count2)
					tfm.exec.removeImage(count2)
					Timer("count1", function(count1)
						tfm.exec.removeImage(count1)
						newRoundStarted = true
						Timer("roundStart", function(imageGo)
							tfm.exec.removeImage(imageGo)
						end, 1000, false, tfm.exec.addImage(assets.newRound, ":1", 145, -120))
					end, 1000, false, tfm.exec.addImage(assets.count1, ":1", 145, -120))
				end, 1000, false, tfm.exec.addImage(assets.count2, ":1", 145, -120))
			end, 1000, false, tfm.exec.addImage(assets.count3, ":1", 145, -120))
		end, Player.playerCount == 1 and 0 or 4000)
	end
end
function eventPlayerDied(name)
	local player = Player.players[name]
	if not player then return end
	if not newRoundStarted then
		tfm.exec.respawnPlayer(name)
		return player:refresh()
	end
	player.lives = player.lives - 1
	tfm.exec.setPlayerScore(name, player.lives)
	player.alive = false

	if player.lives == 0 then
		
		Player.alive[name] = nil
		tfm.exec.chatMessage(translate("LOST_ALL", player.community), name)
		player.rounds = player.rounds + 1
		Player.aliveCount = Player.aliveCount - 1
		player:savePlayerData()
		
		if Player.aliveCount == 1 then
			local winner = next(Player.alive)
			local winnerPlayer = Player.players[winner]
			tfm.exec.chatMessage(translate("SOLE", tfm.get.room.community, nil, {player = winner}))
			tfm.exec.giveCheese(winner)
			tfm.exec.playerVictory(winner)
			winnerPlayer.rounds = winnerPlayer.rounds + 1
			winnerPlayer.survived = winnerPlayer.survived + 1
			winnerPlayer.won = winnerPlayer.won + 1
			winnerPlayer:savePlayerData()	
			Timer("newRound", newRound, 3 * 1000)
		elseif Player.aliveCount == 0  then
			Timer("newRound", newRound, 3 * 1000)
		end
		
	else

		tfm.exec.chatMessage(translate("LIVES_LEFT", player.community, nil, {lives = player.lives}), name)
		Timer("respawn_" .. name, function()
			tfm.exec.respawnPlayer(name)
			player:setLives(player.lives)
			player.alive = true
		end, 3000, false)

	end
end

function eventPlayerLeft(name)
	if Player.players[name] then
		Player.players[name].lives = 1
		eventPlayerDied(name)
		Player.players[name] = nil
		Player.playerCount = Player.playerCount - 1
	end
end
function eventPlayerDataLoaded(name, data)
	-- reset player data if they are stored according to the old version
	if data:find("^v2") then
        dHandler:newPlayer(name, data:sub(3))
    else
        system.savePlayerData(name, "")
        dHandler:newPlayer(name, "")
    end

	Player.players[name].rounds = dHandler:get(name, "rounds")
	Player.players[name].survived = dHandler:get(name, "survived")
	Player.players[name].won = dHandler:get(name, "won")

end
function eventFileLoaded(id, data)
	-- print(table.tostring(leaderboard.leaders))
	if id == leaderboard.FILE_ID or id == tostring(leaderboard.FILE_ID) then
		print("[STATS] Leaderboard data loaded!")
		if not (leaderboard.leaderboardData == data) then
			leaderboard.leaderboardData = data
			leaderboard.leaders = leaderboard.parseLeaderboard(data)
		end
		print("[STATS] Leaderboard prepared!")
		for name, player in next, Player.players do leaderboard.addPlayer(player) end
		leaderboard.save(leaderboard.leaders)
	end
end

function eventFileSaved(id)
	if id == leaderboard.FILE_ID or id == tostring(leaderboard.FILE_ID) then
		print("[STATS] Leaderboard saved!")
		leaderboard.needUpdate = false
	end
end

function eventChatCommand(name, cmd)
	local args = string.split(cmd, " ")
	if cmds[args[1]] then
		local cmdArgs = {}
		for i = 2, #args do cmdArgs[#cmdArgs + 1] = args[i] end
		cmds[args[1]](cmdArgs, cmd, name)
	end
end

function eventTextAreaCallback(id, name, event)
	Panel.handleActions(id, name, event)
end


--==[[ main ]]==--

leaderboard = {}

leaderboard.FILE_ID = 1
leaderboard.DUMMY_DATA = [[*souris1,0,0,0,xx|*souris2,0,0,0,xx|*souris3,0,0,0,xx|*souris4,0,0,0,xx|*souris5,0,0,0,xx|*souris6,0,0,0,xx|*souris7,0,0,0,xx|*souris8,0,0,0,xx|*souris9,0,0,0,xx|*souris10,0,0,0,xx|*souris11,0,0,0,xx|*souris12,0,0,0,xx|*souris13,0,0,0,xx|*souris14,0,0,0,xx|*souris15,0,0,0,xx|*souris16,0,0,0,xx|*souris17,0,0,0,xx|*souris18,0,0,0,xx|*souris19,0,0,0,xx|*souris20,0,0,0,xx|*souris21,0,0,0,xx|*souris22,0,0,0,xx|*souris23,0,0,0,xx|*souris24,0,0,0,xx|*souris25,0,0,0,xx|*souris26,0,0,0,xx|*souris27,0,0,0,xx|*souris28,0,0,0,xx|*souris29,0,0,0,xx|*souris30,0,0,0,xx|*souris31,0,0,0,xx|*souris32,0,0,0,xx|*souris33,0,0,0,xx|*souris34,0,0,0,xx|*souris35,0,0,0,xx|*souris36,0,0,0,xx|*souris37,0,0,0,xx|*souris38,0,0,0,xx|*souris39,0,0,0,xx|*souris40,0,0,0,xx|*souris41,0,0,0,xx|*souris42,0,0,0,xx|*souris43,0,0,0,xx|*souris44,0,0,0,xx|*souris45,0,0,0,xx|*souris46,0,0,0,xx|*souris47,0,0,0,xx|*souris48,0,0,0,xx|*souris49,0,0,0,xx|*souris50,0,0,0,xx]]

leaderboard.needUpdate = false
leaderboard.indexed = {}
leaderboard.leaderboardData = leaderboard.leaderboardData or leaderboard.DUMMY_DATA

leaderboard.parseLeaderboard = function(data)
	local res = {}
  	for i, entry in next, string.split(data, "|") do
		local fields = string.split(entry, ",")
		local name = fields[1]
		res[name] = { name = name, rounds = tonumber(fields[2]), survived = tonumber(fields[3]), won = tonumber(fields[4]), community = fields[5] }
		res[name].score = leaderboard.scorePlayer(res[name])
  	end
  	return res
end

leaderboard.dumpLeaderboard = function(lboard)
	local res = ""
	for i, entry in next, lboard do
  		res = res .. entry.name .. "," .. entry.rounds .. "," .. entry.survived .. "," .. entry.won .. "," .. entry.community .. "|"
	end 
	return res:sub(1, -2)
end

leaderboard.load = function()
	local started = system.loadFile(leaderboard.FILE_ID)
	if started then print("[STATS] Loading leaderboard...") end
end

leaderboard.save = function(leaders)
	local serialised, indexes = leaderboard.prepare(leaders)
	if serialised == leaderboard.leaderboardData then return end
	leaderboard.indexed = indexes
	local started = system.saveFile(serialised, leaderboard.FILE_ID)
	if started then print("[STATS] Saving leaderboard...") end
end

leaderboard.scorePlayer = function(player)
    return player.rounds * 0.5 * ((player.won + player.survived) / (player.rounds == 0 and 1 or player.rounds))
end

leaderboard.addPlayer = function(player)
	local score = leaderboard.scorePlayer(player)
	leaderboard.leaders[player.name] = { name = player.name, rounds = player.rounds, survived = player.survived, won = player.won, community = player.community, score = score }
end

leaderboard.prepare = function(leaders)
	
	local res, i = {}, 0

	for name, leader in next, leaders do
		i = i + 1
		res[i] = leader
		if i >= 50 then break end
	end

	table.sort(res, function(p1, p2)
		return p1.score > p2.score
	end)

	return leaderboard.dumpLeaderboard(res), res

end

leaderboard.displayLeaderboard = function(mode, page, target)
	leaderboardWindow:show(target)
	local leaders = {}
	local rankTxt, nameTxt, roundsTxt, deathsTxt, survivedTxt, wonTxt 
		= "<br>", "<br>", "<br>", "<br>", "<br>", "<br>"

	if mode == "global" then
		for leader = (page - 1) * 10, page * 10 do leaders[#leaders + 1] = leaderboard.indexed[leader] end
		Panel.panels[356]:update("<font size='20'><BV><p align='center'><a href='event:1'>•</a>  <a href='event:2'>•</a>  <a href='event:3'>•</a>  <a href='event:4'>•</a>  <a href='event:5'>•</a></p>")
		Panel.panels[357]:update("<a href='event:switch'>Global \t ▼</a>", target)
	else
		local selfRank
		
		for name, player in next, Player.players do
			leaders[#leaders + 1] = player
		end
		
		table.sort(leaders, function(p1, p2)
			return leaderboard.scorePlayer(p1) > leaderboard.scorePlayer(p2)
		end)
		
		for i, leader in ipairs(leaders) do if leader.name == target then selfRank = i break end end
		-- TODO: Add translations v
		Panel.panels[356]:update("<p align='center'>Your rank: " .. selfRank .. "</p>")
		Panel.panels[357]:update("<a href='event:switch'>Room \t ▼</a>", target)
	end
	
	
	local counter = 0
	for i, leader in next, leaders do
		local name, tag = extractName(leader.name)
		if name and tag then -- non-guest players
			counter = counter + 1
			rankTxt = rankTxt .. "# " .. counter .. "<br>"
			nameTxt = nameTxt .. "\t<b><V>" .. name .. "</V><N><font size='8'>" .. tag .. "</font></N></b><br>"
			roundsTxt = roundsTxt .. leader.rounds .. "<br>"
			deathsTxt = deathsTxt .. (leader.rounds - leader.survived) .. "<br>"
			survivedTxt = survivedTxt .. leader.survived .. " <V><i>(" .. math.floor(leader.survived / leader.rounds * 100) .. " %)</i></V><br>"
			wonTxt = wonTxt .. leader.won .. " <V><i>(" .. math.floor(leader.won / leader.rounds * 100) .. " %)</i></V><br>"
			Panel.panels[351]:addImageTemp(Image(assets.community[leader.community], "&1", 170, 105 + 12 * counter), target)
			if counter >= 10 then break end
		end
	end

	Panel.panels[350]:update(rankTxt, target)	
	Panel.panels[351]:update(nameTxt, target)
	Panel.panels[352]:update(roundsTxt, target)
	Panel.panels[353]:update(deathsTxt, target)
	Panel.panels[354]:update(survivedTxt, target)
	Panel.panels[355]:update(wonTxt, target)


end

leaderboard.leaders = leaderboard.parseLeaderboard(leaderboard.leaderboardData)

cmds = {
    ["p"] = function(args, msg, author)
        local player = Player.players[args[1] or author] or Player.players[author]
        displayProfile(player, author)
    end,
    ["lboard"] = function(args, msg, author) -- temporary commands
        leaderboard.displayLeaderboard("room", nil, author)
    end,
    ["glboard"] = function(args, msg, author) -- temporary commands
        leaderboard.displayLeaderboard("global", 1, author)
    end
}

local rotation, currentMapIndex = {}

local shuffleMaps = function(maps)
    local res = {}
    for _, map in next, maps do
        res[#res + 1] = map
        res[#res + 1] = map
    end
    table.sort(res, function(e1, e2)
        return math.random() <= 0.5
    end)
    return res
end

newRound = function()
    
    newRoundStarted = false
    suddenDeath = false
    currentMapIndex = next(rotation, currentMapIndex)
    
    tfm.exec.newGame(rotation[currentMapIndex])
    tfm.exec.setGameTime(93, true)
    
    Player.alive = {}
    Player.aliveCount = 0
    
    for name, player in next, Player.players do player:refresh() end
    
    if currentMapIndex >= #rotation then
        rotation = shuffleMaps(maps)
        currentMapIndex = 1
    end

    if not initialized then
        initialized = true
        closeSequence[1].images = { tfm.exec.addImage(assets.items[currentItem],":1", 740, 330) }
        Timer("changeItem", function()
            if math.random(1, 3) == 3 then
                currentItem = 17 -- cannon
            else
                currentItem = items[math.random(1, #items)]
            end
            tfm.exec.removeImage(closeSequence[1].images[1])
            closeSequence[1].images = { tfm.exec.addImage(assets.items[currentItem], ":1", 740, 330) }    
        end, 10000, true)
    end

end

getPos = function(item, stance)
	if item == 17 then		
		return { x = stance == -1 and 10 or -10, y = 18 }	
	elseif item == 24 then		
		return { x = 0, y = 10 }	
	else		
		return { x = stance == -1 and -10 or 10, y = 0 }	
	end
end

getRot = function(item, stance)	
	if item == 32 or item == 35 or item == 62 then
		return stance == -1 and 180 or 0	
	elseif item == 17 then
		return stance == -1 and -90 or 90
	else
		return 0	
	end
end

extractName = function(name)
    return name:match("^(.+)(#%d+)$")
end

createPrettyUI = function(id, x, y, w, h, fixed, closeButton)
    
    local window =  Panel(id * 100 + 10, "", x - 4, y - 4, w + 8, h + 8, 0x7f492d, 0x7f492d, 1, true)
        :addPanel(
            Panel(id * 100 + 20, "", x, y, w, h, 0x152d30, 0x0f1213, 1, true)
        )
        :addImage(Image(assets.widgets.borders.topLeft, "&1",     x - 10,     y - 10))
        :addImage(Image(assets.widgets.borders.topRight, "&1",    x + w - 18, y - 10))
        :addImage(Image(assets.widgets.borders.bottomLeft, "&1",  x - 10,     y + h - 18))
        :addImage(Image(assets.widgets.borders.bottomRight, "&1", x + w - 18, y + h - 18))
        

    if closeButton then
        window
            :addPanel(
                Panel(id * 100 + 30, "<a href='event:close'>\n\n\n\n\n\n</a>", x + w + 18, y - 10, 15, 20, nil, nil, 0, true)
                    :addImage(Image(assets.widgets.closeButton, ":0", x + w + 15, y - 10)
                )
            )
            :setCloseButton(id * 100 + 30)
    end
    
    return window

end

displayProfile = function(player, target)
    local name, tag = extractName(player.name)
    if (not name) or (not tag) then return end -- guest players
    profileWindow:show(target)
    Panel.panels[2 * 100 + 20]:update("<b><font size='20'><V>" .. name .. "</V></font><font size='10'><G>" .. tag, target)
    Panel.panels[151]:update("<b><BV><font size='14'>" .. player.rounds .. "</font></BV>", target)
    Panel.panels[152]:update("<b><BV><font size='14'>" .. player.rounds - player.survived .. "</font></BV>", target)
    Panel.panels[153]:update("<b><BV><font size='14'>" .. player.survived .. "</font></BV>     <font size='10'>(" .. math.floor(player.survived / player.rounds * 100) .."%)</font>", target)
    Panel.panels[154]:update("<b><BV><font size='14'>" .. player.won .. "</font></BV>     <font size='10'>(" .. math.floor(player.won / player.rounds * 100) .."%)</font>", target)
end

do

    rotation = shuffleMaps(maps)
    currentMapIndex = 1

    leaderboard.load()
    Timer("newRound", newRound, 6 * 1000)
    Timer("leaderboard", leaderboard.load, 2 * 60 * 1000, true)

    tfm.exec.newGame(rotation[currentMapIndex])
    tfm.exec.setGameTime(8)

    for name in next, tfm.get.room.playerList do
        eventNewPlayer(name)
    end

    profileWindow = createPrettyUI(1, 200, 100, 400, 200, true, true)
        :addPanel(createPrettyUI(2, 240, 80, 250, 35, true))
        :addPanel(
            Panel(150, "", 220, 140, 360, 100, 0x7f492d, 0x7f492d, 1, true)
                :addImage(Image(assets.dummy, "&1", 230, 140))
                :addPanel(Panel(151, "", 290, 150, 120, 50, nil, nil, 0, true))
                :addImage(Image(assets.dummy, "&1", 400, 140))
                :addPanel(Panel(152, "", 460, 150, 120, 50, nil, nil, 0, true))
                :addImage(Image(assets.dummy, "&1", 230, 200))
                :addPanel(Panel(153, "", 290, 210, 120, 50, nil, nil, 0, true))
                :addImage(Image(assets.dummy, "&1", 400, 200))
                :addPanel(Panel(154, "", 460, 210, 120, 50, nil, nil, 0, true))
        )

    leaderboardWindow = createPrettyUI(3, 70, 50, 670, 330, true, true)
        :addPanel(Panel(350, "", 90, 100, 50, 240, 0x7f492d, 0x7f492d, 1, true))
        :addPanel(Panel(351, "", 160, 100, 200, 240, 0x7f492d, 0x7f492d, 1, true))
        :addPanel(
            Panel(352, "", 380, 100, 70, 240, 0x7f492d, 0x7f492d, 1, true)
                :addImage(Image(assets.dummy, "&1", 380, 70))
        )
        :addPanel(
            Panel(353, "", 470, 100, 70, 240, 0x7f492d, 0x7f492d, 1, true)
                :addImage(Image(assets.dummy, "&1", 470, 70))
        )
        :addPanel(
            Panel(354, "", 560, 100, 70, 240, 0x7f492d, 0x7f492d, 1, true)
                :addImage(Image(assets.dummy, "&1", 560, 70))
        )
        :addPanel(
            Panel(355, "", 650, 100, 70, 240, 0x7f492d, 0x7f492d, 1, true)
                :addImage(Image(assets.dummy, "&1", 650, 70))
        )
        :addPanel(
            Panel(356, "", 70, 350, 670, 50, nil, nil, 0, true)
                :setActionListener(function(id, name, event)
                    local page = tonumber(event)
                    if page then leaderboard.displayLeaderboard("global", page, name) end
                end)
            )
        :addPanel(
            Panel(357, "<a href='event:switch'>Room \t ▼</a>", 90, 55, 80, 20, 0x152d30, 0x7f492d, 1, true)
                :setActionListener(function(id, name, event)
                    Panel.panels[id]:addPanelTemp(
                        Panel(358, "<a href='event:room'>Room</a><br><a href='event:global'>Global</a>", 90, 85, 80, 30, 0x152d30, 0x7f492d, 1, true)
                            :setActionListener(function(id, name, event)
                                leaderboardWindow:hide(name)
                                leaderboard.displayLeaderboard(event, 1, name)
                            end),
                    name)
                end)
        )

end

end




if modes[module.mode] then
    modes[module.mode].main()
else
    modes.castle.main()
end
