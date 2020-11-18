/* optiK Wyrm
{
}
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
version 3.0 
Used with a Redragon Samsara2 (M902-RGB)
ALT+219 = █
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
SendMode, Input
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, 2
CoordMode, Mouse, Screen
;}

;{██ optiK Variables
;}

;{██ Initialization
	;{██ Tray Menu
	Menu,	Tray,	Add,		optiK 3.0 (Wyrm), reset ;Add reload button
	Menu,	Tray,	Default,	optiK 3.0 (Wyrm) ;Make reload default action
	Menu,	Tray,	Disable,	optiK 3.0 (Wyrm) ;Grey out reload button
	Menu,	Tray,	Click, 		1 ;Set reload to single click
	Menu,	Tray,	Tip,		Click to reload optiK ;Icon mouseover text
	gosub, ico ;Update tray icon
	;}
return
;}██

;{██ Global Hotkeys
	;{██ Tray Icon Control
	~*LButton::gosub ico
	~*LButton Up::gosub ico
	~*RButton::gosub ico
	~*RButton Up::gosub ico
;}██
	
	;{██ Double Click
	Browser_Stop::Click 2
	;}
	
	;{██ Speed Scrolling
	*XButton1:: ;Scroll Up
	Loop, {
	MouseClick, WU,,, 2 - GetKeyState("LWin") + GetKeyState("LAlt"),, D
	If !GetKeyState("XButton1", "P")
		return
	sleep, 100
	}
	MsgBox, uh ohhh
	*XButton2:: ;Scroll Down
	Loop, {
	MouseClick, WD,,, 2 - GetKeyState("LWin") + GetKeyState("LAlt"),, D
	If !GetKeyState("XButton2", "P")
		return
	sleep, 100
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
	Media_Play_Pause::return
	#if
	#if btn("Volume_Mute")
	Volume_Mute::return
	#if
	#if btn("Media_Stop")
	Media_Stop::return
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
;}

;██ GoSubs
;{
ico: ;{		Updates tray icon based on LButton and RButton states
icon := "ico\optiK" . GetKeyState("LButton", "P") . GetKeyState("RButton", "P") . ".ico"
Menu, Tray, Icon, %icon%
return
;}
reset: ;{	Reloads optiK
Reload
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