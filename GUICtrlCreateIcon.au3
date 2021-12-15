#include <GUIConstantsEx.au3>

#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <WinAPI.au3>

Example()

Func Example()
	GUICreate(" My GUI Icons", 250, 250)

	$Pic1 = GUICtrlCreateIcon("shell32.dll", 10, 20, 20,-1,-1,$SS_NOTIFY)
;~ 	$Pic2 = GUICtrlCreateIcon(@ScriptDir & '\Extras\horse.ani', -1, 20, 40, 32, 32,$ss_notify)
	$Pic2 = GUICtrlCreateIcon("shell32.dll", 331, 100, 20, 32, 32, $SS_NOTIFY)
	$Pic3 = GUICtrlCreateIcon("shell32.dll", 7, 20, 75, 32, 32,$SS_NOTIFY)
	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	While 1
		$idMsg = GUIGetMsg()
;~ ConsoleWrite($idMsg & @CRLF)
;~ 		Switch GUIGetMsg()
		Switch $idMsg

			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $ss_notify
				ConsoleWrite("$ss_notify" & @CRLF)

			Case $GUI_EVENT_PRIMARYDOWN
	      $aInfo = GUIGetCursorInfo()
        If $aInfo[4] = $Pic1 Then ConsoleWrite("Pic1 Clicked" & @CRLF)
        If $aInfo[4] = $Pic2 Then ConsoleWrite("Pic2 Clicked" & @CRLF)
        If $aInfo[4] = $Pic3 Then ConsoleWrite("Pic3 Clicked" & @CRLF)

		EndSwitch
	WEnd

	GUIDelete()
EndFunc   ;==>Example

;~ Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)

;~     If $ilParam = $Pic1 Then

;~         Switch _WinAPI_HiWord($iwParam)

;~             Case $STN_CLICKED

;~                 ConsoleWrite("Clicked")

;~             Case $STN_DBLCLK

;~                 ConsoleWrite("Double Clicked")

;~         EndSwitch

;~         ConsoleWrite(" at (" & _WinAPI_GetMousePosX(True, $Form1) & "," & _WinAPI_GetMousePosY(True, $Form1) & ")" & @CRLF)

;~     EndIf

;~ EndFunc   ;==>WM_COMMAND