/* optiK Omni

███████████████████████████████████████████████████████████████
███████████████████████████████████  ██████████████████████████
███████████████████████████████████  █████████████  ███  ██████    _______   _______   _     _  _________ 
███████████████████████████████████  █████████████  ██  ███████   /  ___  \ |       | | |   | | \__   __/ 
███████       ███████        ███        ███  █████  █  ████████   | |   | | | || || | |  \  | |    | |    
█████  ██   ██  ████   ████   █████  █████████████    █████████   | |   | | | || || | |   \ | |    | |    
████  ██     ██  ███  ██████  █████  ██████  █████  █  ████████   | |   | | | | V | | | |\ \| |    | |    
█████  ██   ██  ████   ████   █████  ██████  █████  ██  ███████   | |   | | | |   | | | | \   |    | |    
███████       ██████         ██████  ██████  █████  ███  ██████   | |___| | | |   | | | |  \  | ___| |___ 
████████████████████  █████████████████████████████████████████   \_______/ |/     \| |/    \_| \_______/ 
  _____                        _                         _    __  __                                          
 |  __ \             _        | |                       | |  |  \/  |                                         
 | |__) | ___  _ __ (_) _ __  | |__    ___  _ __   __ _ | |  | \  / |  __ _  _ __    __ _   __ _   ___  _ __  
 |  ___/ / _ \| '__|| || '_ \ | '_ \  / _ \| '__| / _` || |  | |\/| | / _` || '_ \  / _` | / _` | / _ \| '__| 
 | |    |  __/| |   | || |_) || | | ||  __/| |   | (_| || |  | |  | || (_| || | | || (_| || (_| ||  __/| |    
 |_|     \___||_|   |_|| .__/ |_| |_| \___||_|    \__,_||_|  |_|  |_| \__,_||_| |_| \__,_| \__, | \___||_|    
                       | |                                                                  __/ |               
                       |_|                                                                 |___/                
version 4.0-beta
View the README at https://github.com/SalSonn/optiK for more information.
*/

/* PLANNING
    Update old scripts to ahk2? Maybe just compile them to .exe
*/

;{██ Compiler Directives
	;@Ahk2Exe-SetMainIcon optiK.exe.ico
	;@Ahk2Exe-AddResource ico\blink0.ico, 100
	;@Ahk2Exe-AddResource ico\blink1.ico, 101
	;@Ahk2Exe-AddResource ico\blink2.ico, 102
	;@Ahk2Exe-AddResource ico\blink3.ico, 103
	;@Ahk2Exe-AddResource ico\blink3.ico, 104
    /*@Ahk2Exe-Keep
    A_TrayMenu.Delete()
    A_TrayMenu.Add("Quit", Quit)
    */
;}

;{██ AHK Settings
    Persistent
    #Requires AutoHotkey v2.0
	#SingleInstance Off ;Force
;}

;{██ AHK Variables
	DetectHiddenWindows(True)
	SetTitleMatchMode(2)
	CoordMode("Mouse", "Screen")
	SendMode("Event")
	A_HotkeyInterval := 500
;}

;{██ optiK Variables
    optiKversion := "4.0-beta (OMNI)"

    hasLogitech := False
    hidppPath := "bin\hidpp-list-devices.exe"
    hidppPID := 0
    deviceListPath := ".\config\devices.ini"
    knownPeripherals := []      ; device list loaded into memory.
    oldKnownPeripherals := []
    activeProfiles := []        

    profileMenu := Menu() ; Menu showing available profiles
    deviceMenus := [] ; Menu showing known peripherals
    ;??SavedGamesDir := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
    blinkDelta := 1
    blinkStep := -1
;}

;{██ Main
    SetTimer(blinker, -250)
    if FileExist(deviceListPath) {
        tryParse := parsePeripherals(deviceListPath, knownPeripherals)
        if !tryParse {
            OnMessage(0x219, deviceChange, 5)
            updateknownPeripherals()
        } else {
            MsgBox("Error parsing device configuration:`n" . tryParse)
        }
    }
    ;A_TrayMenu.Delete() ; Removes default tray items
    A_TrayMenu.Add("Profiles", profileMenu)
    ;A_TrayMenu.Disable("No Devices Detected")
	A_TrayMenu.Add(optiKversion, updateknownPeripherals) ;Add reload button
	A_TrayMenu.Default := optiKversion ;Make reload default action
	A_TrayMenu.Disable(optiKversion) ;Grey out reload button
	A_TrayMenu.ClickCount := 1 ;Set reload to single click
	A_IconTip := "Click to rescan" ;Icon mouseover text
;}

>!>+o::A_IconHidden := !A_IconHidden


;{██ Functions

    ;{ Profile Management
        
        aps(oldList, newList) { ; Automatically determines device state during startup or after device plug.
            oddOnesOut := []
            newPlugs := [] ;deDupeArray(newList, oldList)
            unplugged := [] ;deDupeArray(oldList, newList)
            if !oldList.Length
                for newListItem in newList
                    if newListItem.connected and !searchArray(oddOnesOut, newListItem.profile)
                        oddOnesOut.Push(newListItem.profile)
            for newListItem in newList
                for oldListItem in oldList {
                    ignoreOn := 0
                    ingoreOff := 0
                    if (oldListItem.id != newListItem.id) ; Find item in both lists
                        continue
                    else 
                        if (oldListItem.connected != newListItem.connected) ; Check for connection state change
                            for item in newList ; Filter for instances where another device is still connected (or not if it's a new device)
                                if (newListItem.profile == item.profile)
                                    if (newListItem.connected and (newListItem.connected != item.connected))
                                        ignoreOn += 1
                                    else if (!newListItem.connected and item.connected)
                                        ingoreOff += 1
                    if (oldListItem.connected != newListItem.connected) and (!ignoreOn or !ingoreOff)
                        oddOnesOut.Push(oldListItem.profile)
                }
            ; DEBUG
            ; if !oldList.Length
            ;     MsgBox("Was: Unknown `nNow: " . newList[7].connected,, "T1")
            ; else
            ;     MsgBox("Was: " . oldList[7].connected . "`nNow: " . newList[7].connected,, "T1")
            return(oddOnesOut)
        }

        apsOld(oldList, newList) { ; Automatically determines device state during startup or after device plug.
            global activeProfiles
            profilesToToggle := []
            for item in newList
                if !searchArray(profilesToToggle, item.profile) && !searchArray(activeProfiles, item.profile) && item.connected
                    profilesToToggle.Push(item.profile)
            /* Since I don't have a need to implement incompatibility between profiles, this just toggles on
            profiles for new devices and toggles off profiles for disconnected devices.*/
            for item in activeProfiles {
                activeDevicePerProfile := 0
                for newItem in newList 
                    if (item == newItem.profile)
                        activeDevicePerProfile += 1
                if (!activeDevicePerProfile && profilesToToggle.Length)
                    profilesToToggle.RemoveAt(searchArray(profilesToToggle, item))
            }
            return(profilesToToggle)
        }

        toggleProfile(profileName, itemPos:=0, Automatic:=False) {
            global activeProfiles
            found := false
            for i, item in activeProfiles
                if item.name == profileName {
                    found := ProcessClose(item.pid)
                    activeProfiles.RemoveAt(i)
                }
            if !found {
                /*@Ahk2Exe-Keep
                if FileExist(A_ScriptDir . "\optiK-" . profileName . ".exe") {
                    Run(A_ScriptDir . "\optiK-" . profileName . ".exe",,,&found)
                    activeProfiles.Push({name:profileName, pid:found})
                }
                */
                ;@Ahk2Exe-IgnoreBegin
                Loop Files, A_ScriptDir "\*", "D" {
                        if InStr(A_LoopFileName, profileName)
                            if FileExist(A_ScriptDir . "\" . A_LoopFileName . "\" . profileName . ".exe") {
                                ; DEBUG MsgBox("Found:`n" . A_ScriptDir . "\" . A_LoopFileName . "\" . profileName . ".exe")
                                Run(A_ScriptDir . "\" . A_LoopFileName . "\" . profileName . ".exe",,,&found)
                                activeProfiles.Push({name:profileName, pid:found})
                            } else {
                                if FileExist(A_ScriptDir . "\" . A_LoopFileName . "\" . profileName . ".ahk") {
                                    ; DEBUG MsgBox("Found:`n" . A_ScriptDir . "\" . A_LoopFileName . "\" . profileName . ".exe")
                                    Run(A_ScriptDir . "\" . A_LoopFileName . "\" . profileName . ".ahk",,,&found)
                                    activeProfiles.Push({name:profileName, pid:found})
                                }
                            }
                }
                ;@Ahk2Exe-IgnoreEnd
            }

            if !Automatic
                profileMenu.ToggleCheck(profileName)
            else
                for i, item in knownPeripherals
                    if item.name == profileName
                        item.overridden := toggleProfile(item.profile)
            return(true)
        }
    ;}

    ;{ Peripheral Detection
        updateknownPeripherals(*) {
            A_IconHidden := false ;ToolTip("Updating", 0, 0)
            global knownPeripherals
            global profileMenu
            global deviceMenus
            global oldKnownPeripherals
            onQuery := "SELECT * FROM CIM_LogicalDevice"      ; All devices currently connected
            allQuery := "SELECT * FROM Win32_PnPSignedDriver" ; All devices    ever   connected
            relevantDevices := listDevices(onQuery)
            profileCount := 1
            if !deviceMenus.Length { ; Populate menu list if it isn't populated.
                deviceMenus.Push(Menu())
                for i, profile in knownPeripherals {
                    if (knownPeripherals[Max(1, i - 1)].profile != knownPeripherals[i].profile) {
                        deviceMenus.Push(Menu())
                        profileCount += 1
                    }
                    deviceMenus[profileCount].Add(knownPeripherals[i].name, toggleProfile)
                    ;;DEBUG MsgBox("Added: '" . knownPeripherals[i].name . "' to menu #" . profileCount)
                    profileMenu.Add(knownPeripherals[i].profile, deviceMenus[profileCount], "+Radio")
                }
            }
            profileCount := 1
            detectedProfiles := []
            for i, profile in knownPeripherals {
                if (knownPeripherals[Max(1, i - 1)].profile != knownPeripherals[i].profile) {
                    profileCount += 1
                }
                if searchArray(relevantDevices, profile.id) {
                    deviceMenus[profileCount].Enable(knownPeripherals[i].name)
                    detectedProfiles.Push(knownPeripherals[i].profile)
                    knownPeripherals[i].connected := True
                } else {
                    deviceMenus[profileCount].Disable(knownPeripherals[i].name)
                    knownPeripherals[i].connected := False
                }
                knownPeripherals[i].overridden := False
            }
            profileList := []
            for i, profile in knownPeripherals ; Disable menu items for disconnected devices
                if !searchArray(profileList, knownPeripherals[i].profile)
                    profileList.Push(knownPeripherals[i].profile)
            for profile in deDupeArray(profileList, detectedProfiles) ; Disable menu items for unused profiles
                profileMenu.Disable(profile)
            for profile in aps(oldKnownPeripherals, knownPeripherals)
                toggleProfile(profile)
            oldKnownPeripherals := []
            for item in knownPeripherals
                oldKnownPeripherals.Push(item.Clone())
            ; knownPeripherals[1].connected := 2
            ; MsgBox("Old: " . oldKnownPeripherals[1].connected . "`nNew: " . knownPeripherals[1].connected)
            A_IconHidden := true ;ToolTip()
        }

        parsePeripherals(file, exportList) { ; Reads from the specified .ini file and creates a data structure
            deviceIndex := 1                ; correlating optiK profiles with compatible peripherals
            profileName := ''
            loop read file {
                if (A_Index == 1) AND (A_LoopReadLine != "optiKdevices:")
                    return("Format check failed. Line 1 should contain the following:`noptiKdevices:`nFilepath: " . file)
                else if (A_Index == 1) AND (A_LoopReadLine == "optiKdevices:")
                    continue
                if InStr(A_LoopReadLine, "profile:") {
                    ; activeProfile += 1
                    profileName := SubStr(Trim(A_LoopReadLine), 10, -1)
                    ; MsgBox("Switched to: " . profileName)
                    continue
                }
                ; MsgBox(SubStr(LTrim(A_LoopReadLine), 1, 1))
                if (SubStr(LTrim(A_LoopReadLine), 1, 1) == ';') OR (A_LoopReadLine == '')
                    continue ; Skip commented lines
                devName := ""
                devID := ""
                loop parse, A_LoopReadLine, ':' {
                    ; exportList.Push(Map())
                    ; exportList[-1].profile := profileName
                    ; deviceIndex += 1
                    if InStr(A_LoopField, '"')
                        ; exportList[-1].name := Trim(LTrim(A_LoopField), '"')
                        devName := Trim(LTrim(A_LoopField), '"')
                    if InStr(A_LoopField, '&')
                        ; exportList[-1].id := A_LoopField
                        devID := A_LoopField
                }
                exportList.Push({profile:profileName, name:devName, id:devID})
                ; MsgBox("Profile:`n`t" . profileName . "`nName:`n`t" . devName . "`nID:`n`t" . devID)

                ; newDevice := { name : devName, id : devID }
                ; exportList[activeProfile].Push(newDevice)
                ; MsgBox("adding " . devName . ":" . devID . " to " . activeProfile)
                ; exportList.activeProfile.Push(A_LoopReadLine)
            }
            else
                return("The specified file was not found or was empty:`n" . file)
            return(False)
        }

        deviceChange(wParam, lParam, msg, hwnd) { ; Handles System broadcast for change in device list.
            SetTimer(updateknownPeripherals, -100) ; List must be generated outside of this function because Windows.
        }

        listDevices(query) { ; Creates list of peripheral devices.
            global hasLogitech
            global hidppPath
            parsedList := []
            devList := ComObjGet("winmgmts:").ExecQuery(query)
            ; DEBUG
            ; msg := ""
            ; for thing in devList
            ;     msg := msg . thing.DeviceID . "`n"
            ; MsgBox(msg)
            for thing in devList {
                if InStr(thing.DeviceID, 'HID\VID') ; USB-connected
                    parsedID := SubStr(thing.DeviceID, 5, 17)
                else if InStr(thing.DeviceID, "HID\{") ; Bluetooth-connected
                    parsedID := "VID_" . SubStr(thing.DeviceID, InStr(thing.DeviceID, "_DEV_VID&")+11, 4) . "&PID_" . SubStr(thing.DeviceID, InStr(thing.DeviceID, "_DEV_VID&")+20, 4)
                else 
                    parsedID := SubStr(thing.DeviceID, InStr(thing.DeviceID, 'VID_') ? InStr(thing.DeviceID, 'VID_') : 1, 17)
                duplicate := searchArray(parsedList, parsedID) ;InStr(printableList, parsedID)
                ; if InStr(parsedID, "VID_046D")
                ;     msgbox(parsedID)
                if InStr(parsedID, 'VID_') and (!duplicate) {
                    ; MsgBox(parsedID)
                    if InStr(parsedID, "VID_046D") AND !hasLogitech
                                hasLogitech := True ;logitectLoad()
                    parsedList.Push(parsedID)
                }
            }
            if hasLogitech {
                for item in deDupeArray(logitectParse(hidppPath), parsedList)
                    parsedList.Push(item)
                }
            return(parsedList)
        }

        logitectParse(hidppPath) { ; Queries HID++ for list of connected Logitech devices
            tempPath := A_Temp . "\logitect"
            logiDevices := []
            if !FileExist(hidppPath)
                MsgBox("Warning: HID++ dependencies are not detected! `n Wireless Logitech peripherals may not be detected properly.")
            try 
                FileMove(tempPath, tempPath)
            catch
                RunWait("cmd.exe /C taskkill /IM hidpp-list-devices.exe /F",,"Hide")
            Run("cmd.exe /C `"" . hidppPath . "`" >> " . tempPath,,"Hide", &hidppPID)
            Sleep(2000)
            output := FileRead(tempPath)
            RunWait("cmd.exe /C taskkill /IM hidpp-list-devices.exe /F",,"Hide")
            If FileExist(tempPath)
                FileDelete(tempPath)
            ;MsgBox(output,, "T3")
            loop parse, output, ")("
                if InStr(A_LoopField, ':') AND !InStr(A_LoopField, A_Space)
                    logiDevices.Push(StrUpper("VID_" . SubStr(A_LoopField, 1, 4) . "&PID_" . SubStr(A_LoopField, -4)))
            return(logiDevices)
        }

        logitectLoad() { ; Prepares readable shell environment for HID++ to work it's magic.
            Run("cmd.exe",, "Hide", &pid)
            WinWait("ahk_pid " . pid)
            DllCall("AttachConsole", "UInt", pid)
            return(ComObject("Wscript.Shell"))
            ;WshShell.Exec("hidpp-list-devices.exe")
            ;output := exec.StdOut.ReadAll()
        }

        logitectParseOld(hidppPath) { ; Gets updated device info using the HID++ protocol.
            global hasLogitech
            logiDevices := []
            script := hasLogitech.Exec(hidppPath)
            output := script.StdOut.ReadAll()
            ; if WinExist("ahk_pid " . pid)
            ;     WinKill("ahk_pid " . pid)
            FileDelete(A_Temp . "\logitect")
            loop parse, output, ")("
                if InStr(A_LoopField, ':') AND !InStr(A_LoopField, A_Space)
                    logiDevices.Push(StrUpper("VID_" . SubStr(A_LoopField, 1, 4) . "&PID_" . SubStr(A_LoopField, -4)))
            return(logiDevices)
        }

    ;}

    searchArray(haystack, needle) {
        space := 0
        for i, item in haystack
            if InStr(item, needle)
                return(i)
        return(0)
    }

    deDupeArray(haystack1, haystack2) { ; Deletes items from haystack1 that are found in haystack2
        reducedHaystack := []
        for i, item1 in haystack1 {
            bypass := False
            for j, item2 in haystack2
                if InStr(item1, item2)
                    bypass := True
            if !bypass
                reducedHaystack.Push(item1)
            ; else
            ;     MsgBox("Match found: " . item1)
        }
        return(reducedHaystack)
    }

	reset(*) {
		Reload
	}

    quit(*) {
        ExitApp()
    }

    closeOut(ExitReason, ExitCode) {
        global activeProfiles
        for i, item in activeProfiles
            ProcessClose(item.pid)
    }

    blinker(*) {
        global blinkStep
        global blinkDelta
        blinkStep += blinkDelta
        if !blinkStep
            blinkDelta := 1 + (SetTimer(blinker, 500) ? 0 : 0)
        else if blinkStep == 4
            blinkDelta := -1 + (SetTimer(blinker, 120) ? 0 : 0)
        else if !A_IconHidden
            SetTimer(blinker, -60)
        ;@Ahk2Exe-IgnoreBegin
        TraySetIcon("ico\blink" . blinkStep . ".ico")
        ;@Ahk2Exe-IgnoreEnd
        /*@Ahk2Exe-Keep
        TraySetIcon(A_ScriptFullPath, blinkStep)
        */
    }
;}

