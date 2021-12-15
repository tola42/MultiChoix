#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=MultiChoix.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=MultiChoix
#AutoIt3Wrapper_Res_Description=Pour pouvoir avoir un dock d'application pour la fonction "Sendto" de Windows
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=21.12.a
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=FourLC
#AutoIt3Wrapper_Res_LegalCopyright=ChristopheL@fourlc.com
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_After=copy "%out%" "E:\LClogs"
#AutoIt3Wrapper_Run_After=copy "%outx64%" "E:\LClogs"
#AutoIt3Wrapper_Run_After=cmd.exe /c start "" "E:\LCLogs\%scriptfile%_x64.exe"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region HEADER
; AutoIt Version: 	3.3.6.1
; Language:       	French
; Platform:       	Win2000/Xp
; Author:         	LAMY Christophe
; Script function:	Xxxxxxxxxxxxxxxxxxxxxxxxx
; Usage:			xyz.exe par1
; parameters :		Yes/No
; Template date :	yyyy-mm-dd hh:nn:ss
; Comment :			For copy in "C:\Documents and Settings\DMLCL.PREF69\Modèles" (Sous Vista : C:\windows\Shellnew\) (For found 'Windows templates directory', type 'shell:templates' in RunBox)
; Comment : 		Or in "C:\Documents and Settings\All Users\Modèles" with name "Template.au3" (or rename this registry key "HKEY_CLASSES_ROOT\.au3\ShellNew\Filename")
#EndRegion HEADER

#Region INFOS : Somes informations about program.
#cs
#ce
#EndRegion INFOS : Somes informations about program.

#Region INCLUDES
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Debug.au3>
#include <ButtonConstants.au3>
; $SS_NOTIFY
#include <StaticConstants.au3>

#EndRegion INCLUDES

#Region OPTIONS
AutoItSetOption("MustDeclareVars", 1) ;Les varables DOIVENT etre déclarées !
AutoItSetOption("ExpandEnvStrings", 1) ;Expansion des variables d'environnement de l'OS dans les chaines autoit. Exemple: 'Consolewrite("Path = %PATH%" & @LF)' ecrira "Path=C:\bat;c:\windows;c:\......etc......" !
AutoItSetOption("ExpandVarStrings", 1) ;Pareil pour les variables AutoIt! Exemple : 'ConsoleWrite("PC=@Computername@" & @LF)' ecrira 'PC=PREF69-W2330' dans la console !
AutoItSetOption("GUIOnEventMode", 1) ; Change to OnEvent mode
#EndRegion OPTIONS

#Region DECLARATION
Local $sPathTempFileTxt = _TempFile(@TempDir, Default, ".txt")
Local $bIsAtWork = StringLeft(@IPAddress1, 3) = "10."
Local $sTemp = ""
Local $sDummy = ""
Local $sDrive, $sPath, $sFile, $sExt
Local $aSpliPath = _PathSplit(@ScriptFullPath, $sDrive, $sPath, $sFile, $sExt)
Global $sFileIni = $sDrive & $sPath & $sFile & ".ini"
Global $hMainGUI
Global $bQuit = False
Global $arrActions
Global $arrActionsKey
Global $arrActionsValue
Global $idComboBox
Global $Pic1
#EndRegion DECLARATION

#Region INIT
#EndRegion INIT

#include <Crypt.au3>
#Region Restore
;# Chek for specific keys ("Restore" for restoring an '.au3' file) on command line.
If StringInStr(StringUpper($CmdLineRaw), "/RESTORE", 2) Then
	If @Compiled Then
		Local $myPassword = StringUpper(InputBox("Password", "Entrez le mot de passe...", "", "*"))
		_Crypt_Startup()
		;Mes PRECIEUX
		ConsoleWrite(_Crypt_HashData($myPassword, $CALG_MD5) & @CRLF)
		If ((_Crypt_HashData($myPassword, $CALG_MD5) = "0x8D6B5CADA83510220F59E00CE86D4D92") Or (_Crypt_HashData($myPassword, $CALG_MD5) = "0x6195BCAB0F864599D18F560631736D16")) Then
			If FileInstall("MultiChoix.au3", @ScriptDir & "\") Then
;~ 			FileInstall("xxxx.kxf", @ScriptDir & "\")
				MsgBox(BitOR($MB_TOPMOST, $MB_TASKMODAL, $MB_SYSTEMMODAL, $MB_ICONINFORMATION), "Restoration", "Restauration effectuée!", 28)
			Else
				MsgBox(BitOR($MB_TOPMOST, $MB_TASKMODAL, $MB_SYSTEMMODAL, $MB_ICONERROR), 'Restoration', "Restauration échouée !")
			EndIf
		Else
			MsgBox(BitOR($MB_TOPMOST, $MB_TASKMODAL, $MB_SYSTEMMODAL, $MB_ICONERROR), 'Restoration', "Mot de passe invalide !")
		EndIf
		_Crypt_Shutdown()
		Exit
	EndIf
EndIf
#EndRegion Restore

#Region MAIN
$arrActions = _LireIni()
If IsArray($arrActions) Then
	$arrActionsKey = _ArrayExtract($arrActions, 1, -1, 0, 0)
	$arrActionsValue = _ArrayExtract($arrActions, 1, -1, 1, 1)
;~ 	ConsoleWrite(_ArrayToString($arrActions) & @CRLF)
	ConsoleWrite(_ArrayToString($arrActionsKey) & @CRLF & @CRLF)
	ConsoleWrite(_ArrayToString($arrActionsValue) & @CRLF & @CRLF)
;~ 	_test()
	_ShowGui($arrActionsKey)

EndIf
;~ Exit 666

While $bQuit = False
	Sleep(100)   ; Sleep to reduce CPU usage
WEnd
Exit 0
#EndRegion MAIN

#Region *-*-* FONCTIONS METIER*-*-*

Func _ShowGui($arrActionsKey)
	Local $i = 0
	Local $hMainGUI = GUICreate("---", 290, 24, -1, -1, BitOR($DS_MODALFRAME, $WS_POPUPWINDOW), BitOR($WS_EX_TOPMOST, $WS_EX_DLGMODALFRAME))
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_TestButtonPic")

;~ 	$idComboBox = GUICtrlCreateCombo("Item 1", 1, 1, 198)
	$idComboBox = GUICtrlCreateCombo($arrActionsKey[0], 1, 1, 198 + 12)
	For $i = 1 To UBound($arrActionsKey) - 1
		GUICtrlSetData($idComboBox, $arrActionsKey[$i])
	Next
;~ 	GUICtrlSetData($idComboBox, "Item 2|Item 3", "Item 2")

;~ 	Local $iQuitButton = GUICtrlCreateButton("X", 200, 1, 50, 22)

	Local $iOKButton = GUICtrlCreateButton("OK", 212, 1, 26, 22, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent($iOKButton, "OKButton")

;~ 	Local $iParamsButton = GUICtrlCreateButton("Pars", 238, 1, 32, 22, BitOR($BS_ICON, $BS_FLAT))
;~ 	GUICtrlSetImage($iParamsButton, "shell32.dll", 331, 0)
;~ 	GUICtrlSetOnEvent($iParamsButton, "_Params")

	$Pic1 = GUICtrlCreateIcon("shell32.dll", 331, 238, 1, 32, 32, $SS_NOTIFY)
	GUICtrlSetImage($Pic1, "shell32.dll", 331, 0)


	Local $iQuitButton = GUICtrlCreateButton("X", 270, 1, 20, 22)
	GUICtrlSetOnEvent($iQuitButton, "CLOSEButton")

	GUISetState(@SW_SHOW, $hMainGUI)
EndFunc   ;==>_ShowGui

Func _LireIni()
	Local $iNbActions = 0
	Local $_arrActions = IniReadSection($sFileIni, "Actions")

	If IsArray($_arrActions) Then
;~ 	_DebugArrayDisplay($_arrActions)
;~ 		$iNbActions = $_arrActions[0][0]
;~ 		ConsoleWrite($iNbActions & @CRLF)
;~ 		ConsoleWrite(_ArrayToString($_arrActions) & @CRLF)
;~ 		_DebugArrayDisplay(_ArrayExtract($_arrActions, 1, -1, 0, 0))
;~ 		_DebugArrayDisplay(_ArrayExtract($_arrActions, 1, -1, 1, 1))
		Return $_arrActions
	Else
		Return SetError(1, 1, "Actions aren't in an array.")
	EndIf

EndFunc   ;==>_LireIni

Func OKButton()
	; Note: At this point @GUI_CtrlId would equal $iOKButton,
	; and @GUI_WinHandle would equal $hMainGUI
	MsgBox($MB_OK, "GUI Event", "You selected OK!")


EndFunc   ;==>OKButton

Func _TestButtonPic()
	Local $aInfo = GUIGetCursorInfo()
;~ 	If $aInfo[4] = $Pic1 Then ConsoleWrite("Pic1 Clicked" & @CRLF)
	If $aInfo[4] = $Pic1 Then _Params()
EndFunc   ;==>_TestButtonPic


Func CLOSEButton()
	; Note: At this point @GUI_CtrlId would equal $GUI_EVENT_CLOSE,
	; and @GUI_WinHandle would equal $hMainGUI
;~ 	MsgBox($MB_OK, "GUI Event", "You selected CLOSE! Exiting...")
	; Exit
	$bQuit = True
EndFunc   ;==>CLOSEButton

Func _Params()
	MsgBox($MB_OK, "GUI Event", "Paraletrage ....")
EndFunc   ;==>_Params

Func _test()
	Local $sMsg = ""
	If $CmdLineRaw <> "" Then
		MsgBox($MB_TOPMOST + $MB_TASKMODAL + $MB_SYSTEMMODAL + $MB_ICONINFORMATION, "Info...", $CmdLineRaw, 7)
	Else
		MsgBox($MB_TOPMOST + $MB_TASKMODAL + $MB_SYSTEMMODAL + $MB_ICONERROR, "Info...", "Pas de paramètres.", 7)
	EndIf
EndFunc   ;==>_test

#EndRegion *-*-* FONCTIONS METIER*-*-*

#Region *-*-* FONCTIONS GLOBALES *-*-*
Func _LCBasePath($p_sFilename)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $aPath = _PathSplit(StringLower($p_sFilename), $szDrive, $szDir, $szFName, $szExt)
	Return $szDrive & $szDir
EndFunc   ;==>_LCBasePath

Func _LCBaseName($p_sFilename)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $aPath = _PathSplit(StringLower($p_sFilename), $szDrive, $szDir, $szFName, $szExt)
	Return $szFName & $szExt
EndFunc   ;==>_LCBaseName

Func _LCNameAlone($p_sFilename)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $aPath = _PathSplit(StringLower($p_sFilename), $szDrive, $szDir, $szFName, $szExt)
	Return $szFName
EndFunc   ;==>_LCNameAlone

Func _EndPath($p_sPath)
	If StringRight($p_sPath, 1) <> "\" Then $p_sPath &= "\"
	Return $p_sPath
EndFunc   ;==>_EndPath


Func _LCPath234($p_sFilename)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $aPath = _PathSplit(StringLower($p_sFilename), $szDrive, $szDir, $szFName, $szExt)
	Return $szDir & $szFName & $szExt
EndFunc   ;==>_LCPath234

Func _LCPath12($p_sFilename)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $aPath = _PathSplit(StringLower($p_sFilename), $szDrive, $szDir, $szFName, $szExt)
	Return $szDrive & $szDir
EndFunc   ;==>_LCPath12
#EndRegion *-*-* FONCTIONS GLOBALES *-*-*
