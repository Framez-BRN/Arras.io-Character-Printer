
; no comments in my code anymore. dont need them.

;\\\\\ Autoex. /////

    #Requires AutoHotkey v1.1
    #SingleInstance Force
    #Persistent
    #NoEnv

    SetKeyDelay -1
    SetMouseDelay 0
    SetBatchLines, -1

    settingsFile := A_ScriptDir "\settings(ACP).ini"

    sendEnterAfterCancel := false
    isPrintingCancelled := false
    sandboxPausedScript := false
    showUnpausedTooltip := true
    sandboxTimerEnabled := false
    showPauseTooltip := true
    sandboxWasHeld := false
    isPrinting := false
    drawMode := false
    selectedFont := "Default Font"
    selectedBind := ""
    bind2 := "``"
    bind := "-"
    keys := "0|1|2|3|4|5|6|7|8|9|A|Alt|AppsKey|B|Backspace|Browser_Back|Browser_Favorites|Browser_Forward|Browser_Home|Browser_Refresh|Browser_Search|Browser_Stop|C|CapsLock|Ctrl|D|Delete|Down|E|End|Enter|Escape|F|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|G|H|Home|I|Insert|J|K|L|Launch_App1|Launch_App2|Launch_Mail|Launch_Media|LAlt|LCtrl|Left|Lshift|LWin|M|Media_Next|Media_Play_Pause|Media_Prev|Media_Stop|N|NumLock|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|NumpadAdd|NumpadDiv|NumpadDot|NumpadEnter|NumpadMult|NumpadSub|O|P|Pause|PgDn|PgUp|PrintScreen|Q|R|RAlt|RCtrl|Right|Rshift|RWin|S|ScrollLock|Space|T|Tab|U|Up|V|Volume_Down|Volume_Mute|Volume_Up|W|X|XButton1|XButton2|Y|Z|``|'|,|-|.|/|;|=|[|\|]"
    prevX := 0
    prevY := 0
    statusGuiX := 47
    statusGuiY := 768
    printStartX := 707
    printStartY := 484
    printPressCount := 2
    printSleepTime := 50

    LoadSettings()

    SetTimer, CheckArrasFocus, 100

    if (sandboxTimerEnabled)
        SetTimer, CheckSandboxKey, 50

    Suspend, On

;///// Autoex. \\\\\



;\\\\\ Guis /////

    Gui, 4:+AlwaysOnTop -Caption +ToolWindow +E0x08000000
    Gui, 4:+LabelGui4
    Gui, 4:Color, FFFFFF
    Gui, 4:Font, s12 Norm, Calibri
    Gui, 4:Add, Text, vPrinterStatusText x3 y6 w134 h23 Center BackgroundTrans, Script Paused
    Gui, 4:Show, x%statusGuiX% y%statusGuiY% w140 h35 Hide NoActivate
    Gui, 4:+LastFound
    WinSet, Region, 0-0 W140 H35 R17-17

    OnMessage(0x201, "Gui4Drag")
    OnMessage(0x232, "Gui4MoveFinished")


    Gui4Drag(wParam, lParam, msg, hwnd)
    {
        PostMessage, 0xA1, 2
    }

    Gui4MoveFinished(wParam, lParam, msg, hwnd)
    {
        global statusGuiX, statusGuiY

        Gui, 4:+LastFound
        Gui, 4:Show
        WinGetPos, statusGuiX, statusGuiY
        SaveSettings()
    }


    Gui, 1:Font, s13 Norm, Calibri
    Gui, 1:Add, Text, x20 y20 w400 Center, Please assign a custom pause key and
    Gui, 1:Add, Text, x20 y40 w400 Center, your personal sandbox key:
    Gui, 1:Font, s10 Norm, Calibri
    Gui, 1:Add, DropDownList, vbind x80 y75 w150, %keys%
    GuiControl, 1:ChooseString, bind, %bind%
    Gui, 1:Add, Button, gSaveBind x240 y74 w130 h26, Assign Pause Key
    Gui, 1:Add, DropDownList, vbind2 x80 y111 w150, %keys%
    GuiControl, 1:ChooseString, bind2, %bind2%
    Gui, 1:Add, Button, gSaveBind2 x240 y110 w130 h26, Assign Sandbox Key
    Gui, 1:Font, s18 Bold
    Gui, 1:Add, Text, x20 y150 w400 Center, ATTENTION
    Gui, 1:Font, s13 Norm, Calibri
    Gui, 1:Add, Text, x20 y180 w400 Center, If you use my script for a different purpose than intended, aka abusing with it, i am not responsible. If you got punished for it, then thats your problem.
    Gui, 1:Font, s10 Norm, Calibri
    Gui, 1:Add, Button, x320 y260 w100 h26 gShowOptions, Options
    Gui, 1:Add, Button, x170 y260 w100 h26 gShowHelp, Help  
    Gui, 1:Add, Button, x20 y260 w100 h26 gShowUpdates, Changelog
    Gui, 1:Show, w440, Arras.io Character Printer
    return


    ControlFocus,, ahk_id %hHotkey%
    return


    SaveBind:
        Gui, Submit, NoHide

        if (bind = "")
        {
            MsgBox, Please choose a key first.
            return
        }

        if (selectedBind != "")
        {
            Hotkey, IfWinActive, arras.io
            Hotkey, %selectedBind%, Off
            Hotkey, IfWinActive
        }

        selectedBind := bind

        Hotkey, IfWinActive, arras.io
        Hotkey, %selectedBind%, PrinterPauseHotkey, On
        Hotkey, IfWinActive

        SaveSettings()

        MsgBox, Pause Key assigned: %selectedBind%
    return


    SaveBind2:
        Gui, Submit, NoHide

        if (bind2 = "")
        {
            MsgBox, Please choose a key first.
            return
        }

        SaveSettings()

        MsgBox, Pause Key assigned: %bind2%
        return


        GuiClose:
        if GetKeyState("Shift", "P")
        {
            ExitApp
        }
        else
        {
            MsgBox, 4, Confirm Close, Are you sure you want to close this window?
            IfMsgBox, Yes
                ExitApp
        }
    return


    ShowHelp:
        Gui, 2:Destroy
        Gui, 2:Font, s13 Bold, Calibri
        Gui, 2:Add, Text, x15 y10 w350, List of currently printable characters:
        Gui, 2:Font, s11 Norm,
        Gui, 2:Add, Text, x25 y+5 w200, • Full Alphabet: A-Z
        Gui, 2:Add, Text, x25 y+1 w200, • All numbers: 0-9
        Gui, 2:Add, Text, x25 y+1, • Special characters: ?  !  .  ,  =  ~  +  "  '
        Gui, 2:Font, s13 Bold,
        Gui, 2:Add, Text, x15 y+25 w350, Info/Help:
        Gui, 2:Font, s11 Norm,
        Gui, 2:Add, Text, x25 y+8 w770, • How to print: to print a character simply press it on your keyboard while the script is unpaused.
        Gui, 2:Add, Text, x36 y+0 w770, (see list of currently supported characters above.)
        Gui, 2:Add, Text, x25 y+8 w770, • Recommended setup to print: be lvl 45, with default fov and default tank size.
        Gui, 2:Add, Text, x36 y+0 w770, (other tank sizes/fovs will yield differently sized characters than the default size.)
        Gui, 2:Add, Text, x25 y+8 w770, • To see if the script is paused or not, look for a text box at the bottom left of your screen.
        Gui, 2:Add, Text, x25 y+8 w770, • The last orb in the chain is the orb you need to drag in order to move the entire character.
        Gui, 2:Add, Text, x36 y+0 w770, (its recommended to use `W-hirlpool instead of `D-rag, that way its easier to seperate jointed from non jointed orbs.)
        Gui, 2:Add, Text, x25 y+8 w770, • Joint together the last orb of each character to make words and phrases.
        Gui, 2:Add, Text, x25 y+8 w770, • Different printing modes/size modes are planned for future updates, but as of now are not supported by the script.
        Gui, 2:Font, s13 Bold,
        Gui, 2:Add, Text, x15 y+25 w350, Default Keys:
        Gui, 2:Font, s11 Norm,
        Gui, 2:Add, Text, x25 y+0 w770, • RShift = pause/unpause script
        Gui, 2:Add, Text, x25 y+0 w770, • Enter = auto pauses the script whenever typing
        Gui, 2:Add, Text, x25 y+0 w770, • F2 = set current mouse position as starting position for printing
        Gui, 2:Add, Text, x25 y+0 w770, • F4 = enable/disable drawing mode
        Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + E = exit script
        Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + R = reload script
        Gui, 2:Show, w790, Help Menu
    Return


    CloseHelp:
    Gui, 2:Destroy
    Return


    ShowUpdates:
    Gui, 5:Destroy
    Gui, 5:Font, s11 Norm, Calibri
    Gui, 5:Add, Edit, x0 y0 w790 h540 ReadOnly Multi WantTab VScroll, 
    (
    Changelog, 19th of October, 2026 / v3.2.0
    --------------------------------------------------
    ⠀⠀- Added a setting to the options to adjust the printing speed (the printer is now VERY fast)
    ⠀⠀- Overhauled most of the printing sequences to be more efficient, accurate and easier to use
    ⠀⠀- Changed the start-up state so that the script now starts in paused mode
    ⠀⠀- Added full legacy font support to all letters, A-Z and numbers, 0-9
    ⠀⠀- Added 6 new printable, special characters
    ⠀⠀- Organized the code a bit more



    Changelog, 15th of October, 2026 / v3.1.1
    --------------------------------------------------
    ⠀⠀- Fixed some minor spelling mistakes
    ⠀⠀- Cleaned up the code a bit
    ⠀⠀- Added a quick guide to the help menu on how to print



    Changelog, 14th of October, 2026 / v3.1.0
    --------------------------------------------------
    ⠀⠀- Changed the main menu screen layout
    ⠀⠀- Changed the info text in the help menu to fit the current build
    ⠀⠀- Added a changelog
    ⠀⠀- Added 6 new printable, special characters
    ⠀⠀- Added options and their corresponding File
    ⠀⠀- Changed the way the tooltip is displayed for better controll via the options
    ⠀⠀- The tooltip can now be moved by simply left-click-dragging it
    ⠀⠀- Added another tooltip mode for when the script is unpaused
    ⠀⠀- The tooltip modes can now be individually toggled
    ⠀⠀- Added the option to make the chosen sandbox key pause the script while holding it down
    ⠀⠀- Added the option to adjust the amount of orbs used in a print
    ⠀⠀- Added the option to set a custom printing position using F2
    ⠀⠀- Added a sneak peak for an upcoming feature in v3.2.0
    )
    Gui, 5:Show, w790 h538, Changelog
    Return


    CloseUpdates:
    Gui, 5:Destroy
    Return


    ShowOptions:
    Gui, 3:Destroy
    Gui, 3:Font, s13 Bold, Calibri
    Gui, 3:Add, Text, x15 y10 w770, Options are here!
    Gui, 3:Font, s11 Norm, Calibri
    Gui, 3:Add, CheckBox, vSandboxTimerEnabled gSandboxTimerToggle Checked%SandboxTimerEnabled%, Pause Script while holding Sandbox Key
    Gui, 3:Add, CheckBox, vShowPauseTooltip gPauseTooltipToggle Checked%showPauseTooltip%, Show "Script Paused" tooltip
    Gui, 3:Add, CheckBox, vShowUnpausedTooltip gUnpausedTooltipToggle Checked%showUnpausedTooltip%, Show "Script Unpaused" tooltip
    Gui, 3:Add, Text, x15 y125, Orb count per Print (recommended, 2):
    Gui, 3:Add, Slider, vprintPressCount gPrintPressCountChange x15 y150 w250 Range1-3 TickInterval1 ToolTip, %printPressCount%
    Gui, 3:Add, Text, vPrintPressCountLabel x275 y150 w100, %printPressCount%
    Gui, 3:Add, Text, x15 y185, Time interval per orb in milliseconds, aka: the speed of printing something (recommended, 50):
    Gui, 3:Add, Slider, vprintSleepTime gPrintSleepTimeChange x15 y210 w250 Range50-200 TickInterval50 Line50 Page50 ToolTip, %printSleepTime%
    Gui, 3:Add, Text, vPrintSleepTimeLabel x275 y210 w100, %printSleepTime%
    Gui, 3:Add, Text, x15 y250, Character Font (shhh this is a spoiler!):
    Gui, 3:Add, DropDownList, vselectedFont gFontSelect x20 y278 w180, Default Font|Legacy Font
    GuiControl, 3:ChooseString, selectedFont, %selectedFont%
    Gui, 3:Show, w790, Options
    Return


    PrintPressCountChange:
        Gui, 3:Submit, NoHide
        GuiControl, 3:, PrintPressCountLabel, %printPressCount%
        SaveSettings()
    return



    PrintSleepTimeChange:
        Gui, 3:Submit, NoHide
        printSleepTime := Round(printSleepTime / 50) * 50
        GuiControl, 3:, printSleepTime, %printSleepTime%
        GuiControl, 3:, PrintSleepTimeLabel, %printSleepTime%
        SaveSettings()
    return


    SandboxTimerToggle:
        Gui, 3:Submit, NoHide

        if (sandboxTimerEnabled)
        {
            SetTimer, CheckSandboxKey, 50
            IniWrite, 1, %settingsFile%, Settings, SandboxTimer
        }
        else
        {
            SetTimer, CheckSandboxKey, Off
            IniWrite, 0, %settingsFile%, Settings, SandboxTimer
        }
    return


    PauseTooltipToggle:
        Gui, 3:Submit, NoHide
        SaveSettings()
        PrinterStateManager("ArrasFocus")
    return


    UnpausedTooltipToggle:
        Gui, 3:Submit, NoHide
        SaveSettings()
        PrinterStateManager("ArrasFocus")
    return


    FontSelect:
    Gui, 3:Submit, NoHide
    SaveSettings()
    return


    PrintPositionChange:
    Gui, 3:Submit, NoHide
    SaveSettings()
    return


    CloseOptions:
    Gui, 3:Destroy
    Return

;///// Guis \\\\\



;\\\\\ Functions /////

    LoadSettings()
    {
        global settingsFile, bind, bind2, selectedBind, sandboxTimerEnabled, showPauseTooltip, showUnpausedTooltip, statusGuiX, statusGuiY, selectedFont, printStartX, printStartY, printPressCount, printSleepTime

        if (!FileExist(settingsFile))
        {
            SaveSettings()
        }
        else
        {
            IniRead, bind, %settingsFile%, Settings, PauseKey, %bind%
            IniRead, bind2, %settingsFile%, Settings, SandboxKey, %bind2%
            IniRead, sandboxTimerEnabled, %settingsFile%, Settings, SandboxTimer, 0
            sandboxTimerEnabled := (sandboxTimerEnabled = "1")
            IniRead, showPauseTooltip, %settingsFile%, Settings, PauseTooltip, 1
            showPauseTooltip := (showPauseTooltip = "1")
            IniRead, showUnpausedTooltip, %settingsFile%, Settings, UnpausedTooltip, 1
            showUnpausedTooltip := (showUnpausedTooltip = "1")
            IniRead, statusGuiX, %settingsFile%, Settings, StatusGuiX, 47
            IniRead, statusGuiY, %settingsFile%, Settings, StatusGuiY, 768
            IniRead, selectedFont, %settingsFile%, Settings, Font, Default Font
            IniRead, printStartX, %settingsFile%, Settings, PrintStartX, 707
            IniRead, printStartY, %settingsFile%, Settings, PrintStartY, 484
            IniRead, printPressCount, %settingsFile%, Settings, PrintPressCount, 2
            IniRead, printSleepTime, %settingsFile%, Settings, PrintSleepTime, 50
        }

        selectedBind := bind

        if (bind != "")
        {
            Hotkey, IfWinActive, arras.io
            Hotkey, %bind%, PrinterPauseHotkey, On
            Hotkey, IfWinActive
        }
    }

    SaveSettings()
    {
        global settingsFile, bind, bind2, sandboxTimerEnabled, showPauseTooltip, showUnpausedTooltip, statusGuiX, statusGuiY, selectedFont, printStartX, printStartY, printPressCount, printSleepTime

        IniWrite, %bind%, %settingsFile%, Settings, PauseKey
        IniWrite, %bind2%, %settingsFile%, Settings, SandboxKey
        IniWrite, % sandboxTimerEnabled ? 1 : 0, %settingsFile%, Settings, SandboxTimer
        IniWrite, % showPauseTooltip ? 1 : 0, %settingsFile%, Settings, PauseTooltip
        IniWrite, % showUnpausedTooltip ? 1 : 0, %settingsFile%, Settings, UnpausedTooltip
        IniWrite, %statusGuiX%, %settingsFile%, Settings, StatusGuiX
        IniWrite, %statusGuiY%, %settingsFile%, Settings, StatusGuiY
        IniWrite, %selectedFont%, %settingsFile%, Settings, Font
        IniWrite, %printStartX%, %settingsFile%, Settings, PrintStartX
        IniWrite, %printStartY%, %settingsFile%, Settings, PrintStartY
        IniWrite, %printPressCount%, %settingsFile%, Settings, PrintPressCount
        IniWrite, %printSleepTime%, %settingsFile%, Settings, PrintSleepTime
    }


    CheckSandboxKey:
        keyIsHeld := GetKeyState(bind2, "P")

        if (keyIsHeld && !sandboxWasHeld)
        {
            sandboxWasHeld := true
            PrinterStateManager("SandboxDown")
        }
        else if (!keyIsHeld && sandboxWasHeld)
        {
            sandboxWasHeld := false
            PrinterStateManager("SandboxUp")
        }
    return


    PrinterStateManager(source)
    {
        global isPrintingCancelled, isPrinting, sendEnterAfterCancel, bind2, sandboxPausedScript, bind

        if (source = "RShift" || source = "PauseKey")
        {
            Suspend

            if (A_IsSuspended)
            {
                isPrintingCancelled := true
                UpdatePrinterStatus("Paused")
            }
            else
            {
                isPrintingCancelled := false
                UpdatePrinterStatus("Unpaused")
            }

            return
        }

        if (source = "SandboxDown")
        {
            if (!A_IsSuspended)
            {
                sandboxPausedScript := true
                Suspend
                isPrintingCancelled := true
                UpdatePrinterStatus("Paused")
            }

            return
        }

        if (source = "SandboxUp")
        {
            if (sandboxPausedScript && A_IsSuspended)
            {
                sandboxPausedScript := false
                Suspend
                isPrintingCancelled := false
                UpdatePrinterStatus("Unpaused")
            }

            return
        }

        if (source = "Enter")
        {
            if (!A_IsSuspended)
            {
                if (isPrinting)
                {
                    sendEnterAfterCancel := true
                    isPrintingCancelled := true
                }
                else
                {
                    Send, {Enter}
                }

                Suspend, On
                UpdatePrinterStatus("Paused")
            }
            else
            {
                Send, {Enter}
            }

            return
        }

        if (source = "PrintCancelled")
        {
            Send, {%bind2% up}{j up}

            if (sendEnterAfterCancel)
            {
                sendEnterAfterCancel := false
                Send, {Enter}
            }

            isPrinting := false

            return
        }

        if (source = "ArrasFocus")
        {
            if (isPrinting && !WinActive("arras.io") && !A_IsSuspended)
            {
                Suspend
                isPrintingCancelled := true
                UpdatePrinterStatus("Paused")
                return
            }

            if (A_IsSuspended)
                UpdatePrinterStatus("Paused")
            else
                UpdatePrinterStatus("Unpaused")

            return
        }
    }


    UpdatePrinterStatus(status)
    {
        global showPauseTooltip, showUnpausedTooltip

        if (!WinActive("arras.io"))
        {
            Gui, 4:Hide
            return
        }

        if (status = "Paused")
        {
            if (showPauseTooltip)
            {
                GuiControl, 4:, PrinterStatusText, Script Paused
                Gui, 4:Show, w140 h35 NoActivate
            }
            else
            {
                Gui, 4:Hide
            }

            return
        }

        if (status = "Unpaused")
        {
            if (showUnpausedTooltip)
            {
                GuiControl, 4:, PrinterStatusText, Script Unpaused
                Gui, 4:Show, w140 h35 NoActivate
            }
            else
            {
                Gui, 4:Hide
            }

            return
        }

        Gui, 4:Hide
    }


    #IfWinActive arras.io

    PrintCharacter(points)
    {
        global bind2, isPrintingCancelled, isPrinting, printStartX, printStartY, printPressCount, printSleepTime

        isPrinting := true
        Sleep, 200

        CoordMode, Mouse, Screen

        Send, {%bind2% down}

        currentX := printStartX
        currentY := printStartY

        for index, point in points
        {
            if (isPrintingCancelled)
            {
                PrinterStateManager("PrintCancelled")
                return
            }

            if (index = 1)
            {
                currentX := printStartX + point[1]
                currentY := printStartY + point[2]
            }
            else
            {
                currentX := currentX + point[1]
                currentY := currentY + point[2]
            }

            MouseMove, % currentX, % currentY

            Sleep, %printSleepTime%

            Loop, %printPressCount%
                Send, ch
        }

        currentX := printStartX
        currentY := printStartY

        for index, point in points
        {
            if (isPrintingCancelled)
            {
                PrinterStateManager("PrintCancelled")
                return
            }

            if (index = 1)
            {
                currentX := printStartX + point[1]
                currentY := printStartY + point[2]
            }
            else
            {
                currentX := currentX + point[1]
                currentY := currentY + point[2]
            }

            MouseMove, % currentX, % currentY

            Sleep, %printSleepTime%

            if (index = 1)
                Send, {j down}
            else if (index = points.MaxIndex())
                Send, {j up}{%bind2% up}
            else
                Send, {j up}{j down}
        }

        Send, {%bind2% up}{j up}
        isPrinting := false
    }

    #IfWinActive


    PrinterPauseHotkey:
    Suspend, Permit
    PrinterStateManager("PauseKey")
    return


    CheckArrasFocus:
    PrinterStateManager("ArrasFocus")
    return


    DrawingTool:
        if (!drawMode)
            return

        MouseGetPos, currX, currY

        if (currX != prevX || currY != prevY) {
            send, {%bind2% down}{c}{h}{%bind2% up}
        }

        prevX := currX
        prevY := currY
    return

;///// Functions \\\\\



;\\\\\ Hotkeys /////

    #IfWinActive arras.io

    F2::
        MouseGetPos, printStartX, printStartY
        SaveSettings()
        ToolTip, % "Printing position saved: " printStartX ", " printStartY
        SetTimer, RemovePrintPositionTooltip, -1500
    return

    RemovePrintPositionTooltip:
    ToolTip
    return

    #IfWinActive

    F4::
        drawMode := !drawMode
        if (drawMode) {
            MouseGetPos, prevX, prevY
            SetTimer, DrawingTool, 100
        } else {
            SetTimer, DrawingTool, Off
        }
    return

    #IfWinActive arras.io

    $*RShift::
    Suspend, Permit
    PrinterStateManager("RShift")
    return

    $*Enter::
    Suspend, Permit
    PrinterStateManager("Enter")
    return

;///// Hotkeys \\\\\



;\\\\\ Printing Hotkeys /////

    $A up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-15, 40])
            points.Push([-15, 40])
            points.Push([-15, 40])
            points.Push([-15, 40])
            points.Push([45, -50])
            points.Push([30, 0])
            points.Push([0, -70])
            points.Push([15, 40])
            points.Push([15, 40])
            points.Push([15, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -160])
            points.Push([0, 80])
            points.Push([40, -80])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }

        PrintCharacter(points)
    return

    $B up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([25, 25])
            points.Push([0, 30])
            points.Push([-65, -15])
            points.Push([40, 40])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([72, -15])
            points.Push([0, 30])
            points.Push([-32, 25])
            points.Push([-40, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([40, 0])
            points.Push([40, 40])
            points.Push([-40, 40])
            points.Push([40, 40])
            points.Push([-40, 40])
            points.Push([-40, 0])
        }
        PrintCharacter(points)
    return

    $C up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([-28, 12])
            points.Push([-12, 28])
            points.Push([-5, 40])
            points.Push([5, 40])
            points.Push([12, 28])
            points.Push([28, 12])
            points.Push([40, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }
        PrintCharacter(points)
    return

    $D up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([40, 0])
            points.Push([23, 17])
            points.Push([12, 28])
            points.Push([4, 35])
            points.Push([-4, 35])
            points.Push([-12, 28])
            points.Push([-23, 17])
            points.Push([-40, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([40, 0])
            points.Push([40, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 40])
            points.Push([-40, 0])
        }
        PrintCharacter(points)
    return

    $E up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([120, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([120, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }
        PrintCharacter(points)
    return

    $F up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([120, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([-40, 40])
            points.Push([0, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([120, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([-40, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $G up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([-28, 12])
            points.Push([-12, 28])
            points.Push([-5, 40])
            points.Push([5, 40])
            points.Push([12, 28])
            points.Push([28, 12])
            points.Push([40, 0])
            points.Push([0, -40])
            points.Push([0, -40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, -40])
            points.Push([0, -40])
        }
        PrintCharacter(points)
    return

    $H up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -80])
            points.Push([40, -80])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -80])
            points.Push([40, -80])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $I up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }
        PrintCharacter(points)
    return

    $J up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-14, 26])
            points.Push([-26, 14])
            points.Push([-30, -10])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-30, 30])
            points.Push([-40, 0])
        }
        PrintCharacter(points)
    return

    $K up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([80, 0])
            points.Push([-20, -40])
            points.Push([-20, -40])
            points.Push([20, -40])
            points.Push([20, -40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([80, -160])
            points.Push([0, 40])
            points.Push([-40, 40])
            points.Push([40, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $L up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }
        PrintCharacter(points)
    return

    $M up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 160])
            points.Push([6, -40])
            points.Push([6, -40])
            points.Push([6, -40])
            points.Push([6, -40])
            points.Push([15, 38])
            points.Push([15, 38])
            points.Push([15, 38])
            points.Push([15, -38])
            points.Push([15, -38])
            points.Push([15, -38])
            points.Push([6, 40])
            points.Push([6, 40])
            points.Push([6, 40])
            points.Push([6, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 160])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([20, 20])
            points.Push([20, 20])
            points.Push([20, 20])
            points.Push([20, -20])
            points.Push([20, -20])
            points.Push([20, -20])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }

        PrintCharacter(points)
    return

    $N up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 160])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 160])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([22, 32])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
        }

        PrintCharacter(points)
    return

    $O up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-24, -14])
            points.Push([-12, -26])
            points.Push([-5, -32])
            points.Push([5, -32])
            points.Push([12, -26])
            points.Push([24, -14])
            points.Push([30, -8])
            points.Push([28, 8])
            points.Push([24, 14])
            points.Push([12, 26])
            points.Push([5, 32])
            points.Push([-5, 32])
            points.Push([-12, 26])
            points.Push([-24, 14])
            points.Push([-30, 8])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -160])
            points.Push([0, 160])
            points.Push([40, -160])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $P up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([30, -20])
            points.Push([0, -40])
            points.Push([-30, -20])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([35, -40])
            points.Push([-35, -40])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $Q up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-24, -14])
            points.Push([-12, -26])
            points.Push([-5, -32])
            points.Push([5, -32])
            points.Push([12, -26])
            points.Push([24, -14])
            points.Push([30, -8])
            points.Push([28, 8])
            points.Push([24, 14])
            points.Push([12, 26])
            points.Push([5, 32])
            points.Push([-5, 32])
            points.Push([-12, 26])
            points.Push([-24, 14])
            points.Push([-30, 8])
            points.Push([0, 25])
            points.Push([10, 20])
            points.Push([18, 10])
            points.Push([20, 2])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -160])
            points.Push([0, 160])
            points.Push([40, -160])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-14, 27])
            points.Push([-10.5, -31])
            points.Push([21, 62])
        }
        PrintCharacter(points)
    return

    $R up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -160])
            points.Push([0, 80])
            points.Push([26, 40])
            points.Push([5, -99])
            points.Push([0, 42])
            points.Push([9, 97])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -160])
            points.Push([0, 80])
            points.Push([40, -40])
            points.Push([0, 80])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $S up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-35, -5])
            points.Push([-30, 10])
            points.Push([-10, 30])
            points.Push([10, 30])
            points.Push([30, 10])
            points.Push([30, 10])
            points.Push([10, 30])
            points.Push([-10, 30])
            points.Push([-30, 10])
            points.Push([-35, -5])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 0])
            points.Push([-40, 0])
        }
        
        PrintCharacter(points)
    return

    $T up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $U up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([12, 27])
            points.Push([32, 13])
            points.Push([32, -13])
            points.Push([12, -27])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
        }
        PrintCharacter(points)
    return

    $V up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([14, 40])
            points.Push([14, 40])
            points.Push([14, 40])
            points.Push([70, -120])
            points.Push([-14, 40])
            points.Push([-14, 40])
            points.Push([-14, 40])
            points.Push([-14, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([30, 40])
            points.Push([0, 40])
            points.Push([30, 40])
            points.Push([30, -40])
            points.Push([0, -40])
            points.Push([30, -40])
            points.Push([0, -40])
        }
        PrintCharacter(points)
    return

    $W up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([6, 40])
            points.Push([6, 40])
            points.Push([6, 40])
            points.Push([6, 40])
            points.Push([15, -38])
            points.Push([15, -38])
            points.Push([15, -38])
            points.Push([15, 38])
            points.Push([15, 38])
            points.Push([15, 38])
            points.Push([6, -40])
            points.Push([6, -40])
            points.Push([6, -40])
            points.Push([6, -40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([20, -20])
            points.Push([20, -20])
            points.Push([20, -20])
            points.Push([20, 20])
            points.Push([20, 20])
            points.Push([20, 20])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
        }
        PrintCharacter(points)
    return

    $X up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([23, 40])
            points.Push([23, 40])
            points.Push([23, 40])
            points.Push([23, 40])
            points.Push([0, -160])
            points.Push([-23, 40])
            points.Push([-46, 80])
            points.Push([-23, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([40, 40])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([80, -160])
            points.Push([0, 40])
            points.Push([0, 80])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $Y up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([24, 40])
            points.Push([26, 40])
            points.Push([50, -80])
            points.Push([-24, 40])
            points.Push([-26, 80])
            points.Push([0, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([80, -40])
            points.Push([0, 40])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $Z up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([-20, 40])
            points.Push([-20, 40])
            points.Push([-20, 40])
            points.Push([-20, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, 40])
            points.Push([-40, 40])
            points.Push([-40, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }
        PrintCharacter(points)
    return



    $1 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-26, 28])
            points.Push([-25, 27])
            points.Push([51, -15])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, -40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }
        PrintCharacter(points)
    return

    $2 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([35, -20])
            points.Push([35, 20])
            points.Push([0, 40])
            points.Push([-20, 35])
            points.Push([-24, 32])
            points.Push([-26, 32])
            points.Push([40, 0])
            points.Push([40, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
        }
        PrintCharacter(points)
    return

    $3 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([35, -20])
            points.Push([35, 20])
            points.Push([5, 25])
            points.Push([-15, 35])
            points.Push([-40, 0])
            points.Push([55, 35])
            points.Push([-5, 25])
            points.Push([-35, 20])
            points.Push([-35, -20])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([80, 40])
            points.Push([0, 40])
            points.Push([-40, 0])
            points.Push([-40, 0])
        }
        PrintCharacter(points)
    return

    $4 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([-28, 32])
            points.Push([-25, 33])
            points.Push([-20, 35])
            points.Push([40, 0])
            points.Push([68, 0])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, -80])
            points.Push([0, 40])
            points.Push([0, 80])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $5 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([25, 10])
            points.Push([15, 30])
            points.Push([-15, 30])
            points.Push([-25, 10])
            points.Push([-40, -2])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, 0])
            points.Push([40, 40])
            points.Push([-40, 40])
            points.Push([-40, 0])
        }

        PrintCharacter(points)
    return

    $6 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([30, 10])
            points.Push([10, 30])
            points.Push([-10, 30])
            points.Push([-30, 10])
            points.Push([-30, -10])
            points.Push([-10, -30])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([12, -28])
            points.Push([28, -12])
            points.Push([30, -3])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 0])
            points.Push([-40, 0])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([40, 0])
            points.Push([40, 0])
        }

        PrintCharacter(points)
    return

    $7 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([-15, 40])
            points.Push([-15, 40])
            points.Push([-15, 40])
            points.Push([-15, 40])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $8 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-13, -33])
            points.Push([13, -33])
            points.Push([33, -13])
            points.Push([32, -13])
            points.Push([12, -27])
            points.Push([-12, -27])
            points.Push([-32, -13])
            points.Push([-32, 13])
            points.Push([-12, 27])
            points.Push([12, 27])
            points.Push([65, 26])
            points.Push([13, 33])
            points.Push([-13, 33])
            points.Push([-33, 13])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -160])
            points.Push([0, 80])
            points.Push([0, 80])
            points.Push([40, -160])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return

    $9 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-30, -10])
            points.Push([-10, -30])
            points.Push([10, -30])
            points.Push([30, -10])
            points.Push([30, 10])
            points.Push([10, 30])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-12, 28])
            points.Push([-28, 12])
            points.Push([-30, 3])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([-40, 0])
            points.Push([0, -40])
            points.Push([0, -40])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([-40, 0])
            points.Push([-40, 0])
        }
        PrintCharacter(points)
    return

    $0 up::
        if (selectedFont = "Default Font")
        {
            points := []
            points.Push([12, 147])
            points.Push([-12, -27])
            points.Push([-3, -40])
            points.Push([3, -40])
            points.Push([12, -27])
            points.Push([32, -13])
            points.Push([32, 13])
            points.Push([12, 27])
            points.Push([3, 40])
            points.Push([-3, 40])
            points.Push([-12, 27])
            points.Push([-32, 13])
        }

        if (selectedFont = "Legacy Font")
        {
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([40, -160])
            points.Push([0, 160])
            points.Push([40, -160])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 40])
        }
        PrintCharacter(points)
    return



    $? up::
        points := []
        points.Push([0, 0])
        points.Push([35, -20])
        points.Push([35, 20])
        points.Push([0, 40])
        points.Push([-35, 20])
        points.Push([0, 80])
        PrintCharacter(points)
    return

    $*! up::
        KeyWait, LShift
        points := []
        points.Push([0, 0])
        points.Push([0, 40])
        points.Push([0, 40])
        points.Push([0, 80])
        PrintCharacter(points)
    return

    $. up::
        Send,{shift down}{c}{h}{shift up}
    return

    $, up::
        points := []
        points.Push([0, 0])
        points.Push([-3, 22])
        points.Push([-9, 18])
        PrintCharacter(points)
    return

    $= up::
        KeyWait, LShift
        points := []
        points.Push([0, 0])
        points.Push([40, 0])
        points.Push([40, 0])
        points.Push([-80, 60])
        points.Push([40, 0])
        points.Push([40, 0])
        PrintCharacter(points)
    return

    $" up::
        KeyWait, LShift
        points := []
        points.Push([0, 0])
        points.Push([0, 20])
        points.Push([50, -20])
        points.Push([0, 20])
        PrintCharacter(points)
    return

    $' up::
        KeyWait, LShift
        points := []
        points.Push([0, 0])
        points.Push([0, 20])
        PrintCharacter(points)
    return

    $+ up::
        KeyWait, LShift
        points := []
        points.Push([0, 0])
        points.Push([40, 0])
        points.Push([40, 0])
        points.Push([-40, -40])
        points.Push([0, 80])
        PrintCharacter(points)
    return

    $*~ up::
        KeyWait, LShift
            points := []
            points.Push([0, 0])
            points.Push([10, -12])
            points.Push([14, -8])
            points.Push([12, 0])
            points.Push([12, 10])
            points.Push([14, 10])
            points.Push([12, 0])
            points.Push([14, -8])
            points.Push([12, -12])
            PrintCharacter(points)
    return

    #IfWinActive

;///// Printing Hotkeys \\\\\



;\\\\\ Extra Keys /////

    ^!e::
    Suspend, Permit
    ExitApp
    return

    ^!r::
    Suspend, Permit
    Reload
    return

;///// Extra Keys \\\\\