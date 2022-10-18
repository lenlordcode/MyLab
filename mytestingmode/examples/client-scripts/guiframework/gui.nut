/* 
	GUI Framework 2.0
	Author: Osmith.
	
	Gothic Online forum: http://gothic-online.com.pl/
	
			My contacts:
	E-mail		osmith.gmpa123@gmail.com
	GG			60474243
	Discord		#1971
	GO forum	http://gothic-online.com.pl/forum/member.php?action=profile&uid=54
*/

local winMovement = false;
enableEvent_Render(true)

local texElements = [];

class TextureClass {
	
	constructor (args) {
		
		params = args;
		
		tex = Texture(args.x,args.y,args.w,args.h,args.texture);
		addToArray();
	}
	
	function visible (toggle) {
		
		if (toggle != true && toggle != false)
			toggle = false;
		
		tex.visible = toggle;
		if (toggle == false) {
			isActive = false;
		}
	}
	
	function isVisible() {
		
		return tex.visible;
	}
	
	function texture(texture) {
		
		params.texture = texture;
		
		tex.file = texture;
	}
	
	function setPosition(x,y) {
		
		params.x = x;
		params.y = y;
		
		tex.setPosition(x,y);
	}
	
	function setSize(w,h) {
	
		params.w = w;
		params.h = h;
		
		tex.setSize(w,h);
	}
	
	function setAlpha(alpha) {
		
		tex.setAlpha(alpha);
	}
	
	function getAlpha() {
		
		return tex.getAlpha();
	}
	
	function setTexture(texture) {
		
		tex.file = texture;
		params.texture = texture;
	}
	
	function getParams() {
		
		return params;
	}
	
	function access(toggle) {
		
		isAccess = toggle;
	}
	
	function getAccess() {
		
		return isAccess;
	}
	
	function getActive() {
		
		return isActive;
	}
	
	function top() {
		
		tex.top();
	}

	function fadeOut() {
		fadeTimer != -1 ? killTimer(fadeTimer) : fadeTimer = -1;
		fadeStep = 1;
		local point = this;
		fadeTimer = setTimer(function() {
			point.setAlpha(255 - (25.5 * point.fadeStep));
			point.fadeStep++;
		}50,10);
	}

	function fadeIn() {
		fadeTimer != -1 ? killTimer(fadeTimer) : fadeTimer = -1;
		fadeStep = 1;
		local point = this;
		fadeTimer = setTimer(function() {
			point.setAlpha(25.5 * point.fadeStep);
			point.fadeStep+=1;
		},50,10);
	}
	
	params = -1;
	
	fadeTimer = -1;
	fadeStep = 1;
	isActive = false;
	isAccess = true;
	
	tex = -1;
}

class Button extends TextureClass{
	
	function addToArray() {
		
		texElements.append(this);
	}
	
	function connect(window) {
		
		if (window != -1 && connectedWin == -1) {
			if (window.getType() == 2) {
				local win = window.getParams();
				connectedWin = window;
				winParamsX = win.x;
				winParamsY = win.y;
			}
		}
	}
	
	function disconnect() {
		connectedWin = -1;
	}
	
	function check() {
		
		local pos = {x = -1, y = -1};
		if (isCursorVisible()) {
			pos = getCursorPosition();
		}
		
		// check activity
		
		if (getAccess() && isVisible()) {
			if ((pos.x >= params.x && pos.x <= (params.x + params.w)) && (pos.y >= params.y && pos.y <= (params.y + params.h))) {
				isActive = true;
			} else {
				isActive = false;
			}
		}
	
	}
	
	function syncWin(x,y) {
		
		local params = base.getParams();
		base.setPosition(params.x - (winParamsX - x),params.y - (winParamsY - y));
		winParamsX = x;
		winParamsY = y;
	}
	
	function getType() {
		
		return type;
	}
	
	connectedWin = -1;
	winParamsX = -1;
	winParamsY = -1;
	type = 1;
}

class Window extends TextureClass {
	
	function addToArray() {
		
		texElements.append(this);
	}
	
	function setMoving(toggle) {
		
		if (toggle != true && toggle != false) 
			toggle = false;
		
		isMoving = toggle;
	}
	
	function getMoving() {
		
		return isMoving;
	}
	
	function getType() {
		
		return type;
	}
	
	function check() {
		
		if (isCursorVisible()) {
			pos = getCursorPosition();
		}
		
		// check activity
		
		if (getAccess() && isVisible()) {
			if ((pos.x >= params.x && pos.x <= (params.x + params.w)) && (pos.y >= params.y && pos.y <= (params.y + params.h))) {
				isActive = true;
			} else {
				isActive = false;
			}
		}
		
		// movement
		
		if (base.getAccess() && isMoving == true) {
			local par = base.getParams();
			setPosition(par.x + (pos.x - this.cursorCoords.x), par.y + (pos.y - this.cursorCoords.y));
			for (local i = 0; i < texElements.len(); ++i) {
				if (texElements[i].type == 1 || texElements[i].type == 3 || texElements[i].type == 4) {
					if (texElements[i].connectedWin == this) {
						texElements[i].syncWin(base.getParams().x,base.getParams().y);
					}
				}
			}
		}
		
		this.cursorCoords = pos;
	}
	
	isMoving = false;
	pos = {x = -1, y = -1};
	cursorCoords = {x = -1, y = -1};
	type = 2;
}

class DrawClass {
	
	constructor (args) {
		
		params = args;
		
		local draws = split(args.text,"&");
		
		for (local i = 0; i < draws.len(); ++i) {
			draw.append(Draw(0,0,draws[i]));
			draw[i].setPosition(args.x,args.y + (i * draw[i].height));
			draw[i].font = args.font;
			draw[i].setColor(args.r,args.g,args.b);
			drawFonts.append(args.font);
			drawTexts.append(draws[i]);
			drawColors.append({r = args.r,g = args.g,b = args.b});
			drawAccess.append(true);
			drawActive.append(false);
		}
			
		addToArray();
		setPosition(args.x,args.y);
		setFont(args.font);
	}
	
	function visible (toggle) {
		
		if (toggle != true && toggle != false)
			toggle = false;
		
		for (local i = 0; i < draw.len(); ++i) {
			draw[i].visible = toggle;
			draw[i].top();
		}
		
		isVisible = toggle;
	}
	
	function isVisible() {
		
		return isVisible;
	}
	
	function setText(text) {
		
		params.text = text;
		
		for (local i = 0; i < draw.len(); ++i) {
			draw[i].visible = false;
		}
		
		draw = [];
		drawTexts = [];
		
		local draws = split(text,"&");
		local pos = -1;
		
		for (local i = 0; i < draws.len(); ++i) {
			if (i != 0) {
				pos = draw[i - 1].getPosition();
				draw.append(Draw(0,0,draws[i]));
				draw[i].setPosition(params.x,pos.y + (draw[i - 1].height));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			} else {
				draw.append(Draw(params.x,params.y,draws[i]));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			}
			drawTexts.append(draws[i]);
			draw[i].visible = isVisible;
		}
	}
	
	function setLineText(line, text) {
		
		if (line < draw.len() && line > -1) {
			
			local txt = getDrawText(draw[line]);
			local mainText = params.text;
			local index = mainText.find(txt);
			local endText = mainText.slice(0,index) + text + mainText.slice(index + txt.len(),mainText.len());
			params.text = endText;
			draw[line].text = text;
			drawsText[line] = text;
		}
	}
	
	function setFont(font) {
		
		params.font = font;
		
		for (local i = 0; i < draw.len(); ++i) {
			draw[i].visible = false;
		}
		
		draw = [];
		drawFonts = [];
		
		local draws = split(params.text,"&");
		local pos = -1;
		
		for (local i = 0; i < draws.len(); ++i) {
			drawFonts.append(font);
			if (i != 0) {
				pos = draw[i - 1].getPosition();
				draw.append(Draw(0,0,draws[i]));
				draw[i].setPosition(params.x,pos.y + (draw[i - 1].height));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			} else {
				draw.append(Draw(params.x,params.y,draws[i]));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			}
			drawTexts.append(draws[i]);
			draw[i].visible = isVisible;
		}
	}
	
	function setLineFont(line, font) {
		
		if (line < draw.len() && line > -1) {
			for (local i = 0; i < draw.len(); ++i) {
				draw[i].visible = false;
			}
			
			draw = [];
			drawFonts[line] = font;
			
			local draws = split(params.text,"&");
			local pos = -1;
			
			for (local i = 0; i < draws.len(); ++i) {
				if (i != 0) {
					pos = draw[i - 1].getPosition();
					draw.append(Draw(0,0,draws[i]));
					draw[i].setPosition(params.x,pos.y + (draw[i - 1].height));
					draw[i].font = drawFonts[i];
					draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
				} else {
					draw.append(Draw(params.x,params.y,draws[i]));
					draw[i].font = drawFonts[i];
					draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
				}
				drawTexts.append(draws[i]);
				draw[i].visible = isVisible;
			}
		}
	}
	
	function setColor(r,g,b) {
		
		params.r = r;
		params.g = g;
		params.b = b;
		
		for (local i = 0; i < draw.len(); ++i) {
			draw[i].visible = false;
		}
		
		draw = [];
		drawColors = [];
		
		local draws = split(params.text,"&");
		local pos = -1;
		
		for (local i = 0; i < draws.len(); ++i) {
			drawColors.append({r = r, g = g, b = b});
			if (i != 0) {
				pos = draw[i - 1].getPosition();
				draw.append(Draw(0,0,draws[i]));
				draw[i].setPosition(params.x,pos.y + (draw[i - 1].height));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			} else {
				draw.append(Draw(params.x,params.y,draws[i]));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			}
			drawTexts.append(draws[i]);
			draw[i].visible = isVisible;
		}
	}
	
	function setLineColor(line,r,g,b) {
		
		if (line < draw.len() && line > -1) {
			
			drawColors[line].r = r;
			drawColors[line].g = g;
			drawColors[line].b = b;
			
			draw[line].setColor(r,g,b);
		}
	}
	
	function setPosition(x,y) {
		
		params.x = x;
		params.y = y;
		
		for (local i = 0; i < draw.len(); ++i) {
			draw[i].visible = false;
		}
		
		draw = [];
		
		local draws = split(params.text,"&");
		local pos = -1;
		
		for (local i = 0; i < draws.len(); ++i) {
			if (i != 0) {
				pos = draw[i - 1].getPosition();
				draw.append(Draw(0,0,draws[i]));
				draw[i].setPosition(params.x,pos.y + (draw[i - 1].height));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			} else {
				draw.append(Draw(params.x,params.y,draws[i]));
				draw[i].font = drawFonts[i];
				draw[i].setColor(drawColors[i].r,drawColors[i].g,drawColors[i].b);
			}
			drawTexts.append(draws[i]);
			draw[i].visible = isVisible;
		}
	}
	
	function setAlpha(alpha) {
		for (local i = 0; i < draw.len(); ++i) {
			draw[i].setAlpha(alpha);
		}
	}
	
	function getParams() {
		
		return params;
	}
	
	function setAccess(toggle) {
		if (toggle != true && toggle != false) {
			toggle = true;
		}
		
		isAccess = toggle;
	}
	
	function getAccess() {
		
		return isAccess;
	}
	
	function getActive() {
		
		local active = false;
		for (local i = 0; i < draw.len(); ++i) {
			if (drawActive[i] == true) {
				active = i;
				break;
			}
		}
		
		return active;
	}
	
	function getLineActive(line) {
		
		if (line == activeLine) {
			return true;
		} else {
			return false;
		}
	}
	
	function active() {
		
		return activeLine;
	}
	
	function top() {
		
		for (local i = 0; i < draw.len(); ++i) {
			draw[i].top();
		}
	}

	function centrate(num) {
		for (local i = 0; i < draw.len(); i++) {
			textSetFont(drawFonts[0]);
			local width = textWidth(draw[i].text);
			params.x = num - (width / 2).tointeger();
			draw[i].setPosition(num - (width / 2).tointeger(),params.y);
		}
	}
	
	params = -1;
	
	isVisible = false;
	isAccess = true;
	
	draw = [];
	drawFonts = [];
	drawColors = [];
	drawTexts = [];
	drawAccess = [];
	drawActive = [];
}

class Text extends DrawClass {
	
	function addToArray() {
		
		texElements.append(this);
	}
	
	function connect(window) {
		
		if (window != -1 && connectedWin == -1) {
			if (window.getType() == 2) {
				local win = window.getParams();
				connectedWin = window;
				winParams.x = win.x;
				winParams.y = win.y;
			}
		}
	}
	
	function disconnect() {
		connectedWin = -1;
	}
	
	function check() {
		
		local pos = {x = -1, y = -1};
		if (isCursorVisible()) {
			pos = getCursorPosition();
		}
		
		if (isVisible == true && isAccess == true) {
			for (local i = 0; i < draw.len(); ++i) {
				local par = {x = -1, y = -1, w = -1, h = -1}
				local ps = draw[i].getPosition();
				par.x = ps.x;
				par.y = ps.y;
				par.w = ps.x + draw[i].width;
				par.h = ps.y + draw[i].height;
				if ((pos.x >= par.x && pos.x <= par.w) && (pos.y >= par.y && pos.y <= par.h)) {
					activeLine = i;
					break;
				} else {
					activeLine = -1;
					continue;
				}
			}
		}
	
	}
	
	function syncWin(x,y) {
		
		local params = base.getParams();
		base.setPosition(params.x - (winParams.x - x),params.y - (winParams.y - y));
		winParams.x = x;
		winParams.y = y;
	}
	
	connectedWin = -1;
	activeLine = -1;
	winParams = {x = -1, y = -1};
	type = 3;
	
}

class Input {
	
	constructor (args) {
		
		inputParams = args;
		input = Draw(args.input.x,args.input.y,args.input.text);
		input.font = "Font_Old_10_White_Hi.TGA";
		input.setColor(args.input.r,args.input.g,args.input.b);
		inputNote = Draw(args.input.x,args.input.y,args.note.text);
		inputNote.font = "Font_Old_10_White_Hi.TGA";
		inputNote.setColor(args.note.r,args.note.r,args.note.r);
		inputCursor = Draw(args.input.x,args.input.y,"I");
		inputCursor.setColor(190,190,190);
		inputCursor.font = "Font_Old_10_White_Hi.TGA";
		
		inputPass = args.pass;
		inputLen = args.len;
		inputMaxLen = args.maxLen;
		inputBackground = Texture(args.background.x,args.background.y,args.background.w,args.background.h,args.background.texture);
		
		texElements.append(this);
	}
	
	function visible(toggle = true) {
		
		if (toggle != true && toggle != false) {
			toggle = true;
		}
		
		isVisible = toggle;
		input.visible = toggle;
		inputBackground.visible = toggle;
		inputNote.visible = toggle;
		if (toggle == true) {
			if (inputText == "") {
				inputNote.visible = true;
			} else {
				inputNote.visible = false;
			}
		}
		input.top();
		inputNote.top();
		if (toggle == false) {
			iActive = false;
		}
	}

	function visibleNote(toggle) {
		inputNote.visible = toggle;
	}
	
	function isVisible() {
		
		return isVisible;
	}
	
	function open() {

		isOpen = true;
		
		inputCursor.visible = true;
		inputNote.visible = false;
		guiKeys(false);
		tim();
	}
	
	function close() {
		
		isOpen = false;
		inputCursor.visible = false;
		inputCursor.top();
		if (inputText == "") {
			inputNote.visible = true;
			inputNote.top();
		}
		guiKeys(true);
	}
	
	function getOpen() {
		
		return isOpen;
	}
	
	function tim() {
		
		if (isVisible == true && isOpen == true) {
			local inst = this;
				inputCursorTim = setTimer(function() {
					
					if (inst.isVisible == true && inst.isOpen == true) {
						if (inst.pressTimB == false) {
							inst.inputCursor.visible = !inst.inputCursor.visible;
							inst.inputCursor.top();
						}
						inst.tim();
					} else {
						inst.inputCursor.visible = false;
					}
				},500,1);
		}
	}
	
	function pressTim() {
		if (isVisible == true && isOpen == true) {
			
			inputCursor.visible = true;
			pressTimB = true;
			local inst = this;
			inputPressTim = setTimer(function() {
			
				if (inst.isVisible == true && inst.isOpen == true) {
					inst.pressTimB = false;
					//inst.tim();
				} else {
					inst.inputCursor.visible = false;
				}
			},100,1);
		}
	}
	
	function setPass(toggle = true) {
		
		if (toggle != true && toggle != false) {
			toggle = true;
		}
		
		inputPass = toggle;
	}
	
	function getPass() {
		
		return inputPass;
	}
	
	function setText(text) {
		
		inputParams.input.text = text.tostring();
		input.text = text.tostring();
	}
	
	function get() {
		
		return inputParams.input.text;
	}
	
	function setColor(r,g,b) {
		
		inputParams.input.r = r;
		inputParams.input.g = g;
		inputParams.input.b = b;
		
		input.setColor(r,g,b);
	}
	
	function setNoteColor(r,g,b) {
		
		inputParams.note.r = r;
		inputParams.note.g = g;
		inputParams.note.b = b;
		
		inputNote.setColor(r,g,b);
	}
	
	function setNoteText(text) {
		
		inputParams.note.text = text;
		
		inputNote.text = text;
	}
	
	function setPosition(x,y,bX,bY) {
		
		inputParams.input.x = x;
		inputParams.input.y = y;
		inputParams.background.x = bX;
		inputParams.background.y = bY;
		
		input.setPosition(x,y);
		inputNote.setPosition(x,y);
		inputBackground.setPosition(bX,bY);
	}
	
	function setSize(bW,bH) {
		
		inputParams.background.w = bW;
		inputParams.background.h = bH;
		
		inputBackground.setSize(bW,bH);
	}
	
	function getParams() {
		
		return inputParams;
	}
	
	function access(toggle) {
		
		if (toggle != true && toggle != false) {
			toggle = true;
		}
		
		isAccess = toggle;
	}
	
	function getAccess() {
		
		return isAccess;
	}
	
	function getActive() {
		
		return iActive;
	}
	
	function connect(window) {
		
		if (window != -1 && connectedWin == -1) {
			if (window.getType() == 2) {
				local win = window.getParams();
				connectedWin = window;
				winParamsX = win.x;
				winParamsY = win.y;
			}
		}
	}
	
	function disconnect() {
		connectedWin = -1;
	}
	
	function check() {
		
		if (isVisible) {
			
			// check max len
			if (inputParams.input.text.len() > inputMaxLen) {
				inputParams.input.text = inputParams.input.text.slice(0,inputMaxLen);
			}
		
			// check len
			
			if (inputParams.input.text.len() > inputLen) {
				inputText = inputParams.input.text.slice(inputParams.input.text.len() - inputLen,inputParams.input.text.len());
				chatInputSetText(inputText);
			} else {
				inputText = inputParams.input.text;
			}
			
			// check pass
			
			if (inputPass == true) {
				local inputPassText = "";
				for (local i = 0; i < inputText.len(); ++i) {
					inputPassText = inputPassText + "#";
				}
				inputText = inputPassText;
			}
			
			local inputCursorText = split(inputText," ");
			local inputTextWhiteSpaces = 0;
			for (local i = 0; i < inputCursorText.len(); ++i) {
				if (inputCursorText.len() > 1) {
					inputTextWhiteSpaces += 18;
					if (i > 1) {
						inputTextWhiteSpaces += (i * 2);
					}
				}
			}

			inputCursor.setPosition(inputParams.input.x + textWidth(inputText) - inputTextWhiteSpaces,inputParams.input.y);
			
			input.text = inputText;
			
			// check activity
			
			local pos = getCursorPosition();
			if (isAccess == true) {
				if ((pos.x >= inputParams.background.x && pos.x <= (inputParams.background.x + inputParams.background.w)) && (pos.y >= inputParams.background.y && pos.y <= (inputParams.background.y +inputParams.background.h))) {
					iActive = true;
				} else {
					iActive = false;
				}
			}
		}
	}
	
	
	function syncWin(x,y) {
		
		if (connectedWin != -1) {
			local win = connectedWin.getParams();
			local params = getParams();
			input.setPosition(params.input.x - (winParamsX - win.x),params.input.y - (winParamsY - win.y));
			inputNote.setPosition(params.input.x - (winParamsX - win.x),params.input.y - (winParamsY - win.y));
			inputBackground.setPosition(params.background.x - (winParamsX - win.x),params.background.y - (winParamsY - win.y));
			inputParams.input.x = params.input.x - (winParamsX - win.x);
			inputParams.input.y = params.input.y - (winParamsY - win.y);
			inputParams.background.x = params.background.x - (winParamsX - win.x);
			inputParams.background.y = params.background.y - (winParamsY - win.y);
			winParamsX = win.x;
			winParamsY = win.y;
		}
	}
	
	function top() {
		
		input.top();
		inputBackground.top();
		inputNote.top();
	}
	
	input = -1;
	inputBackground = -1;
	inputNote = -1;
	inputPass = false;
	inputLen = -1;
	inputText = "";
	inputMaxLen = -1;
	inputParams = -1;
	
	inputCursor = -1;
	inputCursorTim = -1;
	inputPressTim = -1;
	
	connectedWin = -1;

	pressTimB = false;
	
	winParams = {x = -1, y = -1};
	isOpen = false;
	isVisible = false;
	isAccess = true;
	iActive = false;
	type = 4;
	
}

function guiClick(key) {
	
	if (key == MOUSE_LMB) {
		if (texElements.len() != 0) {
			for (local i = (texElements.len() - 1); i >= 0; --i) {
				if (texElements[i].type == 2) {
					if (texElements[i].isVisible()) {
						if (texElements[i].getActive()) {
							texElements[i].setMoving(true);
							break;
						}
					
					} else {
						continue;
					}
				}
			}
		}
	}
}

addEventHandler("onMouseClick",guiClick);

function guiRelease(key) {
	
	if (key == MOUSE_LMB) {
		if (texElements.len() != 0) {
			for (local i = (texElements.len() - 1); i >= 0; --i) {
				if (texElements[i].type == 2) {
					if (texElements[i].isVisible()) {
						if (texElements[i].getMoving()) {
							texElements[i].setMoving(false);
							break;
						}
					} else {
						continue;
					}
				}
			}
		}
	}
}

addEventHandler("onMouseRelease",guiRelease);

function guiRender() {
	
	if (texElements.len() != 0) {
		for (local i = 0; i < texElements.len(); ++i) {
			texElements[i].check();
		}
	}
	
}

addEventHandler("onRender",guiRender);

function guiKey(key) {
	if (texElements.len() != 0) {
		for (local i = 0; i < texElements.len(); ++i) {
			if (texElements[i].type == 4) {
				if (texElements[i].isOpen == true) {
					if (key == 14) { // BACKSPACE
						if (texElements[i].inputParams.input.text.len() > 0) {
							texElements[i].inputParams.input.text = texElements[i].inputParams.input.text.slice(0,texElements[i].inputParams.input.text.len() -1);
						}
					} else {
						if (getKeyLetter(key)) {
							texElements[i].inputParams.input.text += getKeyLetter(key);
						}
					}
				}
			}
		}
	}
}

function guiKeys(toggle) {
	
	enableKeys(toggle);
}

addEventHandler("onKey",guiKey);
