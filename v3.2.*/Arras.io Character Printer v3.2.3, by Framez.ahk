
; genuinely hope the code is as readable as possible for anyone wanting to learn ahk, lol would honestly be amazing to know someone learned from my script, like i did from others. (almost all code parts are grouped into categories now, for very easy searching and organization.)
; tip for anyone reading this: use apps like Visual Studio Code for an even cleaner look of the code. (use the arrows on the left sidebar, besides the line numbers.)

;\\\\\ Auto-Execution / Startup /////

    ;\\\ Directives ///

        #Requires AutoHotkey v1.1

        #InstallKeybdHook
        #InstallMouseHook

        #SingleInstance Force
        #Persistent
        #NoEnv

    ;/// Directives \\\


    ;\\\ Global Settings ///

        SetKeyDelay -1
        SetMouseDelay 0
        SetBatchLines, -1

    ;/// Global Settings \\\


    settingsFile := A_ScriptDir "\settings(ACP).ini"


    ;\\\ Booleans ///

        sendEnterAfterCancel := false

        isPrintingCancelled := false
        isPrinting := false

        sandboxPausedScript := false

        sandboxTimerEnabled := false

        showUnpausedTooltip := true
        showPauseTooltip := true

        sandboxWasHeld := false

        drawMode := false

        pauseAfterPrint := true

        pauseOnUserInput := true
        userInputDetected := false
        userInputMonitoring := false

    ;/// Booleans \\\


    ;\\\ Strings ///

        selectedFont := "Default Font"

        startPaused := "Paused"

        sandboxBind := "``"

        selectedPauseBind := ""
        pauseBind := "Tab"

        selectedDrawBind := ""
        drawBind := "F4"

        selectedPositionBind := ""
        positionBind := "F2"

        keys := "0|1|2|3|4|5|6|7|8|9|A|Alt|AppsKey|B|Backspace|Browser_Back|Browser_Favorites|Browser_Forward|Browser_Home|Browser_Refresh|Browser_Search|Browser_Stop|C|CapsLock|Ctrl|D|Delete|Down|E|End|Enter|Escape|F|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|G|H|Home|I|Insert|J|K|L|Launch_App1|Launch_App2|Launch_Mail|Launch_Media|LAlt|LCtrl|Left|Lshift|LWin|M|Media_Next|Media_Play_Pause|Media_Prev|Media_Stop|N|NumLock|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|NumpadAdd|NumpadDiv|NumpadDot|NumpadEnter|NumpadMult|NumpadSub|O|P|Pause|PgDn|PgUp|PrintScreen|Q|R|RAlt|RCtrl|Right|Rshift|RWin|S|ScrollLock|Space|T|Tab|U|Up|V|Volume_Down|Volume_Mute|Volume_Up|W|X|XButton1|XButton2|Y|Z|``|'|,|-|.|/|;|=|[|\|]"


        SpecialChars := Chr(8226) . " Special characters:  ?  !  .  ,  =  ~  +  " Chr(34) "  '  #  -  /  ()  {}  []  " Chr(37) "  " Chr(59) "  :  <  >  _"

    ;/// Strings \\\


    ;\\\ Integers ///

        prevX := 0
        prevY := 0

        statusGuiX := 47
        statusGuiY := 768

        printStartX := 707
        printStartY := 484

        printPressCount := 2

        printSleepTime := 50

    ;/// Integers \\\


    ;\\\ Extras ///

        LoadSettings()

        CreatePrinterStatusGUI()

        SetTimer, CheckArrasFocus, 100

        if (sandboxTimerEnabled)
            SetTimer, CheckSandboxKey, 50

        if (startPaused = "Paused")
        Suspend, On

    ;/// Extras \\\

;///// Auto-Execution / Startup \\\\\



;\\\\\ Guis /////

    ;\\\ Main Menu GUI ///

        Gui, 1:Font, s18 Bold
        Gui, 1:Add, Text, x50 y20 w400 Center, ATTENTION
        Gui, 1:Font, s14 Bold, Calibri
        Gui, 1:Add, Text, x15 y+3 w470 Center, I am not responsible for the things you do with my script.
        Gui, 1:Add, Text, x15 y+0 w470 Center, I do not condone abuse or any other forms of miss-use using my script.

        Gui, 1:Font, s14 Norm, Calibri
        Gui, 1:Add, Text, x50 y+30 w400 Center, If this is your first time using the script, please go to the options and assign your own sandbox key that you use, otherwise the script will not function.
        Gui, 1:Font, s13 Norm, Calibri

        Gui, 1:Add, Button, x50 y260 w100 h28 gShowUpdates, Changelog
        Gui, 1:Add, Button, x200 y260 w100 h28 gShowHelp, Help  
        Gui, 1:Add, Button, x350 y260 w100 h28 gShowOptions, Options

        Gui, 1:Show, w500 h300, Arras.io Character Printer
        return


        ControlFocus,, ahk_id %hHotkey%
        return


        SaveBind:
            Gui, Submit, NoHide

            if (pauseBind = "")
            {
                MsgBox, Please choose a key first.
                return
            }

            if (selectedPauseBind != "")
            {
                Hotkey, IfWinActive, arras.io
                Hotkey, % "$*" . selectedPauseBind, Off
                Hotkey, IfWinActive
            }

            selectedPauseBind := pauseBind

            Hotkey, IfWinActive, arras.io
            Hotkey, % "$*" . selectedPauseBind, PrinterPauseHotkey, On P10
            Hotkey, IfWinActive

            SaveSettings()

            MsgBox, Pause Key assigned: %selectedPauseBind%
        return


        SaveBind2:
            Gui, Submit, NoHide

            if (sandboxBind = "")
            {
                MsgBox, Please choose a key first.
                return
            }

            SaveSettings()

            MsgBox, Pause Key assigned: %sandboxBind%
            return


            GuiClose:
            if GetKeyState("Shift", "P")
            {
                ExitApp
            }
            else
            {
                MsgBox, 4, Confirm Close, Are you sure you want to exit the script?
                IfMsgBox, Yes
                    ExitApp
            }
        return

    ;/// Main Menu GUI \\\


    ;\\\ Help GUI ///

        ShowHelp:
        Gui, 2:Destroy
        Gui, 2:Font, s14 Bold, Calibri
        Gui, 2:Add, Text, x15 y10 w350, List of currently printable characters:
        Gui, 2:Font, s12 Norm,

        Gui, 2:Add, Text, x25 y+5 w200, • Full Alphabet: A-Z
        Gui, 2:Add, Text, x25 y+1 w200, • All numbers: 0-9
        Gui, 2:Add, Text, x25 y+1, % SpecialChars

        Gui, 2:Font, s14 Bold,
        Gui, 2:Add, Text, x15 y+25 w350, Info/Help:
        Gui, 2:Font, s12 Norm,

        Gui, 2:Add, Text, x25 y+8 w770, • How to print: to print a character simply press it on your keyboard while the script is unpaused.
        Gui, 2:Add, Text, x36 y+0 w770, (see list of currently supported characters above.)
        Gui, 2:Add, Text, x25 y+8 w770, • Recommended setup to print: be lvl 45, with default fov and default tank size.
        Gui, 2:Add, Text, x36 y+0 w770, (other tank sizes/fovs will yield differently sized characters than the default size.)
        Gui, 2:Add, Text, x25 y+8 w770, • To see if the script is paused or not, look for a text box at the bottom left of your screen.
        Gui, 2:Add, Text, x36 y+0 w770, (optionally, you can drag-click the box to anywhere on screen, and the script will remember the position you chose.)
        Gui, 2:Add, Text, x25 y+8 w770, • The last orb in the chain is the orb you need to drag in order to move the entire character.
        Gui, 2:Add, Text, x36 y+0 w770, (its recommended to use `W-hirlpool instead of `D-rag, that way its easier to seperate jointed from non jointed orbs.)
        Gui, 2:Add, Text, x25 y+8 w770, • Joint together the last orb of each character to make words and phrases.
        Gui, 2:Add, Text, x25 y+8 w770, • Different printing modes/size modes are planned for future updates, but as of now are not supported by the script.

        Gui, 2:Font, s14 Bold,
        Gui, 2:Add, Text, x15 y+25 w350, Default Keys:
        Gui, 2:Font, s12 Norm,

        Gui, 2:Add, Text, x25 y+0 w770, • RShift = pause/unpause script
        Gui, 2:Add, Text, x25 y+0 w770, • Enter = auto pauses the script whenever typing
        Gui, 2:Add, Text, x25 y+0 w770, • F2 = set current mouse position as the starting position for printing
        Gui, 2:Add, Text, x25 y+0 w770, • F4 = enable/disable drawing mode
        Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + E = exit script
        Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + R = reload script

        Gui, 2:Show, w810 h560, Help Menu
        Return


        CloseHelp:
        Gui, 2:Destroy
        Return

    ;/// Help GUI \\\


    ;\\\ Options GUI ///

        ShowOptions:
        Gui, 3:Destroy
        Gui, 3:Font, s11 Norm, Calibri

        Gui, 3:Add, CheckBox, vSandboxTimerEnabled gSandboxTimerToggle Checked%SandboxTimerEnabled% x15 y15, Pause Script while holding Sandbox Key
        Gui, 3:Add, CheckBox, vShowPauseTooltip gPauseTooltipToggle Checked%showPauseTooltip% x15 y+5, Show "Script Paused" tooltip
        Gui, 3:Add, CheckBox, vShowUnpausedTooltip gUnpausedTooltipToggle Checked%showUnpausedTooltip% x15 y+5, Show "Script Unpaused" tooltip
        Gui, 3:Add, CheckBox, vPauseAfterPrint gPauseAfterPrintToggle Checked%pauseAfterPrint% x15 y+5, Pause script after each print
        Gui, 3:Add, CheckBox, vPauseOnUserInput gPauseOnUserInputToggle Checked%pauseOnUserInput% x15 y+5, Pause script if a keyboard or mouse key is pressed while printing

        Gui, 3:Add, Text, x15 y+20, Orb count per Print (recommended, 2):
        Gui, 3:Add, Slider, vprintPressCount gPrintPressCountChange x15 y+8 w250 Range1-3 TickInterval1 ToolTip, %printPressCount%
        Gui, 3:Add, Text, vPrintPressCountLabel x275 yp w100, %printPressCount%

        Gui, 3:Add, Text, x15 y+10, Time interval per orb in milliseconds, aka: the speed of printing something (recommended, 50):
        Gui, 3:Add, Slider, vprintSleepTime gPrintSleepTimeChange x15 y+8 w250 Range50-200 TickInterval50 Line50 Page50 ToolTip, %printSleepTime%
        Gui, 3:Add, Text, vPrintSleepTimeLabel x275 yp w100, %printSleepTime%

        Gui, 3:Add, Text, x15 y+20, Pause Key:
        Gui, 3:Add, DropDownList, vpauseBind x20 y+3 w130, %keys%
        GuiControl, 3:ChooseString, pauseBind, %pauseBind%
        Gui, 3:Add, Button, x160 yp w130 h25 gSaveBind, Assign Pause Key

        Gui, 3:Add, Text, x15 y+10, Sandbox Key:
        Gui, 3:Add, DropDownList, vsandboxBind x20 y+3 w130, %keys%
        GuiControl, 3:ChooseString, sandboxBind, %sandboxBind%
        Gui, 3:Add, Button, x160 yp w130 h25 gSaveBind2, Assign Sandbox Key

        Gui, 3:Add, Text, x15 y+10, Drawing Mode Key:
        Gui, 3:Add, DropDownList, vdrawBind x20 y+3 w130, %keys%
        GuiControl, 3:ChooseString, drawBind, %drawBind%
        Gui, 3:Add, Button, x160 yp w130 h25 gSaveDrawBind, Assign Drawing Key

        Gui, 3:Add, Text, x15 y+10, Print Position Key:
        Gui, 3:Add, DropDownList, vpositionBind x20 y+3 w130, %keys%
        GuiControl, 3:ChooseString, positionBind, %positionBind%
        Gui, 3:Add, Button, x160 yp w130 h25 gSavePositionBind, Assign Position Key

        Gui, 3:Add, Text, x15 y+20, Character Font:
        Gui, 3:Add, DropDownList, vselectedFont gFontSelect x20 y+3 w180, Default Font|Legacy Font
        GuiControl, 3:ChooseString, selectedFont, %selectedFont%

        Gui, 3:Add, Text, x684 y10, Startup State
        Gui, 3:Add, DropDownList, vstartPaused gStartupStateChange x680 y33 w90, Paused|Unpaused
        GuiControl, 3:ChooseString, startPaused, %startPaused%

        Gui, 3:Show, w790 h560, Options
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


        PauseOnUserInputToggle:
            Gui, Submit, NoHide
            pauseOnUserInput := PauseOnUserInput
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


        SaveDrawBind:
            Gui, Submit, NoHide

            if (drawBind = "")
            {
                MsgBox, Please choose a key first.
                return
            }

            if (selectedDrawBind != "")
            {
                Hotkey, IfWinActive, arras.io
                Hotkey, %selectedDrawBind%, Off
                Hotkey, IfWinActive
            }

            selectedDrawBind := drawBind

            Hotkey, IfWinActive, arras.io
            Hotkey, %selectedDrawBind%, DrawingModeHotkey, On
            Hotkey, IfWinActive

            SaveSettings()

            MsgBox, Drawing Mode Key assigned: %selectedDrawBind%
        return


        SavePositionBind:
            Gui, Submit, NoHide

            if (positionBind = "")
            {
                MsgBox, Please choose a key first.
                return
            }

            if (selectedPositionBind != "")
            {
                Hotkey, IfWinActive, arras.io
                Hotkey, %selectedPositionBind%, Off
                Hotkey, IfWinActive
            }

            selectedPositionBind := positionBind

            Hotkey, IfWinActive, arras.io
            Hotkey, %selectedPositionBind%, SetPrintPosition, On
            Hotkey, IfWinActive

            SaveSettings()

            MsgBox, Print Position Key assigned: %selectedPositionBind%
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


        StartupStateChange:
        Gui, 3:Submit, NoHide
        SaveSettings()
        return


        PauseAfterPrintToggle:
        Gui, 3:Submit, NoHide
        SaveSettings()
        return


        CloseOptions:
        Gui, 3:Destroy
        Return

    ;/// Options GUI \\\


    ;\\\ Tooltip GUI ///
    
        CreatePrinterStatusGUI()
        {
            global statusGuiX, statusGuiY, PrinterStatusText

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
        }

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
        return

    ;/// Tooltip GUI \\\


    ;\\\ Changelog GUI ///

        ShowUpdates:
        Gui, 5:Destroy
        Gui, 5:Font, s11 Norm, Calibri
        Gui, 5:Add, Edit, x0 y0 w800 h540 ReadOnly Multi WantTab VScroll, 
        (

        Changelog, ??th of November, 2026 / v3.2.3
        --------------------------------------------------
        ⠀⠀- Added an option that pauses the script if any key is pressed while printing, this option is on by default
        ⠀⠀⠀(very useful for situations where you forgot to pause the script and it accidentally prints)
        ⠀⠀- Fixed a bug related to the script keys being active while outside of arras.io and interfering with user input
        ⠀⠀- Updated the main menu and options screen to better fit their intended purpose
        ⠀⠀- Reformatted the entire script to be very clean and readable
        ⠀⠀⠀(best thing to use for reading the code is Visual Studio Code and its AHK addon)



        Changelog, 14th of November, 2026 / v3.2.2
        --------------------------------------------------
        ⠀⠀- Added an option that lets you choose if you want the script to pause after every print, this option is on by default
        ⠀⠀- Added 5 new printable, special characters
        ⠀⠀- Fixed a bug where you couldnt set the printing position when the script is paused
        ⠀⠀- Changed the key for setting the printing position to support custom keys (defaults to F2)
        ⠀⠀- Changed the key for starting/stopping drawing mode to support custom keys (defaults to F4)
        ⠀⠀- Cleaned up the code a bit



        Changelog, 13th of November, 2026 / v3.2.1
        --------------------------------------------------
        ⠀⠀- Changed the options screen to fit better with the new options
        ⠀⠀- Added the option to choose on which mode the script starts on (paused/unpaused)
        ⠀⠀- Drawing mode is now fully integrated into the scripts pausing/canceling functions and not just its stand-alone thing
        ⠀⠀- Added 10 new printable, special characters
        ⠀⠀- Fixed some characters not printing correctly due to newer arras.io updates (there might be more characters with
        ⠀⠀⠀ this issue that i havent found yet, so id appreciate any help in finding ones where the orb spawning/jointing breaks)
        ⠀⠀- Fixed an issue related to the custom pause key not actually pausing/unpausing and canceling correctly
        ⠀⠀- Cleaned up the code a bit



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
        Gui, 5:Show, w800 h538, Changelog
        Return


        CloseUpdates:
        Gui, 5:Destroy
        Return

    ;/// Changelog GUI \\\

;///// Guis \\\\\



;\\\\\ Functions /////

    ;\\\ Settings ///

        LoadSettings()
        {
            global settingsFile, pauseBind, sandboxBind, selectedPauseBind, sandboxTimerEnabled, showPauseTooltip, showUnpausedTooltip, statusGuiX, statusGuiY, selectedFont, printStartX, printStartY, printPressCount, printSleepTime, startPaused, pauseAfterPrint, drawBind, selectedDrawBind, positionBind, selectedPositionBind, pauseOnUserInput

            if (!FileExist(settingsFile))
            {
                SaveSettings()
            }
            else
            {
                IniRead, pauseBind, %settingsFile%, Settings, PauseKey, %pauseBind%
                IniRead, sandboxBind, %settingsFile%, Settings, SandboxKey, %sandboxBind%
                IniRead, drawBind, %settingsFile%, Settings, DrawKey, F4
                IniRead, positionBind, %settingsFile%, Settings, PrintPositionKey, F2
                IniRead, sandboxTimerEnabled, %settingsFile%, Settings, SandboxTimer, 0
                sandboxTimerEnabled := (sandboxTimerEnabled = "1")
                IniRead, showPauseTooltip, %settingsFile%, Settings, PauseTooltip, 1
                showPauseTooltip := (showPauseTooltip = "1")
                IniRead, showUnpausedTooltip, %settingsFile%, Settings, UnpausedTooltip, 1
                showUnpausedTooltip := (showUnpausedTooltip = "1")
                IniRead, pauseOnUserInput, %settingsFile%, Settings, PauseOnUserInput, 0
                pauseOnUserInput := (pauseOnUserInput = "1")
                IniRead, statusGuiX, %settingsFile%, Settings, StatusGuiX, 47
                IniRead, statusGuiY, %settingsFile%, Settings, StatusGuiY, 768
                IniRead, selectedFont, %settingsFile%, Settings, Font, Default Font
                IniRead, printStartX, %settingsFile%, Settings, PrintStartX, 707
                IniRead, printStartY, %settingsFile%, Settings, PrintStartY, 484
                IniRead, printPressCount, %settingsFile%, Settings, PrintPressCount, 2
                IniRead, printSleepTime, %settingsFile%, Settings, PrintSleepTime, 50
                IniRead, startPaused, %settingsFile%, Settings, StartupState, Paused
                IniRead, pauseAfterPrint, %settingsFile%, Settings, PauseAfterPrint, 0
                pauseAfterPrint := (pauseAfterPrint = "1")
                if (startPaused != "Paused" && startPaused != "Unpaused")
                    startPaused := "Paused"
            }

            selectedPauseBind := pauseBind
            selectedDrawBind := drawBind
            selectedPositionBind := positionBind

            if (pauseBind != "")
            {
                Hotkey, IfWinActive, arras.io
                Hotkey, % "$*" . pauseBind, PrinterPauseHotkey, On P10
                Hotkey, IfWinActive
            }

            if (drawBind != "")
            {
                Hotkey, IfWinActive, arras.io
                Hotkey, %drawBind%, DrawingModeHotkey, On
                Hotkey, IfWinActive
            }

            if (positionBind != "")
            {
                Hotkey, IfWinActive, arras.io
                Hotkey, %positionBind%, SetPrintPosition, On
                Hotkey, IfWinActive
            }
        }


        SaveSettings()
        {
            global settingsFile, pauseBind, sandboxBind, sandboxTimerEnabled, showPauseTooltip, showUnpausedTooltip, statusGuiX, statusGuiY, selectedFont, printStartX, printStartY, printPressCount, printSleepTime, startPaused, pauseAfterPrint, drawBind, positionBind, pauseOnUserInput

            IniWrite, %pauseBind%, %settingsFile%, Settings, PauseKey
            IniWrite, %sandboxBind%, %settingsFile%, Settings, SandboxKey
            IniWrite, %drawBind%, %settingsFile%, Settings, DrawKey
            IniWrite, %positionBind%, %settingsFile%, Settings, PrintPositionKey
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
            IniWrite, %startPaused%, %settingsFile%, Settings, StartupState
            IniWrite, % pauseAfterPrint ? 1 : 0, %settingsFile%, Settings, PauseAfterPrint
            IniWrite, %pauseOnUserInput%, %settingsFile%, Settings, PauseOnUserInput
        }

    ;/// Settings \\\


    ;\\\ Printer & Management ///

        CheckSandboxKey:
            keyIsHeld := GetKeyState(sandboxBind, "P")

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
            global isPrintingCancelled, isPrinting, sendEnterAfterCancel, sandboxBind, sandboxPausedScript, pauseBind, drawMode, userInputMonitoring

            if (source = "RShift" || source = "PauseKey")
            {
                Suspend

                if (A_IsSuspended)
                {
                    StopDrawingMode()
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
                    StopDrawingMode()
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
                    StopDrawingMode()
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
                StopDrawingMode()
                Send, {%sandboxBind% up}{j up}

                if (sendEnterAfterCancel)
                {
                    sendEnterAfterCancel := false
                    Send, {Enter}
                }

                userInputMonitoring := false
                SetTimer, CheckUserInput, Off

                isPrinting := false

                return
            }

            if (source = "ArrasFocus")
            {
                if ((isPrinting || drawMode) && !WinActive("arras.io") && !A_IsSuspended)
                {
                    Suspend, On
                    StopDrawingMode()
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

            if (source = "PrintFinished")
            {
                if (!A_IsSuspended)
                {
                    Suspend, On
                    UpdatePrinterStatus("Paused")
                }

                return
            }

            if (source = "UserInput")
            {
                Suspend, On
                StopDrawingMode()
                isPrintingCancelled := true
                UpdatePrinterStatus("Paused")
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

        PrintCharacter(points, character := "")
        {
            global sandboxBind, isPrintingCancelled, isPrinting, printStartX, printStartY, printPressCount, printSleepTime, pauseAfterPrint, pauseOnUserInput, userInputDetected, userInputMonitoring

            currentPrintSpeed := printSleepTime

            slowCharacters := ["%", "Q"]

            if (printSleepTime = 50)
            {
                for index, slowCharacter in slowCharacters
                {
                    if (character = slowCharacter)
                    {
                        currentPrintSpeed := 100
                        break
                    }
                }
            }

            isPrinting := true
            Sleep, 200

            userInputDetected := false

            if (pauseOnUserInput)
            {
                userInputMonitoring := true
                SetTimer, CheckUserInput, 10
            }

            CoordMode, Mouse, Screen

            Send, {%sandboxBind% down}

            currentX := printStartX
            currentY := printStartY

            for index, point in points
            {
                if (userInputDetected)
                {
                    PrinterStateManager("UserInput")
                    PrinterStateManager("PrintCancelled")
                    return
                }

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

                Sleep, %currentPrintSpeed%

                Loop, %printPressCount%
                    Send, ch
            }

            currentX := printStartX
            currentY := printStartY

            for index, point in points
            {
                if (userInputDetected)
                {
                    PrinterStateManager("UserInput")
                    PrinterStateManager("PrintCancelled")
                    return
                }

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

                Sleep, %currentPrintSpeed%

                if (index = 1)
                    Send, {j down}
                else if (index = points.MaxIndex())
                    Send, {j up}{%sandboxBind% up}
                else
                    Send, {j up}{j down}
            }

            Send, {%sandboxBind% up}{j up}

            if (pauseAfterPrint)
                PrinterStateManager("PrintFinished")

            userInputMonitoring := false
            SetTimer, CheckUserInput, Off

            isPrinting := false
        }

        #IfWinActive


        CheckUserInput:
            if (!pauseOnUserInput || !userInputMonitoring || !isPrinting || userInputDetected)
                return

            if (!WinActive("arras.io"))
                return

            Loop, 254
            {
                keyName := Format("vk{:02X}", A_Index)

                if (GetKeyState(keyName, "P"))
                {
                    userInputDetected := true
                    return
                }
            }

            if (GetKeyState("LButton", "P")
                || GetKeyState("RButton", "P")
                || GetKeyState("MButton", "P")
                || GetKeyState("XButton1", "P")
                || GetKeyState("XButton2", "P"))
            {
                userInputDetected := true
            }
        return

    ;/// Printer & Management \\\


    ;\\\ Drawing Mode ///

        StopDrawingMode()
        {
            global drawMode
            drawMode := false
            SetTimer, DrawingTool, Off
        }

        DrawingTool:
            if (!drawMode)
                return

            MouseGetPos, currX, currY

            if (currX != prevX || currY != prevY) {
                send, {%sandboxBind% down}{c}{h}{%sandboxBind% up}
            }

            prevX := currX
            prevY := currY
        return

        #IfWinActive arras.io

        DrawingModeHotkey:
            drawMode := !drawMode
            if (drawMode) {
                MouseGetPos, prevX, prevY
                SetTimer, DrawingTool, 100
            } else {
                SetTimer, DrawingTool, Off
            }
        return

    ;/// Drawing Mode \\\


    ;\\\ Hotkeys ///

        SetPrintPosition:
            Suspend, Permit
            MouseGetPos, printStartX, printStartY
            SaveSettings()
            ToolTip, % "Printing position saved: " printStartX ", " printStartY
            SetTimer, RemovePrintPositionTooltip, -1500
        return

        RemovePrintPositionTooltip:
        ToolTip
        return

        PrinterPauseHotkey:
        Suspend, Permit
        PrinterStateManager("PauseKey")
        return


        CheckArrasFocus:
        PrinterStateManager("ArrasFocus")
        return


        $*RShift::
        Suspend, Permit
        PrinterStateManager("RShift")
        return


        $*Enter::
        Suspend, Permit
        PrinterStateManager("Enter")
        return

    ;/// Hotkeys \\\

;///// Functions \\\\\



;\\\\\ Prints /////

    ;\\\ Prints A-Z ///

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
            PrintCharacter(points, "Q")
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

    ;/// Prints A-Z \\\


    ;\\\ Prints 0-9 ///

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

    ;/// Prints 0-9 \\\


    ;\\\ Special Characters ///

        $*? up::
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
            points := []
            points.Push([0, 0])
            points.Push([0, 40])
            points.Push([0, 40])
            points.Push([0, 80])
            PrintCharacter(points)
        return

        $*. up::
            Send,{shift down}{c}{h}{shift up}
        return

        $*, up::
            points := []
            points.Push([0, 0])
            points.Push([-3, 22])
            points.Push([-9, 18])
            PrintCharacter(points)
        return

        $*= up::
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])

            points.Push([-80, 60])
            points.Push([40, 0])
            points.Push([40, 0])
            PrintCharacter(points)
        return

        $*" up::
            points := []
            points.Push([0, 0])
            points.Push([0, 20])
            points.Push([50, -20])
            points.Push([0, 20])
            PrintCharacter(points)
        return

        $*' up::
            points := []
            points.Push([0, 0])
            points.Push([0, 20])
            PrintCharacter(points)
        return

        $*+ up::
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([-40, -40])
            points.Push([0, 80])
            PrintCharacter(points)
        return

        $*~ up::
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

        $*# up::
            points := []
            points.Push([0, 0])
            points.Push([-7, 40])
            points.Push([-7, 40])
            points.Push([-7, 40])
            points.Push([-7, 40])

            points.Push([80, 0])
            points.Push([7, -40])
            points.Push([7, -40])
            points.Push([7, -40])
            points.Push([7, -40])

            points.Push([23, 40])
            points.Push([-70, 0])
            points.Push([-70, 0])

            points.Push([-14, 80])
            points.Push([70, 0])
            points.Push([70, 0])
            PrintCharacter(points, "#")
        return

        $*- up::
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            PrintCharacter(points)
        return

        $*/ up::
            points := []
            points.Push([0, 175])
            points.Push([15, -37])
            points.Push([15, -37])
            points.Push([15, -37])
            points.Push([15, -37])
            points.Push([15, -37])
            PrintCharacter(points)
        return

        $*( up::
            points := []
            points.Push([0, 0])
            points.Push([-12, 28])
            points.Push([-4, 35])
            points.Push([4, 35])
            points.Push([12, 28])
            PrintCharacter(points)
        return

        $*) up::
            points := []
            points.Push([0, 0])
            points.Push([12, 28])
            points.Push([4, 35])
            points.Push([-4, 35])
            points.Push([-12, 28])
            PrintCharacter(points)
        return

        $*{ up::
            points := []
            points.Push([0, 0])
            points.Push([-15, 10])
            points.Push([-3, 30])
            points.Push([-18, 30])
            points.Push([18, 30])
            points.Push([3, 30])
            points.Push([15, 10])
            PrintCharacter(points)
        return

        $*} up::
            points := []
            points.Push([0, 0])
            points.Push([15, 10])
            points.Push([3, 30])
            points.Push([18, 30])
            points.Push([-18, 30])
            points.Push([-3, 30])
            points.Push([-15, 10])
            PrintCharacter(points)
        return

        $*[ up::
            points := []
            points.Push([0, 0])
            points.Push([-23, 0])
            points.Push([0, 33])
            points.Push([0, 33])
            points.Push([0, 33])
            points.Push([0, 33])
            points.Push([23, 0])
            PrintCharacter(points)
        return

        $*] up::
            points := []
            points.Push([0, 0])
            points.Push([23, 0])
            points.Push([0, 33])
            points.Push([0, 33])
            points.Push([0, 33])
            points.Push([0, 33])
            points.Push([-23, 0])
            PrintCharacter(points)
        return

        $*% up::
            points := []
            points.Push([0, 0])
            points.Push([0, 20])
            points.Push([23, 13])
            points.Push([23, -13])
            points.Push([0, -20])
            points.Push([-23, -13])

            points.Push([100, 110])
            points.Push([0, 20])
            points.Push([23, 13])
            points.Push([23, -13])
            points.Push([0, -20])
            points.Push([-23, -13])

            points.Push([-96, 55])
            points.Push([17, -40])
            points.Push([17, -40])
            points.Push([17, -40])
            points.Push([17, -40])
            PrintCharacter(points, "%")
        return

        $*; up::
            points := []
            points.Push([0, 0])
            points.Push([0, 80])
            points.Push([-3, 22])
            points.Push([-9, 18])
            PrintCharacter(points)
        return

        $*: up::
            points := []
            points.Push([0, 0])
            points.Push([0, 80])
            PrintCharacter(points)
        return

        $*< up::
            points := []
            points.Push([0, 0])
            points.Push([-35, 22])
            points.Push([-35, 22])
            points.Push([35, 22])
            points.Push([35, 22])
            PrintCharacter(points)
        return

        $*> up::
            points := []
            points.Push([0, 0])
            points.Push([35, 22])
            points.Push([35, 22])
            points.Push([-35, 22])
            points.Push([-35, 22])
            PrintCharacter(points)
        return

        $*_ up::
            points := []
            points.Push([0, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            points.Push([40, 0])
            PrintCharacter(points)
        return

        #IfWinActive

    ;/// Special Characters \\\

;///// Prints \\\\\



;\\\\\ Control Keys /////

    ^!e::
    Suspend, Permit
    ExitApp
    return

    ^!r::
    Suspend, Permit
    Reload
    return

;///// Control Keys \\\\\