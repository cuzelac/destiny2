#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#maxThreadsPerHotkey, 2
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

setKeyDelay, 50, 50
setMouseDelay, 50

POSTMASTER_CAPACITY := 20

;;
;; Turn in 20 tokens
;;

token_toggle := 0

F9::
  token_toggle := !token_toggle
  ToolTip Turning in tokens (F9)

  Loop, %POSTMASTER_CAPACITY% {
    Loop, 3 {
      Sleep, 1000
    }
    if (token_toggle = 0) {
      break
    }
  }

  ToolTip
return

;;
;; Dismantle equipment (toggle)
;;

dismantle_toggle := 0

F10::
  ToolTip, Dismantling (F10)
  dismantle_toggle := !dismantle_toggle

  while (dismantle_toggle = 1) {
    Send {f down}
    Sleep, 1050
    Send {f up}
    Sleep, 600
  }
  ToolTip
return

;;
;; Sell shaders (toggle)
;;

shader_toggle = 0

F11::
  shader_toggle := !shader_toggle
  ToolTip, Selling shaders (F11)

  while (shader_toggle = 1) {
    Send {f down}
    Sleep, 1000
    Send {f up}
    Sleep, 100
  }
  ToolTip
return
