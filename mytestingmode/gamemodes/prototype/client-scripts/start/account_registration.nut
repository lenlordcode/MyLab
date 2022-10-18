local password;
local authtorisaton = false;
local idPlayer = heroId; 
local regMenu = GUI.Window(3000, 2000, anx(500), any(500), "MENU_INGAME.TGA", null, false)
local textInput = GUI.Input(anx(100), any(10), anx(300), any(50), "DLG_CONVERSATION.TGA", "FONT_OLD_20_WHITE_HI.TGA", Input.Text, Align.Left, "PASSWORD", 6, regMenu)
textInput.selector = "|"
local regButton = GUI.Button(anx(50), any(300), anx(100), any(50), "INV_SLOT_FOCUS.TGA", "REG", regMenu)
local macButton = GUI.Button(anx(200), any(300), anx(100), any(50), "INV_SLOT_FOCUS.TGA", "MAC", regMenu)
local enterButton = GUI.Button(anx(350), any(300), anx(100), any(50), "INV_SLOT_FOCUS.TGA", "ENTER", regMenu)
local exitButton = GUI.Button(anx(200), any(400), anx(100), any(50), "INV_SLOT_FOCUS.TGA", "EXIT", regMenu)


addEventHandler("onInit",function()
{
	cameraReg ();
	setCursorVisible(true)
	setFreeze (true);

	regMenu.setVisible(true)
})



addEventHandler("GUI.onClick", function(self)
{
	switch (self)
	{
		case regButton:
		print ("regButton");
		callServerFunc("enterInput", heroId, password, "reg");
		break;

		case macButton:
		print ("macButton");
		callServerFunc("enterInput", heroId, password, "mac");
		
		break;

		case enterButton:
		print ("enterButton");
		callServerFunc("enterInput", heroId, password, "pass");

		break;

		case exitButton:
			exitGame ();
			break;

	}
})


addEventHandler("GUI.onInputInsertLetter", function(element, text)
{
    if(element == textInput)
        password = password + text;
})

addEventHandler("GUI.onInputRemoveLetter", function(element, letter)
{
    if(element == textInput)
    	password = letter;
})


registerClientFunc ("cEnterInput", function (a){
	regMenu.setVisible(false);
	choiceFraction (true);
})


function cameraReg ()
{
Camera.setPosition(26142, -3124, 14408)
Camera.setRotation(0.0, 215.0, 0.0)
Camera.enableMovement(false) // disabling game moving camera
Camera.modeChangeEnabled = false // disabling switching into other camera modes
    

}


