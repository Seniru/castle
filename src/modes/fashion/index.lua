function()
    
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