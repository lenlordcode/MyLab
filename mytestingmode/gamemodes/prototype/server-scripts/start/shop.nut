registerServerFunc ("buyItem", function (id, price, typeItem ,nameItem)
{
	Player [id]._gold -= price; 
	giveItem (id, Items.id (nameItem), 1)
	print (nameItem)
	switch (typeItem)
	{
		case "weapon":
		print ("buyITEM" + nameItem)
		Player [id]._gunOne = nameItem;
		equipItem(id,Items.id (nameItem));
		break;

		case "weaponDistance":
		print ("buyITEM" + nameItem)
		Player [id]._gunTwo = nameItem;
		equipItem(id,Items.id (nameItem));
		break;

		case "armor":
		Player [id]._armor = nameItem;
		equipItem(id,Items.id (nameItem));
		break;
	}
})


function onTestCommand (pid,cmd,params){
	
		switch (cmd)
		{
			case "gold":
			Player [pid]._gold += 10000; 
			callClientFunc (pid, "goldCheckShop", 10000);
			break;
			
		}
	}
	addEventHandler ("onPlayerCommand", onTestCommand)