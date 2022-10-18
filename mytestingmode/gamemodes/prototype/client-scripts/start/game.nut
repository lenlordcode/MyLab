_team <- "Bandit";
local _class = "Warrior";
local _swap = false;
playerId <- heroId; // new update
local armorBandit = Items.id("ITAR_BDT_M")
local armorMilicia = Items.id ("ITAR_MIL_L");






	local playerMenu = GUI.Window(6500, 1500, anx(300), any(600), "MENU_INGAME.TGA", null, false);
	local rightClick = GUI.Button(anx(200), any(500), anx(75), any(75), "INV_SLOT_FOCUS.TGA", "->", playerMenu)
	local leftClick = GUI.Button(anx(25), any(500), anx(75), any(75), "INV_SLOT_FOCUS.TGA", "<-", playerMenu)
	local okClick = GUI.Button(anx(100), any(500), anx(100), any(75), "INV_SLOT_FOCUS.TGA", "OK", playerMenu)
	local textTeam = GUI.Draw(7000, 1600, "Team");
	local textPlayerTeam = GUI.Draw(7000, 2100, _team);
	local textClass = GUI.Draw(7000, 3000, "Class");
	local textPlayerClass = GUI.Draw(7000, 3500, _class);

function choiceFraction (athory)
{
	if (athory == true)
	{
	playerGameStatus = false;
	setPlayerPosition(heroId, 27553, -3335, 16275);	
	setPlayerAngle(heroId, 60);
	cameraChoiceTeam ();	
	playerMenu.setVisible (true);
	leftClick.setVisible(false);
	textTeam.setVisible (true);
	textPlayerTeam.setVisible (true);	
	textClass.setVisible (true);
	textPlayerClass.setVisible (true);
	equipItem (playerId, armorBandit);
	_team = "Bandit";
	gold = 0;
	}
} 


addEventHandler("GUI.onClick", function(self)
{
	switch (self)
	{
		case rightClick:
		rightClick.setVisible (false);
		leftClick.setVisible (true);
		_team = "Milicia";
		textPlayerTeam.setText (_team);
		equipItem (playerId, armorMilicia);

		break;

		case leftClick:
		equipItem (playerId, armorBandit);
		leftClick.setVisible (false);
		rightClick.setVisible(true);
		_team = "Bandit";
		textPlayerTeam.setText (_team);
		break;

		case okClick:
		playerGameStatus = true;
		print (playerGameStatus);
		callServerFunc("choiceFraction", playerId, _team);
		Camera.enableMovement(true)
    	Camera.modeChangeEnabled = true;
    	playerMenu.setVisible (false);
    	setCursorVisible (false);
    	setFreeze (false);
    	textTeam.setVisible (false);
		textPlayerTeam.setVisible (false);	
		textClass.setVisible (false);
		textPlayerClass.setVisible (false);
		clearInventory();
		teamCounterOpen ();
		refreshArmorList ()
		break;
	}
})


function cameraChoiceTeam ()
{
	print ("cameraEnabled")
	Camera.setPosition(27700, -3335, 16400) 
	Camera.setRotation(0.0, 215.0, 0.0)
}


