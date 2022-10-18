local trueMessage = false;
local password = "123456";
local input_Password;


function createGUITexture (parmx,parmy,parmw,parmh,name){
	local GUITexture = Texture (parmx,parmy,parmw,parmh,name);
	return GUITexture;
}

function createGUIDraw (parmx,parmy,r,g,b,usefont,text){

	local GUIText = Draw (parmx,parmy,text);
	GUIText.font = (usefont);
	GUIText.setColor (r,g,b);

	return GUIText;
}



function passwordGUIInput (parmx,parmy, parmObject)
{
	parmObject.visible = false;
	input_Password = parmObject;
	chatInputOpen ();
	chatInputSetPosition(parmx,parmy);
		if (chatInputIsOpen() == true)
		{
			trueMessage = true;
			input_Password = Draw (3483,3300,255,255,255 chatInputGetText());
			input_Password.visible = true;
			chatInputClear();
            		chatInputClose();
		}

}




/*
function passwordGUIInputEnter (key)
{	

	if (trueMessage == true)
	{	
		
	    if (key == KEY_RETURN)  // ENTER
	    {	    	
	    	input_Password.visible = true;
	    	trueMessage = false;
	    	print (password);
	    }
	}
	else if (key == KEY_T && trueMessage == false) // block T
	{
		chatInputClose ();
	}
}
addEventHandler("onKey", passwordGUIInputEnter);

*/