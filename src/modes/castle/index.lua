function(modes)

    tfm.exec.disableAfkDeath()
    tfm.exec.disableAutoNewGame()
    tfm.exec.disableAutoShaman()
    tfm.exec.newGame(0)

    eventNewGame = function(name)
        for k, v in next, tfm.get.room.playerList do eventNewPlayer(k) end
    end

    eventNewPlayer = function(name)
        local commu = tfm.get.room.playerList[name].community
        tfm.exec.chatMessage(module.translate("welcome", commu), name)
    end 

end
