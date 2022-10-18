class GUI.Draw extends GUI.Base
{
#private:
	m_positionPx = null
	m_sizePx = null
	m_lineSizePx = 0

	m_text = ""
	m_font = "FONT_OLD_10_WHITE_HI.TGA"

	m_color = null
	m_alpha = 255
	m_parent = null

	m_draws = null
	m_drawsCount = 0

	constructor(x, y, text, window = null, colorParserEnabled = true)
	{
		base.constructor()

		m_draws = [Draw(x, y, "")]
		m_drawsCount = 1

		m_color = {r = 255, g = 255, b = 255}

		m_positionPx = {x = nax(x), y = nay(y)}
		m_sizePx = {width = 0, height = 0}

		updateLineSize()
		setText(text, colorParserEnabled)

		if (window)
			window.insert(this)
	}

	function leftPx(x, y, width, height)
	{
		local size = getSizePx()

		if (!size.width && !size.height)
			return

		centerPx(x, y, width, height)

		local position = getPositionPx()
		setPositionPx(x, position.y)
	}

	function left(x, y)
	{
		leftPx(nax(x), nay(y))
	}

	function centerPx(x, y, width, height)
	{
		if (!width && !height)
			return

		local size = getSizePx()

		if (!size.width && !size.height)
			return

		local centerX = x + (width - size.width) / 2
		local centerY = y + (height - size.height) / 2

		setPositionPx(centerX, centerY)
	}

	function center(x, y, width, height)
	{
		centerPx(nax(x), nay(y), nax(width), nay(height))
	}

	function rightPx(x, y, width, height)
	{
		local size = getSizePx()

		if (!size.width && !size.height)
			return

		centerPx(x, y, width, height)
		local position = getPositionPx()

		local rightX = x + (width - size.width)
		setPositionPx(rightX, position.y)
	}

	function right(x, y, width, height)
	{
		rightPx(nax(x), nay(y), nax(width), nay(height))
	}

	function updateLineSize()
	{
		local oldFont = textGetFont()

		textSetFont(m_font)
		m_lineSizePx = letterHeightPx()
		textSetFont(oldFont)
	}

	function setVisible(visible)
	{
		base.setVisible(visible)

		for (local i = 0; i != m_drawsCount; ++i)
			m_draws[i].visible = visible
	}

	function getPositionPx()
	{
		return m_positionPx
	}

	function setPositionPx(x, y)
	{
		for (local i = 0; i != m_drawsCount; ++i)
		{
			local draw = m_draws[i]
			local drawPosition = draw.getPositionPx()

			draw.setPositionPx(drawPosition.x + (x - m_positionPx.x), drawPosition.y + (y - m_positionPx.y))
		}

		m_positionPx.x = x
		m_positionPx.y = y
	}

	function getPosition()
	{
		return {x = anx(m_positionPx.x), y = any(m_positionPx.y)}
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function getSizePx()
	{
		return m_sizePx
	}

	function getSize()
	{
		return {width = anx(m_sizePx.width), height = any(m_sizePx.height)}
	}

	function getLineSizePx()
	{
		return m_lineSizePx
	}

	function setLineSizePx(lineSize)
	{
		m_lineSizePx = lineSize
		setPositionPx(m_positionPx.x, m_positionPx.y)
	}

	function getLineSize()
	{
		return any(getLineSizePx())
	}

	function setLineSize(lineSize)
	{
		setLineSizePx(any(lineSize))
	}

	function getLinesCount()
	{
		return getSizePx().height / getLineSizePx()
	}

	function top()
	{
		base.top()

		for (local i = 0; i != m_drawsCount; ++i)
			m_draws[i].top()
	}

	function parse(text, colorParserEnabled = true)
	{
		local info = []

		local expression = "\\n"
		expression += (colorParserEnabled) ? "|" + @"\[#[0-9_a-f_A-F]{6,}]" : ""

		local regex = regexp(expression)

		local currentPosition = 0
		local currentColor = m_color

		m_text = ""

		local result = null
		while (result = regex.search(text, currentPosition))
		{
			local isEOLFound = (result.end - result.begin == 1)
			local endPosition = (isEOLFound) ? result.end - 1 : result.begin

			local slicedText = text.slice(currentPosition, endPosition)

			if (slicedText != "" || isEOLFound)
			{
				info.push({text = slicedText, color = currentColor, newLine = isEOLFound})
				m_text += slicedText
			}

			currentPosition = result.end
			currentColor = (isEOLFound) ? currentColor : hexToRgb(text.slice(result.begin + 2, result.end - 1))
		}

		local slicedText = text.slice(currentPosition, text.len())

		m_text += slicedText
		info.push({text = slicedText, color = currentColor, newLine = false})

		if (info.len())
			return info

		return null
	}

	function getText()
	{
		return m_text
	}

	function setText(text, colorParserEnabled = true)
	{
		if (typeof text != "string")
			text = text.tostring()

		if (text == "")
		{
			foreach (draw in m_draws)
				draw.text = ""

			m_drawsCount = 0

			return
		}
			
		local x = m_positionPx.x, y = m_positionPx.y
		local width = 0, height = m_lineSizePx
			
		local i = 0
		foreach (info in parse(text, colorParserEnabled))
		{
			local draw = null

			if (info.text != "")
			{
				if (m_draws.len() <= i)
					m_draws.push(Draw(0, 0, ""))

				draw = m_draws[i]

				draw.setPositionPx(x, y)

				draw.setColor(info.color.r, info.color.g, info.color.b)
				draw.alpha = m_alpha

				draw.font = m_font
				draw.text = info.text

				draw.visible = m_visible
			}

			if (info.newLine)
			{
				local lineWidth = x - m_positionPx.x

				if (lineWidth > width)
					width = lineWidth

				height += m_lineSizePx

				x = m_positionPx.x
				y += m_lineSizePx

			}
			else if (draw)
				x += draw.widthPx
				
			++i
		}

		local lineWidth = x - m_positionPx.x

		if (lineWidth > width)
			width = lineWidth

		m_sizePx.width = width
		m_sizePx.height = height

		m_drawsCount = i

		for (local i = m_draws.len() - 1; i >= m_drawsCount; --i)
			m_draws[i].visible = false

	}

	function getFont()
	{
		return m_font
	}

	function setFont(font)
	{
		if (font == m_font)
			return

		m_font = font

		updateLineSize()
		setText(getText())
	}

	function getColor()
	{
		return m_color
	}

	function setColor(r, g, b)
	{
		m_color.r = r
		m_color.g = g
		m_color.b = b

		for (local i = 0; i != m_drawsCount; ++i)
			m_draws[i].setColor(r, g, b)
	}

	function getAlpha()
	{
		return m_alpha
	}

	function setAlpha(alpha)
	{
		m_alpha = alpha

		for (local i = 0; i != m_drawsCount; ++i)
			m_draws[i].alpha = alpha
	}
}
