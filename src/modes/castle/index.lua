function()

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
            print(imgid)
            tfm.exec.removeImage(imgid)
        end
        for _, txtareaid in next, sequence.txtareas do
            ui.removeTextArea(txtareaid, target)
        end
    end

    -- [[main functions]] --
    displayModes = function(target)
        local res = "<p align='center'><D><font size='16' face='Lucida console'>Castle - submodes</font></D><br><br>"
        for name, mode in next, modes do
            if name ~= "castle" then
                res = res .. "<b>castle0" .. name .. "</b> <a href='event:modeinfo:" .. name .. "'>ⓘ</a>\t<a href='event:play:" .. name .. "'>( Play )</a><br>"
            end
        end
        addTextArea(1, res .. "</p>", target, 200, 100, 400, 200, true)
    end

    -- [[events]] --

    eventNewGame = function(name)
        for k, v in next, tfm.get.room.playerList do eventNewPlayer(k) end
    end

    eventNewPlayer = function(name)
        local commu = tfm.get.room.playerList[name].community
        tfm.exec.chatMessage(module.translate("welcome", commu), name)
    end 

    eventChatCommand = function(name, cmd)
        local args = string.split(cmd, " ")
        if args[1] == "modes" then
            displayModes(name)
        end
    end

    eventTextAreaCallback = function(id, name, evt)
        if evt == "close" then
            handleCloseButton(id, name)
        elseif evt:find("%w+:%w+") then
            local key, value = table.unpack(string.split(evt, ":"))
            if key == "play" then
                tfm.exec.chatMessage("<N>[</N><CS>•</CS><N>]</N> /room #castle0" .. value .. "@" .. name .. "</CS>", name)
            end
        end
    end

end
