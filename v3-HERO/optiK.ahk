﻿/* optiK HERO
████████████████████████████████████████████████████████████████
███████████████████████████████████  ██████████████  ████  █████
███████████████████████████████████  ██████████████  ███  ██████              _______   _______   _______ 
████████████████████████████████        ███████████  ██  ███████   |\     /| |  ____ \ |  ____ | /  ___  \
███████       ███████        ██████  ██████  ██████    █████████   | |   | | | |    \/ | |    || | |   | |
█████  ██   ██  ████   ████   █████  ██████████████    █████████   | |___| | | |__     | |____|| | |   | |
████  ██     ██  ███  ██████  █████  ██████  ██████  ██  ███████   |  ___  | |  __|    |     __| | |   | |
█████  ██   ██  ████   ████   █████  ██████  ██████  ███  ██████   | |   | | | |       | |\ |    | |   | |
███████       ██████         ██████  ██████  ██████  ████  █████   | |   | | | |____/\ | | \ \__ | |___| |
████████████████████  ██████████████████████████████████████████   |/     \| |_______/ |/   \__/ \_______/
version 3.0 
Used with a Logitech G502 SE (HERO)
ALT+219 = █
*/
/* Key Guide

 	   ███████		
 	   ██TOP██		
       ___   ___
 	 _/   | |   \_
	/G8 L<|M|>R   \			  ████████
	|G7   | |     |			  ██Side██
	|     |W|     |	 	  _________________
   /|    _|G9\_   |	     /    ______ ______ \ 		L. LButton		<.  WheelLeft	G6. F16
  / |  _/      \  \	    |   \   G5     G4    |		M. RButton    	>.  WheelRight	G7. F17
 /  |_/         \__\ 	| G6 \               |		R. MButton		G4. F14			G8. F18
/___\_            | 	 \__________________/		W. Wheel Lock	G5. F15			G9. G-Shift
     \\___		  /
      |	 /		 /
	   \/_______/
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
	optiKversion := "3.0 (HERO)"
	RegRead, SavedGamesDir, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, {4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}
;}

;{██ Initialization
	;{██ Tray Menu
	Menu,	Tray,	Add,		Edit Elite Ship List,	shipList ; Add Elite .ini edit button
	Menu,	Tray,	Add,		%optiKversion%, 		reset ;Add reload button
	Menu,	Tray,	Default,	%optiKversion% ;Make reload default action
	Menu,	Tray,	Disable,	%optiKversion% ;Grey out reload button
	Menu,	Tray,	Click, 		1 ;Set reload to single click
	Menu,	Tray,	Tip,		Click to reload optiK ;Icon mouseover text
	gosub, ico ;} Update tray icon
	;{██ WinGroup Assignments
	GroupAdd, EDGame, ahk_exe EliteDangerous64.exe
	GroupAdd, EDGame, ahk_exe EliteDangerous32.exe 
	GroupAdd, EliteDangerous, ahk_group EDGame
	GroupAdd, EliteDangerous, ahk_exe EDLaunch.exe ;}
	;{██ Game-specific Code Setup
	SetTimer, EDUpdate, 20000
	gosub, EDUpdate ;}
	SetKeyDelay, 16, 16
return
;}██

;{██ Global Hotkeys
	;~ F13 & F14::
	;~ F13 & F15::
	;~ F13 & F16::
	;~ F13 & F17::
	;~ F13 & F18::
	;~ return
	;{██ Tray Icon Control
		~*LButton::gosub ico
		~*LButton Up::gosub ico
		~*RButton::gosub ico
		~*RButton Up::gosub ico
	;}██
	
	;{██ Double & Triple Click
		$*F18::Click 2
	;}
	
	;{██ Speed Scrolling
		*F14:: ;Scroll Down
		Loop, {
		MouseClick, WD,,, 1 + GetKeyState("LAlt"),, D
		If !GetKeyState("F14", "P")
			return
		sleep, 72
		}
		*F15:: ;Scroll Up
		Loop, {
		MouseClick, WU,,, 1 + GetKeyState("LAlt"),, D
		If !GetKeyState("F15", "P")
			return
		sleep, 72
		}
	;}

	;{██ Disable Unused Buttons
		F16::^v
		F17::^c
		;F19::^x
	;}
	
;}

;{██ Elite Dangerous
	#If EDandShip("HAMMERHEAD CORVETTE")
		
	#If
	#If EDandShip("THE asdfCORVID")
		WheelRight::send, {Down}{Up}{Left 2}
		+WheelRight::send, {Right}
		WheelLeft::send, {Down}{Left 2}
	#If
	#If EDandShip("ONCOMING STORM")
		WheelRight::send, {Down}{Left}{Right}
		+WheelRight::send, {Down}{Left}
		WheelLeft::send, {Down}{Left 2}{Right}{Left}{Up}
		+WheelLeft::send, {Down}{Up}{Left 3}
		+F18::send, {Down}{Right}{Up 3}
	#If
	#If EDandShip("Mourning Dove")
		WheelRight::send, {Down}{Left}
		*F15::send, {Down}{Up}{Right}
		+WheelRight::send, {Right}
		WheelLeft::send, {Down}{Left 2}
	#If
	#If EDandShip("Poker of Justice")
		WheelRight::send, {Down}{Up}{Right 2}
	#If
	#If EDandShip("540 TON MICROWAVE") or EDandShip("THE CORVID")
		WheelRight::send, {Down}{Up}{Right 3}
		+WheelRight::send, {Down}{Left}{Right 3}
		!WheelRight::send, {Right}
		F18::send, {Down}{Right}{Up 3}
		+F18::send, {Down}{Left}{Up 3}
		!F18::send, {Up}
		!+F18::send, {Down}{Up 2}
		WheelLeft::send, {Down}{Right}{Left 3}
		+WheelLeft::send, {Down}{Up}{Left 3}
		!WheelLeft::send, {Left}
	#If
	#IfWinActive ahk_group EDGame
		*WheelLeft::send, {Left}
		+WheelLeft::send, {Down}{Left 2}
		*WheelRight::send, {Right}
		+WheelRight::send, {Down}{Right 2}
		*F16::n
		*F14::/
		*F15::!/
		+F14::Down
		+F17::u
		F18::send, {Down}{Up 2}
		;g::h
		;+g::send, {h Down}{h Up}{LShift Down}h{LShift Up}
		;!g::send, {h Down}{h Up}{LAlt Down}h{LAlt Up}
		;!f::send, op
		^Media_Play_Pause::9
		^Media_Next::0
		^Media_Prev::8
	#If
;}

;{██ Minecraft
	#IfWinActive, Minecraft
	!F16 Up::
	BlockInput, On
	ToolTip, Let go of all buttons
	sleep, 2500
	BlockInput, Off
	ToolTip
	return
	#IfWinActive
;}

;{██ Unreal Tournament (2000)
	#IfWinActive, ahk_exe UnrealTournament.exe
		F16::F16
		F15::
		SetKeyDelay, 16, 16
		if GetKeyState("w", "P") {
			send, {w up}w{w down}
		} else {
			send, ww
		}
		SetKeyDelay, 10, -1
		return
		F14::
		SetKeyDelay, 16, 16
		if GetKeyState("s", "P") {
			send, {s up}s{s down}
		} else {
			send, ss
		}
		SetKeyDelay, 10, -1
		return
	#IfWinActive
;}

;{██ Terraria
	#IfWinActive, ahk_exe Terraria.exe
		*F18::MouseClick, Left,,,,, D
		!F18::
		SetKeyDelay, 10, 32
		KeyWait, LAlt
		Loop {
		If GetKeyState("LAlt", "P")
			Break
		send, {Click}
		Sleep, 2750
		send, {Click}
		Sleep, 250
		send, {Click}
		}
		SetKeyDelay, 10
		Return
		*F15::e
		*F16::r
		*F14::h
		*F17::b
		*MButton::Escape
	#IfWinActive
;}

;{██ TrackMania Nations Forever
	#IfWinActive, ahk_exe TmForever.exe
		Space::send, {Down Down}
		Space Up::send, {Down Up}
;}

;{██ Prey
	#IfWinActive, ahk_exe Prey.exe
		*F15::XButton1
		*F14::XButton2
	#IfWinActive
;}

;{██ Functions 
	ReadEDLogs(dir, searchString, freshestFile:=0, lineFound:=0) {
		searchString := chr(34) . searchString . chr(34)
		Loop, %dir%\Frontier Developments\Elite Dangerous\*.log						;
			If (A_LoopFileTimeCreated > freshestFile)								; Finds most recent log file
				out := A_LoopFileFullPath, freshestFile := A_LoopFileTimeCreated	;
		loop, Read, %out%									;
			if A_LoopReadLine contains %searchString%		; Searches recent log for newest
				if (InStr(A_LoopReadLine, searchString))	; line containing searchString
					lineFound := A_LoopReadLine				;
		Return (RegExMatch(lineFound, searchString . ":""([^""]*)""", result) = 0) || (lineFound = 0) ? searchString . " was not found!" : result1 ; Uses RegEx and Ternary sorcery to get the desired string with only one line of code
	}
	
	EDandShip(ShipName) {
		global EDShipName
		If (WinActive("ahk_group EDGame"))
			If (ShipName == "")
				Return True
			else
				If (EDShipName == ShipName)
					Return True
		Return False
	}
;}

;{██ GoSubs
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
		EDShipName := ReadEDLogs(SavedGamesDir, "ShipName")
		return
;}

shipList: ;{	Opens ShipList.ini for editing
	Run, edit "ShipList.ini"
	;}
;}

/*████ Templates ████
------------------------------------------------------------------------------------------
;{██ CategoryName
	;{██ Subcategory
	
	;}
;}
------------------------------------------------------------------------------------------
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