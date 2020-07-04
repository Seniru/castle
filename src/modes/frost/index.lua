function()
    
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