local GUIWindowBoxClasses = classes(GUI.Window, GUI.Offset)
class GUI.WindowBox extends GUIWindowBoxClasses
{
#public:
	topBar = null
	title = null
	minimizeButton = null
	closeButton = null

	constructor(x, y, w, h, backgroundFile, topBarFile, minimizeButtonFile, closeButtonFile, text = "", enabled = true)
	{
		local buttonWidth = anx(WINDOWBOX_BUTTON_WIDTH)
		local topBarHeight = any(WINDOWBOX_TOPBAR_HEIGHT)

		base.constructor(x, y + topBarHeight, w, h - topBarHeight, backgroundFile, null, enabled)
		GUI.Offset.constructor.call(this)

		topBar = GUI.Texture(x, y, w, topBarHeight, topBarFile)
		topBar.parent = this

		topBar.bind(EventType.MouseDown, function(self, button)
		{
			if (button != MOUSE_LMB)
				return

			local cursorPosition = getCursorPositionPx()
			local position = self.getPositionPx()

			GUI.Window.setCursorOffset(position.x - cursorPosition.x, position.y - cursorPosition.y)
			GUI.Window.setActiveWindow(self.parent)
		})

		m_offsetPx.x = 5
		
		title = GUI.Draw(x + m_offsetPx.x, y + m_offsetPx.y, text)
		title.setDisabled(true)
		title.parent = this

		minimizeButton = GUI.Button(x + w - buttonWidth * 2, y, buttonWidth, topBarHeight, "", "_")
		minimizeButton.setOffsetPx(0, -6)
		minimizeButton.parent = this

		minimizeButton.bind(EventType.Click, function(self)
		{
			local parent = self.parent
			GUI.Window.setVisible.call(parent, !parent.getVisible())
		})

		closeButton = GUI.Button(x + w - buttonWidth, y, buttonWidth, topBarHeight, "", "X")
		closeButton.parent = this

		closeButton.bind(EventType.Click, function(self)
		{
			self.parent.setVisible(false)
		})
	}

	function setOffsetPx(x, y)
	{
		GUI.Offset.setOffsetPx.call(this, x, y)
		title.setPositionPx(x + m_offsetPx.x, y + m_offsetPx.y)
	}

	function insert(pointer)
	{
		if (getChildIdx(pointer) != -1)
			return

		local bodyPos = base.getPositionPx()
		local childPos = pointer.getPositionPx()

		childs.push({offset = clone childPos, pointer = pointer})
		pointer.setPositionPx(bodyPos.x + childPos.x, bodyPos.y + childPos.y)
	}

	function setVisible(visible)
	{
		base.setVisible(visible)

		topBar.setVisible(visible)
		title.setVisible(visible)
		minimizeButton.setVisible(visible)
		closeButton.setVisible(visible)
	}

	function getPositionPx()
	{
		local position = base.getPositionPx()
		position.y -= topBar.getSizePx().height

		return position
	}

	function setPositionPx(x, y)
	{
		local size = getSizePx()

		base.setPositionPx(x, y + topBar.getSizePx().height)

		topBar.setPositionPx(x, y)
		title.setPositionPx(x + m_offsetPx.x, y + m_offsetPx.y)
		minimizeButton.setPositionPx(x + size.width - closeButton.getSizePx().width - minimizeButton.getSizePx().width, y)
		closeButton.setPositionPx(x + size.width - closeButton.getSizePx().width, y)
	}

	function getSizePx()
	{
		local size = base.getSizePx()
		size.height -= topBar.getSizePx().height

		return size
	}

	function setSizePx(width, height)
	{
		base.setSizePx(width, height - topBar.getSizePx().height)
	}
}