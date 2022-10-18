enum Input
{
    Text,
    Password,
    Numbers
}

local activeInput = null

class GUI.Input extends GUI.Texture
{
#private:
    m_type = null
    m_align = null
    m_inputColor = null
    m_inputAlpha = 255
    m_placeholderColor = null
    m_placeholderAlpha = 255
    m_placeholderText = ""
    m_margin = 2
    m_text = ""
    m_isDotPresent = false
    m_isScientificEPresent = false
#public:
    draw = null
    distance = null
    selector = "|"
    maxLetters = 1000

    constructor(x, y, w, h, file, font, type, align = Align.Left, placeholderText = "", margin = 2, window = null)
    {
		draw = GUI.Draw(x, y, placeholderText)
		draw.setDisabled(true)
        draw.setFont(font)

        m_inputColor = {r = 255, g = 255, b = 255}
        m_placeholderColor = {r = 255, g = 255, b = 255}
        m_placeholderText = placeholderText

        m_align = align
        m_type = type
        m_margin = margin

		base.constructor(x, y, w, h, file, window)
		draw.top()

        alignText()
    }

    function alignText()
    {
        local pos = base.getPositionPx()
        local size = base.getSizePx()
        local sizeDraw = draw.getSizePx()
        switch(m_align)
        {
            case Align.Left:
                draw.setPositionPx(pos.x + m_margin, pos.y + size.height/2 - sizeDraw.height/2)
                break
            case Align.Center:
                draw.setPositionPx(pos.x + size.width/2 - sizeDraw.width/2, pos.y + size.height/2 - sizeDraw.height/2)
                break
            case Align.Right:
                draw.setPositionPx(pos.x + size.width - (sizeDraw.width + m_margin), pos.y + size.height/2 - sizeDraw.height/2)
                break
        }
    }

    function setVisible(bool)
    {
        base.setVisible(bool)
        draw.setVisible(bool)
    }

    function destroy()
	{
		base.destroy()
		draw.destroy()
	}

    function setPosition(x, y)
    {
        setPositionPx(nax(x), nay(y))
    }

    function setPositionPx(x, y)
    {
        base.setPositionPx(x, y)
        alignText()
    }

    function getColor()
    {
        return m_inputColor
    }

    function setColor(r, g, b)
    {
        m_inputColor.r = r
        m_inputColor.g = g
        m_inputColor.b = b

        if(getActive() || m_text != "")
            draw.setColor(m_inputColor.r, m_inputColor.g, m_inputColor.b)
    }

    function getAlpha()
    {
        return m_inputAlpha
    }

    function setAlpha(alpha)
    {
        draw.setAlpha(alpha)
        base.setAlpha(alpha)

        m_inputAlpha = alpha

        if(getActive() || m_text != "")
            draw.setAlpha(m_inputAlpha)
    }

    function setText(text)
    {
        m_text = text

        local active = getActive()

        if(!active && m_text == "")
        {
            draw.setText(m_placeholderText)
            draw.setColor(m_placeholderColor.r, m_placeholderColor.g, m_placeholderColor.b)
            draw.setAlpha(m_placeholderAlpha)
            
            return
        }
        else if (active)
        {
            draw.setColor(m_inputColor.r, m_inputColor.g, m_inputColor.b)
            draw.setAlpha(m_inputAlpha)
        }

        if(m_type == Input.Numbers)
        {
            m_isDotPresent = text.find(".") != null
            m_isScientificEPresent = text.find("e") != null || text.find("E") != null
        }

        if(active)
        {
            if(m_type == Input.Password)
                draw.setText(cutText(hash(m_text) + selector))
            else
                draw.setText(cutText(m_text + selector))
        }
        else
        {
            if(m_type == Input.Password)
                draw.setText(cutText(hash(m_text)))
            else
                draw.setText(cutText(m_text))
        }

        alignText()
    }

    function getText()
    {
        return m_text
    }

    function setPlaceholderColor(r, g, b)
    {
        m_placeholderColor.r = r
        m_placeholderColor.g = g
        m_placeholderColor.b = b

        if(!getActive() && m_text == "")
            draw.setColor(m_placeholderColor.r, m_placeholderColor.g, m_placeholderColor.b)
    }

    function getPlaceholderColor()
    {
        return m_placeholderColor
    }

    function setPlaceholderAlpha(alpha)
    {
        m_placeholderAlpha = alpha

        if(!getActive() && m_text == "")
            draw.setAlpha(m_placeholderAlpha)
    }

    function getPlaceholderAlpha()
    {
        return m_placeholderAlpha
    }

    function setPlaceholderText(holder)
    {
        if(!getActive() && m_text == "")
        {
            draw.setText(holder)
            alignText()
        }

        m_placeholderText = holder

    }

    function getPlaceholderText()
    {
        return m_placeholderText
    }

    function setDisabled(disable)
    {
        setActive(false)
        base.setDisabled(disable)

        if(disable && m_active)
            setActive(false)
    }

    function getActive()
    {
        return activeInput == this
    }

    function setActive(active)
    {
        if (active && activeInput && activeInput != this)
            activeInput.setActive(false)

        activeInput = (active) ? this : null

        enableKeys(!active)
        setText(m_text)
    }

    static function cutText(text)
    {
        local size = base.getSizePx()
        local finishText = ""

        local oldFont = textGetFont()
		textSetFont(draw.getFont())

        for (local i = text.len(); i > 0; i--)
        {
            local char = text.slice(i-1, i);
            if(textWidthPx(finishText + char) < size.width - (2*m_margin))
                finishText = char + finishText
            else
            {
                textSetFont(oldFont)
                return finishText
            }
        }

        textSetFont(oldFont)
        return finishText
    }

    static function hash(text)
    {
        local endText = ""
        for(local i = 0; i < text.len(); i++)
            endText += "#"

        return endText
    }

    function removeLetter()
    {
        if(m_text.len() < 1)
            return

        setText(m_text.slice(0, m_text.len()-1))

        if(!base.getDisabled())
        {
            call(EventType.RemoveLetter, m_text)
            callEvent("GUI.onInputRemoveLetter", this, m_text)
        }
    }

    function addLetter(key)
    {
        if(m_text.len() >= maxLetters)
            return

        local letter = getKeyLetter(key)

        if(!letter)
            return

        if(m_type == Input.Numbers)
        {
            if((m_text.len() == 0 && (letter == "-" || letter == "+"))
            || (!m_isDotPresent && (letter == "."))
            || (!m_isScientificEPresent && (letter == "e" || letter == "E"))
            || letter == "0" || letter == "1" || letter == "2" || letter == "3" || letter == "4"
            || letter == "5" || letter == "6" || letter == "7" || letter == "8" || letter == "9" || letter == "0")
                m_text += letter
        }
        else
            m_text += letter

        setText(m_text)

        if(!base.getDisabled())
        {
            call(EventType.InsertLetter, letter)
            callEvent("GUI.onInputInsertLetter", this, letter)
        }
    }

    static function onKey(key)
    {
        if (!activeInput)
            return

        if(key == KEY_BACK)
            activeInput.removeLetter()
        else
            activeInput.addLetter(key)

        activeInput.alignText()
    }

    static function onMouseClick(button)
    {
        if (button != MOUSE_LMB)
			return

        if (!activeInput)
            return

        if (GUI.Base.getElementPointedByCursor() instanceof this)
            return
        
        activeInput.setActive(false)
    }

    static function onMouseDown(self, button)
    {
        if (button != MOUSE_LMB)
			return

		if (!(self instanceof this))
			return

        if (activeInput == self)
            return

        self.setActive(true)

    }
}

addEventHandler("onKey", GUI.Input.onKey)
addEventHandler("onMouseClick", GUI.Input.onMouseClick.bindenv(GUI.Input))
addEventHandler("GUI.onMouseDown", GUI.Input.onMouseDown.bindenv(GUI.Input))
