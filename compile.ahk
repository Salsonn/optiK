#Requires AutoHotkey v2.0
compilerPath := SubStr(A_AhkPath, 1, -20) . "\Compiler\Ahk2Exe.exe"
/*@Ahk2Exe-Keep
compilerPath := RegRead("Computer\HKEY_LOCAL_MACHINE\SOFTWARE\AutoHotkey", "InstallDir") . "\Compiler\Ahk2Exe.exe"
*/
if !FileExist(compilerPath) {
    MsgBox("Compiler is not detected. Press okay to install the compiler. `n" . compilerPath)
    RunWait(SubStr(compilerPath, 1, -21) . "\UX\install-ahk2exe.ahk")
}

Run(compilerPath . " /in optiK.ahk /out optiK.exe /icon ico/optiK.exe.ico /base `"" SubStr(compilerPath, 1, -20) . "v2\AutoHotkey64.exe`"", A_ScriptDir)
ExitApp()