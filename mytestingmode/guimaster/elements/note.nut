local GUINoteClasses = classes(GUI.Texture, GUI.Margin, GUI.Alignment)
class GUI.Note extends GUINoteClasses
{
#private:
	m_font = "FONT_OLD_10_WHITE_HI.TGA"
	m_lineSpacingPx = 0
	m_separator = " "
	m_visibleLinesCount = 0
	m_LinesCount = 0
	m_isWordsPerLine = true
	m_text = ""
	m_scrollValue = 0

#public:
	visibleLines = null
	lines = null
	scrollbar = null

	constructor(x, y, width, height, file, scrollBg, scrollIndicator, scrollIncreaseBtn, scrollDecreaseBtn, text, window = null)
    {
        visibleLines = []
        lines = []

        local oldFont = textGetFont()

        textSetFont(m_font)
        m_lineSpacingPx = letterHeightPx()
        textSetFont(oldFont)

        GUI.Margin.constructor.call(this)
        base.setAlignment(Align.Left)

        scrollbar = GUI.ScrollBar(x + width, y, anx(SCROLLBAR_SIZE), height, scrollBg, scrollIndicator, scrollIncreaseBtn, scrollDecreaseBtn, Orientation.Vertical)
        base.constructor(x, y, width, height, file, window)

        scrollbar.parent = this
        scrollbar.setMinimum(0)
        scrollbar.setMaximum(0)
        scrollbar.top()

        m_text = text
        updateVisibleLines()
    }

	function updateVisibleLines()
	{
		local oldFont = textGetFont()
		local visible = getVisible()
		local oldVisibleLinesCount = m_visibleLinesCount
		local pos = getPositionPx()
		local margin = getMarginPx()

		textSetFont(m_font)
		m_visibleLinesCount = (getSizePx().height - margin.top - margin.bottom - letterHeightPx())/m_lineSpacingPx

		if(m_visibleLinesCount > oldVisibleLinesCount)
		{
			for(local i = oldVisibleLinesCount; i < m_visibleLinesCount; ++i)
			{
				visibleLines.append(GUI.Draw(0, 0, ""))
				visibleLines[i].setVisible(visible)
				visibleLines[i].setDisabled(true)
			}
		}

		else
		{
			for(local i = oldVisibleLinesCount - 1; i >= m_visibleLinesCount; --i)
			{
				visibleLines[i] = visibleLines[i].destroy()
				visibleLines.remove(i)
			}
		}

		local marginPosX = pos.x + margin.left
		local marginPosY = pos.y + margin.top
		for(local i = 0; i < m_visibleLinesCount; ++i)
		{
			visibleLines[i].setPositionPx(marginPosX, marginPosY + m_lineSpacingPx * i)
		}

		setText(m_text)
		textSetFont(oldFont)
	}

	function destroy()
	{
		foreach(i, v in visibleLines)
		{
			visibleLines[i] = visibleLines[i].destroy()
		}

		scrollbar = scrollbar.destroy()
		base.destroy()
	}

	function setVisible(visible)
	{
		base.setVisible(visible)
		scrollbar.setVisible(visible)

		foreach(line in visibleLines)
		{
			line.setVisible(visible)
		}
	}

	function setAlpha(alpha)
	{
		base.setAlpha(alpha)
		scrollbar.setAlpha(alpha)

		foreach(line in visibleLines)
		{
			line.setAlpha(alpha)
		}
	}

	function top()
	{
		base.top()

		foreach(line in visibleLines)
		{
			line.top()
		}

		scrollbar.top()
	}

	function setDisabled(bool)
	{
		base.setDisabled(bool)
		scrollbar.setDisabled(bool)
	}

	function setPositionPx(x, y)
	{
		base.setPositionPx(x, y)
		scrollbar.setPositionPx(x + getSizePx().width, y)

		updateVisibleLines()
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function setSizePx(width, height)
	{
		local positionPx = getPositionPx()

		base.setSizePx(width, height)
		scrollbar.setPositionPx(positionPx.x + width, positionPx.y)
		scrollbar.setSizePx(scrollbar.getSizePx().width, height - scrollbar.increaseButton.getSizePx().height - scrollbar.decreaseButton.getSizePx().height)
		updateVisibleLines()
	}

	function setSize(x, y)
	{
		setSizePx(nax(x), nay(y))
	}

	function setMarginPx(top, right, bottom, left)
	{
		base.setMarginPx(top, right, bottom, left)
		updateVisibleLines()
	}

	function setMargin(top, right, bottom, left)
	{
		setMarginPx(nay(top), nax(right), nay(bottom), nax(left))
	}

	function setLineSpacingPx(spacing)
	{
		m_lineSpacingPx = spacing
		updateVisibleLines()
	}

	function getLineSpacingPx()
	{
		return m_lineSpacingPx
	}

	function setLineSpacing(spacing)
	{
		setLineSpacingPx(nax(spacing))
	}

	function getLineSpacing()
	{
		return anx(m_lineSpacingPx)
	}

	function setWordsPerLine(bool)
	{
		m_isWordsPerLine = bool
		setText(getText())
	}

	function getWordsPerLine()
	{
		return m_isWordsPerLine
	}

	function setFont(font)
	{
		local oldFont = textGetFont()
		m_font = font.toupper()

		foreach(visibleLine in visibleLines)
		{
			visibleLine.setFont(m_font)
		}

		textSetFont(font)
		setLineSpacingPx(letterHeightPx())
		textSetFont(oldFont)
	}

	function getFont()
	{
		return m_font
	}

	function getText()
	{
		return m_text
	}

	function setAlignment(alignment)
	{
		local positionX = getPositionPx().x
		local size = getSizePx()
		local margin = getMarginPx()
		base.setAlignment(alignment)

		switch(alignment)
		{
			case Align.Left:
				foreach(line in lines)
				{
					line.posX = margin.left
				}
				break

			case Align.Center:
				foreach(line in lines)
				{
					line.posX = (size.width - textWidthPx(line.text))/2
				}
				break

			case Align.Right:
				local linePos = size.width - margin.right
				foreach(line in lines)
				{
					line.posX = linePos - textWidthPx(line.text)
				}
				break
		}

		local lastLineId = m_visibleLinesCount + m_scrollValue
		foreach(i, visibleLine in visibleLines)
		{
			if(i < m_LinesCount)
			{
				if(i >= m_scrollValue && i < lastLineId)
				{
					visibleLine.setPositionPx(lines[i].posX + positionX, visibleLine.getPositionPx().y)
				}
			}
		}
	}

	function setLineColor(id, red, green, blue)
	{
		lines[id].color = {r = red, g = green, b = blue}
		if(id >= m_scrollValue && id < m_visibleLinesCount + m_scrollValue)
		{
			visibleLines[id].setColor(red, green, blue)
		}
	}

	function getLineColor(id)
	{
		return lines[id].color
	}

	function setLineAlpha(id, alpha)
	{
		lines[id].alpha <- alpha
		if(id >= m_scrollValue && id < m_visibleLinesCount + m_scrollValue)
		{
			visibleLines[id].setAlpha(alpha)
		}
	}

	function getAlpha()
	{
		return lines[id].alpha
	}

	function addLine(lineText)
	{
		lines.push({text = lineText, posX = 0, color = {r = 255, g = 255, b = 255}, alpha = 255})
	}

	function setText(text)
	{
		local oldFont = textGetFont()

		textSetFont(m_font)
		lines.clear()
		m_text = text

		local margin = getMarginPx()
		local maxLineWidth = getSizePx().width - margin.right - margin.left
		local curLineWidth = 0
		local textLen = text.len() - 1
		local firstIndex = 0

		for(local index = 0; index <= textLen; ++index)
		{
			curLineWidth += textWidthPx(text[index].tochar().tostring())

			if(text[index] == '\n')
			{
				addLine(text.slice(firstIndex, index))
				curLineWidth = 0
				firstIndex = index + 1

				if(firstIndex > textLen)
				{
					firstIndex = textLen
				}
			}

			else if(curLineWidth >= maxLineWidth)
			{
				local curLineText = text.slice(firstIndex, index)

				if(!getWordsPerLine())
				{
					if(curLineText[0].tochar() == m_separator)
					{
						curLineText = curLineText.slice(1)
					}

					addLine(curLineText)
					firstIndex = index
					curLineWidth = 0
				}

				else
				{
					local curLineTextLen = curLineText.len() - 1
					local foundSeparator = false

					for(local i = curLineTextLen; i >= 0; --i)
					{
						if(curLineText[i].tochar() == m_separator)
						{
							addLine(curLineText.slice(0, i))
							firstIndex = index - curLineTextLen + i
							curLineWidth = textWidthPx(text.slice(firstIndex, index))
							foundSeparator = true
							break
						}
					}

					if(!foundSeparator)
					{
						addLine(curLineText)
						firstIndex = index
						curLineWidth = 0
					}
				}
			}
		}

		addLine(text.slice(firstIndex))
		m_LinesCount = lines.len()

		if(m_visibleLinesCount < m_LinesCount)
		{
			scrollbar.setMaximum(m_LinesCount - m_visibleLinesCount)
		}

		else
		{
			scrollbar.setMaximum(0)
		}

		foreach(i, visibleLine in visibleLines)
		{
			if(m_LinesCount > i)
			{
				visibleLine.setText(lines[i].text)
			}

			else visibleLine.setText("")
		}

		scrollbar.setValue(0)
		setAlignment(getAlignment())
		textSetFont(oldFont)
	}

	function refreshNote(scrollValue)
	{
		local positionX = getPositionPx().x
		m_scrollValue = scrollValue

		foreach(i, visibleLine in visibleLines)
		{
			local lineIndex = i + m_scrollValue
			if(lineIndex < m_LinesCount)
			{
				local line = lines[lineIndex]
				local color = line.color

				visibleLine.setText(line.text)
				visibleLine.setPositionPx(line.posX + positionX, visibleLine.getPositionPx().y)
				visibleLine.setColor(color.r, color.g, color.b)
				visibleLine.setAlpha(line.alpha)
			}
		}
	}

	static function onChange(self)
	{
		local parent = self.parent
		if (!(self instanceof GUI.ScrollBar) || !(parent instanceof this))
		{
			return
		}

		parent.refreshNote(self.getValue().tointeger())
	}
}

addEventHandler("GUI.onChange", GUI.Note.onChange.bindenv(GUI.Note))
