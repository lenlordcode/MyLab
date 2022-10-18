GUI <- {}

enum Orientation
{
	Horizontal,
	Vertical
}

enum Align
{
    Center,
    Left,
    Right
}

const DRAW_SHRINK_TO_FIT = false

const TOOLTIP_INTERVAL = 500

const RANGE_INDICATOR_SIZE = 25

const SCROLLBAR_BUTTON_SIZE = 25
const SCROLLBAR_DRAG_DISTANCE = 135

const WINDOWBOX_BUTTON_WIDTH = 45
const WINDOWBOX_TOPBAR_HEIGHT = 20

const TAB_WIDTH = 100
const TAB_HEIGHT = 33

const SCROLLBAR_SIZE = 20

/////////////////////
// OOP Event types //
/////////////////////
enum EventType
{
	Render,
	Click,
	TakeFocus,
	LostFocus,
	MouseIn,
	MouseOut,
	MouseMove,
	MouseUp,
	MouseDown,
	Change,
	Switch,
	InsertLetter,
	RemoveLetter,
	Max
}

////////////////////
// Global Events //
///////////////////
addEvent("GUI.onRender")
addEvent("GUI.onClick")

// base.nut
addEvent("GUI.onTakeFocus")
addEvent("GUI.onLostFocus")

addEvent("GUI.onMouseIn")
addEvent("GUI.onMouseOut")

addEvent("GUI.onMouseMove")

addEvent("GUI.onMouseUp")
addEvent("GUI.onMouseDown")

// range.nut
addEvent("GUI.onChange")

// tabpanel.nut
addEvent("GUI.onSwitch")

// input.nut
addEvent("GUI.onInputInsertLetter")
addEvent("GUI.onInputRemoveLetter")


//Main init func
addEventHandler("onInit",function()
{
	enableEvent_Render(true)

	//Information about the authors
	print("## Gui Engine 2.0 successfully loaded ##")
	print("- Author Tommy & Patrix")
})
