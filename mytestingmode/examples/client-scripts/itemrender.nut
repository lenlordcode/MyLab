// constants
local ROT_VELOCITY = 7

// variables
local item, bStartAnimate

local function onInit()
{
    item = ItemRender(1500, 500, 2000, 5000, "ITMW_2H_SPECIAL_04")
    item.visible = true
    bStartAnimate = false
}

addEventHandler("onInit", onInit)

local function commandHandler(cmd, params)
{
    switch (cmd)
	{
	    case "light":
            item.lightingswell = !item.lightingswell
		break

        case "animate":
            item.zbias = 102
            item.rotY = 224
            item.rotZ = 168
            bStartAnimate = !bStartAnimate

            enableEvent_Render(bStartAnimate)
        break
	}
}

addEventHandler("onCommand", commandHandler)

local function keyHandler(key)
{
    switch(key)
    {
        case KEY_X:
            if(item.rotX >= 360)
                item.rotX = 0

            item.rotX += ROT_VELOCITY
        break

        case KEY_Y:
            if(item.rotY >= 360)
                item.rotY = 0

            item.rotY += ROT_VELOCITY
        break

        case KEY_Z:
            if(item.rotZ >= 360)
                item.rotZ = 0

            item.rotZ += ROT_VELOCITY
        break

        case KEY_END:
            item.zbias += 1
        break

        case KEY_INSERT:
            item.zbias -= 1
        break
    }
}

addEventHandler("onKey", keyHandler)

local function renderHandler()
{
    if(item && bStartAnimate)
    {
        if(item.rotX > 360) item.rotX = 0

        item.rotX += 1
    }
}

addEventHandler("onRender", renderHandler)