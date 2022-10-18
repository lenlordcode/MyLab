// WINDOW
local shopWindow = GUI.Window(anx(500), any(100), anx(950), any(800), "MENU_INGAME.TGA", null, false)
local visualObjectWindow = GUI.Window(anx(985), any(165), anx(425), any(300), "MENU_INGAME.TGA", null, false)

//BUTTON OK / CANCEL
local closeButton = GUI.Button(anx(10), any(750), anx(100), any(40), "INV_SLOT_FOCUS.TGA", "Close", shopWindow)
local enterButton = GUI.Button(anx(835), any(750), anx(100), any(40), "INV_SLOT_FOCUS.TGA", "Buy", shopWindow)



//LIST
local listWeapon = GUI.List(anx(530), any(500), anx(880), any(325), "MENU_INGAME.TGA", "MENU_INGAME.TGA", "BAR_MISC.TGA", "O.TGA", "U.TGA")
listWeapon.setMarginPx(10, 5, 5, 10)
local listWeaponDist = GUI.List(anx(530), any(500), anx(880), any(325), "MENU_INGAME.TGA", "MENU_INGAME.TGA", "BAR_MISC.TGA", "O.TGA", "U.TGA")
listWeaponDist.setMarginPx(10, 5, 5, 10)
local listArmor = GUI.List(anx(530), any(500), anx(880), any(325), "MENU_INGAME.TGA", "MENU_INGAME.TGA", "BAR_MISC.TGA", "O.TGA", "U.TGA")
listArmor.setMarginPx(10, 5, 5, 10)
local listPotion = GUI.List(anx(530), any(500), anx(880), any(325), "MENU_INGAME.TGA", "MENU_INGAME.TGA", "BAR_MISC.TGA", "O.TGA", "U.TGA")
listPotion.setMarginPx(10, 5, 5, 10)
//LIST CHART
local row;	



//ITEM MODEL AND GOLD
local item;
gold <- 0;
local armorModel = 0;

//SOUND
local soundOpenShop = Sound ("DOOR_UNLOCK.WAV");
local soundBuy = Sound ("DIA_LEHMAR_GELDZURUECK_09_01.WAV");
local soundErrorBuy = Sound ("DIA_LEHMAR_NOCHMALGELD_09_01.WAV");


//BUTTON LISTEN
local weaponButtton = GUI.Button(anx(40), any(20), anx(200), any(40), "INV_SLOT_FOCUS.TGA", "Weapon", shopWindow)
local weaponButttonDistance = GUI.Button(anx(270), any(20), anx(200), any(40), "INV_SLOT_FOCUS.TGA", "Weapon (dist)", shopWindow)
local armorButton = GUI.Button(anx(490), any(20), anx(200), any(40), "INV_SLOT_FOCUS.TGA", "Armor", shopWindow)
local potionButton = GUI.Button(anx(710), any(20), anx(200), any(40), "INV_SLOT_FOCUS.TGA", "Potion", shopWindow)

//STAT ITEM
local nameItem = GUI.Draw(anx(200), any(80), "", shopWindow);
local statItemOne = GUI.Draw(anx(40), any(120), "", shopWindow);
local statItemTwo = GUI.Draw(anx(40), any(160), "", shopWindow);
local statItemThree = GUI.Draw(anx(40), any(200), "", shopWindow);
local statItemFour = GUI.Draw(anx(40), any(240), "", shopWindow);
local statItemFive = GUI.Draw(anx(40), any(280), "", shopWindow);
local currentGoldDraw = GUI.Draw(anx(490), any(370), ("Gold: "+ gold), shopWindow);
local statusBuy = GUI.Draw(anx(360), any(750), "Test", shopWindow);

//CURRENT USE OBJECT
local currentButton;
local currentButtonOneUse = false;
local currentLine;
local currentListen = listWeapon;
local currentItemNumber;
local currentTypeItem = "weapon";


//BOOL VISIBLE
local visibleOjbect = false;

function activateShop (key)
{
	if (playerGameStatus == true)
	{	
		if (key == KEY_J)
		{
			if (visibleOjbect == true)
			{
				shopRender ();
			}
			else 
			{
				soundOpenShop.play ();
				if (currentButtonOneUse == false)
				{
					currentButtonOneUse = true;
					currentButton = weapon_list;

				}
				visibleOjbect = true;
				shopWindow.setVisible(visibleOjbect);
				visualObjectWindow.setVisible (visibleOjbect);
				setCursorVisible(visibleOjbect);
			   	currentListen.setVisible(visibleOjbect);
			   	setFreeze (visibleOjbect);
			}
		}
		else if (key == KEY_ESCAPE)
		{
			exitGame ();
		}
	}
}
addEventHandler ("onKey", activateShop)



addEventHandler("GUI.onClick", function(self)
{
	switch (self)
	{
		case weaponButtton:
		currentButton = weapon_list;
		currentListen.setVisible(false)
		currentListen = listWeapon;
		currentListen.setVisible (true);
		currentTypeItem = "weapon";
		break;

		case weaponButttonDistance:
		currentButton = weaponDistance_list;
		currentListen.setVisible(false)
		currentListen = listWeaponDist;
		currentListen.setVisible (true);
		currentTypeItem = "weaponDistance";
		break;

		case armorButton:
		currentButton = armor_list;
		currentListen.setVisible(false)
		currentListen = listArmor;
		currentListen.setVisible (true);
		currentTypeItem = "armor";
		break;

		case potionButton:
		currentButton = potion_list;
		currentListen.setVisible(false)
		currentListen = listPotion;
		currentListen.setVisible (true);
		break;

		case closeButton:
		visibleOjbect = false;
		setCursorVisible(visibleOjbect);
		shopWindow.setVisible(visibleOjbect);
	   	currentListen.setVisible(visibleOjbect);
	   	visualObjectWindow.setVisible (visibleOjbect);
	   	if (visibleOjbect != null)
	   	{item.visible = visibleOjbect;}
	   	setFreeze (visibleOjbect);
	   	break;

	   	case enterButton:
	   	if (gold>=currentButton[currentItemNumber].idG)
	   	{
	   		statusBuy.setText ("Successfully!");
	   		statusBuy.setColor (0,214,120);
	   		if (currentButton[currentItemNumber].idB != "Arrow" || currentButton[currentItemNumber].idB != "Bolt")
	   		{
	   			if (currentTypeItem == "armor")
	   			{
				callServerFunc ("buyItem", heroId, gold, currentTypeItem, currentButton[currentItemNumber + armorModel].idA);
	   			}
	   			else 
	   			{
	   			callServerFunc ("buyItem", heroId, gold, currentTypeItem, currentButton[currentItemNumber].idA);	
	   			}		
	   			soundBuy.play ();
	   		}
	   		else
	   		{
	   			callServerFunc ("buyItem", heroId, gold, "null", currentButton[currentItemNumber].idA);
	   		}
	   		gold -= currentButton[currentItemNumber].idG;
	   		currentGoldDraw.setText ("Gold: " + gold);

	   	}
	   	else if (gold<currentButton[currentItemNumber].idG)
	   	{
	   		soundErrorBuy.play ();
	   		statusBuy.setText ("Not enough gold");
	   		statusBuy.setColor (255,0,0);
	   	}
	   	break;
		
	}
		if (currentLine != null && currentLine == row)
		{
			currentLine.setColor (255,255,255);
		}

	if (!(self instanceof GUI.VisibleListRow))
	return
			
		row = currentListen.rows[self.id]
		currentLine = row;

		if (currentTypeItem == "armor")
	   	{
			renderItem (currentButton[self.id + armorModel].idA);
	   	}
	   		else 
	   	{
	   		renderItem (currentButton[self.id].idA);
	   	}		
    	
    	row.setColor(255, 255, 0);
    	nameItem.setText (currentButton[self.id].idB);
    	currentItemNumber = self.id;

    	statItemOne.setText ("");
    	statItemTwo.setText (""); statItemTwo.setColor (255,255,255)
    	statItemThree.setText (""); statItemThree.setColor (255,255,255)
    	statItemFour.setText ("");  statItemFour.setColor (255,255,255)
    	statItemFive.setText ("");  statItemFive.setColor (255,255,255)


    	switch (currentButton)
    	{
    		case weapon_list:
    		statItemOne.setText ("Damage: " + weapon_list[self.id].idC);
    		statItemTwo.setText ("Distance: " + weapon_list[self.id].idD);
    		statItemThree.setText ("Gold: " + weapon_list[self.id].idG);
    		statItemThree.setColor (255,255,0);
    		break;
    		case weaponDistance_list:
    		statItemOne.setText ("Damage: " + weaponDistance_list[self.id].idC);
    		statItemTwo.setText ("Gold: " + weaponDistance_list[self.id].idG);
    		statItemTwo.setColor (255,255,0);
    		break;
    		case armor_list:
    		statItemOne.setText ("Defense weapon: " + armor_list[self.id + armorModel].idC);
    		statItemTwo.setText ("Defense weapon distance: " + armor_list[self.id + armorModel].idD);
    		statItemThree.setText ("Defense magic: " + armor_list[self.id + armorModel].idF);
    		statItemFour.setText ("Gold: " + armor_list[self.id+ armorModel].idG);
    		statItemFour.setColor (255,255,0);
    		break;
    		case potion_list:
    		statItemOne.setText ("Heal: " + potion_list[self.id].idC);
    		statItemTwo.setText ("Gold: " + potion_list[self.id].idG);
    		statItemTwo.setColor (255,255,0);
    		break;
    	}
    	/*
		statItemOne
		statItemTwo
		statItemThree
		statItemFour
		statItemFive
*/    
})


function shopRender ()
{
	soundOpenShop.play ();
	visibleOjbect = false;
	setCursorVisible(visibleOjbect);
	shopWindow.setVisible(visibleOjbect);
	currentListen.setVisible(visibleOjbect);
	setFreeze (visibleOjbect);
	visualObjectWindow.setVisible (visibleOjbect);
	item.visible = visibleOjbect;
	currentGoldDraw.setText ("Gold: " + gold)
}


function renderItem (name)
{
	item = ItemRender(anx(985), any(165), anx(425), any(300), name)
	item.visible = true;
}

addEventHandler ("onInit", function(){
	for (local i = 0; i<weapon_list.len (); i++)
	{
	listWeapon.addRow (weapon_list[i].idB);	
	}
	for (local i = 0; i<weaponDistance_list.len (); i++)
	{
	listWeaponDist.addRow (weaponDistance_list[i].idB);
	}
	for (local i = 0; i<potion_list.len (); i++)
	{
	listPotion.addRow (potion_list[i].idB);
	}

})


local function saveRow(r)
{
	return currentLine = r;
}

registerClientFunc ("goldCheckShop", function (money)
{
	gold += money;
	currentGoldDraw.setText ("Gold: "+ gold);
	return gold;
})

function refreshArmorList ()
{
	listArmor.clear ();
	for (local a = 0; a<armor_list.len (); a++)
	{
		if (_team == "Milicia" && a>=5)
		{
		print ("Milicia - " + armor_list[a].idB + " - "+ a)
		listArmor.addRow (armor_list[a].idB);
		armorModel = 5;
		}
		else if (_team == "Bandit" && a<5)
		{
		print ("Bandit - " + armor_list[a].idB + " - "+ a)
		listArmor.addRow (armor_list[a].idB);
		armorModel = 0;	
		}	
	}
}
