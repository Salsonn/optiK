/* optiK Wyrm

████████████████████████████████████████████████████████████████
███████████████████████████████████  ██████████████  ████  █████
███████████████████████████████████  ██████████████  ███  ██████                        _______    _______ 
████████████████████████████████        ███████████  ██  ███████   |\     /| |\     /| |  ____  | |       |
███████       ███████        ██████  ██████  ██████    █████████   | |   | | | \   / | | |    | | | || || |
█████  ██   ██  ████   ████   █████  ██████████████    █████████   | |   | |  \ |_| /  | |____| | | || || |
████  ██     ██  ███  ██████  █████  ██████  ██████  ██  ███████   | | Ʌ | |   \   /   |     __ | | | V | |
█████  ██   ██  ████   ████   █████  ██████  ██████  ███  ██████   | || || |    | |    | |\ |     | |   | |
███████       ██████         ██████  ██████  ██████  ████  █████   | || || |    | |    | | \ \__  | |   | |
████████████████████  ██████████████████████████████████████████   |_______|    \_/    |/   \__/  |/     \|
version 2.0-beta 
Used with a Redragon Samsara2 (M902-RGB)
ALT+219 = █
*/
/* Key Guide

   TOP			Side
 ___   ___   _________________
/d a|c|b  \  /    6   7   8    \ 		a. LButton		1. Media_Next	5. XButton1			9. XButton2
|   | |   | |     __ ___ __     |		b. RButton    	2. Media_Prev	6. Media_Play_Pause	
|   1 3   | |    /         \    |		c. MButton		3. Volume_Up	7. Media_Mute		
|   2 4   |  \  | 5       9 |   /		d. Apps+LButton	4. Volume_Down	8. Media_Stop		
|_______ _|   \________________/

*/

;{██ AHK Settings
#NoEnv
#Warn
#InstallKeybdHook
#InstallMouseHook
#SingleInstance Force
;}

;{██ AHK Variables
DetectHiddenWindows, On
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, 2
CoordMode, Mouse, Screen
;}

;{██ optiK Variables
	RegRead, SavedGamesDir, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, {4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}
;}

;{██ Initialization
	;{██ Tray Menu
	Menu,	Tray,	Add,		Edit Elite Ship List,	shipList ; Add Elite .ini edit button
	Menu,	Tray,	Add,		optiK 2.0 (Wyrm), 		reset ;Add reload button
	Menu,	Tray,	Default,	optiK 2.0 (Wyrm) ;Make reload default action
	Menu,	Tray,	Disable,	optiK 2.0 (Wyrm) ;Grey out reload button
	Menu,	Tray,	Click, 		1 ;Set reload to single click
	Menu,	Tray,	Tip,		Click to reload optiK ;Icon mouseover text
	gosub, ico ;} Update tray icon
	;{██ WinGroup Assignments
	GroupAdd, EDGame, ahk_exe EliteDangerous64.exe
	GroupAdd, EDGame, ahk_exe EliteDangerous32.exe 
	GroupAdd, EliteDangerous, ahk_group EDGame
	GroupAdd, EliteDangerous, ahk_exe EDLaunch.exe ;}
	SetTimer, EDUpdate, 20000
	gosub, EDUpdate
return
;}██


;{██ Elite Dangerous
	#IfWinActive ahk_group EDGame
	*XButton1::n
	XButton2::Down
	#IfWinActive
	#If btn("Media_Next", "ahk_group EDGame") and EDShipName == "The Corvid"
		Media_Next::send, {Down}{Up}{Left 2}
		+Media_Next::send, {Right}
	#If
	#If btn("Media_Next", "ahk_group EDGame") and EDShipName == "Poker of Justice"
		Media_Next::send, {Down}{Up}{Right 2}
	#If
	#If btn("Media_Next", "ahk_group EDGame")
		Media_Next::send, {Right}
	#If
	#If btn("Media_Prev", "ahk_group EDGame")
		Media_Prev::send, {Left}
		+Media_Prev::send, {Down}{Left 2}
	#If
	#If btn("Volume_Up", "ahk_group EDGame")
		Volume_Up::send, {Down}{Up 2}
		*Volume_Up::send, {Down}{Up 2}
	#If
	#If btn("Volume_Down", "ahk_group EDGame")
		Volume_Down::send, u
		*Volume_Down::send, u
	#If
;}

;{██ Global Hotkeys
	;{██ Tray Icon Control
	~*LButton::gosub ico
	~*LButton Up::gosub ico
	~*RButton::gosub ico
	~*RButton Up::gosub ico
;}██
	
	;{██ Double & Triple Click
	AppsKey & MButton::Click 2
	*AppsKey::AppsKey
	;}
	
	;{██ Speed Scrolling
	*XButton1:: ;Scroll Up
	Loop, {
	MouseClick, WU,,, 2 - GetKeyState("LWin") + GetKeyState("LAlt"),, D
	If !GetKeyState("XButton1", "P")
		return
	sleep, 72
	}
	MsgBox, uh ohhh
	*XButton2:: ;Scroll Down
	Loop, {
	MouseClick, WD,,, 2 - GetKeyState("LWin") + GetKeyState("LAlt"),, D
	If !GetKeyState("XButton2", "P")
		return
	sleep, 72
	}
	;}

	;{██ Disable Unused Buttons
	#if btn("Media_Next")
	Media_Next::return
	#if
	#if btn("Media_Prev")
	Media_Prev::return
	#if
	#if btn("Volume_Up")
	Volume_Up::return
	#if
	#if btn("Volume_Down")
	Volume_Down::return
	#if
	#if btn("Media_Play_Pause")
	Media_Play_Pause::^v
	#if
	#if btn("Volume_Mute")
	Volume_Mute::^c
	#if
	#if btn("Media_Stop")
	Media_Stop::^x
	#if
	;}
	
;}

;██ Functions
;{
btn(mBtn, wind:="a") { ;	Updates tray icon based on LButton and RButton states
	if !GetKeyState(mBtn, "P") and !GetKeyState(mBtn) and WinActive(wind)
		return 1
	return 0
}

ReadEDLogs(dir, searchString, freshestFile:=0, lineFound:=0) {
Loop, %dir%\Frontier Developments\Elite Dangerous\*.log						;
	If (A_LoopFileTimeCreated > freshestFile)								; Finds most recent log file
		out := A_LoopFileFullPath, freshestFile := A_LoopFileTimeCreated	;
loop, Read, %out%									;
	if A_LoopReadLine contains %searchString%		; Searches recent log for
		if (InStr(A_LoopReadLine, searchString))	; line containing searchString
		    lineFound := A_LoopReadLine				;
if (lineFound == 0)
	Return "null"
loop, Read, ShipList.ini					; Searches above line
	if lineFound contains %A_LoopReadLine%	; for string contained
		Return A_LoopReadLine				; in Shiplist.ini
}

;}

;██ GoSubs
;{
ico: ;{			Updates tray icon based on LButton and RButton states
	icon := "ico\optiK" . GetKeyState("LButton", "P") . GetKeyState("RButton", "P") . ".ico"
	Menu, Tray, Icon, %icon%
	return
;}

reset: ;{		Reloads optiK
	Reload
;}

EDUpdate: ;{	Rechecks ED logs for change in current ship
	If !WinExist("ahk_group EliteDangerous") {
		Menu, Tray, Disable, Edit Elite Ship List
		SetKeyDelay, 10
		return ; skips if Elite Dangerous isn't running
	}
	Menu, Tray, Enable, Edit Elite Ship List
	SetKeyDelay, 32
	EDShipName := ReadEDLogs(SavedGamesDir, chr(34) . "ShipName")
	return
;}

shipList: ;{	Opens ShipList.ini for editing
	Run, edit "ShipList.ini"
	;}
;}

/*████ Templates ████
------------------------------------------------------------------------------------------
#if btn("mBtn", "WinTitle")
mBtn::
#if
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
;{██ CategoryName
	;{██ Subcategory
	
	;}
;}
if ()
  {
  
  }
else if ()
  {
  
  }
else
  {
  
  }
------------------------------------------------------------------------------------------
*/