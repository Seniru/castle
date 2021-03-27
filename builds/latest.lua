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

    fileData = {}

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

    loadFiles = function()
        print("Loading files...")
        system.loadFile(2)
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
        elseif args[1] == "pw" and module.subRoomAdmins[name] then
            tfm.exec.chatMessage("Password: " .. args[2], name)
            tfm.exec.setRoomPassword(args[2])
        elseif args[1] == "np" and module.subRoomAdmins[name] then
            tfm.exec.newGame(args[2])
        elseif cmd == "leaderboard pewpew" and fileData[2] then
            print("printing lboard")
            local chunk = fileData[2]
            local i = 0
            while i < #chunk do
                tfm.exec.chatMessage("\r\n" .. chunk:sub(i, i + 998), name)
                i = i + 999
            end
			  tfm.exec.chatMessage(string.char(26), name)
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

    eventFileLoaded = function(id, data)
        fileData[tonumber(id)] = data:match("^(.+)\n.+")
    end

    eventPlayerDied = tfm.exec.respawnPlayer

    if module.roomAdmin:find("bot") then
        loadFiles()
        system.newTimer(loadFiles, 1000 * 60 * 15, true)
    end
end

modes.dodge = {
	version = "v1",
	description = "Dodge!!",
	author = "Factral#0000"
}

modes.dodge.main = function()
 -- #Dodge Transformice
    --script hecho por factral#0000 , creditos a Deadjerry y maik005
    
    tfm.exec.disableAutoNewGame(true); tfm.exec.disableAutoShaman(true)
    tfm.exec.disableAfkDeath(true); tfm.exec.disableAutoScore(true)
    tfm.exec.disableAutoTimeLeft(true); 
    tfm.exec.disableMinimalistMode(); tfm.exec.disablePhysicalConsumables()
    tfm.exec.newGame(7818703);   tfm.exec.setGameTime(1)

    for _, v in next, {'help', 'modos', 'settings', 'restart',} do system.disableChatCommandDisplay(v) end

    tfm.exec.chatMessage("<br><p align='left'><font color='#638071'>[DODGE] </font><font color='#7CD499'>Welcome to </font><b><font color='#D2EC16'>#dodge </font></b><font color='#7CD499'>survive the cannons!<br>Plase Type</br> <b><font color='#33AA74'>!help</font></b> to show more information about this. </font><font color='#7CD499'>see the project repository here:</font><b><font color='#33AA74'>https://github.com/Factral/dodge</font></b></p>")
 
    boxes={
      help={
        acercade={
          "<p align='center'><font size='25'><bv>Acerca de</bv></font></p> <p align='left'></font> <br><br>Esto es  <b><font                                             color='#FFFF00'>#DODGE</font></b><br><br>Dodge es un minijuego originalmente creado por <font color='#BBCF7B'>Deadjerry</font> y <font color='#BBCF7B'>Maik005</font> de forma separada, el fin de este script, es hacer un re-diseño implementando nuevas funcionalidades y arreglando algunos bugs <br><br>El objetivo de Dodge es que te puedas divertir en tu cTiempoTranscurrido de tribu,   deberás intentar sobrevivir el mayor tiempo que puedas a los cañones que se te lanzan, ¡para así sobrevivir y ganar todas las rondas! <br><br><br><br><br>                                             &#x3c;3 </p>",
                  },
        modos={
          "<p align='center'><font size='25'><bv>Modos</bv></font></p><br><br><p align='left'><font size='13' color='#CF7B7B'>Modo estándar:</font> Es el modo que se ejecuta de forma predeterminada, se divide en 7 rondas y el que mas haya sobrevivido en el total de rondas es el ganador, esta habilitado el doble salto durante el modo dios  <br><br><font size='13' color='#CF7B7B'>Modo crono:</font>Es un modo para contabilizar el tiempo que sobrevives en un mapa determinado, al morir automáticamente te dará el tiempo es segundos que has sobrevivido. Para ponerlo simplemente pon el comando  <font color='#BBCF7B'>!crono</font>  <br><br><font size='13' color='#CF7B7B'>Modo individual:</font> Este modo solo se ejecuta cuando hay una persona en la sala</p>",
              },
        comandos={
          "<p align='center'><font size='25'><bv>Comandos</bv></font></p><br><p align='left'> <b><font color='#EFF0EE'>!np</font></b> cambia de mapa<br><br><b><font color='#EFF0EE'>!modos</font></b> muestra los modos disponibles<br><br><b><font color='#EFF0EE'>!restart</font></b> reinicia las rondas desde 1 (disponible al finalizar todas las rondas)<br><br><b><font color='#EFF0EE'>!redo</font></b> comando para reiniciar el tiempo (disponible en modo crono)</p><br><p align='center'><font size='25'><bv>Teclas</bv></font></p><br><p align='left'><b><font color='#EFF0EE'>L </font></b>: muestra la clasificacion en el modo estandar<br><br><b><font color='#EFF0EE'>O </font></b>: muestra la configuracion de dodge<br><br><b><font color='#EFF0EE'>M </font></b>: muestra los modos disponibles</p>",
                    },
        creditos={
          "<p align='center'><font size='25'><bv>Creditos</bv></font></p><br><br>El rediseño de Dodge es desarrollado por mi, <font color='#7BCFC5'>Factral#0000</font>, he aprendido mucho sobre <font color='#CFA97B'>lua</font> mientras lo desarrollaba y mi intención nunca ha sido que este proyecto sea similar a algún modulo oficial, simplemente lo hice por diversión y aprender un poco de <font color='#CFA97B'>lua.</font><br><br><br>Gracias especiales a <font color='#7BCFC5'>Jp_darkuss#4806</font>  y <font color='#7BCFC5'>Mundialpross#0000</font> por ayudar con parte del codigo y ideas con el diseño</p>",
                  }
            }
          }
    nombresempate = {}
    players = {}
    IDList = {}
    maps={7813846,7813847,7814210,7815341,7814864,7814091,7816146,7816244}
    cannones={17,1701,1702,1703,1705,1706,1707,1708,1709,1710,1711,1712,1714,1715,1718,1719,1720,1721}
    specialcannons={ 
      deathmatch={ --creditos a los desarrolladores de deathmatch
                  {"Star of death", "1502f9cb9a8"};    {"Balanced", "149af0fdbf7"};  {"Plate spike", "149af0ef041"};   {"Diamon ore", "149af129a4c"};    {"baffbot", "149af1482f5"};    {"girly", "149aeabeff6"};    {"disturbed eye", "149aeaab097"};    {"cow", "149af1414ae"};    {"magma", "149aea9f2cc"};    {"demon", "149aeab32ec"};   {"shymer", "175c88cf5bd"};    {"contest", "149aeac1f50"};    {"sweet", "149aeac07ee"};    {"cookie", "149af11f084"};    {"drop the boss", "149af134d03"};    {"troll", "149af11af76"};    {"venom", "16ebc8b35de"};    {"nocturnal", "17045bccc54"};    {"cardistry", "169550c8e43"};    {"sharingan", "16943972c4a"};    {"lollipop", "1693eb4fc8b"};    {"oblivion", "172576581a4"};   {"energon", "166216a1a33"};   {"metal plates", "1660c17bb0e"};   {"bronze", "149af130a30"};   {"silver", "149af12c2d6"};    {"vermilion", "1705dfa253d"};      {"target", "175db7c6a9a"};    {"water", "1660c65740f"};    {"air", "1660c5db325"};    {"flame", "1660c4bf1a4"};    {"nature", "149af13faa2"};    {"recycle", "149aeaaf47a"};    {"vine", "149af122bb3"};    {"music", "149af146cb6"};
                 },
      ffarace={  -- creditos a los desarrolladores de ffarace
                "1725661e561","17256629950","172566b1f35","17256648ca4","1725660c3a3","1725664047b","1725663bf5c","1725662f803","1725660a1bf","1725660878e","17256614f72","1725660dd88","17256627e1f","1725662627f","17256646dac","1725661c3f7","1725663e5be","1725662b1d7","17256658589"
              }
                   }

    ffaracecannons=false;deathmatchcannons = false;mostrarTitulo=true;primeraEjecucion=true;rondaFinal=false;bool=false;modoIndividual=false;modoCrono=false;muertoJugadorCrono=false;   
    countdown = 0;  count = 0;diagonal=0;mins=0; seconds=0;wait = 0;numeroRonda=1;cambiocannones=0;

    function shootcannonspecial(idcannonn)
      if deathmatchcannons then
        tfm.exec.addImage(""..specialcannons.deathmatch[cannD][2]..".png","#" .. idcannonn,-16,-16,nil) 
      end
      if ffaracecannons then
        tfm.exec.addImage(""..specialcannons.ffarace[cannF]..".png","#" .. idcannonn,-16,-16,nil)
      end   
    end

    function cerrartodo(name)
      ui.removeTextArea(95,name); ui.removeTextArea(99,name);
      for id=12,17 do  ui.removeTextArea(id,name)   end
      for id=25,33 do  ui.removeTextArea(id,final)  end
    end

    function actualizarcuadro(namee)
      local textcannondeathmatch = "<font color='#B1B0B0' size='13' align='center' face='Ubuntu'>  Cañones Deathmatch     </font>"
      local textcannonffarace = "<font color='#B1B0B0' size='13' align='center' face='Ubuntu'>  Cañones FFArace           </font>"
      local rand_can_txt = deathmatchcannons and "<font color='#63da0b' size='15' align='center' face='Ubuntu'>☑</font>" or "<font color='#727272' size='15' align='center' face='Ubuntu'>☐</font>"
      local rand_can_txt2 = ffaracecannons and "<font color='#63da0b' size='15' align='center' face='Ubuntu'>☑</font>" or "<font color='#727272' size='15' align='center' face='Ubuntu'>☐</font>"
      settings = "<p align='center'><font color='#ffffff' size='13' align='center' face='Ubuntu'>Settings</font></p><br/>"..textcannondeathmatch.."<a href='event:deathmatchcannons'>"..rand_can_txt.."</a><br>"..textcannonffarace.."<a href='event:ffaracecannons'>"..rand_can_txt2.."</a>"
      for name, player in pairs(tfm.get.room.playerList) do
        if players[name].opened.sett then  ui.addTextArea(95, settings, name, 280,145, 210, 110, 0x171616, 0x555555, 0.9, true)   end
      end
    end

    function generarCannonId()
       -- genera numero aleatorio para la posicion dentro de specialcannons     
       cannD = math.random (1,#specialcannons.deathmatch); cannF=math.random(1,#specialcannons.ffarace)
       -- genera el id del cañon para los cañones estandar               
       idCannon = cannones[math.random(1,#cannones)] -- Pick value from table
    end

    function suprimircannones()
      for idCannon, object in pairs(tfm.get.room.objectList) do
            table.insert(IDList, idCannon)
      end
      --eliminar cañones
      for i, idCannon in pairs(IDList) do
        tfm.exec.removeObject(idCannon)
      end
    end

    function verjugadores()
        i=0
        for k,v in pairs(tfm.get.room.playerList) do
          i=i+1
        end
     end   
    
    function EjecutarMapa()        
        if not primeraEjecucion then
            tfm.exec.newGame(maps[math.random(#maps)])
            bool = false; countdown = 0;cambiocannones=0;count=0;diagonal=0;ui.removeTextArea(101,final);ui.removeTextArea(102,final)
            for name, player in pairs(tfm.get.room.playerList) do players[name].jump = 5  end
        end
    end
    
    local Load= function(time, remaining)

      TiempoTranscurrido=time/1000;
      if not primeraEjecucion then
            
        if not bool and not rondaFinal and TiempoTranscurrido >= 6 and TiempoTranscurrido <=50 then
          shootedcannon= tfm.exec.addShamanObject(idCannon, 820, math.random(150,380), math.random(-135, -45), 0, 0, false)
          shootcannonspecial(shootedcannon)
        end
                    
        if not bool and not rondaFinal and TiempoTranscurrido >= 8 then
          diagonal = diagonal + math.random(0, 4);count = count + 1; 
          if count > 10 and TiempoTranscurrido <= 53 then
            shootedcannon1 = tfm.exec.addShamanObject(idCannon, -10, 200, 180)
            shootcannonspecial(shootedcannon1)
            count = 0
          elseif diagonal >= 14 then
            shootedcannon2 = tfm.exec.addShamanObject(idCannon, 110, 100, math.random(-160, -120))
            shootcannonspecial(shootedcannon2)
            diagonal = 0
          end
          --modio dios
          if math.floor(TiempoTranscurrido) == 43 then
            tfm.exec.setUIMapName("<YELLOW>#dodge by factral  <font color='#5c5474'>|</font> <N> Modo Dios En Unos Segundos.... ... .. .")
          end
          if TiempoTranscurrido>= 53 and TiempoTranscurrido <=53.5 then
            generarCannonId()
          end
          if TiempoTranscurrido >= 53 and not modoCrono then
            for name, player in pairs(tfm.get.room.playerList) do players[name].jump = players[name].jump+1  end
            if  modoIndividual then
              tfm.exec.setUIMapName("<YELLOW>#dodge by factral              <N>Modo: <V>Individual")
            else
              tfm.exec.setUIMapName("<YELLOW>#dodge by factral        <N>Ronda: <V>"..numeroRonda.."/7      <N>Modo: <V>Estandar")
            end
          end
          if (modoCrono or not modoCrono) and TiempoTranscurrido >= 53 then
            shootedcannon4 = tfm.exec.addShamanObject(idCannon, 840, math.random()*350, 270)
            shootedcannon5 = tfm.exec.addShamanObject(idCannon, 840, math.random()*350, 225)
              shootcannonspecial(shootedcannon4)
              shootcannonspecial(shootedcannon5)
          end  
        end
                
        if TiempoTranscurrido >=6 then
          ui.removeTextArea(25,final); ui.removeTextArea(26,final)
        end

        if bool and not modoCrono then
          countdown = countdown + 1
          if countdown  >= 3 and not rondaFinal then
            EjecutarMapa()
          end            
               
          --dar ganador al final de el cumulo de rondas               
          if rondaFinal and countdown ==3 then
            ui.removeTextArea(7,name);  empate=false;
            tfm.exec.newGame(7815400)                            
            ui.addTextArea(6, "<p align='center'><font color='#ffe300' size='14'><b>"..campeon.. "</font><N> Ha ganado!" , final , 200, 30, 400, 23,0x373737,0x373737)
            tfm.exec.setGameTime(25)                
            for i=1, 50 do
              tfm.exec.displayParticle(math.random(21,24), math.random(1,800), 20, math.random(-20,20)/100, math.random(10,1000)/100, 0, 0, nil)
            end
            tfm.exec.movePlayer(campeon,400,210)
          end
 
          if rondaFinal and TiempoTranscurrido>=24 then         
              reiniciartodo()
          end                                                         
        end
                
        if modoCrono and not muertoJugadorCrono then
          showTime(TiempoTranscurrido)            
        end
 
        if bool and modoCrono then
          mins=0; secs=0
        end
                      
        if mostrarTitulo and TiempoTranscurrido <=5 then
          --creditos para Deadjerry y maik005 en esta parte
          game="#Dodge";
          ui.addTextArea(1, "<BR><B><p align='center'><font face='Soopafresh' size='120' color='#000000'><BR>"..game, p, 10, -30, 790, 400, 1, 1, 0.0, false)
          ui.addTextArea(2, "<BR><B><p align='center'><font face='Soopafresh' sdize='120' color='#000000'><BR>"..game, p, 0, -30, 790, 400, 1, 1, 0.0, false)
          ui.addTextArea(3, "<BR><B><p align='center'><font face='Soopafresh' size='120' color='#EAA118'><BR>"..game, p, 5, -35, 790, 400, 1, 1, 0.0, false)
          ui.addTextArea(4, "<BR><B><p align='center'><font face='Soopafres' size='120' color='#000000'><BR>"..game, p, 5, -25, 790, 400, 1, 1, 0.0, false)
          ui.addTextArea(5, "<BR><B><p align='center'><font face='Soopafresh' size='120' color='#E7DB25'><BR>"..game, p, 5, -30, 790, 400, 1, 1, 0.0, false)
        elseif mostrarTitulo and TiempoTranscurrido >=5 and TiempoTranscurrido <=7 then
          for i = 1,5 do   ui.removeTextArea(i, p)   end
          mostrarTitulo=false
        end
      end
    end   
    
    local Wait= 0
    local winned= false
    function eventLoop(time,remaining)
      if not winned then
        if cambiocannones>=3 then
          Wait= Wait + 500
          if Wait>= 3500 then
            Wait= 0
            ui.removeTextArea(101,name); ui.removeTextArea(102,name)
          end
        end
        Load(time, remaining)
      else
        Wait= Wait + 500
        if Wait>= 3500 then
          Wait= 0
          finish()
        end
      end
    end   
         
  function reiniciartodo()
    numeroRonda=1;   bool=false;    rondaFinal=false; empate=false;
    for name, player in pairs(tfm.get.room.playerList) do
       players[name].score = 0
       nombresempate[name] = false
    end
    EjecutarMapa();  darscore();  ui.removeTextArea(6,final)    
  end
 
  function box(input)
    return boxes.help[input]
  end
 
  function showTime(TiempoTranscurrido) 
    amount = TiempoTranscurrido / 60
    mins = math.floor(amount)
    seconds = math.floor((amount - mins)*60)
    
    if mins<=9 then
      if seconds <=9 then
      tfm.exec.setUIMapName("<YELLOW>#dodge by factral              <N>Modo: <V>Crono         <N>Time : <V>0"..mins..":0"..seconds.."\n")
      else
      tfm.exec.setUIMapName("<YELLOW>#dodge by factral              <N>Modo: <V>Crono         <N>Time : <V>0"..mins..":"..seconds.."\n")
      end
    elseif mins>9 then
      if seconds <=9 then
        tfm.exec.setUIMapName("<YELLOW>#dodge by factral              <N>Modo: <V>Crono         <N>Time : <V>"..mins..":0"..seconds.."\n")
      else 
        tfm.exec.setUIMapName("<YELLOW>#dodge by factral              <N>Modo: <V>Crono         <N>Time : <V>"..mins..":"..seconds.."\n")
      end
    end    
  end
 
  function eventChatCommand(name,command)
                   
    if command=="settings" then
      if not primeraEjecucion then
        players[name].opened.help=false;players[name].opened.leader=false;players[name].opened.modos=false;
        cerrartodo(name)        
        if players[name].opened.sett then
          players[name].opened.sett=false
          ui.removeTextArea(95,name)
        else
          players[name].opened.sett=true
        end
        actualizarcuadro(name)    
      end
    end
               
    if command== "lea" then
      if not modoCrono and not primeraEjecucion then
        players[name].opened.help=false;players[name].opened.sett=false;players[name].opened.modos=false;
        cerrartodo(name)
        local leaderboard="<p align='center'><font color='#FFFFFF'>Leaderboard</font><br/><br/>"                    
        for name, player in pairs(tfm.get.room.playerList) do
          leaderboard= leaderboard..players[name].nombre.." - "..players[name].score.." pts<br/>"
        end
        ui.addTextArea(99, leaderboard, name, 280,85, 210, 250, 0x171616, 0x555555, 0.9, true)
        if players[name].opened.leader then
          players[name].opened.leader=false
          ui.removeTextArea(99,name)
        else
          players[name].opened.leader=true
        end       
      end
    end                   
                   
    if command== "np" then
      if  not muertoJugadorCrono then
        if TiempoTranscurrido*1000 <=3000 or bool then
          ui.addTextArea(25,"<p align='center'><b><font color='#EB1D51'></font></b></a></p>",final,2,387,270,12,0x171616,0x772727,nil,true)
          ui.addTextArea(26,"<p align='center'><b>Vuelve a escribir el comando.</b></a></p>",final,2,383,270,16,0,0,0,true)
        end
        if TiempoTranscurrido*1000 >=3000 and not bool then
            ui.removeTextArea(25,final)
            ui.removeTextArea(26,final)
            EjecutarMapa()
        end
      end
    end
                    
    if command=="restart" then
      if numeroRonda==8 then
        reiniciartodo()    
      end
    end
                    
    if command=="redo" then
      if muertoJugadorCrono then                    
        ui.removeTextArea(7,final); ui.removeTextArea(22,final)
        ui.removeTextArea(23,final)
        reiniciartodo()   
        mins=0; seconds=0; muertoJugadorCrono=false
      end
    end

     if command=="modoestandar" or command=="modocrono" then 
        if TiempoTranscurrido*1000 >=3000 then     
          ui.removeTextArea(7,final);ui.removeTextArea(22,final);ui.removeTextArea(23,final)
          ui.removeTextArea(25,final);ui.removeTextArea(26,final)
          reiniciartodo()
          players[name].opened.modos=false;muertoJugadorCrono=false
          if command=="modoestandar" and i>=2 then
            modoIndividual=false;modoCrono=false
          elseif command=="modoestandar" and i==1 then
            modoIndividual=true;modoCrono=false
          elseif command=="modocrono" then
             mins=0;seconds=0;modoCrono=true;modoIndividual=false
          end
        end
    end
                    
    if command=="help" then
     if not primeraEjecucion then 
      players[name].opened.leader=false;players[name].opened.sett=false;players[name].opened.modos=false;     
      cerrartodo(name)
      ui.addTextArea(12,"<p align='left'><a href='event:acercade'><b>Acerca de</b></a></p>",name,149,122,90,16,0x231414,0x3e5d2e,nil,true)
      ui.addTextArea(13,"<p align='left'><a href='event:modos'><b>Modos</b></a></p>",name,149,152,90,16,0x231414,0x3e5d2e,nil,true)
      ui.addTextArea(14,"<p align='left'><a href='event:comandos'><b>Comandos</b></a></p>",name,149,182,90,16,0x231414,0x3e5d2e,nil,true)
      ui.addTextArea(15,"<p align='left'><a href='event:creditos'><b>Creditos</b></a></p>",name,149,212,90,16,0x231414,0x3e5d2e,nil,true)
      --contenido de cada pestaña, de forma predefinida esta el acercade
      ui.addTextArea(16,box("acercade")[1],name,230,70,380,280,0x1d1b1b,0x242525,nil,true) 
      --boton para cerrar
      ui.addTextArea(17,"<p align='center'><font size='25'><a href='event:close'><b>X</b></a></p>",name,565,72,53,43,0,0,0,true)                      
    
      if players[name].opened.help then
        players[name].opened.help=false
        for id=12,17 do
          ui.removeTextArea(id,name)
        end
      else
        players[name].opened.help=true
      end     
     end                
    end
                                         
  if command=="modos" then 
    if not primeraEjecucion then    
      players[name].opened.help=false;players[name].opened.leader=false;players[name].opened.sett=false;
      cerrartodo(name)
    end     
    ui.addTextArea(27," ",name,200,120,400,180,0x1d1b1b,0xFFFFFF,nil,true)
    ui.addTextArea(28,"<p align='center'><b><font size='23' color='#37C68E'>Escoge un modo</font></b></a></p>",name,201,125,400,180,0,0,0,true)  
    ui.addTextArea(29," ",name,240,175,100,90,0x141816,0xFFFFFF,nil,true)
    ui.addTextArea(30," ",name,460,175,100,90,0x141816,0xFFFFFF,nil,true)
    ui.addTextArea(31,"<p align='center'><a href='event:modoestandar'><b><font size='17' color='#EC1616'>Modo <br>Estandar</font></b></a></p>",name,240,195,100,90,0,0,0,true)
    ui.addTextArea(32,"<p align='center'><a href='event:modocrono'><b><font size='17' color='#EC1616'>Modo <br>Crono</font></b></a></p>",name,460,195,100,90,0,0,0,true)
    if not primeraEjecucion then
      ui.addTextArea(33,"<p align='center'><font size='25'><a href='event:cerrar'><b>X</b></a></p>",name,552,119,53,43,0,0,0,true)        
      if players[name].opened.modos == true then
        players[name].opened.modos=false
        for id=25,33 do
          ui.removeTextArea(id,final)
        end
      else         
        players[name].opened.modos=true
      end
    end                     
  end
  end
                    
  function eventKeyboard(name,key,down,x,y)
    if (key == 32 and TiempoTranscurrido >=53 and not modoCrono and players[name].jump >= 5) then
          tfm.exec.movePlayer(name,0,0,true,0,-60,false)
          players[name].jump = 0
    end    
    if key == 72 then
      eventChatCommand(name,"help")        
    elseif key==76 then     
      eventChatCommand(name,"lea")
    elseif key==77 then
      eventChatCommand(name,"modos")
    elseif key==79 then
      eventChatCommand(name,"settings")      
    end
  end                 
      
  function eventNewPlayer(name)
    players[name] = {
                score = 0,
                jump=5,
                nombre=name,
                opened={
                  help=false;
                  leader=false;
                  sett=false;
                  modos=false;
                        }
                    }
    ui.addTextArea(10,"<p align='center'><b><font color='#EB1D51'></font></b></a></p>",name,779,387,17,12,0x030200,0x2a291a,nil,true)
    ui.addTextArea(11,"<p align='center'><a href='event:help'><b><font color='#FFFFFF'>?</font></b></a></p>",name,780,383,16,16,0,0,0,true)           
    for name in pairs(tfm.get.room.playerList) do
      for keys, k in pairs({32, 72, 76,79,77}) do
        tfm.exec.bindKeyboard(name, k, true, true)
      end
    end
    if primeraEjecucion then
        eventChatCommand(name,"modos")
    end
  end
        
  function darscore()
    for name, player in pairs(tfm.get.room.playerList) do
      tfm.exec.setPlayerScore(name, 0, false)
    end
  end      
    
  function eventTextAreaCallback(id,name,callback)

    if (callback=="deathmatchcannons" or callback=="ffaracecannons") and cambiocannones>2 then
        ui.addTextArea(101,"<p align='center'><b><font color='#EB1D51'></font></b></a></p>",name,2,387,270,12,0x171616,0x772727,nil,true)
        ui.addTextArea(102,"<p align='center'><b>Espera al siguiente mapa.</b></a></p>",name,2,383,270,16,0,0,0,true) 
    end

    if callback=="deathmatchcannons" then
      if deathmatchcannons and cambiocannones<=2 then
          deathmatchcannons=false
      elseif not deathmatchcannons and cambiocannones<=2 then
          ffaracecannons=false; cannons=deathmatch;
          deathmatchcannons=true
      end
    end

    if callback=="ffaracecannons" then
      if ffaracecannons and cambiocannones<=2 then
          ffaracecannons=false
      elseif not ffaracecannons and cambiocannones<=2 then
          deathmatchcannons=false; cannons=ffarace;
          ffaracecannons=true
      end
    end

    if (callback=="deathmatchcannons" or callback=="ffaracecannons") and cambiocannones<=2 then
          actualizarcuadro(name)
          cambiocannones=cambiocannones+1
    end

    if callback=="help" then
      eventChatCommand(name,callback) 
    elseif callback=="close" then
      players[name].opened.help=false
      for id=12,17 do
        ui.removeTextArea(id,name)    
      end
 
    elseif callback=="acercade" or callback=="modos" or callback=="comandos" or callback=="creditos" then
      ui.updateTextArea(16,box(callback)[1],name)
      ui.addTextArea(17,"<p align='center'><font size='25'><a href='event:close'><b>X</b></a></p>",name,565,72,53,43,0,0,0,true)
 
    elseif (callback=="modoestandar" or callback=="modocrono") then
      if TiempoTranscurrido*1000<=3000 then
        ui.addTextArea(25,"<p align='center'><b><font color='#EB1D51'></font></b></a></p>",final,2,387,270,12,0x171616,0x772727,nil,true)
        ui.addTextArea(26,"<p align='center'><b>Vuelve a escoger porfavor.</b></a></p>",final,2,383,270,16,0,0,0,true)    
      else
        primeraEjecucion=false
        for id=25,33 do
          ui.removeTextArea(id,final)
        end
        eventChatCommand(name,callback)
      end
  
    elseif callback=="cerrar" then
      players[name].opened.modos=false
      for id=25,33 do
        ui.removeTextArea(id,final)
      end   
    end
  end
    
  function eventPlayerDied(name)  
    playersAlive=playersAlive-1
    
    if not modoCrono then
      if ((playersAlive  == 0 and modoIndividual) or playersAlive == 1) and not rondaFinal then
        bool = true;   
        tfm.exec.setGameTime(5)
        tfm.exec.setUIMapName("<YELLOW>#dodge by factral  <font color='#5c5474'>|</font>  <N>Cambiando De Mapa.....")                
        suprimircannones()
      end
      if playersAlive  == 1 and not rondaFinal then
        winned= true 
      end
    else
      if playersAlive  == 0 and not rondaFinal then
        muertoJugadorCrono=true; bool=true                        
        suprimircannones()          
        tfm.exec.chatMessage("<font color='#24CBC5'>"..name.."</font> has sobrevivido por <ROSE>"..TiempoTranscurrido.." sg</ROSE>  en el mapa <font color='#6DD6A9'>"..tfm.get.room.currentMap.."</font>",name)
        ui.addTextArea(7, "<p align='center'><font size='14' color='#24CBC5'><b>"..name.. "</font><N> ha sobrevivido por "..TiempoTranscurrido.." segundos wow!" , final , 120, 30, 550, 23,0x030303,0x030303)
        ui.addTextArea(22,"<p align='center'><b><font color='#EB1D51'></font></b></a></p>",final,2,387,270,12,0x171616,0x772727,nil,true)
        ui.addTextArea(23,"<p align='center'><b>escribe el comando <font color='#EFF0EE'>!redo</font> para reiniciar</b></a></p>",final,2,383,270,16,0,0,0,true)       
        tfm.exec.respawnPlayer(name)
      end     
    end
  end    
       
  function eventNewGame()
    
    --toma un id para el cañon
    generarCannonId() 
    -- ve los jugadores 
    verjugadores()             
                        
    if i==1 and not modoCrono then
      tfm.exec.setUIMapName("<YELLOW>#dodge by factral              <N>Modo: <V>Individual")
      modoIndividual = true; numeroRonda=1
    elseif modoCrono then            
      tfm.exec.setUIMapName("<YELLOW>#dodge by factral              <N>Modo: <V>Crono         <N>Time : <V>"..mins..":"..seconds.."\n")                        
    else
      tfm.exec.setUIMapName("<YELLOW>#dodge by factral        <N>Ronda: <V>"..numeroRonda.."/7      <N>Modo: <V>Estandar")
      modoIndividual = false
    end

    if empate then
          tfm.exec.setUIMapName("<YELLOW>#dodge by factral     <N>Ronda: <V>Desempate      <N>Modo: <V>Estandar")
          ui.addTextArea(7, "<p align='center'><font size='14' color='#24CBC5'><b>** Ronda de desempate **" , final , 240, 20, 300, 23,0x030303,0x030303)
          for name in pairs(tfm.get.room.playerList) do
            if not nombresempate[name] then
              tfm.exec.killPlayer(name)
            end     
          end
    end

    if rondaFinal then
      tfm.exec.setUIMapName("<YELLOW>#dodge by factral          <N>Modo: <V>Estandar")
    end

    playersAlive=0
    for n,p in pairs(tfm.get.room.playerList) do
      playersAlive=playersAlive+1
    end
            
    if primeraEjecucion then
      tfm.exec.setUIMapName("<YELLOW>#dodge by factral                                 ")
    end
  end 
    
  function finish()
    numeroRonda=numeroRonda+1
    if playersAlive==0 then
          campeon="todos muertos, nadie"  --mensaje predefinido cuando todos los jugadores empatados mueren
    else
      for name, player in pairs(tfm.get.room.playerList) do 
        if not player.isDead then
          players[name].score = players[name].score + 1
          tfm.exec.setPlayerScore(name, 5, true)
          if empate then
           campeon=name
          end
        end
        tfm.exec.giveCheese(name)
        tfm.exec.playerVictory(name)
      end
    end
    winned= false; Wait= 0 
    if not modoIndividual and not modoCrono then
      ganadorTotal()
    end               
  end 
 
  function ganadorTotal()
    if numeroRonda>=8 then
      if empate then
        rondaFinal = true; empate=false;
      else
        local max = 0
        for name in pairs(tfm.get.room.playerList) do
          nombresempate[name]=false
          if players[name].score > max then
            key, max = name, players[name].score
          end
        end
        campeon, highscore = key, max
        buscarempate()
      end    
      bool = true;                                 
    end
  end

  function buscarempate()
    contadorempate=0;    empate=false
    for name in pairs(tfm.get.room.playerList) do
      if players[name].score == highscore then 
        nombresempate[name]=true
        contadorempate=contadorempate+1    -- contador de los jugadores empatados para despues verificar si son mas de 2   
      end
    end
    if contadorempate < 2 then
      for name in pairs(tfm.get.room.playerList) do
        nombresempate[name] = false
      end
      rondaFinal = true;
    else  
      empate=true
    end
  end   
 
  table.foreach(tfm.get.room.playerList, eventNewPlayer)
  verjugadores()
  darscore() end


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

    eventNewPlayer = function(name)
        tfm.exec.chatMessage("<N>/room #pewpew</N>", name)
    end

end




if modes[module.mode] then
    modes[module.mode].main()
else
    modes.castle.main()
end
