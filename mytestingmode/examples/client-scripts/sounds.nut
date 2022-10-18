local sound = null
local sound3d = null
local vob = null
local npc = null

local function initHandler()
{
	// Npc
	npc = createNpc("Abuyin")
	spawnNpc(npc)
	setPlayerPosition(npc, 500, -90, 0)
	setPlayerAngle(npc, 270)
	setPlayerColor(npc, 255, 255, 255)
	setPlayerHealth(npc, 1000)
	setPlayerMaxHealth(npc, 1000)
	setPlayerVisual(npc, "Hum_Body_Naked0", 3, "Hum_Head_Bald", 134)
	equipItem(npc, Items.id("ITAR_VLK_M"))

	// Sound 2d
	sound = Sound("DRG_ATTACK_02.WAV")
	sound.looping = false
	sound.balance = 1.0

	sound3d = Sound3d("DIA_ABUYIN_ANDEREN_13_04.WAV")
	sound3d.looping = true
	sound3d.radius = 2500

	vob = Vob("MIN_ORE_BIG_V1.3DS")
	vob.setPosition(0, 0, 800)
	vob.addToWorld()
	
	print("Time (msec): " + sound.playingTime)
	print("Time 3d (msec): " + sound3d.playingTime)
}

addEventHandler("onInit", initHandler)

local function commandHandler(cmd, params)
{
	switch (cmd)
	{
	case "play":
		sound.play()
		break
		
	case "play3d":
		sound3d.stop()
		sound3d.setTargetVob(vob)
		sound3d.play()
		break
		
	case "playVoice":
		sound3d.stop()
		sound3d.setTargetPlayer(npc)
		sound3d.play()
		break
		
	case "volume":
		sound3d.volume = 0.5
		break
	}
}

addEventHandler("onCommand", commandHandler)