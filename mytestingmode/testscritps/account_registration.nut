setCursorVisible (true);

local name_label = createGUIDraw (3950,2650,255,255,255 "FONT_10_BOOK.TGA", getPlayerName (heroId))
local pass_label = createGUIDraw (3950,3350,255,255,255 "FONT_10_BOOK.TGA", "Password")


local archon_background = Texture (2805,2130,2700,3700,"INV_TITLE.TGA")
local login_edit = Texture (3483,2493,1342,454,"INV_TITEL.TGA")
local pass_edit = Texture (3483,3215,1342,454,"INV_TITEL.TGA")
local reg_button = Texture (2985,3935,538,348,"INV_TITEL.TGA")
local mac_button = Texture (3861,3935,538,348,"INV_TITEL.TGA")
local enter_button = Texture (4729,3935,538,348,"INV_TITEL.TGA")
local exit_button = Texture (3871,4760,538,348,"INV_TITEL.TGA")
local reg_label = Draw (3150,4050,"REG")
reg_label.font = "FONT_10_BOOK.TGA";
reg_label.setColor(255, 0, 0);
local max_label = Draw (4029,4050,"MAC")
max_label.font = "FONT_10_BOOK.TGA";
max_label.setColor(255, 0, 0);
local enter_label = Draw (4836,4050,"ENTER")
enter_label.font = "FONT_10_BOOK.TGA";
enter_label.setColor(255, 0, 0);
local exit_label = Draw (4034,4846,"EXIT")
exit_label.font = "FONT_10_BOOK.TGA";
exit_label.setColor(255, 0, 0);

	local name_label = Draw (3900,2650,getPlayerName(heroId))
	name_label.font = "FONT_10_BOOK.TGA";
	name_label.setColor(255, 0, 0);

addEventHandler("onInit",function()
{
   archon_background.visible = true;
   login_edit.visible = true;
   pass_edit.visible = true;
   reg_button.visible = true;
   mac_button.visible = true;
   enter_button.visible = true;
   exit_button.visible = true;
   reg_label.visible = true;
   max_label.visible = true;
   enter_label.visible = true;
   exit_label.visible = true;

	pass_label.visible = true;
   name_label.visible = true;

   setFreeze(true);
});

/*function onRender (){
 	clickButton (key);
}
addEventHandler("onRender", onRender)
*/

local ar_object_distance = {
	x_pos = 0,
	y_pos = 0,
	w_pos = 0,
	h_pos = 0 
}
local ar_mouse_distance = {
	x = 0,
	y = 0
}

function positionGUInterface (object, ar_object_distance){
	local pos = object.getPositionPx();
	local pos2 = object.getSizePx ();
	ar_object_distance = {
		x_pos = pos.x,
		y_pos = pos.y,
		w_pos = pos2.width,
		h_pos = pos2.height

		/* x_width = pos.width,
		y_height = pos.height */
	}
	return ar_object_distance;
}

function positionMouse (ar_mouse_distance){
	local posm = getCursorPositionPx();
	ar_mouse_distance = {
		x = posm.x,
		y = posm.y
	}
	return ar_mouse_distance;
}

function onMouseClick (btn)
{	
	if (btn == MOUSE_LMB)
		{
		
		
		local exit_ar_object_distance = positionGUInterface (exit_button, ar_object_distance);
		local mac_ar_object_distance = positionGUInterface (mac_button, ar_object_distance);
		local enter_ar_object_distance = positionGUInterface (enter_button, ar_object_distance);
		local reg_ar_object_distance = positionGUInterface (reg_button, ar_object_distance);
		local pass_ar_object_distance = positionGUInterface (pass_edit, ar_object_distance);
		local ar_mouse_distance = positionMouse (ar_mouse_distance);		
		//
		local exitCheck = checkButton (exit_ar_object_distance.x_pos,exit_ar_object_distance.y_pos,
												exit_ar_object_distance.w_pos,exit_ar_object_distance.h_pos,
												ar_mouse_distance.x,ar_mouse_distance.y)	
		local macCheck = checkButton (mac_ar_object_distance.x_pos,mac_ar_object_distance.y_pos,
												mac_ar_object_distance.w_pos,mac_ar_object_distance.h_pos,
												ar_mouse_distance.x,ar_mouse_distance.y)	
		local enterCheck = checkButton (enter_ar_object_distance.x_pos,enter_ar_object_distance.y_pos,
												enter_ar_object_distance.w_pos,enter_ar_object_distance.h_pos,
												ar_mouse_distance.x,ar_mouse_distance.y)	
		local regCheck = checkButton (reg_ar_object_distance.x_pos,reg_ar_object_distance.y_pos,
												reg_ar_object_distance.w_pos,reg_ar_object_distance.h_pos,
												ar_mouse_distance.x,ar_mouse_distance.y)	


		local passCheck = checkButton (pass_ar_object_distance.x_pos,pass_ar_object_distance.y_pos,
												pass_ar_object_distance.w_pos,pass_ar_object_distance.h_pos,
												ar_mouse_distance.x,ar_mouse_distance.y)
			if (exitCheck == true)
			{
				exitGame ();
				exitCheck = false;
			}
			else if (macCheck == true)
			{
				print ("MacEnabled");
				macCheck = false
				
			}
			else if (enterCheck == true)
			{
				print ("EnterEnabled");
				enterCheck = false;
			}
			else if (regCheck == true)
			{
				print ("RegEnabled");
				regCheck = false;
			}
			else if (passCheck == true)
			{
				passwordGUIInput (3483,3300,pass_label); 

			}
	}

}
addEventHandler("onMouseClick", onMouseClick)


function checkButton (x1,y1,x2,y2,x,y)
{
	if ( x>=x1 && x<=(x1+x2) && y>=y1 && y<=(y1+y2))
	{
		return true;
	}
		return false;
}

