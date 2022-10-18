# Gothic 2 Online - GUI Framework 2.0

usage:

### Buttons
```
local myButton = Button({x = x_, y = y_, width = width_, height = height_, texture = texture_});
void myButton.visible(bool toggle);             // show/hide button
bool myButton.isVisible();                      // return true/false if the button is visible
void myButton.texture(string tex);              // set new texture to the button
void myButton.setPosition(int x, int y);        // set new position to the button
void myButton.setSize(int width, int height);   // set new size to the button
void myButton.setAlpha(int alpha);              // change button's transparency
int myButton.getAlpha()
void myButton.setTexture(string texture)        // = myButton.texture(string texture)
{x, y, width, height, texture} myButton.getParams()    // get params table of the button
void myButton.access(bool toggle)               // accessibility of the button
bool myButton.getAccess()
bool myButton.getActive()                       // return true/false if the cursor hovers the button
void myButton.top()                             // set button to the top layer
void myButton.fadeOut()
void myButton.fadeIn()

void connect(Window winObject)                  // connect button to the window
void disconnect()
```
### Windows
```
(creation and all the methods are same as for button (except connect and disconnect))

void myWindow.setMoving(bool toggle)            // ability to move window with the mouse
void myWindow.getMoving()
```
### Text
```
local myText = Text({x = x_, y = y_, font = font_, text = text_, r = r_, g = g_, b = b_});

you can also create multiline text with the symbol & i.e.:
myText = Text({x = 1000, y = 1000, font = "Font_Old_10_White_Hi.TGA", text = "First Line&SecondLine&ThirdLine", r = 255, g = 255, b = 255});
it's quite useful to create menus (yes, you can get active line, not the full text)

myText.visible(bool toggle)
bool myText.isVisible()
void myText.setText(string text)        // set new text (with multiline support ofc.)
void myText.setLineText(int line, string text)    // set new text to the specific line (numerating starts with 0)
void myText.setFont(string font)        // set new font
void myText.setLineFont(int line, string font)    // set new font to the specific line
void myText.setColor(int r, int g, int b)         // set new color
void myText.setLineColor(int line, int r, int g, int b)
void myText.setPosition(int x, int y)
void myText.setAlpha(int alpha)
{x, y, font, text, r, g, b} myText.getParams()
void myText.setAccess(bool toggle)
bool myText.getAccess()
bool myText.getActive()
bool myText.getLineActive(int line)                 // return true/false if the cursor hovers specific line
void myText.top()
void myText.centrate(x)                             // centrate all the text lines basing on the x coordinate

void myText.connect(Window winObject)
void myText.disconnect()
```

### Input Field
```
local myInput = Input({
  input = {x = x_, y = y_, text = text_, r = r_, g = g_, b = b_},
  note = {r = r_, g = g_, b = b_, text = text_},
  background = {x = x_, y = y_, width = width_, height_, texture = texture_},
  pass = pass_,
  len = len_,
  maxlen = maxlen_
});

Table input contains information of the input text
Table note contains information of the note text (text that appears when the input field is empty)
Table background contains information of the input field's background
pass (bool) is mode that hides all symbols with "#"
len (int) is max visible(!) length of the input (it's needed for keeping visible text input in the background)
maxlen (int) is max length of the input

example:

local loginInput = Input({
   input = {x = 3797, y = 3688, r = 255, g = 255, b = 255, text = ""}, // text = "" cuz there is no value by default
   note = {r = 255, g = 255, b = 255, text = "Login"},                 // text "Login" appears when the input is empty
   background = {x = 3737, y = 3602, w = 1486, h = 339, texture = "TEXTBOX.TGA"},
   pass = false,       // this field is no need to hide
   len = 16,
   maxlen = 30
});

local passInput = Input({
   input = {x = 3797, y = 4040, r = 255, g = 255, b = 255, text = ""},
   note = note = {r = 190, g = 190, b = 190, text = "Password"},
   background = {x = 3737, y = 3966, w = 1486, h = 339, texture = "TEXTBOX.TGA"},
   pass = true,       // here. All the input symbols will replace with "#"
   len = 16,
   maxlen = 30
});

you can see this code working here: https://www.youtube.com/watch?v=GKmmavMBUJc

void myInput.visible(bool toggle)
void myInput.visibleNote(bool toggle)         // show/hide note
bool myInput.isVisible()
void myInput.open()             // opens input field (to enter the text)
void myInput.close()
bool myInput.getOpen()
void myInput.setPass(bool toggle)
bool myInput.getPass()
void myInput.setText(string text)
string myInput.get()            // get text from the input field
void myInput.setColor(int r, int g, int b)
void myInput.setNoteColor(int r, int g, int b)
void myInput.setNoteText(string text)
void myInput.setPosition(x, y, background_x, background_y)
void myInput.setSize(background_width, background_height)
table myInput.getParams()
void access(bool toggle)
bool getAccess()
bool getActive()
void connect(Window winObject)
void disconnect()
void top()
