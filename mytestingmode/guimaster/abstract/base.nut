local _getroottable = getroottable
local elementPointedByCursor = null
local focusedElement = null

class GUI.Base
{
	static m_objects = []

#protected:
	m_id = -1

	m_visible = false
	m_isDisabled = false
	m_events = null

#public:
	toolTip = null
	parent = null

	constructor()
	{
		m_events = array(EventType.Max)
	}

	function bind(event_type, callback) {
		local events = m_events[event_type] || []
		if (events.len() == 0) {
			m_events[event_type] = events
		}

		events.push(callback)
	}

	function call(event_type, ...) {
		local events = m_events[event_type]
		if (events == null) return

		// Context + This GUI element
		vargv.insert(0, _getroottable())
		vargv.insert(1, this)

		foreach (callback in events) {
			callback.acall(vargv)
		}
	}

	function destroy()
	{
		if (elementPointedByCursor == this)
			elementPointedByCursor = null

		if(focusedElement == this)
			focusedElement = null

		if (toolTip)
		{
			if (toolTip.getToolTip(this))
				delete toolTip.m_toolTip[this]

			toolTip = null
		}

		removeFromArray()
	}

	function addToArray()
	{
		m_id = m_objects.len()
		m_objects.push(this)
	}

	function removeFromArray()
	{
		if (m_id == -1)
			return

		for (local i = m_objects.len() - 1; i > m_id; --i)
			--m_objects[i].m_id

		m_objects.remove(m_id)
		m_id = -1
	}

	function top()
	{
		if (!m_visible)
			return

		removeFromArray()
		addToArray()
	}

	function getVisible()
	{
		return m_visible
	}

	function setVisible(visible)
	{
		if (m_visible == visible)
			return

		if (!visible)
		{
			if (this == focusedElement)
				loseFocus()

			removeFromArray()
		}
		else
			addToArray()

		m_visible = visible
	}

	function getDisabled()
	{
		return m_isDisabled
	}

	function setDisabled(disabled)
	{
		if (disabled && isFocused())
			loseFocus()

		m_isDisabled = disabled
	}

	function checkIsMouseAt()
	{
		if (!isCursorVisible())
			return false

		local texPosition
		local texSize

		if (base)
		{
			texPosition = base.getPositionPx()
			texSize = base.getSizePx()
		}
		else
		{
			texPosition = getPositionPx()
			texSize = getSizePx()
		}

		local cursorPosition = getCursorPositionPx()

		if (cursorPosition.x >= texPosition.x && cursorPosition.x <= texPosition.x + texSize.width
		&& cursorPosition.y >= texPosition.y && cursorPosition.y <= texPosition.y + texSize.height)
			return true

		return false
	}

	function isMouseAt()
	{
		return elementPointedByCursor == this
	}

	function isFocused()
	{
		return focusedElement == this
	}

	function takeFocus()
	{
		focusedElement = this

		call(EventType.TakeFocus)
		callEvent("GUI.onTakeFocus", this)
	}

	function loseFocus()
	{
		local tmpRef = focusedElement
		focusedElement = null

		tmpRef.call(EventType.LostFocus)
		callEvent("GUI.onLostFocus", tmpRef)
	}

	static function getElementPointedByCursor()
	{
		return elementPointedByCursor
	}

	static function getFocusedElement()
	{
		return focusedElement
	}

	static function uncheckElementPointedByCursor()
	{
		elementPointedByCursor.call(EventType.MouseOut)
		callEvent("GUI.onMouseOut", elementPointedByCursor)
		elementPointedByCursor = null
	}

	static function onRender()
	{
		local cursorPosition = getCursorPositionPx()
		local deltaTime = getFrameTime()

		foreach (object in GUI.Base.m_objects)
		{
			if (!object.getVisible())
				continue

			object.call(EventType.Render)
			callEvent("GUI.onRender", object)
		}
	}

	static function onMouseMove(newCursorX, newCursorY, oldCursorX, oldCursorY)
	{
		if (elementPointedByCursor && !elementPointedByCursor.getVisible())
			GUI.Base.uncheckElementPointedByCursor()

		for (local i = GUI.Base.m_objects.len() - 1; i >= 0; --i)
		{
			local object = GUI.Base.m_objects[i]

			if (!object.getVisible())
				continue

			if (object.m_isDisabled)
				continue

			if (object.m_visible && object.checkIsMouseAt())
			{
				if (object != elementPointedByCursor)
				{
					if (elementPointedByCursor)
						GUI.Base.uncheckElementPointedByCursor()

					elementPointedByCursor = object
					object.call(EventType.MouseIn)
					callEvent("GUI.onMouseIn", object)
				}
				else {
					object.call(EventType.MouseMove, newCursorX, newCursorY, oldCursorX, oldCursorY)
					callEvent("GUI.onMouseMove", object, newCursorX, newCursorY, oldCursorX, oldCursorY)
				}

				break
			}
			else if (object == elementPointedByCursor)
				GUI.Base.uncheckElementPointedByCursor()
		}
	}

	static function onMouseClick(button)
	{
		if (elementPointedByCursor && !elementPointedByCursor.getVisible())
			GUI.Base.uncheckElementPointedByCursor()

		if (elementPointedByCursor)
		{
			if (elementPointedByCursor != focusedElement)
			{
				if (focusedElement)
					focusedElement.loseFocus()

				elementPointedByCursor.takeFocus()
			}

			elementPointedByCursor.call(EventType.MouseDown, button)
			callEvent("GUI.onMouseDown", elementPointedByCursor, button)
		}
		else if (focusedElement)
			focusedElement.loseFocus()
	}

	static function onMouseRelease(button)
	{
		if (focusedElement)
		{
			focusedElement.call(EventType.MouseUp, button)
			callEvent("GUI.onMouseUp", focusedElement, button)

			if (button == MOUSE_LMB) {
				focusedElement.call(EventType.Click)
				callEvent("GUI.onClick", focusedElement)
			}
		}
	}
}

addEventHandler("onRender", GUI.Base.onRender)
addEventHandler("onMouseMove", GUI.Base.onMouseMove)
addEventHandler("onMouseClick", GUI.Base.onMouseClick)
addEventHandler("onMouseRelease", GUI.Base.onMouseRelease)
