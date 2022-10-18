local randomChar = @() rand() % 255
local list = GUI.List(0, 0, 2000, 4000, "MENU_INGAME.TGA", "MENU_INGAME.TGA", "BAR_MISC.TGA", "O.TGA", "U.TGA")

addEventHandler("onInit", function()
{
    list.setMarginPx(10, 5, 5, 10)

    list.setVisible(true)
    setCursorVisible(true)

    for (local i = 1; i <= 30; ++i)
        list.addRow(i)
})

addEventHandler("GUI.onClick", function(self)
{
    if (!(self instanceof GUI.VisibleListRow))
        return
    
    local row = list.rows[self.id]
    row.setColor(randomChar(), randomChar(), randomChar())
})