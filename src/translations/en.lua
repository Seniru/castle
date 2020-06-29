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
    welcome0graphs = "<br><N><p align='center'>Welcome to <b><D>#castle0graphs</D></b><br>Report any bugs or suggest interesting functions to <b><O>King_seniru</O><G><font size='8'>#5890</font></G></b><br><br>Type <b><BV>!commands</BV></b> to check out the available commands</p></N><br>",
    cmds0graphs = "<BV>!admin <name></BV> - Makes a player admin <R><i>(admin only command)</i></R>",
    fs_welcome = "<br><N><p align='center'>Welcome to <b><D>#castle0fashion</D></b> - the Fashion show!<br><br><br>Type <b><BV>!join</BV></b> to participate the game or <b><BV>!help</BV></b> to see more things about this module!</p></N><br>",
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
    fs_elimination_end = "<p align='center'><b><a href='event:newround'>Done!</a></b></p>",
    fs_maxplayers_error = "<N>[</N><R>•</R><N>] Sorry, the fashion show already got enough participants :(",
    fs_elimination_confirm = "Eliminate ${name}?",
    fs_error_not_playing = "<R>The selected player is not a participant!",
    fs_players_not_enough = "<N>[</N><R>•</R><N>] <R>Error: Not enough players!</R>",
    fs_winner = "<N>[</N><D>•</D><N>] <b><D>Fashion show ended!</D><br>... and the winner is <D>${winner}</D>! Good job!</b></N>",
    fs_help = {
        ["main"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help</b></font></p><br>" ..
            "This is a submode of semi-official module #castle which lets players to host fashion shows easily, while keeping most of the old styles to make it close to you.<br>" ..
            "Create a room with your name included in the room name to host a fashion show as you the admin <i>(/room *#castle0fashion@Yourname#0000)</i><br>" ..
            "<br><b><D>Index</D></b><br><a href='event:help:commands'>• Commands</a><br><a href='event:help:keys'>• Key bindings</a><br><a href='event:help:credits'>• Credits</a>",
        ["commands"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help - Commands</b></font></p><br>" ..
            "<b>!admin [name]</b> - make a player an admin (admin only command)<br>" ..
            "<b>!admins</b> - shows a list of admins<br>" ..
            "<b>!checkpoint [all|<me>]</b> - set checkpoints (E)" ..
            "<b>!eliminate [name]</b> - eliminates the player from the round (admin only command) (Shift + click)<br>" ..
            "<b>!help</b> - displays this help menu<br>" ..
            "<b>!join</b> - joins the fashion show, if you haven`t participated yet<br>" ..
            "<b>!omo <text></b> - displays an omo - like in utility (admin only command)<br>" ..
            "<b>!s [me|admins|all|name]</b> - make players shaman according to the arguments provided or the name (admin only command)<br>" ..
            "<b>!stop</b> - force stop the current round<br>" ..
            "<b>!tp [me|admins|all|name]</b> - teleports a players according to the arguments provided or the name (admin only command)<br><br><a href='event:help:main'><BV>« Back</BV></a>",
        ["keys"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help - Keys</b></font></p><br>" ..
            "<b>E</b> - set a checkpoint<br>" ..
            "<b>Shift + Click (on player)</b> - eliminates a player after the round <i>(admin only)</i><br><br><a href='event:help:main'><BV>« Back</BV></a>",
        ["credits"] = "<p align='center'><font size='20' color='#ffcc00'><b>Help - Credits</b></font></p><br>" ..
            "<b><D>Testing</D></b><br>" ..
            "• Snowvlokje#4925<br>• Lpspopcorn#0000<br>• Light#5990<br>• Lilylolarose#0000<br><br>Also thanks for <b>Snowvlokje#4925</b> and the tribe <b>We Talk a Lot</b> to encouraging me and supporting me to do this work!<br><br><a href='event:help:main'><BV>« Back</BV></a>"
    }
}