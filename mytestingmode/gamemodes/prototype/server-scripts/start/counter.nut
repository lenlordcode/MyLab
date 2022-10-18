local timeGame = {
		_hour = 0,
		_minute = 5, 
		_second = 5
	}
local timerStatus = true;
local pauseCheck = 0;
local tickTimer;
local tickPause = 11;
local tickTimerOut;
local pointTeam = {
	bandit = 0,
	milicia = 0
}

function calculateTick ()
{
	tickTimer = (timeGame._second + 1) + ((timeGame._minute * 60)) + ((timeGame._hour * 3600));
	tickTimerOut = tickTimer;

}
addEventHandler ("onInit", calculateTick)


function updateTimer ()
{	
	switch (timerStatus)
	{
	case true:	
		setTimer(function (){
		time ()}, 1000, tickTimer);
	break;
	case false:
	setTimer(function (){
		 timePause()}, 1000, tickPause);
	break;
	}
}
addEventHandler ("onInit", updateTimer)


registerServerFunc ("timeDataOne", function (id){
callClientFunc (id, "timeData", timeGame._hour,timeGame._minute,timeGame._second, tickTimerOut, tickPause, timerStatus);
})




function timePause ()
{
	if (pauseCheck >= 10)
	{
		timerStatus = true;
		timeGame = {
				_hour = 0,
				_minute = 5, 
				_second = 5
		}
		pauseCheck = 0;
		updateTimer ();
		roundReborn ();


	}
	pauseCheck++
}



function roundReborn ()
{
	for (local i = 0; i<Players.len (); i++)
	{			
				giveItem (i, Items.id ("ITAR_BDT_M"), 1)
				giveItem (i, Items.id ("ITAR_MIL_L"), 1)
				callClientFunc (i, "timeDataReborn", timeGame._hour,timeGame._minute,timeGame._second, tickTimerOut, tickPause, timerStatus);
	}
}



function time ()
{
	print (timeGame._hour+":"+timeGame._minute+":" +timeGame._second);
	
	timeGame._second--;
	tickTimerOut--;

	if (timeGame._hour == 0 && timeGame._minute == 0 && timeGame._second == 0)
	{
		if (pointTeam.bandit == pointTeam.milicia)
		{
			sendMessageToAll(170, 104, 57, "DRAW");
		}
		else if (pointTeam.bandit > pointTeam.milicia)
		{	
			sendMessageToAll(170, 104, 57, "Bandit WIN");
		}
		else if (pointTeam.bandit < pointTeam.milicia)
		{
			sendMessageToAll(170, 104, 57, "Milicia WIN");
		}
		pointTeam = {
			bandit = 0,
			milicia =0
		}
		timerStatus = false;
		updateTimer ();
	}

	
	else if (timeGame._minute ==0 && timeGame._second ==0)
	{
		timeGame._hour--;
		timeGame._minute = 59;
		timeGame._second = 59;
	}
	else if (timeGame._hour == 0 && timeGame._minute <= 0 && timeGame._second == 0)
	{
			timeGame._minute = 59;
	}

	else if (timeGame._second<0)
	{
		timeGame._second = 59;
		timeGame._minute--;	
		
	}
	
}


function onPlayerDeadPlayer(pid, kid)
{
	sendMessageToAll(170, 104, 57, getPlayerName(pid) + " has been killed by " + getPlayerName(kid) + ".");
	print (pid + " + " + kid)
	if (kid<0)
	{
		sendMessageToAll(170, 104, 57, "NPC KILL - " + getPlayerName (pid));
	}
	else 
	{
		switch (Player [kid]._team) // pid и kid полетели
		{
			case "Bandit":
			sendMessageToAll(170, 104, 57, "Bandit KILL");
			if (Player [pid]._team == "Milicia")
			{
				giveItem (kid, Items.id ("ITMI_GOLD"), 1500);
				pointTeam.bandit++;
				imoprtAllPlayerText (pointTeam.bandit, 0);
			}
			else if (Player [kid]._team == "Bandit")
			{
				pointTeam.bandit--;
				imoprtAllPlayerText (pointTeam.bandit, 0);
			}
			break;
			case "Milicia":
			sendMessageToAll(170, 104, 57, "Milicia KILL");
			if (Player [pid]._team == "Bandit")
			{
				giveItem (kid, Items.id ("ITMI_GOLD"), 1500);
				pointTeam.milicia++;
				imoprtAllPlayerText (pointTeam.milicia, 1); //
			}
			else if (Player [pid]._team == "Milicia")
			{
				pointTeam.milicia--;
				imoprtAllPlayerText (pointTeam.milicia, 1);
			}
			break;
		}
	}	
}

addEventHandler("onPlayerDead", onPlayerDeadPlayer);

// Б



function imoprtAllPlayerText (pT, p)
{
	for (local i = 0; i<Player.len (); i++){ //цикл поправить
		if (Players[i].activate == true)
		{
		callClientFunc (i, "DeathPlayer", pT, p);
		}
	}
}

function giveGold (id)
{
	giveItem (id, Items.id ("ITMI_GOLD"), 1500);
	Player [id]._gold += 1500;
}


function importPoint ()
{

}
addEventHandler ("onPlayerJoin", importPoint)

