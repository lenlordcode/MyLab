 function checkId ()
 {
	for (local i = 0; i<Players.len (); i++)
	{
		Players [i] = {password = "null",
						mac = "null",
						getReg = "null",
						activate = false,
						reg = false,
					};	
	}	
}
addEventHandler ("onInit", checkId)

/*
Автоматические при запуске запускать строчку пользователей
Присваивать пользователям по проверки данных параметры
*/

function restartCheckId (pid)
{
	Players [pid] = {password = "null",
						mac = "null",
						getReg = "null",
						activate = false,
						reg = false,
					};		
}





// CHECK LOGIN
function checkLogin (pid)
{	
	local checkAccount = io.file ("database/" + getPlayerName (pid) + ".txt", "r")
	 if (checkAccount.isOpen){
		sendMessageToPlayer (pid, 255, 255, 255, "ENTER PASSWORD IN CHAT /login [password] ");
		Players[pid].reg = true;
		checkAccount.close ();
	 }
	 else {
		print (getPlayerName (pid) + " " + "Account Not Registration");
		sendMessageToPlayer (pid, 255,255,0, "Reigistration. Enter please /reg (password) (repeat password)");
		}
}
addEventHandler ("onPlayerJoin", checkLogin);





	// AUTHO

	function Authorization (pid, params, type)
				{		
					Players[pid].password = checkLine (pid, PStat.dbPassword);
					Players[pid].mac = checkLine (pid,PStat.dbMac);
					if (params == Players[0].password )
					{
						sendMessageToAll (0, 212, 155, getPlayerName(pid) + " conntected to server." );
						Players[pid].activate = true;
						callClientFunc (pid, "cEnterInput", false);

					}
					else if (Players[pid].mac == getPlayerMacAddr (pid) && type == "mac")
					{
						sendMessageToAll (0, 212, 155, getPlayerName(pid) + " conntected to server." );
						Players[pid].activate = true;
						callClientFunc (pid, "cEnterInput", false);
					}

					else 
					{
						sendMessageToPlayer (pid, 255, 0, 0, "Wrong password. Try: ");
					}
						
				}
			




	// REGISTRATION

function Registration (pid, params)
{
	print ("Registration enabled");
		Players[pid].getReg = params;
		if (Players [pid].getReg.len () >=6 && Players [pid].getReg.len ()<=16) 
		{
			sendMessageToPlayer (pid, 255,0,0, "Reigistration ENABLED");
			local regAccount = io.file ("database/" + getPlayerName (pid) + ".txt", "w");
			if(regAccount.isOpen)
			{
			regAccount.write (getPlayerName (pid)+"\n");
			regAccount.write (Players[pid].getReg +"\n");
			regAccount.write (getPlayerMacAddr (pid)+"\n");
			regAccount.write ("0\n");
			regAccount.write ("0\n");
			regAccount.write ("0\n");
			Players[pid].reg = true;
			Players[pid].activate = true;
			regAccount.close ();
			}
		}
		else 
		{
			sendMessageToPlayer (pid, 255,0,0, "WRONG! Min simvolos 6/ Max simvols 16");
		}
}	


function checkLine (pid, numb)
{
 	switch (numb)
 	{
 		case PStat.dbPassword:
 		local rPassword = io.file ("database/" + getPlayerName (pid) + ".txt", "r");
 		rPassword.read (io_type.LINE);
 		local result = rPassword.read (io_type.LINE);
 		rPassword.close();
 		return result;

 		case PStat.dbMac:
 		local rPassword = io.file ("database/" + getPlayerName (pid) + ".txt", "r");
 		rPassword.read (io_type.LINE);
 		rPassword.read (io_type.LINE);
 		local result = rPassword.read (io_type.LINE);
 		rPassword.close();
 		return result;

 	}	
}

function playerDisconnect (pid, reason){
	switch (reason){
		case DISCONNECTED:
		restartCheckId (pid)
		break;

		case LOST_CONNECTION:
		restartCheckId (pid)
		break;

		case HAS_CRASHED:
		restartCheckId (pid)
		break;
	}
}
addEventHandler("onPlayerDisconnect", playerDisconnect)







registerServerFunc ("enterInput", function(id, clientPass, type)
{
	switch (type){
		case "pass":
		if (Players[id].reg == true)
		{
		Authorization (id, clientPass,type);
		}
		break;

		case "mac":
		if (Players[id].reg == true)
		{
		Authorization (id, clientPass,type);
		}	
		break;

		case "reg":
		if (Players[id].reg == false)
		{	
		Registration (id, clientPass);
		}
		break;

	}	
	
});

