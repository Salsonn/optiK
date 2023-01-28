/* optiK HERO

███████████████████████████████████████████████████████████████
███████████████████████████████████  ██████████████████████████
███████████████████████████████████  █████████████  ███  ██████              _______   _______   _______ 
███████████████████████████████████  █████████████  ██  ███████   |\     /| |  ____ \ |  ____ | /  ___  \
███████       ███████        ███        ███  █████  █  ████████   | |   | | | |    \/ | |    || | |   | |
█████  ██   ██  ████   ████   █████  █████████████    █████████   | |___| | | |__     | |____|| | |   | |
████  ██     ██  ███  ██████  █████  ██████  █████  █  ████████   |  ___  | |  __|    |     __| | |   | |
█████  ██   ██  ████   ████   █████  ██████  █████  ██  ███████   | |   | | | |       | |\ |    | |   | |
███████       ██████         ██████  ██████  █████  ███  ██████   | |   | | | |____/\ | | \ \__ | |___| |
████████████████████  █████████████████████████████████████████   |/     \| |_______/ |/   \__/ \_______/
version 3.1
Used with a Logitech G502 SE (HERO) and a Logitech G502 LIGHTSPEED
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

;{██ Compiler Directives
	; @Ahk2Exe-UpdateManifest 0, Ringdown optiK, 3.1
	;@Ahk2Exe-SetMainIcon optiK.exe.ico
	;@Ahk2Exe-AddResource ico\optiK00.ico, 100
	;@Ahk2Exe-AddResource ico\optiK01.ico, 101
	;@Ahk2Exe-AddResource ico\optiK10.ico, 110
	;@Ahk2Exe-AddResource ico\optiK11.ico, 111
;}

;{██ AHK Settings
	;#Warn All, Off
	#SingleInstance Force
	InstallKeybdHook()
	InstallMouseHook()
;}

;{██ AHK Variables
	DetectHiddenWindows(True)
	SetTitleMatchMode(2)
	CoordMode("Mouse", "Screen")
	SendMode("Event")
	A_HotkeyInterval := 500
;}

;{██ optiK Variables
	optiKversion := "3.0 (HERO)"
	SavedGamesDir := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
;}

;{██ Initialization
	
;{██ Tray Menu
	A_TrayMenu.Add("Edit Elite Ship List", shipList) ; Add Elite .ini edit button
	A_TrayMenu.Add(optiKversion, reset) ;Add reload button
	A_TrayMenu.Default := optiKversion ;Make reload default action
	A_TrayMenu.Disable(optiKversion) ;Grey out reload button
	A_TrayMenu.ClickCount := 1 ;Set reload to single click
	A_IconTip := "Click to reload optiK" ;Icon mouseover text
	updateTrayIcon() ;}
	;{██ WinGroup Assignments
	GroupAdd("EDGame", "ahk_exe EliteDangerous64.exe")
	GroupAdd("EDGame", "ahk_exe EliteDangerous32.exe")
	GroupAdd("EliteDangerous", "ahk_group EDGame")
	GroupAdd("EliteDangerous", "ahk_exe EDLaunch.exe") ;}+

	;{██ Game-specific Code Setup
	SetTimer EDUpdate, 20000
	EDUpdate() ;}
	SetKeyDelay(16, 16)
return
;}██

;{██ Global Hotkeys

	;{██ Tray Icon Control
		~*LButton::
		~*LButton Up::
		~*RButton::
		~*RButton Up:: {
			ico()
		}
	;}██
	
	;{██ Double & Triple Click
		$*F18::Click 2
	;}
	
	;{██ Speed Scrolling
		*F14:: { ;Scroll Down
			Loop {
			MouseClick("WD",,, 1 + GetKeyState("LAlt"),, "D")
			If !GetKeyState("F14", "P")
				return
			sleep 72
			}
		}
		*F15:: { ;Scroll Up
			Loop {
			MouseClick("WU",,, 1 + GetKeyState("LAlt"),, "D")
			If !GetKeyState("F15", "P")
				return
			sleep 72
			}
		}
	;}

	;{██ Disable Unused Buttons
		F16::^v
		F17::^c
	;}	
;}

;{██ Elite Dangerous
	#HotIf EDandShip("HAMMERHEAD CORVETTE")
		
	#HotIf
	#HotIf EDandShip("THE asdfCORVID")
		WheelRight::send("{Down}{Up}{Left 2}")
		+WheelRight::send("{Right}")
		WheelLeft::send("{Down}{Left 2}")
	#HotIf
	#HotIf EDandShip("ONCOMING STORM")
		WheelRight::send("{Down}{Left}{Right}")
		+WheelRight::send("{Down}{Left}")
		WheelLeft::send("{Down}{Left 2}{Right}{Left}{Up}")
		+WheelLeft::send("{Down}{Up}{Left 3}")
		+F18::send("{Down}{Right}{Up 3}")
	#HotIf
	#HotIf EDandShip("Mourning Dove")
		WheelRight::send("{Down}{Left}")
		*F15::send("{Down}{Up}{Right}")
		+WheelRight::send("{Right}")
		WheelLeft::send("{Down}{Left 2}")
	#HotIf
	#HotIf EDandShip("Poker of Justice")
		WheelRight::send("{Down}{Up}{Right 2}")
	#HotIf
	#HotIf EDandShip("540 TON MICROWAVE") or EDandShip("THE CORVID")
		WheelRight::send("{Down}{Up}{Right 3}")
		+WheelRight::send("{Down}{Left}{Right 3}")
		!WheelRight::send("{Right}")
		F18::send("{Down}{Right}{Up 3}")
		+F18::send("{Down}{Left}{Up 3}")
		!F18::send("{Up}")
		!+F18::send("{Down}{Up 2}")
		WheelLeft::send("{Down}{Right}{Left 3}")
		+WheelLeft::send("{Down}{Up}{Left 3}")
		!WheelLeft::send("{Left}")
	#HotIf
	#HotIf WinActive("ahk_group EDGame")
		*WheelLeft::send("{Left}")
		+WheelLeft::send("{Down}{Left 2}")
		*WheelRight::send("{Right}")
		+WheelRight::send("{Down}{Right 2}")
		*F16::n
		*F14::/
		*F15::!/
		+F14::Down
		+F17::u
		F18::send "{Down}{Up 2}"
		;g::h"
		;+g::send "{h Down}{h Up}{LShift Down}h{LShift Up}"
		;!g::send "{h Down}{h Up}{LAlt Down}h{LAlt Up}"
		;!f::send "op"
		^Media_Play_Pause::9
		^Media_Next::0
		^Media_Prev::8
	#HotIf
;}

;{██ Minecraft
	#HotIf WinActive("Minecraft")
	!F16 Up:: {
		BlockInput(true)
		ToolTip("Let go of all buttons")
		sleep(2500)
		BlockInput(false)
		ToolTip()
	}
	#HotIf
;}

;{██ Unreal Tournament (2000)
	#HotIf WinActive("ahk_exe UnrealTournament.exe")
		F16::F16
		F15:: {
			SetKeyDelay(16, 16)
			if GetKeyState("w", "P") {
				send("{w up}w{w down}")
			} else {
				send("ww")
			}
			SetKeyDelay(10, -1)
		}
		F14:: {
			SetKeyDelay(16, 16)
			if GetKeyState("s", "P") {
				send("{s up}s{s down}")
			} else {
				send("ss")
			}
			SetKeyDelay(10, -1)
		}
	#HotIf
;}

;{██ Terraria
	#HotIf WinActive("ahk_exe Terraria.exe")
		*F18::MouseClick("Left",,,,, "D")
		!F18:: {
			SetKeyDelay(10, 32)
			KeyWait("LAlt")
			Loop {
			If GetKeyState("LAlt", "P")
				Break
			send("{Click}")
			sleep(2750)
			send("{Click}")
			sleep(250)
			send("{Click}")
			}
			SetKeyDelay(10)
		}
		*F15::e
		*F16::r
		*F14::h
		*F17::b
		*MButton::Escape
	#HotIf
;}

;{██ TrackMania Nations Forever
	#HotIf WinActive("ahk_exe TmForever.exe")
		Space::send("{Down Down}")
		Space Up::send("{Down Up}")
;}

;{██ Wizard101
	#HotIf WinActive("ahk_exe WizardGraphicalClient.exe")
		MButton::Space
		F14::Down
		F15::Up
		F16::x
		F17::b
		F18::Esc
		;WheelRight::Right
		WheelRight:: {
			Send("{Right Down}")
			Sleep(100)
			Send("{Right Up}")
		}
		WheelLeft:: {
			Send("{Left Down}")
			Sleep(100)
			Send("{Left Up}")
		}
;}

;{██ Functions 
	ReadEDLogs(dir, searchString, freshestFile:=0, lineFound:=0) {
		searchString := chr(34) . searchString . chr(34)
		Loop Files dir "\Frontier Developments\Elite Dangerous\*.log"				;
			If (A_LoopFileTimeCreated > freshestFile)								; Finds most recent log file
				out := A_LoopFileFullPath, freshestFile := A_LoopFileTimeCreated	;
		Loop Read, out									;
					; Searches recent log for newest     if A_LoopReadLine contains %searchString%
				if (InStr(A_LoopReadLine, searchString))	; line containing searchString
					lineFound := A_LoopReadLine				;
		Return ((RegExMatch(lineFound, searchString . '\:"([^""]*)"', &result) = 0) || (lineFound = 0)) ? searchString . " was not found!" : result[1] ; Uses RegEx and Ternary sorcery to get the desired string with only one line of code
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

	updateTrayIcon() {
		global icon := "ico\optiK" . GetKeyState("LButton", "P") . GetKeyState("RButton", "P") . ".ico"
		TraySetIcon(icon)
		return
	}

	EDUpdate() { ;{	Rechecks ED logs for change in current ship
		If !WinExist("ahk_group EliteDangerous") {
			A_TrayMenu.Disable("Edit Elite Ship List")
			SetKeyDelay(10)
			return ; skips if Elite Dangerous isn't running
		}
		A_TrayMenu.Enable("Edit Elite Ship List")
		SetKeyDelay(32)
		global EDShipName := ReadEDLogs(SavedGamesDir, "ShipName")
		return
	}

	ico(*) {
		;@Ahk2Exe-IgnoreBegin
		icon := "ico\optiK" . GetKeyState("LButton", "P") . GetKeyState("RButton", "P") . ".ico"
		TraySetIcon(icon)
		;@Ahk2Exe-IgnoreEnd
		/*@Ahk2Exe-Keep
		icon := 1 + GetKeyState("RButton", "P") + (GetKeyState("LButton", "P") * 2)
		TraySetIcon(A_ScriptFullPath, icon )
		*/
		return
	}

	reset(*) {
		Reload
	}

	shipList(*) {	;Opens ShipList.ini for editing
		Run('edit "ShipList.ini"')
	}
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