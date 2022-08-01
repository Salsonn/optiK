; Loop Files, A_ProgramFiles "\*.txt", "R"  ; Recurse into subfolders.
;     {
;         Result := MsgBox("Filename = " A_LoopFilePath "`n`nContinue?",, "y/n")
;         if Result = "No"
;             break
;     }


dir := SavedGamesDir := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
MsgBox(dir)
Loop Files, dir "\Frontier Developments\Elite Dangerous\*.log", "F"
    FileList .= A_LoopFileName
    
MsgBox(FileList)