#InstallKeybdHook
#SingleInstance force
SetTitleMatchMode, 2
DetectHiddenWindows, On
Menu, Tray, Icon, mouse.ico
Menu, Tray, Add, Switch to LUOM, SwitchToLUOM
Menu, Tray, Add, Reload, Reload
Menu, Tray, Default, Reload
Menu, Tray, Click, 1
scrollSpeed := 1
tooltipX := A_ScreenWidth - 20
tooltipY := A_ScreenHeight - 65
Coordmode, Tooltip, Screen
WinGet, scriptPID, PID, LUOM.ahk - AutoHotkey
FileAppend, %scriptPID%, %A_ScriptDir%\LUOMPID.txt

;█████████████████████████████████████████
;██████████████Explorer███████████████████
#IfWinActive, ahk_class CabinetWClass ;ahk_exe Explorer.exe
SetTitleMatchMode, 2
;#If (!winActive("Blender") && !winActive("Autodesk") && !winActive("Shell_TrayWnd") && !winActive("Shell_SecondaryTrayWnd"))
MButton::send, {LButton}{LButton}
;#If
#IfWinActive
;█████████████████████████████████████████
;██████████████Minecraft██████████████████
#IfWinActive, ahk_exe javaw.exe
*MButton::

XButton1::9
XButton2:: ;FOV Zoom
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
#IfWinActive
;█████████████████████████████████████████
;██████████████Starcraft██████████████████
#IfWinActive, Brood War
MButton::sendinput, 1{RButton}2{RButton}3{RButton}4{RButton}5{RButton}6{RButton}7{RButton}8{RButton}9{RButton}0{RButton}
#IfWinActive
;█████████████████████████████████████████
;██████████████Sagittarius████████████████
#IfWinActive, Sagittarius
RButton::send, {Right Down}
RButton UP::send, {Right Up}
XButton1::send, {Left Down}
XButton1 UP::send, {Left Up}
MButton::send, {Left Down}
MButton UP::send, {Left Up}
#IfWinActive
;█████████████████████████████████████████
;█████████████████████████████████████████
;                DEFAULTS
;█████████████████████████████████████████
;██████████████Double Click███████████████
;SPAMMER:~LButton::
;SPAMMER:GoSub, DoubleClicker
;SPAMMER:return
;█████████████████████████████████████████
;██████████████Middle Mouse███████████████

;█████████████████████████████████████████
;██████████████Side Buttons███████████████
;SCROLLING
*XButton1::
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
return
;█████████████████████████████████████████
XButton2::
ScrollUpToggle := !ScrollUpToggle
    if (ScrollUpToggle) {
        SetTimer, Timer_ScrollUp, 100
	SetTimer, Timer_ScrollUpFast, Off
    } else {
        SetTimer, Timer_ScrollUp, Off
	SetTimer, Timer_ScrollUpFast, Off
	Tooltip
    }
return
;███████████████████
!XButton2::
ScrollUpFastToggle := !ScrollUpFastToggle
    if (ScrollUpFastToggle) {
        SetTimer, Timer_ScrollUpFast, 100
	SetTimer, Timer_ScrollUp, Off
    } else {
        SetTimer, Timer_ScrollUpFast, Off
	SetTimer, Timer_ScrollUp, Off
	Tooltip
    }
return


;██████████████Timers & Functions███████████████
DoubleClicker:
send, {$LButton Down}
if (A_PriorHotkey <> "~LButton" or A_TimeSincePriorHotkey > 70)
    return
lBtnSpam := !lBtnSpam
    if (lBtnSpam) {
        SetTimer, Timer_Spam, 10
	FLButton = D
    } else {
        SetTimer, Timer_Spam, Off
	FLButton = U
    }
return

Timer_Spam:
    send {LButton}
return
Timer_ScrollUpFast:
    MouseClick, WU,,, 3, 0, D
    Tooltip,||, %tooltipX%, %tooltipY%
return
Timer_ScrollUp:
    MouseClick, WU,,, 1, 0, D
    Tooltip,|, %tooltipX%, %tooltipY%
return

Reload:
Reload
Return
SwitchToLUOM:
run "AutoHotkey.exe" "LUOM.ahk"
ExitApp
return