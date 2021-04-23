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
 * Don't forget that above here is a magic function
 */

;;
;; Turn in 20 tokens
;;

F9::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]
  
  ToolTip % "Turning in tokens (" . this_hotkey . ")"

  Loop, %POSTMASTER_CAPACITY% {
    Loop, 3 {
      Click
      Sleep, 1000
    }
    if (toggle[this_hotkey] = 0) {
      break
    }
  }

  ToolTip
return

;;
;; Dismantle equipment (toggle)
;;

F10::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]

  ToolTip, % "Dismantling (" . this_hotkey . ")"

  while (toggle[this_hotkey] = 1) {
    DoDismantle()
  }
  ToolTip
return

DoDismantle(hold_time:=1050, padding:=600) {
  Send {f down}
  Sleep, hold_time
  Send {f up}
  Sleep, padding
}

;;
;; Sell shaders (toggle)
;;

F11::
  this_hotkey := A_ThisHotkey
  toggle[this_hotkey] := !toggle[this_hotkey]
  ToolTip, % "Selling shaders (" . this_hotkey . ")"

  while (toggle[this_hotkey] = 1) {
    DoDismantle(1000, 100)
  }
  ToolTip
return

;;
;; Spider material exchange
;;

F12::
  this_hotkey := A_ThisHotkey

  toggle[this_hotkey] := !toggle[this_hotkey]
  if (!toggle[this_hotkey]) {
    return
    ToolTip
  }

  ; store mouse position in orig_x and orig_y
  MouseGetPos, orig_x, orig_y
  
  InputBox, num_items, how many?
  OutputDebug, %num_items%

  Gui, New
  Gui, Add, Text,, Check the items you want to buy
  Gui, Add, Text

  ; add checkbox elements to gui horizontally
  Loop %num_items% {
    OutputDebug, creating checkbox number %A_Index%
    Gui, Add, CheckBox, vcheckbox_out%A_Index% x+1 Checked, 
  }

  Gui, Add, Button, default, OK
  Gui, Show,, Select Items

  return

  ButtonOK:
  Gui, Submit

  if (!num_items) {
    return
  }
  
  total := 1
  tip_str := "Buy multiple from vendor ({1})`nCount: {2}"
  ToolTip, % Format(tip_str, this_hotkey, total)
  
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

NextItem() {
  Global ITEM_WIDTH, ITEM_HORIZ_PAD

  MouseMove, ITEM_WIDTH + ITEM_HORIZ_PAD, 0, , R
}



