
function allCreateUser (pid)
{
	for (local i = 0; i<Player.len (); i++)
	{
		Player [i] = {_hp = 500,
			_strength = 50,
			_agility = 50,
			_mo = 60,
			_md = 60,
			_mb = 60,
			_ma = 60,
			_team = "null", 
			_kill = 0,
			_death = 0,
			_gunOne = "null",
			_gunTwo = "null",
			_armor = "null",
			_gold = 0,
		}
	}

}
addEventHandler ("onInit", allCreateUser);



function createUser (pid)
{
		Player [pid] = {_hp = 500,
			_strength = 50,
			_agility = 50,
			_mo = 60,
			_md = 60,
			_mb = 60,
			_ma = 60,
			_team = "null", 
			_kill = 0,
			_death = 0,
			_gunOne = "null",
			_gunTwo = "null",
			_armor = "null",
			_gold = 0
		}
}
addEventHandler ("onPlayerJoin", createUser);




function playerStat (pid)
{
	
	spawnPlayer(pid)
	setPlayerHealth(pid, Player[pid]._hp)
	setPlayerMaxHealth(pid, Player[pid]._hp)
	setPlayerStrength(pid, Player[pid]._strength)
	setPlayerDexterity(pid, Player[pid]._agility)
		
	setPlayerSkillWeapon(pid, WEAPON_1H, Player[pid]._mo)
	setPlayerSkillWeapon(pid, WEAPON_2H, Player[pid]._md)
	setPlayerSkillWeapon(pid, WEAPON_BOW, Player[pid]._mb)
	setPlayerSkillWeapon(pid, WEAPON_CBOW, Player[pid]._ma)

	if (Player[pid]._team == "Bandit")

		{
		setPlayerPosition(pid, 1.6, -627, -3554); setPlayerAngle (pid, 180)	
		setPlayerColor (pid, 255, 0, 0)
		giveItem (pid, Items.id (Player [pid]._armor), 1)
		giveItem (pid, Items.id (Player [pid]._gunOne),1)
		equipItem (pid, Items.id (Player [pid]._armor))
		equipItem (pid, Items.id (Player [pid]._gunOne))
		}
		else if (Player[pid]._team == "Milicia")
		{
		setPlayerColor (pid, 0, 0, 255)
		setPlayerPosition(pid, -70, -684, -9662);setPlayerAngle (pid, 0)
		giveItem (pid, Items.id (Player [pid]._armor), 1)
		giveItem (pid, Items.id (Player [pid]._gunOne),1)
		equipItem (pid, Items.id (Player [pid]._armor))
		equipItem (pid, Items.id (Player [pid]._gunOne))	
		}

		
}



function playerRespawn (pid)
{
	getPlayerStat (pid);

	if (Player[pid]._team == "Bandit")
		{
		setPlayerPosition(pid, 1.6, -627, -3554); setPlayerAngle (pid, 180)	
		setPlayerColor (pid, 255, 0, 0)
		getPlayerItems (pid);
		spawnPlayer(pid);
		}
		else if (Player[pid]._team == "Milicia")
		{
		setPlayerColor (pid, 0, 0, 255)
		setPlayerPosition(pid, -70, -684, -9662);setPlayerAngle (pid, 0)
		getPlayerItems (pid);
		spawnPlayer(pid);	
		}

}
addEventHandler("onPlayerRespawn", playerRespawn)


	function teamSelect (pid, team)
	{
		if (Players[pid].activate == true)
		{
			switch (team)
			{
				case "Bandit":
				Player [pid]._team = "Bandit"
				Player [pid]._gunOne = "ITMW_SHORTSWORD2";
				Player [pid]._armor = "ITAR_BDT_M";
				playerStat (pid);
				break

				case "Milicia":
				Player [pid]._team = "Milicia"
				Player [pid]._gunOne = "ITMW_SHORTSWORD1";
				Player [pid]._armor = "ITAR_MIL_L";
				playerStat (pid);
				break
			}
		}
	}
	
registerServerFunc ("choiceFraction", function(id, team)
{
	teamSelect (id,team);
})



function getPlayerStat (pid)
{
	setPlayerHealth(pid, Player[pid]._hp)
	setPlayerMaxHealth(pid, Player[pid]._hp)
	setPlayerStrength(pid, Player[pid]._strength)
	setPlayerDexterity(pid, Player[pid]._agility)
		
	setPlayerSkillWeapon(pid, WEAPON_1H, Player[pid]._mo)
	setPlayerSkillWeapon(pid, WEAPON_2H, Player[pid]._md)
	setPlayerSkillWeapon(pid, WEAPON_BOW, Player[pid]._mb)
	setPlayerSkillWeapon(pid, WEAPON_CBOW, Player[pid]._ma)

}
function getPlayerItems (pid)
{
		giveItem (pid, Items.id (Player [pid]._armor), 1)
		giveItem (pid, Items.id (Player [pid]._gunOne),1)
		equipItem (pid, Items.id (Player [pid]._armor))
		equipItem (pid, Items.id (Player [pid]._gunOne))
		if (Player [pid]._gunTwo != "null")
		{
			giveItem (pid, Items.id (Player [pid]._gunTwo),1)
			equipItem (pid, Items.id (Player [pid]._gunTwo))
		}
}
