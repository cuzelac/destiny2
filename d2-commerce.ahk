#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#maxThreadsPerHotkey, 2
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

setKeyDelay, 50, 50
setMouseDelay, 50

POSTMASTER_CAPACITY := 20

; dismantle toggle
dismantle_toggle :=0

F9::
  ToolTip, Dismantling (F9)
  dismantle_toggle := !dismantle_toggle
  
  while (dismantle_toggle = 1) {
    Send {f down}
    Sleep, 1050
    Send {f up}
    Sleep, 600
  }
  ToolTip
return

; Turn in tokens
token_toggle := 0

F10::
  token_toggle := !token_toggle
  ToolTip Turning in tokens (F10)

  Loop, %POSTMASTER_CAPACITY% {
    Loop, 3 {
      Click
      Sleep, 1000
    }
    if (token_toggle = 0) {
      break
    }
  }

  ToolTip
return