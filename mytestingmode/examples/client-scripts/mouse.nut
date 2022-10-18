enum Color
{
	RED,
	GREEN,
	BLUE
}

local drawPos = null
local currColor = Color.RED
local colorValue = 150

local function init()
{
	setCursorVisible(true)
	
	drawPos = Draw(0, 0, "")
	drawPos.setColor(150, 0, 0)
	drawPos.visible = true
}

addEventHandler("onInit", init)

local function mouseClick(btn)
{
	colorValue = 150
	
	switch (btn)
	{
	case MOUSE_LMB:
		currColor = Color.RED
		drawPos.setColor(colorValue, 0, 0)
		break
		
	case MOUSE_RMB:
		currColor = Color.GREEN
		drawPos.setColor(0, colorValue, 0)
		break
		
	case MOUSE_MMB:
		currColor = Color.BLUE
		drawPos.setColor(0, 0, colorValue)
		break
	}
}

addEventHandler("onMouseClick", mouseClick)

local function mouseRelease(btn)
{
	local pos = getCursorPositionPx()
	
	drawPos.text = format("%d, %d", pos.x, pos.y)
	drawPos.setPositionPx(pos.x, pos.y)
}

addEventHandler("onMouseRelease", mouseRelease)

local function mouseWheel(value)
{
	colorValue += (value * 5)

	switch (currColor)
	{
	case Color.RED:
		drawPos.setColor(colorValue, 0, 0)
		break
		
	case Color.GREEN:
		drawPos.setColor(0, colorValue, 0)
		break
		
	case Color.BLUE:
		drawPos.setColor(0, 0, colorValue)
		break
	}
}

addEventHandler("onMouseWheel", mouseWheel)