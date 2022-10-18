local pointBandit = 0;
local pointMilicia = 0;
local teamBanditDraw;
local teamMiliciaDraw;
local roundTime;
local timeGame = {
			_hour = 1,
			_minute = 20,
			_second = 59,
			_tickTimer = 0,
			_tickPause = 0,
			_timerStatus = false
}

local lastPlayer = array (1);
local timerStatus = true;
local pauseCheck = 0;


// Функция вызывает

function teamCounterOpen ()
{
	teamMiliciaDraw = GUI.Draw (75, 7000, "Milicia: " + pointMilicia)
	teamBanditDraw = GUI.Draw (75, 6800, "Bandit: " + pointBandit)
	roundTime = GUI.Draw (75, 6600, timeGame._hour + ":" + timeGame._minute + ":" + timeGame._second)
	teamBanditDraw.setVisible (true);
	teamMiliciaDraw.setVisible (true);
	roundTime.setVisible (true);
	callFuncTime ();

}


function updateCounter ()
{	
	setTimer(function (){
		time ()}, 1000, timeGame._tickTimer);
}
addEventHandler ("onInit", updateCounter);


registerClientFunc ("timeData",function (hour,minute,second, tick, tickP, tStatus ){
	timeGame ={
		_hour = hour,
		_minute = minute,
		_second = second,
		_tickTimer = tick,
		_tickPause = tickP,
		_timerStatus= tStatus
	}

})
registerClientFunc ("timeDataReborn",function (hour,minute,second, tick, tickP, tStatus ){
	timeGame ={
		_hour = hour,
		_minute = minute,
		_second = second,
		_tickTimer = tick,
		_tickPause = tickP,
		_timerStatus= tStatus
	}
	teamBanditDraw.setVisible (false);
	teamMiliciaDraw.setVisible (false);
	roundTime.setVisible (false);
	setCursorVisible (true);
	teamSwap ();
	

})



// TIME запускатся несколько раз, решить проблему


function time ()
{
		if (timeGame._hour == 0 && timeGame._minute == 0 && timeGame._second == 0)
		{
			timeGame._timerStatus = false;
			// shopRender ()
			setFreeze (true);
		}

		else if  (timeGame._minute<0)
		{
			timeGame._minute = 59;
		}

		else if (timeGame._second<0)
		{
			timeGame._second = 59;
			timeGame._minute--;

		}
		else
		{
		timeGame._second--;
		timeTextReturn ();
		}
}


function callFuncTime ()
{
callServerFunc ("timeDataOne", heroId);
}

function timeTextReturn ()
{
	roundTime.setText (timeGame._hour + ":" + timeGame._minute + ":" + timeGame._second);
}

function teamSwap ()
{
	choiceFraction (timeGame._timerStatus);
	Camera.setPosition(27700, -3335, 16400) 
	Camera.setRotation(0.0, 215.0, 0.0)

	Camera.enableMovement(false) // disabling game moving camera
	Camera.modeChangeEnabled = false
}




function testCommand (cmd, params)
{
	switch (cmd)
	{
	case "point":	
	pointBandit++;
	teamBanditDraw.setText ("Bandit: " + pointBandit)
	break;
	}
}
addEventHandler ("onCommand", testCommand)




registerClientFunc ("DeathPlayer", function (pointTeam,point){
	switch (point)
	{
		case 0:
		teamBanditDraw.setText ("Bandit: " + pointTeam)
		break;
		case 1:	
		teamMiliciaDraw.setText ("Milicia: " + pointTeam)
		break;	
	}
	
})
