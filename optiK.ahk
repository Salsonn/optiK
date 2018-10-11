#InstallKeybdHook
#InstallMouseHook
#SingleInstance force
#MaxThreadsPerHotkey, 3
DetectHiddenWindows, On
SetTitleMatchMode, 2
CoordMode, Mouse, Screen

StringTrimRight, CDL, A_ScriptDir, StrLen(A_ScriptDir) - 2
zoomed := 0

Menu, Tray, Icon, optiK.ico
Menu, Tray, Add, Switch to Zealot, SwitchToZealot
Menu, Tray, Add, Reload, Reload
Menu, Tray, Default, Reload
Menu, Tray, Click, 1

WinGet, scriptPID, PID, optiK.ahk - AutoHotkey
FileAppend, %scriptPID%, %A_ScriptDir%\optiKPID.txt

GroupAdd, EliteD, ahk_exe EliteDangerous64.exe
GroupAdd, EliteD, ahk_exe EliteDangerous32.exe

;Update Script on DADSTOY
IfExist, T:\My Documents
 If (A_ScriptDir != "T:\My Documents\.bat\Files.ahk\MouseMode")
  FileCopy, T:\My Documents\.bat\Files.ahk\MouseMode\optiK.ahk, T:\My Documents\.bat\Files.ahk\MouseMode\optiK.ahk.old, 1
  FileCopy, %A_ScriptDir%\optiK.ahk, T:\My Documents\.bat\Files.ahk\MouseMode\optiK.ahk, 1
 
;████████████████████████████████████████████
;██████████████Priority Codes████████████████
;████████████████████████████████████████████
#Launch_Mail::WinMinimize, a
;█████████████████████████████████████████
;████████████Program-Specific█████████████
;█████████████████████████████████████████
;██████████████Explorer███████████████████
#IfWinActive, ahk_exe explorer.exe
Launch_Media::send, {Up down}
Launch_Mail::send, {Down down}
Launch_Media UP::send, {Up up}
Launch_Mail UP::send, {Down up}
#IfWinActive
;█████████████████████████████████████████
;████████████████Notepad██████████████████
#IfWinActive, - Notepad
Launch_Mail::send, {LCtrl Down}s{LCtrl Up}
return
Launch_Media::send, {Return}
return
::ThumbUp::Launch_Media
::ThumbDown::Launch_Mail
#IfWinActive
#IfWinActive, optiK.ahk * SciTE4AutoHotkey
Launch_Mail::send, {LCtrl Down}s{LCtrl Up}
return
Launch_Media::send, {Return}
return
::ThumbUp::Launch_Media
::ThumbDown::Launch_Mail
#IfWinActive
;█████████████████████████████████████████
;███████████Elite Dangerous███████████████
#IfWinActive, ahk_group EliteD
Launch_Media::send, {Up Down}
Launch_Media UP::send, {Up Up}

Launch_Mail::send, {Down Down}
Launch_Mail UP::send, {Down Up}

XButton1::send, {Right Down}
XButton1 UP::send, {Right Up}

XButton2::send, {Left Down}
XButton2 UP::send, {Left Up}

Launch_App1::send, {n Down}
Launch_App1 UP::send, {n Up}
#IfWinActive
;█████████████████████████████████████████
;██████████████Minecraft██████████████████
#IfWinActive, ahk_exe javaw.exe
*XButton1::
  Send, 8
  Sleep, 10
  MouseClick Right
  Sleep, 10
  Send, 1
  return
Launch_Media:: ;FOV Zoom
if (zoomed = 0)
 {
  send, {Esc}
  Click, 600, 370
  Click, 377, 128
  send, {Esc}
  sleep, 50
  send, {F7}
  zoomed = 1
 }
else
 {
  send, {Esc}
  Click, 600, 370
  Click, 592, 128
  send, {Esc}
  sleep, 50
  send, {F7}
  zoomed = 0
 }
return
*Launch_Mail::7
*XButton2:: ;Elytra Boost
  Send, 5
  Sleep, 10
  MouseClick Right
  Sleep, 10
  Send, 1
  return
#IfWinActive
;█████████████████████████████████████████
;██████████████Starcraft██████████████████
#IfWinActive, Brood War
MButton::sendinput, 1{RButton}2{RButton}3{RButton}4{RButton}5{RButton}6{RButton}7{RButton}8{RButton}9{RButton}0{RButton}
#IfWinActive
;█████████████████████████████████████████
;████████████Starcraft II█████████████████
#IfWinActive, ahk_exe SCII.exe 
Hotkey, MButton, off
*Launch_Media::1
*Launch_Mail::2
*XButton1::3
*XButton2::4
#IfWinActive
;█████████████████████████████████████████
;██████████████Terraria███████████████████
#IfWinActive, ahk_exe Terraria.exe
Launch_App1::
SysGet, ScreenRes, Monitor
WinSet, Style, -0xC40000, ahk_exe Terraria.exe
WinMove, ahk_exe Terraria.exe, , 0, 0, %ScreenResRight%, %ScreenResBottom%
return
XButton2:: ; Healing Potion
  send, {h down}
  sleep, 10
  send, {h up}
  return
Launch_Mail:: ; Double Tap 'S'
  send, {s down}
  sleep, 20
  send, {s up}
  sleep, 20
  send, {s down}
  sleep, 20
  send, {s up}
  return
#IfWinActive
;█████████████████████████████████████████
;██████████████Half-Life 2████████████████
#IfWinActive, HALF-LIFE 2
Launch_Media::WheelUp
Launch_Mail::WheelDown
XButton1::g
XButton2::
send, 33
click
return
#IfWinActive
;█████████████████████████████████████████
;███████████Unreal Tournament█████████████
#IfWinActive, Unreal Tournament
Launch_Media::
GetKeyState, isMoving, w, P
if isMoving = D
{
send, {w Up}
sleep, 55
send, {w Down}
sleep, 55
send, {w Up}
sleep, 55
send, {w Down}
} else {
send, {w Down}
sleep, 55
send, send, {w Up}
sleep, 55
send, {w Down}
sleep, 55
send, {w Up}
}
return
#IfWinActive
;█████████████████████████████████████████
;███████████Google Chrome.exe█████████████
#IfWinActive, Google Chrome
Launch_Media::
  scrolling := 1
  getKeyState, state, LAlt, P
  if state = D 
   scrollSpeed := 3
  Loop, 
  {
  MouseClick, WU,,, scrollSpeed, 0, D
  Sleep, 100
  GetKeyState, state, Launch_Media, P
  if state = U
   break
  }
  scrollSpeed := 1
  scrolling := 0
return
Launch_Mail::
  scrolling := 1
  GetKeyState, state, LAlt, P
  if state = D 
   scrollSpeed := 3
  Loop, 
  {
   MouseClick, WD,,, scrollSpeed, 0, D
   Sleep, 100
   GetKeyState, state, Launch_Mail, P
   if state = U
    break
  }  
  scrollSpeed := 1
  scrolling := 0
return
#IfWinActive
;█████████████████████████████████████████
;██████████████ Skyrim ███████████████████
#IfWinActive, ahk_exe TESV.exe
*Launch_Media::6
*Launch_Mail::7
*XButton1::8
*XButton2::9
#IfWinActive
;█████████████████████████████████████████
;█████████████████████████████████████████
;                DEFAULTS
;█████████████████████████████████████████
;█████████████████Center██████████████████
#Launch_App1::
SendLevel, 1
send, !{Pause}
SendLevel, 0
IfWinExist, ahk_exe Decrypt.exe
{
send, !{ScrollLock}
  Sleep, 50
  Click 5, 5
  reload
} else {
  SendLevel, 1
  send, !{Pause}
  SendLevel, 0
}
;███████████████████
Launch_App1 & c::run, chrome
return
;███████████████████
Launch_App1 & XButton2::run, explorer.exe /n`,
return
;███████████████████
Launch_App1 & XButton1::run, calc
return
;███████████████████
Launch_App1 & f::run, "%CDL%\.Sudo\scripts\AutoHotKey.exe" "%A_ScriptDir%\FloatingChrome.ahk"
;███████████████████

;█████████████████████████████████████████
;█████████████████ThumbUp█████████████████
Launch_Media::
return
;█████████████████████████████████████████
;█████████████████ThumbDn█████████████████
Launch_Mail::
return
;█████████████████████████████████████████
;██████████████Double Click███████████████

;█████████████████████████████████████████
;██████████████Middle Mouse███████████████

;█████████████████████████████████████████
;██████████████Half Buttons███████████████
ScrollDown:
*XButton1::
  scrolling := 1
  GetKeyState, state, LAlt, P
  if state = D 
   scrollSpeed := 3
  Loop, 
  {
   MouseClick, WD,,, scrollSpeed, 0, D
   Sleep, 100
   GetKeyState, state, XButton1, P
   if state = U
    break
  }  
  scrollSpeed := 1
  scrolling := 0
return
;███████████████████
ScrollUp:
*XButton2::
  scrolling := 1
  getKeyState, state, LAlt, P
  if state = D 
   scrollSpeed := 3
  Loop, 
  {
  MouseClick, WU,,, scrollSpeed, 0, D
  Sleep, 100
  GetKeyState, state, XButton2, P
  if state = U
   break
  }
  scrollSpeed := 1
  scrolling := 0
return
;████████████████████████████████████████████
;██████████Timers & Misc Functions███████████
;████████████████████████████████████████████

;██████████████████
Reload:
  Reload
return
SwitchToZealot:
run, "AutoHotkey.exe" "Zealot.ahk"
ExitApp
return
;████████████████████████████████████████████
;███████████████Base Scripts█████████████████
;████████████████████████████████████████████

if ()
  {
  
  }
else if ()
  {
  
  }
else
  {
  
  }


;█████████████████████████████████████████
;██████████████        ███████████████████
#IfWinActive, 
#IfWinActive