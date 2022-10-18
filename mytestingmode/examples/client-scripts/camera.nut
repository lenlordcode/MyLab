local vob = null
local mob = null

/*

	CAMERA MODES
	
	"CAMMODNORMAL"
	"CAMMODRUN"
	"CAMMODDIALOG"
	"CAMMODINVENTORY"
	"CAMMODMELEE"
	"CAMMODMAGIC"
	"CAMMODMELEEMULT"
	"CAMMODRANGED"
	"CAMMODSWIM"
	"CAMMODDIVE"
	"CAMMODJUMP"
	"CAMMODJUMPUP"
	"CAMMODCLIMB"
	"CAMMODDEATH"
	"CAMMODLOOK"
	"CAMMODLOOKBACK"
	"CAMMODFOCUS"
	"CAMMODRANGEDSHORT"
	"CAMMODSHOULDER"
	"CAMMODFIRSTPERSON"
	"CAMMODTHROW"
	"CAMMODMOBLADDER"
	"CAMMODFALL"

*/

local function initHandler()
{
	vob = Vob("MIN_ORE_BIG_V1.3DS")
	vob.setPosition(0, 0, 0)
	vob.addToWorld()
	
	mob = Mob("MIN_ORE_BIG_V1.3DS")
	mob.setPosition(0, 0, 300)
	mob.addToWorld()
	
	// Disable changing camera mode by Gothic
	// So for now Gothic won't change ur camera mode for example while fighting
	Camera.modeChangeEnabled = false
}

addEventHandler("onInit", initHandler)

local movement = false

local function commandHandler(cmd, params)
{
	switch (cmd)
	{
	case "camlookback":
		Camera.mode = "CAMMODLOOKBACK"
		break
		
	case "camfall":
		Camera.mode = "CAMMODFALL"
		break
		
	case "caminv":
		Camera.mode = "CAMMODINVENTORY"
		break
		
	case "camvob":
		Camera.setTargetVob(vob)
		break
		
	case "cammob":
		Camera.setTargetVob(mob)
		break
		
	case "camhero":
		Camera.setTargetPlayer(heroId)
		break
		
	case "camai":
		Camera.movementEnabled = movement
		movement = !movement
		break
	}
}

addEventHandler("onCommand", commandHandler)

local rot = {x=0, y=0, z=0}

local function keyHandler(key)
{
	switch (key)
	{
	case KEY_X:
		rot.x += 5
		if (rot.x > 350) rot.x = 0
		
		Camera.setRotation(rot.x, rot.y, rot.z)
		break
		
	case KEY_Y:
		rot.y += 5
		if (rot.y > 350) rot.y = 0
		
		Camera.setRotation(rot.x, rot.y, rot.z)
		break
		
	case KEY_Z:
		rot.z += 5
		if (rot.z > 350) rot.z = 0
		
		Camera.setRotation(rot.x, rot.y, rot.z)
		break
	}
}

addEventHandler("onKey", keyHandler)