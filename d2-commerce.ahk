#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#maxThreadsPerHotkey, 2
#SingleInstance Force ; always kill running instance of script if it exists
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

setKeyDelay, 50, 50
setMouseDelay, 50

POSTMASTER_CAPACITY := 20

; Vendor item box measurements at 1080p, measured at Spider
; 96x96
; padding: 6
; padding between last row of old section and first row of new: 87

ITEM_WIDTH := 96
ITEM_HEIGHT := ITEM_WIDTH
ITEM_HORIZ_PAD := 6

toggle := {}

/*
 * AHK TREATS EVERYTHING ABOVE THE FIRST HOTKEY AS A SINGLE MAGIC FUNCTION
 */
 
/*
 * General notes
 * You can reassign hotkeys and things should just work
 * Hotkey functions can generally be cancelled by pressing the hotkey again
 */
 
/*
 * General TODO
 * - Too much boilerplate
 * - Look at AHK's OO features to see if they'd make it easier to navigate a vendor
 * - Organize functions & shortcuts better 
 */
 
; Sell Vanguard tokens

F7::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]
  
  count := 0
  tip_str := "({1})`nCount: {2}"
  
  while (toggle[this_hotkey] = 1) {
    ToolTip, % Format(tip_str, this_hotkey, count)
    count += 1
    
    ; tokens: 1256,313
    MouseMove 1256, 313
    DoClick()
    Sleep, 250
    DoClick()
    ; engram: 1693,210
    Sleep, 250
    MouseMove 1693, 210
    DoClick()
    
    Sleep, 900
  }
  
  ToolTip
return

/*
 * Don't get sent to orbit by doing the following at least every 10m:
 *  - Move twice
 *  - Look twice
 *  - Do two actions
 * 
 * For afk farming exp in Shattered Throne thrall room 
 */

F8::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]
  
  count := 0
  tip_str := "({1})`nCount: {2}"
  
  while (toggle[this_hotkey] = 1) {
    ToolTip, % Format(tip_str, this_hotkey, count)
    count += 1
    
    ; reload & switch weapon
    PressKey("r")
    RandomSleep(200, 400)
    PressKey("~")
    
    ; Move forward and back
    Random, walk_time, 50, 75
    PressKey("w", walk_time, walk_time)
    RandomSleep(50, 100)
    PressKey("s", walk_time, walk_time)
    
    ; Move mouse up & down
    move_amt := 100
    MouseMove, 0 , move_amt, 95, R
    RandomSleep(150, 400)
    MouseMove, 0, -move_amt, 95, R
    
    ; Sleep for a minute
    RandomSleep(60000,61000)
  }

  ToolTip
return

PressKey(key, min := 100, max := 200) {
  Send, {%key% down}
  RandomSleep(min, max)
  Send, {%key% up}
}

RandomSleep(min, max) {
  Random, sleep_time, min, max
  Sleep, sleep_time
}

/*
 * Click in a loop
 * Good for buying one thing repeatedly from a vendor
 */

F9::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]
  
  count := 0
  tip_str := "Clicking in a loop ({1})`nCount: {2}"
  
  while (toggle[this_hotkey] = 1) {
    count += 1
    ToolTip, % Format(tip_str, this_hotkey, count)
    DoClick()
  }

  ToolTip
return

/*
 * Press & hold F in a loop (toggle)
 * Good for dismantling things under the mouse
 */

F10::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]
  
  count := 0
  tip_str := "Dismantling in a loop ({1})`nCount: {2}"

  while (toggle[this_hotkey] = 1) {
    count += 1
    ToolTip, % Format(tip_str, this_hotkey, count)
    ;DoDismantle(hold_time := 4050) ; Exotics
    DoDismantle()
  }

  ToolTip
return

; Send an f key and hold it long enough for a dismantle
; Includes padding sleep after
DoDismantle(hold_time:=1050, padding:=600) {
  Send {f down}
  Sleep, hold_time
  Send {f up}
  Sleep, padding
}

/*
 * Dismantle shaders (toggle)
 * Tuned to go faster since shaders dismantle quicker
 */

F11::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]
  count := 0
  tip_str := "Dismantling shaders ({1})`nCount: {2}"

  while (toggle[this_hotkey] = 1) {
    count += 1
    ToolTip, % Format(tip_str, this_hotkey, count)
    DoDismantle(1000, 100)
  }

  ToolTip
return

/*
 * Buy some items from a row at a vendor in a loop
 * Usage:
 *   1. Put your game in windowed mode at 1080p resolution
 *   2. Put your mouse over the first item in the row
 *   3. Press the hotkey (F12 currently)
 *   4. Enter the # of items in the row (7 in Spider's Material Exchange)
 *   5. Check the boxes that represent the items in the row you want to buy
 *   6. Press the hotkey again to cancel the loop
 */

F12::
  this_hotkey := A_ThisHotkey

  toggle[this_hotkey] := !toggle[this_hotkey]
  if (!toggle[this_hotkey]) {
    return
    ToolTip
  }

  ; store mouse position in orig_x and orig_y
  ; store window ahk_id to work around bug that changes active window
  MouseGetPos, orig_x, orig_y, destiny_window_ahk_id
  
  InputBox, num_items, how many? (a row usually has 7)
  OutputDebug, %num_items%
  
  ; Switch back to d2 window to work around
  ; InputBox behavior that changes active window
  WinActivate, ahk_id %destiny_window_ahk_id%

  ; START building checkbox gui window
  ; TODO it would be cool if 
  Gui, New
  Gui, Add, Text,, Check the items you want to buy
  Gui, Add, Text

  ; add checkbox elements to gui horizontally
  Loop %num_items% {
    OutputDebug, creating checkbox number %A_Index%
    ; 'x+28' spaces out checkboxes so they're roughly above each item square
    Gui, Add, CheckBox, vcheckbox_out%A_Index% x+28 Checked, 
  }

  ; 2nd arg 'Button' + last arg 'OK' mean go to tag 'ButtonOK' below
  Gui, Add, Button, default, OK
  Gui, Show,, Select Items
  ; END checkbox gui build

  return

  ButtonOK:
  Gui, Submit

  if (!num_items) {
    return
  }
  
  total := 1
  tip_str := "Buy multiple from vendor row ({1})`nCount: {2}"
  ToolTip, % Format(tip_str, this_hotkey, total)
  
  WinActivate, ahk_id %destiny_window_ahk_id%
  MouseMove, orig_x, orig_y
  
  index := 1
  while (toggle[this_hotkey]) {
    if (checkbox_out%index% = 1) {
      ;~ TestClick()
      ;~ Sleep, 1000
      DoClick()
    }
  
    if (index >= num_items) {
      index := 1
      total++
      MouseMove, orig_x, orig_y
      ToolTip, % Format(tip_str, this_hotkey, total)
    }
    else {
      NextItem()
      index++
    }
  }
  
  ToolTip
return

; Don't actually click but put up a tool tip
; for testing visually
TestClick(padding:=1000) {
  ToolTip, CLICK, , , 1
  Sleep, 150
  ToolTip, , , , 1
  Sleep, padding
}

DoClick(padding:=1000) {
  Sleep, 50
  Click
  Sleep, padding
}

; Move to the next item in a vendor's row
; NB: globals have to be defined at the top of the file before the first function
NextItem() {
  Global ITEM_WIDTH, ITEM_HORIZ_PAD

  MouseMove, ITEM_WIDTH + ITEM_HORIZ_PAD, 0, , R
}



