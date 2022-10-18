
enableEvent_Render(true);

local testtex = -1;
local sizetex = -1;
local isTap = false;
local isTapDraw = false;
local oldx = 0;
local oldy = 0;
local lastid = -1;
local textures = 0;
local draws = 0;
local activeTex = -1;
local first = false;
local chosefont = 0;
local moveDraw = -1;
local inCell = false;
local oldmuchx = 0;
local oldmuchy = 0;
local onecell = 50;
local moveWindowInCell = false;

local last_command = 0;
local last_arg_01 = -1;
local last_arg_02 = -1;
local last_arg_03 = -1;

local otdarr = [];
local drawarr = [];
local fontarr = ["FONT_OLD_10_WHITE.TGA","FONT_OLD_10_WHITE_HI.TGA","FONT_OLD_20_WHITE.TGA","FONT_OLD_20_WHITE_HI.TGA"];

function onInit()
{
	sizetex = Button({x = 1000, y = 1000, w = 150, h = 150, texture = "INV_SLOT_EQUIPPED_FOCUS.TGA"});
	setCursorVisible(true);
	setFreeze(true);
	first = true;
}

addEventHandler("onInit",onInit);

function onClick(button)
{
	if (button == MOUSE_LMB)
	{
		setActive();
		if (sizetex.getActive() && isTap == false)
		{
			local pos = getCursorPosition();
			otdarr[activeTex].access(false);
			if (inCell == false)
			{
				oldx = pos.x;
				oldy = pos.y;
			}
			else
			{
				oldmuchx = (pos.x/onecell);
				oldmuchy = (pos.y/onecell);
			};
			isTap = true;
		}
		else if (isTapDraw == false)
		{
			for (local i = 0; i < draws; ++i)
			{
				if (drawarr[i])
				{
					if (drawarr[i].getLineActive(0))
					{
						local pos = getCursorPosition();
						moveDraw = i;
						if (inCell == false)
						{
							oldx = pos.x;
							oldy = pos.y;
						}
						else
						{
							oldmuchx = (pos.x/onecell);
							oldmuchy = (pos.y/onecell);
						};
						isTapDraw = true;
						for (local i = 0; i < otdarr.len(); ++i) {
							otdarr[i].access(false);
						}
					};
				};
			};
		};
		if (inCell == true)
		{
			if (activeTex != -1)
			{
				if (otdarr[activeTex].getActive() == true && sizetex.getActive() == false)
				{
					if (isTapDraw == false)
					{
						local pos = getCursorPosition();
						moveWindowInCell = true;
						oldmuchx = (pos.x/onecell);
						oldmuchy = (pos.y/onecell);
					};
				};
			};
		};
	}
}

addEventHandler("onMouseClick",onClick);

function onRelease(button) {
	if (button == MOUSE_LMB)
	{
		if (isTap == true || isTapDraw == true || moveWindowInCell == true)
		{
			isTap = false;
			if (activeTex != -1) {
				otdarr[activeTex].access(true);
			}
			isTapDraw = false;
			moveWindowInCell = false;
			if (inCell == false)
			{
				for (local i = 0; i < otdarr.len(); ++i) {
					otdarr[i].access(true);
				}
			};
		};
	}
}

addEventHandler("onMouseRelease",onRelease);

function onKey(key)
{
	if (key == KEY_UP)
	{
		if (!chatInputIsOpen())
		{
			for (local i = 0; i < draws; ++i)
			{
				if (drawarr[i])
				{
					if (drawarr[i].getLineActive(0))
					{
						if (chosefont != 3)
						{
							chosefont += 1;
						}
						else
						{
							chosefont = 0;
						};
						drawarr[i].setFont(fontarr[chosefont]);
					};
				};
			};
		}
		else
		{
			if (last_command == 1)
			{
				chatInputSetText("/texture " + last_arg_01);
			}
			else if (last_command == 2)
			{
				chatInputSetText("/draw " + last_arg_01);
			}
			else if (last_command == 3)
			{
				chatInputSetText("/color " + last_arg_01 + " " + last_arg_02 + " " + last_arg_03);
			}
			else if (last_command == 4)
			{
				chatInputSetText("/text " + last_arg_01);
			}
			else if (last_command == 5)
			{
				chatInputSetText("/tex " + last_arg_01);
			}
			else if (last_command == 6)
			{
				chatInputSetText("/cell");
			}
			else if (last_command == 7)
			{
				chatInputSetText("/changecell " + last_arg_01);
			}
			else if (last_command == 8)
			{
				chatInputSetText("/print");
			}
			else if (last_command == 9)
			{
				chatInputSetText("/save" + last_arg_01);
			};
		}
	
	}
	else if (key == KEY_DOWN)
	{
		if (!chatInputIsOpen())
		{
			for (local i = 0; i < draws; ++i)
			{
				{
					print("2");
					if (drawarr[i].getLineActive(0))
					{
						if (chosefont != 0)
						{
							chosefont -= 1;
						}
						else
						{
							chosefont = 3;
						};
						drawarr[i].setFont(fontarr[chosefont]);
					};
				};
			};
		}
		else
		{
			chatInputSetText("");
		};
	};
}

addEventHandler("onKey",onKey);

function onCommand(cmd,params)
{
	if (cmd == "texture")
	{
		commandTexCreate(params);
	}
	else if (cmd == "draw")
	{
		commandDrawCreate(params);
	}
	else if (cmd == "color")
	{
		commandDrawChangeColor(params);
	}
	else if (cmd == "text")
	{
		commandDrawChangeText(params);
	}
	else if (cmd == "tex")
	{
		commandTextureChange(params);
	}
	else if (cmd == "cell")
	{
		if (inCell == false)
		{
			commandActivateCell();
		}
		else
		{
			commandDeactivateCell();
		};
	}
	else if (cmd == "changecell")
	{
		commandChangeCell(params);
	}
	else if (cmd == "print")
	{
		commandPrintAll();
	}
	else if (cmd == "save")
	{
		commandSave(params);
	};
}

addEventHandler("onCommand",onCommand);

function onRender()
{
	if (first == true)
	{
		if (activeTex != -1)
		{
			local size = {w = otdarr[activeTex].getParams().w, h = otdarr[activeTex].getParams().h};
			local posd = {x = otdarr[activeTex].getParams().x, y = otdarr[activeTex].getParams().y};
			sizetex.disconnect();
			sizetex.connect(otdarr[activeTex]);
			sizetex.visible(false);
			sizetex.visible(true);
			sizetex.setPosition((posd.x + size.w) - 150,(posd.y + size.h) - 150);
			sizetex.top();
		};
		local pos = getCursorPosition();
		if (isTap == true)
		{
			if (inCell == false)
			{
				local size = {w = otdarr[activeTex].getParams().w, h = otdarr[activeTex].getParams().h};
				local newx = 0;
				local newy = 0;
				if (pos.x < oldx)
				{
					newx = oldx - pos.x;
					newx = size.w - newx;
				}
				else
				{
					newx = pos.x - oldx;
					newx = size.w + newx;
				};
				if (pos.y < oldy)
				{
					newy = oldy - pos.y;
					newy = size.h - newy;
				}
				else
				{
					newy = pos.y - oldy;
					newy = size.h + newy;
				};
				otdarr[activeTex].setSize(newx,newy);
				oldx = pos.x;
				oldy = pos.y;
			}
			else
			{
				local size = {w = otdarr[activeTex].getParams().w, h = otdarr[activeTex].getParams().h};
				local muchx = (pos.x/onecell);
				local muchy = (pos.y/onecell);
				local newx = 0;
				local newy = 0;
				if (oldmuchx > muchx)
				{
					newx = oldmuchx - muchx;
					newx = size.w - (newx * onecell);
				}
				else
				{
					newx = muchx - oldmuchx;
					newx = size.w + (newx * onecell);
				};
				if (oldmuchy > muchy)
				{
					newy = oldmuchy - muchy;
					newy = size.h - (newy * onecell);
				}
				else
				{
					newy = muchy - oldmuchy;
					newy = size.h + (newy * onecell);
				};
				oldmuchx = muchx;
				oldmuchy = muchy;
				otdarr[activeTex].setSize(newx,newy);
			};
		};
		if (isTapDraw == true)
		{
			if (inCell == false)
			{
				local posdraw = {x = drawarr[moveDraw].getParams().x, y = drawarr[moveDraw].getParams().y};
				local newx = 0;
				local newy = 0;
				if (pos.x < oldx)
				{
					newx = oldx - pos.x;
					newx = posdraw.x - newx;
				}
				else
				{
					newx = pos.x - oldx;
					newx = posdraw.x + newx;
				};
				if (pos.y < oldy)
				{
					newy = oldy - pos.y;
					newy = posdraw.y - newy;
				}
				else
				{
					newy = pos.y - oldy;
					newy = posdraw.y + newy;
				};
				drawarr[moveDraw].setPosition(newx,newy);
				drawarr[moveDraw].top();
				oldx = pos.x;
				oldy = pos.y;
			}
			else
			{
				local pt = {x = drawarr[moveDraw].getParams().x, y = drawarr[moveDraw].getParams().y};
				local muchx = (pos.x/onecell);
				local muchy = (pos.y/onecell);
				local newx = 0;
				local newy = 0;
				if (oldmuchx > muchx)
				{
					newx = oldmuchx - muchx;
					newx = pt.x - (newx * onecell);
				}
				else
				{
					newx = muchx - oldmuchx;
					newx = pt.x + (newx * onecell);
				};
				if (oldmuchy > muchy)
				{
					newy = oldmuchy - muchy;
					newy = pt.y - (newy * onecell);
				}
				else
				{
					newy = muchy - oldmuchy;
					newy = pt.y + (newy * onecell);
				};
				oldmuchx = muchx;
				oldmuchy = muchy;
				drawarr[moveDraw].setPosition(newx,newy);
			};
		};
		if (moveWindowInCell == true)
		{
			local pos = getCursorPosition();
			local pt = {x = otdarr[activeTex].getParams().x, y = otdarr[activeTex].getParams().y};
			local muchx = (pos.x/onecell);
			local muchy = (pos.y/onecell);
			local newx = 0;
			local newy = 0;
			if (oldmuchx > muchx)
			{
				newx = oldmuchx - muchx;
				newx = pt.x - (newx * onecell);
			}
			else
			{
				newx = muchx - oldmuchx;
				newx = pt.x + (newx * onecell);
			};
			if (oldmuchy > muchy)
			{
				newy = oldmuchy - muchy;
				newy = pt.y - (newy * onecell);
			}
			else
			{
				newy = muchy - oldmuchy;
				newy = pt.y + (newy * onecell);
			};
			oldmuchx = muchx;
			oldmuchy = muchy;
			otdarr[activeTex].setPosition(newx,newy);
		};
	};
}

addEventHandler("onRender",onRender);

function commandTexCreate(params)
{
	local args = sscanf("s",params);
	if (args)
	{
		texCreate(1000,1000,1000,1000,args[0]);
		last_arg_01 = args[0];
		last_command = 1;
	};
};

function commandDrawCreate(params)
{
	local args = sscanf("s",params);
	if (args)
	{
		drawCreate(args[0],fontarr[0],1000,1000,255,255,255);
		last_arg_01 = args[0];
		last_command = 2;
	};
};

function commandDrawChangeText(params)
{
	local args = sscanf("s",params);
	if (args)
	{
		for (local i = 0; i < draws; ++i)
		{
			if (drawarr[i])
			{
				if (drawarr[i].getActive())
				{
					drawarr[i].setText(args[0]);
					last_arg_01 = args[0];
					last_command = 4;
				};
			};
		};
	};
};

function commandDrawChangeColor(params)
{
	local args = sscanf("ddd",params);
	if (args)
	{
		for (local i = 0; i < draws; ++i)
		{
			if (drawarr[i])
			{
				if (drawarr[i].getActive())
				{
					drawarr[i].setColor(args[0],args[1],args[2]);
					last_arg_01 = args[0];
					last_arg_02 = args[1];
					last_arg_03 = args[2];
					last_command = 3;
				};
			};
		};
	};
};

function commandActivateCell()
{
	inCell = true;
	last_command = 6;
	for (local i = 0; i < textures; ++i)
	{
		if (otdarr[i])
		{
			for (local i = 0; i < otdarr.len(); ++i) {
				otdarr[i].access(false);
			}
			local pos = {x = otdarr[i].getParams().x, y = otdarr[i].getParams().y};
			local size = {w = otdarr[i].getParams().w, h = otdarr[i].getParams().h};
			otdarr[i].setPosition((pos.x/onecell) * onecell,(pos.y/onecell) * onecell);
			otdarr[i].setSize((size.w/onecell) * onecell,(size.h/onecell) * onecell);
		};
	};
};

function commandDeactivateCell()
{
	inCell = false;
	last_command = 6;
};

function commandChangeCell(params)
{
	local args = sscanf("d",params);
	if (args)
	{
		onecell = args[0];
		last_arg_01 = args[0];
		last_command = 7;
		for (local i = 0; i < textures; ++i)
		{
			if (otdarr[i])
			{
				local pos = {x = otdarr[i].getParams().x, y = otdarr[i].getParams().y};
				local size = {w = otdarr[i].getParams().w, h = otdarr[i].getParams().h};
				otdarr[i].setPosition((pos.x/onecell) * onecell,(pos.y/onecell) * onecell);
				otdarr[i].setSize((size.w/onecell) * onecell,(size.h/onecell) * onecell);
			};
		};
		for (local i = 0; i < draws; ++i)
		{
			if (drawarr[i])
			{
				local pos = {x = drawarr[i].getParams().x, y = drawarr[i].getParams().y};
				drawarr[i].setPosition((pos.x/onecell) * onecell,(pos.y/onecell) * onecell);
			};
		};
	};
};

function commandPrintAll()
{
	last_command = 8;
	for (local i = 0; i < textures; ++i)
	{
		if (otdarr[i])
		{
			local pos = {x = otdarr[i].getParams().x, y = otdarr[i].getParams().y};
			local size = {w = otdarr[i].getParams().w, h = otdarr[i].getParams().h};
			local texture = otdarr[i].getParams().texture;
			print("Texture(" + pos.x.tostring() + "," + pos.y.tostring() + "," + size.w.tostring() + "," + size.h.tostring() + ",\"" + texture.tostring() + "\")");
		};
	};
	for (local i = 0; i < draws; ++i)
	{
		if (drawarr[i])
		{
			local text = drawarr[i].getParams().text;
			local font = drawarr[i].getParams().font;
			local pos = {x = drawarr[i].getParams().x, y = drawarr[i].getParams().y};
			local r = drawarr[i].getParams().r;
			local g = drawarr[i].getParams().g;
			local b = drawarr[i].getParams().g;
			print("Draw(\"" + text.tostring() + "\"," + font.tostring() + "," + pos.x.tostring() + "," + pos.y.tostring() + "," + r.tostring() + "," + g.tostring() + "," + b.tostring() + ")");
		};
	};
};

function commandTextureChange(params)
{
	local args = sscanf("s",params);
	if (args)
	{
		for (local i = 0; i < textures; ++i)
		{
			if (otdarr[i])
			{
				if (otdarr[i].getActive())
				{
					otdarr[i].setTexture(args[0]);
					last_arg_01 = args[0];
					last_command = 5;
				};
			};
		};
	};
};

function commandSave(params)
{
	local args = sscanf("s",params);
	if (args)
	{
		last_arg_01 = args[0];
		last_command = 9;
		for (local i = 0; i < textures; ++i)
		{
			if (otdarr[i])
			{
				local pos = {x = otdarr[i].getParams().x, y = otdarr[i].getParams().y};
				local size = {w = otdarr[i].getParams().w, h = otdarr[i].getParams().h};
				local texture = otdarr[i].getParams().texture;
				callServerFunc("OTDFileSave",args[0],"Texture(" + pos.x + "," + pos.y + "," + size.w + "," + size.h + "," + texture + ");");
			};
		};
		for (local i = 0; i < draws; ++i)
		{
			if (drawarr[i])
			{
				local text = drawarr[i].getParams().text;
				local font = drawarr[i].getParams().font;
				local pos = {x = drawarr[i].getParams().x, y = drawarr[i].getParams().y};
				local r = drawarr[i].getParams().r;
				local g = drawarr[i].getParams().g;
				local b = drawarr[i].getParams().b;
				callServerFunc("OTDFileSave",args[0],"createDraw(" + text.tostring() + "," + font.tostring() + "," + pos.x.tostring() + "," + pos.y.tostring() + "," + r.tostring() + "," + g.tostring() + "," + b.tostring() + ")");
			};
		};
	};
};

function texCreate(x,y,width,height,tex)
{
	otdarr.append(Window({x = x, y = y, w = width, h = height, texture = tex}));
	lastid += 1;
	textures += 1;
	activeTex = lastid;
	otdarr[activeTex].visible(true);
	if (inCell == true)
	{
		for (local i = 0; i < textures; ++i)
		{
			if (otdarr[i])
			{
				local pos = {x = otdarr[i].getParams().x, y = otdarr[i].getParams().y};
				local size = {w = otdarr[i].getParams().w, h = otdarr[i].getParams().h};
				otdarr[i].setPosition((pos.x/onecell) * onecell,(pos.y/onecell) * onecell);
				otdarr[i].setSize((size.w/onecell) * onecell,(size.h/onecell) * onecell);
			};
		};
		for (local i = 0; i < draws; ++i)
		{
			if (drawarr[i])
			{
				local pos = {x = drawarr[i].getParams().x, y = drawarr[i].getParams().y};
				drawarr[i].setPosition((pos.x/onecell) * onecell,(pos.y/onecell) * onecell);
			};
		};
	};
};

function drawCreate(text,font,x,y,r,g,b)
{
	drawarr.append(Text({text = text, font = font, x = x, y = y, r = r, g = g, b = b}));
	drawarr[draws].visible(true);
	draws += 1;
	if (inCell == true)
	{
		for (local i = 0; i < textures; ++i)
		{
			if (otdarr[i])
			{
				local pos = {x = otdarr[i].getParams().x, y = otdarr[i].getParams().y};
				local size = {w = otdarr[i].getParams().w, h = otdarr[i].getParams().h};
				otdarr[i].setPosition((pos.x/onecell) * onecell,(pos.y/onecell) * onecell);
				otdarr[i].setSize((size.w/onecell) * onecell,(size.h/onecell) * onecell);
			};
		};
		for (local i = 0; i < draws; ++i)
		{
			if (drawarr[i])
			{
				local pos = {x = drawarr[i].getParams().x, y = drawarr[i].getParams().y};
				drawarr[i].setPosition((pos.x/onecell) * onecell,(pos.y/onecell) * onecell);
			};
		};
	};
};

function setActive()
{
	for (local i = 0; i < textures; ++i)
	{
		if (otdarr[i])
		{
			if (otdarr[i].getMoving())
			{
				activeTex = i;
				break;
			};
		};
	};
}
		