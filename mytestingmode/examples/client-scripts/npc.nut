local wolf = null
local test_npc = null

function spawnWolf()
{
	spawnNpc(wolf, "WOLF")
	
	setPlayerPosition(wolf, 180, -91, -1948)
	setPlayerColor(wolf, 255, 0, 0)
	setPlayerStrength(wolf, 200)
	setPlayerHealth(wolf, 1000)
	setPlayerMaxHealth(wolf, 1000)
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

local function hitHandler(kid, pid, dmg)
{
	print (kid + " " + pid + " -> " + dmg)
}

addEventHandler("onPlayerHit", hitHandler)

local function deadHandler(pid)
{
	print ("Die: " + pid)

	if (pid == wolf)
	{
		unspawnNpc(pid)
		spawnWolf()
	}
}

addEventHandler("onPlayerDead", deadHandler)

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
}

addEventHandler("onInit", initHandler)