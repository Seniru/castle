function()
    
    -- [[ dependencies]] --
    --[ timers4tfm ]--
    local a={}a.__index=a;a._timers={}setmetatable(a,{__call=function(b,...)return b.new(...)end})function a.process()local c=os.time()local d={}for e,f in next,a._timers do if f.isAlive and f.mature<=c then f:call()if f.loop then f:reset()else f:kill()d[#d+1]=e end end end;for e,f in next,d do a._timers[f]=nil end end;function a.new(g,h,i,j,...)local self=setmetatable({},a)self.id=g;self.callback=h;self.timeout=i;self.isAlive=true;self.mature=os.time()+i;self.loop=j;self.args={...}a._timers[g]=self;return self end;function a:setCallback(k)self.callback=k end;function a:addTime(c)self.mature=self.mature+c end;function a:setLoop(j)self.loop=j end;function a:setArgs(...)self.args={...}end;function a:call()self.callback(table.unpack(self.args))end;function a:kill()self.isAlive=false end;function a:reset()self.mature=os.time()+self.timeout end;Timer=a

    system.disableChatCommandDisplay()
    tfm.exec.disableAfkDeath()
    tfm.exec.disableAutoNewGame()
    tfm.exec.disableAutoShaman()
    tfm.exec.newGame(0)

    -- [[ game variables ]] --
    local players = {}
    -- copied shamelessly from Utility (https://github.com/imliam/Transformice-Utility/blob/master/utility.lua#L5128)
    local omos = {"omo","@_@","@@","è_é","e_e","#_#",";A;","owo","(Y)(omo)(Y)","©_©","OmO","0m0","°m°","(´°?°`)","~(-_-)~","{^-^}", "uwu", "o3o"}
    local closeSequence = {}
    local started = false
    local round = 0
    local participants = {}
    local participantCount = 0

    local settings = {
        title = "",
        desc = "",
        prize = "",
        maxPlayers = 100,
        pw = "",
        map = 0,
        specSpawn = {},
        playerSpawn = {},
        outSpawn = {}
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
            local res = module.translate("fs_participants", commu)
            for name in next, participants do
                res = res .. name .. ", "
            end
            addTextArea(2, res:sub(1, -2), target, 275, 100, 250, 200, true, false)
            table.insert(closeSequence[2][target].txtareas, ui_addTextArea(2000, "<p align='center'><a href='event:close'>OK</a></p>", target, 290, 260, 225, 20, nil, 0x324650, 1, true))
            closeSequence[2][target].onclose = function(target)
                if module.subRoomAdmins[target] then displayConfigMenu(target) end
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
            specX = specSpawn.x or defaultX, specY = specSpawn.y or defaultY,
            playerX = playerSpawn.x or defaultX, playerY = playerSpawn.y or defaultY,
            outX = outSpawn.x or defaultX, outY = outSpawn.y or defaultY
        }), target, 100, 50, 600, 320, true, true)
        if module.roomAdmin == target then
            table.insert(closeSequence[1][target].txtareas, ui_addTextArea(200, module.translate("fs_start", commu), target, 110, 345, 580, 16, nil, 0x324650, 1, true))
        end
    end

    start = function()
        tfm.exec.chatMessage(module.translate("fs_starting", tfm.get.room.community))
        started = true
        tfm.exec.newGame(settings.map)
        local playerX, playerY, specsX, specsY = settings.playerSpawn.x, settings.playerSpawn.y, settings.specSpawn.x, settings.specSpawn.y
        for player in next, tfm.get.room.playerList do
            print(player)
            if not module.subRoomAdmins[player] then
                if participants[player] then
                    tfm.exec.movePlayer(player, playerX, playerY)
                else
                    tfm.exec.movePlayer(player, specX, specY)
                end
            else
                handleCloseButton(1, player)
            end
        end
    end
    
    -- [[ events]] --

    eventMouse = function(name, x, y)
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

    eventNewPlayer = function(name)
        players[name] = {clicks = {}}
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
            end
        end
    end

    eventLoop = function()
        Timer.process()
    end

end