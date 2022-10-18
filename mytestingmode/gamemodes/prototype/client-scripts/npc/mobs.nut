local wolf = null
local test_npc = null


function spawnWolf()
{
	spawnNpc(wolf, "WOLF")
	
	setPlayerPosition(wolf, 180, -91, -1948)
	setPlayerColor(wolf, 255, 0, 0)
	setPlayerStrength(wolf, 50)
	setPlayerHealth(wolf, 200)
	setPlayerMaxHealth(wolf, 200)
}

local function Wolf_AI()
{
	if (isPlayerDead(wolf) || isPlayerDead(heroId)) return

	local hPos = getPlayerPosition(heroId)
	local wPos = getPlayerPosition(wolf)
	
	local dist = getDistance3d(hPos.x, hPos.y, hPos.z, wPos.x, wPos.y, wPos.z)
	if (dist <= 600)
	{
		local angle = getVectorAngle(wPos.x, wPos.z, hPos.x, hPos.z)
		setPlayerAngle(wolf, angle)
	
		if (dist <= 200)
		{
			playAni(wolf, "S_FISTATTACK")
			hitPlayer(wolf, heroId)
		}
		else
			playAni(wolf, "S_FISTRUNL")
	}
	else
		playAni(wolf, "S_FISTRUN")
}

local function hitHandlerNpc(kid, pid, dmg)
{
	print (kid + " " + pid + " -> " + dmg)
}

addEventHandler("onPlayerHit", hitHandlerNpc)

local function deadNpc(pid, kid)
{
	print ("Die: " + pid)

	if (pid == wolf)
	{
		unspawnNpc(pid)
		giveItem (kid, Items.id (ITMI_GOLD), 100);
		spawnWolf()
	}
}

addEventHandler("onPlayerDead", deadNpc)

local function initHandler()
{
	// Test NPC
	test_npc = createNpc("Brahim")
	spawnNpc(test_npc)
	setPlayerPosition(test_npc, 1310, -90, 332)
	setPlayerAngle(test_npc, 270)
	setPlayerColor(test_npc, 0, 0, 200)
	setPlayerHealth(test_npc, 1000)
	setPlayerMaxHealth(test_npc, 1000)
	setPlayerVisual(test_npc, "Hum_Body_Naked0", 1, "Hum_Head_Bald", 10)
	
	equipItem(test_npc, Items.id("ITAR_VLK_L"))
	playAni(test_npc, "S_HGUARD")
	
	// Our pet
	wolf = createNpc("Soiref")
	print("Soiref id: " + wolf)
	spawnWolf()
	
	setTimer(Wolf_AI, 1000, 0)
}

addEventHandler("onInit", initHandler)