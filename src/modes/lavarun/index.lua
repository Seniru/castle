function()

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