#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>

#include <WindowsConstants.au3>

Example()

Func Example()
	GUICreate("My GUI") ; will create a dialog box that when displayed is centered

;~ 	GUICtrlCreateButton("my picture button", 10, 20, 32, 32, $BS_ICON)
;~ 	GUICtrlCreateButton("my picture button", 10, 20, 32, 32, BitOR($BS_FLAT, $BS_PUSHBOX))
;~ 	GUICtrlCreateButton("my picture button", 10, 20, 32, 32,  $BS_PUSHBOX)
	GUICtrlCreateButton("my picture button", 10, 20, 32, 32, BitOR($BS_ICON, $BS_FLAT,$WS_EX_TRANSPARENT))
;~ 	GUICtrlCreateButton("my picture button", 10, 20, 32, 32, BitOR($BS_FLAT,0))

	GUICtrlSetImage(-1, "shell32.dll", 16750)

	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

		EndSwitch
	WEnd
EndFunc   ;==>Example
