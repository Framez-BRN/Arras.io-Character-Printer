
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


    ;\\\ Booleans ///
    
        keyInput := false

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


        settingsFile := A_ScriptDir "\settings(ACP).ini"

        SpecialChars := Chr(8226) . " Special characters:  ?  !  .  ,  =  ~  +  " Chr(34) "  '  #  -  /  ()  {}  []  " Chr(37) "  " Chr(59) "  :  <  >  _  \  $"

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

        CreateMainMenuGUI()

        SetTimer, CheckArrasFocus, 100

        if (sandboxTimerEnabled)
            SetTimer, CheckSandboxKey, 50

        keyInput := (startPaused = "Unpaused")

    ;/// Extras \\\

;///// Auto-Execution / Startup \\\\\



;\\\\\ Control Keys /////

    $<^<!s::
        Suspend, Permit
        Suspend
    return

    $<^<!e::
        Suspend, Permit
        ExitApp
    return

    $<^<!r::
        Suspend, Permit
        Reload
    return

;///// Control Keys \\\\\



;\\\\\ Guis /////

    ;\\\ Main Menu GUI ///

        CreateMainMenuGUI()
        {
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
        }
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
            Gui, 3:Add, CheckBox, vPauseOnUserInput gPauseOnUserInputToggle Checked%pauseOnUserInput% x15 y+5, Pause if key pressed while printing


            Gui, 3:Add, Text, x15 y+20, Orb count per Print (recommended, 2):
            Gui, 3:Add, Slider, vprintPressCount gPrintPressCountChange x15 y+8 w250 Range1-3 TickInterval1 ToolTip, %printPressCount%
            Gui, 3:Add, Text, vPrintPressCountLabel x275 yp w100, %printPressCount%

            Gui, 3:Add, Text, x15 y+10, Time interval per orb in milliseconds, aka: the speed of printing something (recommended, 50):
            Gui, 3:Add, Slider, vprintSleepTime gPrintSleepTimeChange x15 y+8 w250 Range50-200 TickInterval50 Line50 Page50 ToolTip, %printSleepTime%
            Gui, 3:Add, Text, vPrintSleepTimeLabel x275 yp w100, %printSleepTime%


            pauseBindDisplay := FormatBindDisplay(pauseBind)
            sandboxBindDisplay := FormatBindDisplay(sandboxBind)
            drawBindDisplay := FormatBindDisplay(drawBind)
            positionBindDisplay := FormatBindDisplay(positionBind)

            Gui, 3:Add, Text, x15 y+20, Pause Key:
            Gui, 3:Add, Edit, ReadOnly vpauseBindDisplay x20 y+3 w130, %pauseBindDisplay%
            Gui, 3:Add, Button, x160 yp w135 h25 gRecordPauseBind, Record Pause Key

            Gui, 3:Add, Text, x15 y+10, Sandbox Key:
            Gui, 3:Add, Edit, ReadOnly vsandboxBindDisplay x20 y+3 w130, %sandboxBindDisplay%
            Gui, 3:Add, Button, x160 yp w135 h25 gRecordSandboxBind, Record Sandbox Key

            Gui, 3:Add, Text, x15 y+10, Drawing Mode Key:
            Gui, 3:Add, Edit, ReadOnly vdrawBindDisplay x20 y+3 w130, %drawBindDisplay%
            Gui, 3:Add, Button, x160 yp w135 h25 gRecordDrawBind, Record Drawing Key

            Gui, 3:Add, Text, x15 y+10, Print Position Key:
            Gui, 3:Add, Edit, ReadOnly vpositionBindDisplay x20 y+3 w130, %positionBindDisplay%
            Gui, 3:Add, Button, x160 yp w135 h25 gRecordPositionBind, Record Position Key


            Gui, 3:Add, Text, x15 y+20, Character Font:
            Gui, 3:Add, DropDownList, vselectedFont gFontSelect x20 y+3 w180, Default Font|Legacy Font
            GuiControl, 3:ChooseString, selectedFont, %selectedFont%

            Gui, 3:Add, Text, x684 y10, Startup State
            Gui, 3:Add, DropDownList, vstartPaused gStartupStateSelect x680 y33 w90, Paused|Unpaused
            GuiControl, 3:ChooseString, startPaused, %startPaused%

            Gui, 3:Show, w790 h580, Options
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
            Gui, 3:Submit, NoHide
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


        RecordPauseBind:
            StartBindRecording("pauseBind")
        return

        RecordSandboxBind:
            StartBindRecording("sandboxBind")
        return

        RecordDrawBind:
            StartBindRecording("drawBind")
        return

        RecordPositionBind:
            StartBindRecording("positionBind")
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

        PauseAfterPrintToggle:
            Gui, 3:Submit, NoHide
            SaveSettings()
        return


        FontSelect:
            Gui, 3:Submit, NoHide
            SaveSettings()
        return

        StartupStateSelect:
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

            Gui, 5:Color, F2F2F2

            Gui, 5:Add, ListBox, x10 y5 w260 h530 vSelectedUpdate gUpdateSelected AltSubmit,
            (LTrim
            v3.2.5 - 25th November 2026 |
            v3.2.4 - 20th November 2026 |
            v3.2.3 - 17th November 2026 |
            v3.2.2 - 14th November 2026 |
            v3.2.1 - 13th November 2026 |
            v3.2.1 - 19th October 2026 |
            v3.2.1 - 15th October 2026 |
            v3.2.1 - 14th October 2026 |
            )

            Gui, 5:Font, s11 Norm, Calibri
            Gui, 5:Add, Edit, x+5 y5 w640 h526 ReadOnly Multi WantTab VScroll vUpdateContent
            GuiControl, 5:+Background000000, UpdateContent

            Gui, 5:Show, w925 h540, Changelog

            GuiControl, 5:Choose, SelectedUpdate, 1
            Gosub, UpdateSelected
        Return


        UpdateSelected:
            Gui, 5:Submit, NoHide
            SelectedUpdate := 9 - SelectedUpdate

            if (SelectedUpdate = 8)
            {
                UpdateText =
                (LTrim
                Changelog, 25th of November, 2026 - v3.2.5
                --------------------------------------------------

                - Reworked how the key selection happens, so its easier to choose what key you want to use, key combos up to 2 are now possible. (it was NOT easy to create though, that much ill say...)

                - Fixed a bug related to the "Pause if key pressed while printing" option that would permanently softlock the script into a brocken state, and could only be fixed by reloading it.

                - All characters that are producable via the keyboard are now fully supported by the script.

                - Reformatted a few parts of the script and updated some calls/handlers.
                )
            }
            else if (SelectedUpdate = 7)
            {
                UpdateText =
                (LTrim
                Changelog, 20th of November, 2026 - v3.2.4
                --------------------------------------------------

                - All previous versions of the script are now available over on github (go to discord for the link)

                - Reworked the pausing/unpausing of the script to not be dependant on suspend anymore

                - Added 2 new printable, special characters

                - Updated the changelog screen for easier navigation
                )
            }
            else if (SelectedUpdate = 6)
            {
                UpdateText =
                (LTrim
                Changelog, 17th of November, 2026 - v3.2.3
                --------------------------------------------------

                - Added an option that pauses the script if any key is pressed while printing, this option is on by default (Very useful for situations where you forgot to pause the script and it accidentally prints)

                - Fixed a bug related to the script keys being active while outside of arras.io and interfering with user input

                - Updated the main menu and options screen to better fit their intended purpose

                - Reformatted the entire script to be very clean and readable (The best thing to use for reading the code is Visual Studio Code and its AHK addon)
                )
            }
            else if (SelectedUpdate = 5)
            {
                UpdateText =
                (LTrim
                Changelog, 14th of November, 2026 - v3.2.2
                --------------------------------------------------

                - Added an option that lets you choose if you want the script to pause after every print, this option is on by default

                - Added 5 new printable, special characters

                - Fixed a bug where you couldn't set the printing position when the script is paused

                - Changed the key for setting the printing position to support custom keys (defaults to F2)

                - Changed the key for starting/stopping drawing mode to support custom keys (defaults to F4)

                - Cleaned up the code a bit
                )
            }
            else if (SelectedUpdate = 4)
            {
                UpdateText =
                (LTrim
                Changelog, 13th of November, 2026 - v3.2.1
                --------------------------------------------------

                - Changed the options screen to fit better with the new options

                - Added the option to choose on which mode the script starts on (paused/unpaused)

                - Drawing mode is now fully integrated into the scripts pausing/canceling functions and not just its stand-alone thing

                - Added 10 new printable, special characters

                - Fixed some characters not printing correctly due to newer arras.io updates

                - Fixed an issue related to the custom pause key not actually pausing/unpausing and canceling correctly

                - Cleaned up the code a bit
                )
            }
            else if (SelectedUpdate = 3)
            {
                UpdateText =
                (LTrim
                Changelog, 19th of October, 2026 - v3.2.0
                --------------------------------------------------

                - Added a setting to the options to adjust the printing speed

                - Overhauled most of the printing sequences to be more efficient, accurate and easier to use

                - Changed the start-up state so that the script now starts in paused mode

                - Added full legacy font support to all letters, A-Z and numbers, 0-9

                - Added 6 new printable, special characters

                - Organized the code a bit more
                )
            }
            else if (SelectedUpdate = 2)
            {
                UpdateText =
                (LTrim
                Changelog, 15th of October, 2026 - v3.1.1
                --------------------------------------------------

                - Fixed some minor spelling mistakes

                - Cleaned up the code a bit

                - Added a quick guide to the help menu on how to print
                )
            }
            else if (SelectedUpdate = 1)
            {
                UpdateText =
                (LTrim
                Changelog, 14th of October, 2026 - v3.1.0
                --------------------------------------------------

                - Changed the main menu screen layout

                - Changed the info text in the help menu to fit the current build

                - Added a changelog

                - Added 6 new printable, special characters

                - Added options and their corresponding File

                - Changed the way the tooltip is displayed for better control via the options

                - The tooltip can now be moved by simply left-click-dragging it

                - Added another tooltip mode for when the script is unpaused

                - The tooltip modes can now be individually toggled

                - Added the option to make the chosen sandbox key pause the script while holding it down

                - Added the option to adjust the amount of orbs used in a print

                - Added the option to set a custom printing position using F2

                - Added a sneak peek for an upcoming feature in v3.2.0
                )
            }

            GuiControl, 5:, UpdateContent, %UpdateText%
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


    ;\\\ Printing & Management ///

        SetKeyInput(state)
        {
            global keyInput

            if (state = "toggle")
                keyInput := !keyInput
            else
                keyInput := state ? true : false
        }


        CheckSandboxKey:
            keyIsHeld := IsBindHeld(sandboxBind)

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
            global keyInput, isPrintingCancelled, isPrinting, sendEnterAfterCancel, sandboxBind, sandboxPausedScript, pauseBind, drawMode, userInputMonitoring

            if (source = "RShift" || source = "PauseKey")
            {

                keyInput := !keyInput

                if (!keyInput)
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
                if (keyInput)
                {
                    sandboxPausedScript := true
                    SetKeyInput(false)
                    StopDrawingMode()
                    isPrintingCancelled := true
                    UpdatePrinterStatus("Paused")
                }

                return
            }

            if (source = "SandboxUp")
            {
                if (sandboxPausedScript && !keyInput)
                {
                    sandboxPausedScript := false
                    SetKeyInput(true)
                    isPrintingCancelled := false
                    UpdatePrinterStatus("Unpaused")
                }

                return
            }

            if (source = "Enter")
            {
                if (keyInput)
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

                    SetKeyInput(false)
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

                userInputDetected := false

                isPrinting := false

                return
            }

            if (source = "ArrasFocus")
            {
                if ((isPrinting || drawMode) && !WinActive("arras.io") && keyInput)
                {
                    SetKeyInput(false)
                    StopDrawingMode()
                    isPrintingCancelled := true
                    UpdatePrinterStatus("Paused")
                    return
                }

                if (keyInput)
                    UpdatePrinterStatus("Unpaused")
                else
                    UpdatePrinterStatus("Paused")

                return
            }

            if (source = "PrintFinished")
            {
                if (keyInput)
                {
                    SetKeyInput(false)
                    UpdatePrinterStatus("Paused")
                }

                return
            }

            if (source = "UserInput")
            {
                SetKeyInput(false)
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


        #If (keyInput && WinActive("arras.io"))

        PrintCharacter(points, character := "")
        {
            global keyInput, sandboxBind, isPrintingCancelled, isPrinting, printStartX, printStartY, printPressCount, printSleepTime, pauseAfterPrint, pauseOnUserInput, userInputDetected, userInputMonitoring

            currentPrintSpeed := printSleepTime

            slowCharacters := ["%", "Q", "§", "&", "@"]

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

            userInputDetected := false
            userInputMonitoring := false

            SetTimer, CheckUserInput, Off

            isPrinting := true
            Sleep, 200

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

        #If


        CheckUserInput:
            if (!pauseOnUserInput || !userInputMonitoring || !isPrinting || userInputDetected)
                return

            if (!WinActive("arras.io"))
                return

            Loop, 255
            {
                vk := A_Index

                if (vk >= 0x30 && vk <= 0x39)
                    keyName := Format("vk{:02X}", vk)

                else if (vk >= 0x41 && vk <= 0x5A)
                    keyName := Format("vk{:02X}", vk)

                else if (vk >= 0x60 && vk <= 0x69)
                    keyName := Format("vk{:02X}", vk)

                else if (vk >= 0x70 && vk <= 0x87)
                    keyName := Format("vk{:02X}", vk)

                else if (vk = 0x08 || vk = 0x09 || vk = 0x0D
                    || vk = 0x10 || vk = 0x11 || vk = 0x12
                    || vk = 0x13 || vk = 0x14 || vk = 0x1B
                    || vk = 0x20 || vk = 0x21 || vk = 0x22
                    || vk = 0x23 || vk = 0x24 || vk = 0x25
                    || vk = 0x26 || vk = 0x27 || vk = 0x28
                    || vk = 0x2C || vk = 0x2D || vk = 0x2E
                    || vk = 0x5B || vk = 0x5C || vk = 0x5D
                    || vk = 0xA0 || vk = 0xA1 || vk = 0xA2
                    || vk = 0xA3 || vk = 0xA4 || vk = 0xA5)
                    keyName := Format("vk{:02X}", vk)

                else
                    continue

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

    ;/// Printing & Management \\\


    ;\\\ GUI Related ///

        StartBindRecording(target)
        {
            global recordingTarget, recordingCapturedKeys, recordingCapturedSet
            global recordingPreviousDown, recordingKeyNames, keys

            recordingTarget := target
            recordingCapturedKeys := []
            recordingCapturedSet := {}
            recordingPreviousDown := {}

            recordingKeyNames := StrSplit(keys, "|")
            recordingKeyNames.Push("LButton")
            recordingKeyNames.Push("RButton")
            recordingKeyNames.Push("MButton")

            controlName := target . "Display"
            GuiControl, 3:, %controlName%, Press a key...

            SetTimer, CaptureBind, 10
        }

        CaptureBind:
            currentDown := []
            newDown := {}

            for index, keyName in recordingKeyNames
            {
                if (keyName = "Alt" || keyName = "Ctrl")
                    continue

                if GetKeyState(keyName, "P")
                {
                    currentDown.Push(keyName)
                    newDown[keyName] := true

                    if (!recordingPreviousDown.HasKey(keyName))
                    {
                        normalizedKey := NormalizeRecordedKey(keyName)

                        if (!recordingCapturedSet.HasKey(normalizedKey))
                        {
                            recordingCapturedKeys.Push(normalizedKey)
                            recordingCapturedSet[normalizedKey] := true
                        }
                    }
                }
            }

            recordingPreviousDown := newDown

            if (recordingCapturedKeys.Length() > 2)
            {
                CancelBindRecording()
                MsgBox, 48, Key Recorder, Only one modifier and one regular key can be assigned together., 6
                return
            }

            if (currentDown.Length() = 0 && recordingCapturedKeys.Length() > 0)
            {
                FinishBindRecording()
            }
        return

        FinishBindRecording()
        {
            global recordingTarget, recordingCapturedKeys

            SetTimer, CaptureBind, Off

            if (recordingCapturedKeys.Length() = 1)
            {
                recordedBind := recordingCapturedKeys[1]
            }
            else if (recordingCapturedKeys.Length() = 2)
            {
                firstKey := recordingCapturedKeys[1]
                secondKey := recordingCapturedKeys[2]

                if IsModifierKey(firstKey)
                {
                    modifier := firstKey
                    regularKey := secondKey
                }
                else if IsModifierKey(secondKey)
                {
                    modifier := secondKey
                    regularKey := firstKey
                }
                else
                {
                    CancelBindRecording()
                    MsgBox, 48, Key Recorder, A two-key combination must contain one modifier key and one regular key., 6
                    return
                }

                prefix := GetModifierPrefix(modifier)

                if (prefix = "")
                {
                    CancelBindRecording()
                    return
                }

                recordedBind := prefix . regularKey
            }
            else
            {
                CancelBindRecording()
                return
            }

            target := recordingTarget
            recordingTarget := ""

            ApplyRecordedBind(target, recordedBind)
        }

        CancelBindRecording()
        {
            global recordingTarget, pauseBind, sandboxBind, drawBind, positionBind

            SetTimer, CaptureBind, Off

            target := recordingTarget
            recordingTarget := ""

            if (target = "")
                return

            if (target = "pauseBind")
                oldBind := pauseBind
            else if (target = "sandboxBind")
                oldBind := sandboxBind
            else if (target = "drawBind")
                oldBind := drawBind
            else if (target = "positionBind")
                oldBind := positionBind

            controlName := target . "Display"
            displayText := FormatBindDisplay(oldBind)

            GuiControl, 3:, %controlName%, %displayText%
        }

        ApplyRecordedBind(target, recordedBind)
        {
            global pauseBind, sandboxBind, drawBind, positionBind
            global selectedPauseBind, selectedDrawBind, selectedPositionBind

            if (target = "pauseBind")
            {
                if (selectedPauseBind != "")
                {
                    Hotkey, IfWinActive, arras.io
                    Hotkey, % "$*" . selectedPauseBind, Off
                    Hotkey, IfWinActive
                }

                pauseBind := recordedBind
                selectedPauseBind := recordedBind

                Hotkey, IfWinActive, arras.io
                Hotkey, % "$*" . selectedPauseBind, PrinterPauseHotkey, On P10
                Hotkey, IfWinActive
            }
            else if (target = "sandboxBind")
            {
                sandboxBind := recordedBind
            }
            else if (target = "drawBind")
            {
                if (selectedDrawBind != "")
                {
                    Hotkey, IfWinActive, arras.io
                    Hotkey, %selectedDrawBind%, Off
                    Hotkey, IfWinActive
                }

                drawBind := recordedBind
                selectedDrawBind := recordedBind

                Hotkey, IfWinActive, arras.io
                Hotkey, %selectedDrawBind%, DrawingModeHotkey, On
                Hotkey, IfWinActive
            }
            else if (target = "positionBind")
            {
                if (selectedPositionBind != "")
                {
                    Hotkey, IfWinActive, arras.io
                    Hotkey, %selectedPositionBind%, Off
                    Hotkey, IfWinActive
                }

                positionBind := recordedBind
                selectedPositionBind := recordedBind

                Hotkey, IfWinActive, arras.io
                Hotkey, %selectedPositionBind%, SetPrintPosition, On
                Hotkey, IfWinActive
            }

            controlName := target . "Display"
            displayText := FormatBindDisplay(recordedBind)

            GuiControl, 3:, %controlName%, %displayText%

            SaveSettings()

            MsgBox, 64, Key Recorder, % "Key assigned: " displayText, 1.5
        }

        NormalizeRecordedKey(keyName)
        {
            StringLower, lowerKey, keyName

            if (lowerKey = "lshift")
                return "LShift"
            if (lowerKey = "rshift")
                return "RShift"
            if (lowerKey = "lctrl")
                return "LCtrl"
            if (lowerKey = "rctrl")
                return "RCtrl"
            if (lowerKey = "lalt")
                return "LAlt"
            if (lowerKey = "ralt")
                return "RAlt"
            if (lowerKey = "lwin")
                return "LWin"
            if (lowerKey = "rwin")
                return "RWin"

            return keyName
        }

        IsModifierKey(keyName)
        {
            return RegExMatch(keyName, "i)^(LShift|RShift|LCtrl|RCtrl|LAlt|RAlt|LWin|RWin)$")
        }

        GetModifierPrefix(modifier)
        {
            if RegExMatch(modifier, "i)^L?Ctrl$|^RCtrl$")
                return "^"

            if RegExMatch(modifier, "i)^L?Alt$|^RAlt$")
                return "!"

            if RegExMatch(modifier, "i)^L?Shift$|^RShift$")
                return "+"

            if RegExMatch(modifier, "i)^L?Win$|^RWin$")
                return "#"

            return ""
        }

        FormatBindDisplay(bind)
        {
            if RegExMatch(bind, "^([!^+#])(.+)$", match)
            {
                if (match1 = "^")
                    modifierName := "Ctrl"
                else if (match1 = "!")
                    modifierName := "Alt"
                else if (match1 = "+")
                    modifierName := "Shift"
                else if (match1 = "#")
                    modifierName := "Win"

                return modifierName . " + " . match2
            }

            if (bind = "LShift")
                return "Left Shift"
            if (bind = "RShift")
                return "Right Shift"
            if (bind = "LCtrl")
                return "Left Ctrl"
            if (bind = "RCtrl")
                return "Right Ctrl"
            if (bind = "LAlt")
                return "Left Alt"
            if (bind = "RAlt")
                return "Right Alt"
            if (bind = "LWin")
                return "Left Win"
            if (bind = "RWin")
                return "Right Win"

            return bind
        }

        IsBindHeld(bind)
        {
            if RegExMatch(bind, "^([!^+#])(.+)$", match)
            {
                baseKeyHeld := GetKeyState(match2, "P")

                if (!baseKeyHeld)
                    return false

                if (match1 = "^")
                    return GetKeyState("LCtrl", "P") || GetKeyState("RCtrl", "P")

                if (match1 = "!")
                    return GetKeyState("LAlt", "P") || GetKeyState("RAlt", "P")

                if (match1 = "+")
                    return GetKeyState("LShift", "P") || GetKeyState("RShift", "P")

                if (match1 = "#")
                    return GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
            }

            return GetKeyState(bind, "P")
        }

    ;/// GUI Related \\\


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
            if (!keyInput)
                return
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
            MouseGetPos, printStartX, printStartY
            SaveSettings()
            ToolTip, % "Printing position saved: " printStartX ", " printStartY
            SetTimer, RemovePrintPositionTooltip, -1500
        return

        RemovePrintPositionTooltip:
        ToolTip
        return

        PrinterPauseHotkey:
        PrinterStateManager("PauseKey")
        return


        CheckArrasFocus:
        PrinterStateManager("ArrasFocus")
        return


        $*RShift::
        PrinterStateManager("RShift")
        return


        $*Enter::
        PrinterStateManager("Enter")
        return

        #IfWinActive

    ;/// Hotkeys \\\

;///// Functions \\\\\



;\\\\\ Prints /////

    #If (keyInput && WinActive("arras.io"))

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
            if (selectedFont = "Default Font")
            {
                points := []
                points.Push([0, 0])
                points.Push([35, -20])
                points.Push([35, 20])
                points.Push([0, 40])
                points.Push([-35, 20])
                points.Push([0, 80])
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
                points.Push([0, 80])
            }
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
            if (!keyInput)
                return

            Send,{shift down}{c}{shift up}
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

        $*\ up::
            points := []
            points.Push([0, 175])
            points.Push([-15, -37])
            points.Push([-15, -37])
            points.Push([-15, -37])
            points.Push([-15, -37])
            points.Push([-15, -37])
            PrintCharacter(points)
        return

        $*$ up::
            points := []
            points.Push([0, 0])
            points.Push([-35, -25])
            points.Push([0, 20])
            points.Push([-30, 10])
            points.Push([-10, 30])
            points.Push([10, 30])
            points.Push([30, 10])
            points.Push([30, 10])
            points.Push([10, 30])
            points.Push([-10, 30])
            points.Push([-30, 10])
            points.Push([-35, -5])
            points.Push([35, 25])
            PrintCharacter(points)
        return

        $*§ up::
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

            points.Push([-65, -55])
            points.Push([-10, 30])
            points.Push([10, 30])
            points.Push([30, 10])
            points.Push([30, 10])
            points.Push([10, 30])
            points.Push([-10, 30])
            points.Push([-30, 10])
            points.Push([-35, -5])
            PrintCharacter(points, "§")
        return

        $*| up::
            points := []
            points.Push([0, 0])
            points.Push([0, 37])
            points.Push([0, 37])
            points.Push([0, 37])
            points.Push([0, 37])
            points.Push([0, 37])
            PrintCharacter(points)
        return

        $*^ up::
            points := []
            points.Push([0, 70])
            points.Push([22, -35])
            points.Push([22, -35])
            points.Push([22, 35])
            points.Push([22, 35])
            PrintCharacter(points)
        return

        $*° up::
            points := []
            points.Push([0, 0])
            points.Push([0, -20])
            points.Push([-23, -13])
            points.Push([-23, 13])
            points.Push([0, 20])
            points.Push([23, 13])
            PrintCharacter(points)
        return

        $*& up::
            points := []
            points.Push([0, 0])
            points.Push([-23, -27])
            points.Push([-23, -27])
            points.Push([-23, -27])
            points.Push([-23, -27])
            points.Push([-23, -18])
            points.Push([-13, -26])
            points.Push([13, -26])
            points.Push([25, -8])
            points.Push([25, 8])
            points.Push([13, 26])
            points.Push([-13, 26])

            points.Push([-48, 48])
            points.Push([-20, 23])
            points.Push([-8, 31])
            points.Push([17, 23])
            points.Push([32, 5])
            points.Push([30, -15])
            points.Push([45, -58])
            PrintCharacter(points, "&")
        return

        $*€ up::
            points := []
            points.Push([0, 0])
            points.Push([-35, -15])
            points.Push([-33, 17])
            points.Push([-17, 33])

            points.Push([-25, 15])
            points.Push([50, 0])
            points.Push([25, 0])

            points.Push([-55, 25])

            points.Push([-20, 25])
            points.Push([50, 0])
            points.Push([25, 0])

            points.Push([-50, 15])
            points.Push([17, 33])
            points.Push([33, 17])
            points.Push([35, -15])
            PrintCharacter(points)
        return

        $*@ up::
            points := []
            points.Push([0, 0])
            points.Push([-36, -9])
            points.Push([-30, -20])
            points.Push([-20, -30])
            points.Push([-9, -36])
            points.Push([9, -36])
            points.Push([20, -30])
            points.Push([30, -20])
            points.Push([36, -9])
            points.Push([36, 9])
            points.Push([30, 20])
            points.Push([20, 30])
            points.Push([9, 36])
            points.Push([-11, 34])
            points.Push([-28, 12])

            points.Push([-27, -6])
            points.Push([-37.5, 1])
            points.Push([-20, -23])
            points.Push([-1, -33.5])
            points.Push([21, -18])
            points.Push([36, 1])
            points.Push([3, 34])
            PrintCharacter(points, "@")
        return

    ;/// Special Characters \\\

    #If

;///// Prints \\\\\