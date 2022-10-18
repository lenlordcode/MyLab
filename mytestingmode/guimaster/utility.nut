///////////////
//	Functions
///////////////

/*
	getResolutionChangedScale
*/

local oldResolution = getResolution()
local newResolution = getResolution()

addEventHandler("onChangeResolution", function()
{
	oldResolution = newResolution
	newResolution = getResolution()
})

function getResolutionChangedScale()
{
	local result =
	{
		x = newResolution.x.tofloat() / oldResolution.x.tofloat(),
		y = newResolution.y.tofloat() / oldResolution.y.tofloat()
	}

	return result
}

/*
	getFrameTime
*/

local before = getTickCount()

addEventHandler("onInit", function()
{
	addEventHandler("onRender", function()
	{
		before = getTickCount()
	})
})

function getFrameTime()
{
	return getTickCount() - before
}

function getFrameTimeF()
{
	return getFrameTime() / 1000.0
}

///////////////
//	Events
///////////////

/*
	onMouseMove event
*/

addEvent("onMouseMove")

local oldCursorPosition = getCursorPositionPx()

addEventHandler("onRender", function()
{
	if (!isCursorVisible())
		return

	local cursorPosition = getCursorPositionPx()

	if (cursorPosition.x == oldCursorPosition.x && cursorPosition.y == oldCursorPosition.y)
		return

	callEvent("onMouseMove", cursorPosition.x, cursorPosition.y, oldCursorPosition.x, oldCursorPosition.y)

	oldCursorPosition.x = cursorPosition.x
	oldCursorPosition.y = cursorPosition.y
})
