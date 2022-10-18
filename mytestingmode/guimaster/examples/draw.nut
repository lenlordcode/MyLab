local draw = GUI.Draw(1000, 1000, "[#F60005]E[#aadd20]x[#aaffff]a[#ed00ef]m[#ff7800]p[#2900ff]l[#F60005]e [#50cc29]T[#cc298a]e[#F60005]x[#50cc29]t")
local draw2 = GUI.Draw(1000, 1250, "HOVER me")

addEventHandler("onInit",function()
{
	draw.setVisible(true)
	draw2.setVisible(true)

	draw.setFont("FONT_OLD_20_WHITE_HI.TGA")
	setCursorVisible(true)
})

addEventHandler("GUI.onMouseIn", function(self)
{
	switch (self)
	{
		case draw:
			self.setColor(255, 0, 0)
			break

		case draw2:
			self.setText("HOVER me")
			break
	}
})

addEventHandler("GUI.onMouseOut", function(self)
{
	switch (self)
	{
		case draw:
			self.setText("[#F60005]E[#aadd20]x[#aaffff]a[#ed00ef]m[#ff7800]p[#2900ff]l[#F60005]e [#50cc29]T[#cc298a]e[#F60005]x[#50cc29]t")
			break

		case draw2:
			self.setText("HOVER")
			break
	}
})
