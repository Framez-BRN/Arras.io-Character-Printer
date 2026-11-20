;\\\\\ Autoex. /////

#Requires AutoHotkey v1.1
#SingleInstance Force
#Persistent
#NoEnv

SetKeyDelay -1
SetMouseDelay 1
SetBatchLines, -1

settingsFile := A_ScriptDir "\settings(ACP).ini"

isPrintingCancelled := false
sendEnterAfterCancel := false
pauseAfterCancel := false
isPrinting := false
drawMode := false
selectedBind := ""
selectedBind2 := ""
bind := "-"
bind2 := "``"
keys := "0|1|2|3|4|5|6|7|8|9|A|Alt|AppsKey|B|Backspace|Browser_Back|Browser_Favorites|Browser_Forward|Browser_Home|Browser_Refresh|Browser_Search|Browser_Stop|C|CapsLock|Ctrl|D|Delete|Down|E|End|Enter|Escape|F|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|G|H|Home|I|Insert|J|K|L|Launch_App1|Launch_App2|Launch_Mail|Launch_Media|LAlt|LCtrl|Left|Lshift|LWin|M|Media_Next|Media_Play_Pause|Media_Prev|Media_Stop|N|NumLock|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|NumpadAdd|NumpadDiv|NumpadDot|NumpadEnter|NumpadMult|NumpadSub|O|P|Pause|PgDn|PgUp|PrintScreen|Q|R|RAlt|RCtrl|Right|Rshift|RWin|S|ScrollLock|Shift|Space|T|Tab|U|Up|V|Volume_Down|Volume_Mute|Volume_Up|W|X|XButton1|XButton2|Y|Z|``|'|,|-|.|/|;|=|[|\|]"
prevX := 0
prevY := 0

SetTimer, CheckArrasFocus, 100

LoadSettings()

;///// Autoex. \\\\\



;\\\\\ Guis /////

Gui, 1:Font, s13 Norm, Calibri
Gui, 1:Add, Text, x20 y20 w400 Center, Please assign a secondary custom Pause key and
Gui, 1:Add, Text, x20 y40 w400 Center, your personal Sandbox key:
Gui, 1:Font, s10 Norm, Calibri
Gui, 1:Add, DropDownList, vbind x20 y75 w150, %keys%
GuiControl, 1:ChooseString, bind, %bind%
Gui, 1:Add, Button, gSaveBind x180 y74 w130 h26, Assign Pause Key
Gui, 1:Add, DropDownList, vbind2 x20 y111 w150, %keys%
GuiControl, 1:ChooseString, bind2, %bind2%
Gui, 1:Add, Button, gSaveBind2 x180 y110 w130 h26, Assign Sandbox Key
Gui, 1:Add, Button, x320 y74 w100 h26 gShowHelp, Help
Gui, 1:Add, Button, x320 y110 w100 h26 gShowOptions, Options
Gui, 1:Font, s18 Bold
Gui, 1:Add, Text, x20 y170 w400 Center, ATTENTION!
Gui, 1:Font, s12 Norm, Calibri
Gui, 1:Add, Text, x20 y210 w400 Center, If you abuse using this script in any way and get punished for it, that is your fault. not mine. This text is here so that you dont go complaining that my script got you demoted or anything, and that you have read this and were aware beforehand that spam or similar forms of abuse are not tolerated using my script.
Gui, 1:Add, Text, x20 y330 w400 Center, In the case that you have not read the big fat attention text and still complain about it, then thats on you not me, since i have clearly stated it here.
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
    Hotkey, %selectedBind%, Off

selectedBind := bind

Hotkey, IfWinActive, arras.io
Hotkey, %selectedBind%, TogglePrinterPause, On
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

selectedBind2 := bind2

SaveSettings()

MsgBox, Pause Key assigned: %selectedBind2%
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
Gui, 2:Add, Text, x25 y+5 w200, - Full Alphabet, A-Z
Gui, 2:Add, Text, x25 y+1 w200, - All numbers, 0-9
Gui, 2:Add, Text, x25 y+1 w200, - Special characters: "?" "!" "."
Gui, 2:Font, s13 Bold,
Gui, 2:Add, Text, x15 y+25 w350, Info/Help:
Gui, 2:Font, s11 Norm,
Gui, 2:Add, Text, x25 y+5 w770, • If you want to print out a character you have to first make sure the script isnt paused. (see first window for key assigning)
Gui, 2:Add, Text, x25 y+8 w770, • Requirements to print: You need to be lvl 45, with a normal fov and tank size, otherwise it will break.
Gui, 2:Add, Text, x25 y+8 w770, • To see if the script is paused or not, look for a text box underneath your tank. it only shows whenever the script is paused.
Gui, 2:Add, Text, x36 y+0 w770, currently supported characters in order to print them out. example: press A to print out A.
Gui, 2:Add, Text, x25 y+8 w770, • The last orb that your cursor is on, after printing, is the one that you need to drag in order to move the entire letter.
Gui, 2:Add, Text, x36 y+0 w770, I suggest you use W instead of D, because it makes it easier to seperate the stacked orbs.
Gui, 2:Add, Text, x25 y+8 w770, • You can also joint together characters and make words by simply jointing the last orb(s) of each letter to the next one.
Gui, 2:Add, Text, x25 y+8 w770, • Printing size cant currently be changed in any officially supported way. Although i will add different sizes in the future,
Gui, 2:Add, Text, x36 y+0 w770, check out the discord post for updates.
Gui, 2:Font, s13 Bold,
Gui, 2:Add, Text, x15 y+25 w350, Default Keys:
Gui, 2:Font, s11 Norm,
Gui, 2:Add, Text, x25 y+0 w770, • RShift = pause/unpause script
Gui, 2:Add, Text, x25 y+0 w770, • Enter = pause script
Gui, 2:Add, Text, x25 y+0 w770, • F4 = Drawing Mode
Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + E = exit script
Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + R = reload script
Gui, 2:Show, w790, Help Menu
Return


CloseHelp:
Gui, 2:Destroy
Return


ShowOptions:
Gui, 3:Destroy
Gui, 3:Font, s13 Bold, Calibri
Gui, 3:Add, Text, x15 y10 w770, Future additions coming in v3.1, stay tuned!
Gui, 3:Font, s11 Norm,
Gui, 3:Show, w790, Options
Return

CloseOptions:
Gui, 3:Destroy
Return

;///// Guis \\\\\



;\\\\\ Functions /////

LoadSettings()
{
    global settingsFile, bind, bind2, selectedBind, selectedBind2

    if (!FileExist(settingsFile))
    {
        SaveSettings()
    }
    else
    {
    IniRead, bind, %settingsFile%, Settings, PauseKey, %bind%
    IniRead, bind2, %settingsFile%, Settings, SandboxKey, %bind2%
    }

    selectedBind := bind
    selectedBind2 := bind2

    if (bind != "")
        Hotkey, IfWinActive, arras.io
        Hotkey, %bind%, TogglePrinterPause, On
        Hotkey, IfWinActive
}

SaveSettings()
{
    global settingsFile, bind, bind2

    IniWrite, %bind%, %settingsFile%, Settings, PauseKey
    IniWrite, %bind2%, %settingsFile%, Settings, SandboxKey
}


#IfWinActive arras.io

; engine that runs the arrays for the hotkeys
PrintCharacter(points)
{
    global bind2, isPrintingCancelled, sendEnterAfterCancel, isPrinting

    isPrinting := true
    Sleep, 200

    Send, {%bind2% down}

    for index, point in points
    {
        if (isPrintingCancelled)
        {
            CancelPrint()
            isPrinting := false

            if (pauseAfterCancel)
            {
                pauseAfterCancel := false
                Suspend, On
                SetTimer, CheckPauseTooltip, 200
            }
            return
        }

        MouseMove, % point[1], % point[2]
        Send, chchch
    }

    for index, point in points
    {
        if (isPrintingCancelled)
        {
            CancelPrint()
            isPrinting := false

            if (pauseAfterCancel)
            {
                pauseAfterCancel := false
                Suspend, On
                SetTimer, CheckPauseTooltip, 200
            }
            return
        }

        MouseMove, % point[1], % point[2]

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

CancelPrint()
{
    global sendEnterAfterCancel
    global bind2

    Send, {%bind2% up}{j up}

    if (sendEnterAfterCancel)
    {
        sendEnterAfterCancel := false
        Send, {Enter}
    }
}

; for pausing/unpausing stuff
TogglePrinterPause()
{
    global isPrintingCancelled

    Suspend

    if (A_IsSuspended)
    {
        isPrintingCancelled := true
        SetTimer, CheckPauseTooltip, 200
    }
    else
    {
        isPrintingCancelled := false
        SetTimer, CheckPauseTooltip, Off
        ToolTip
    }
}

CheckPauseTooltip:
if WinActive("arras.io")
    ToolTip, Script Paused, 918, 590
else
    ToolTip
return


CheckArrasFocus:
if (isPrinting && !WinActive("arras.io") && !A_IsSuspended)
{
    TogglePrinterPause()
}
return


; thingie for the drawing mode, also why tf is a hotkey above the autoex stuff?? fix ts shi future me
; fixed dumbass, after 3 hours
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

F4::
drawMode := !drawMode
if (drawMode) {
    MouseGetPos, prevX, prevY
    SetTimer, DrawingTool, 100
} else {
    SetTimer, DrawingTool, Off
}
return

$*RShift::
Suspend, Permit
TogglePrinterPause()
return

$*Enter::
Suspend, Permit
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

    SetTimer, CheckPauseTooltip, 200
    Suspend, On
}
else
{
    Send, {Enter}
}
return

;///// Hotkeys \\\\\



;\\\\\ Printing Hotkeys /////

$A up::
    points := []

    points.Push([560, 520])
    points.Push([545, 560])
    points.Push([530, 600])
    points.Push([515, 640])
    points.Push([500, 680])
    points.Push([545, 630])
    points.Push([575, 630])
    points.Push([575, 560])
    points.Push([590, 600])
    points.Push([605, 640])
    points.Push([620, 680])

    PrintCharacter(points)
return


$B up::
    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([585, 545])
    points.Push([585, 575])
    points.Push([520, 560])
    points.Push([560, 600])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([592, 625])
    points.Push([592, 655])
    points.Push([560, 680])
    points.Push([520, 680])

    PrintCharacter(points)
return


$C up::
    points := []

    points.Push([532, 532])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([520, 560])
    points.Push([515, 600])
    points.Push([520, 640])
    points.Push([532, 668])
    points.Push([560, 680])
    points.Push([600, 680])

    PrintCharacter(points)
return


$D up::
    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([520, 560])
    points.Push([583, 537])
    points.Push([595, 565])
    points.Push([520, 600])
    points.Push([600, 600])
    points.Push([520, 640])
    points.Push([583, 667])
    points.Push([595, 635])
    points.Push([560, 680])
    points.Push([520, 680])

    PrintCharacter(points)
return


$E up::
    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([560, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([560, 680])
    points.Push([600, 680])

    PrintCharacter(points)
return


$F up::
    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([560, 600])
    points.Push([520, 640])
    points.Push([520, 680])

    PrintCharacter(points)
return


$G up::
    points := []

    points.Push([532, 532])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([520, 560])
    points.Push([515, 600])
    points.Push([600, 600])
    points.Push([520, 640])
    points.Push([600, 640])
    points.Push([532, 668])
    points.Push([560, 680])
    points.Push([600, 680])

    PrintCharacter(points)
return


$H up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([560, 600])
    points.Push([600, 520])
    points.Push([600, 560])
    points.Push([600, 600])
    points.Push([600, 640])
    points.Push([600, 680])

    PrintCharacter(points)
return


$I up::
    points := []

    points.Push([560, 520])
    points.Push([560, 560])
    points.Push([560, 600])
    points.Push([560, 640])
    points.Push([560, 680])

    PrintCharacter(points)
return


$J up::
    points := []

    points.Push([600, 520])
    points.Push([600, 560])
    points.Push([600, 600])
    points.Push([600, 640])
    points.Push([586, 666])
    points.Push([560, 680])
    points.Push([530, 670])

    PrintCharacter(points)
return


$K up::
    points := []

    points.Push([520, 520])
    points.Push([600, 520])
    points.Push([520, 560])
    points.Push([586, 560])
    points.Push([520, 600])
    points.Push([560, 600])
    points.Push([520, 640])
    points.Push([586, 640])
    points.Push([520, 680])
    points.Push([600, 680])

    PrintCharacter(points)
return


$L up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([560, 680])
    points.Push([600, 680])

    PrintCharacter(points)
return


$M up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([649, 520])
    points.Push([649, 560])
    points.Push([649, 600])
    points.Push([649, 640])
    points.Push([649, 680])
    points.Push([544, 541])
    points.Push([560, 560])
    points.Push([586, 583])
    points.Push([600, 560])
    points.Push([628, 541])

    PrintCharacter(points)
return


$N up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([600, 520])
    points.Push([600, 560])
    points.Push([600, 600])
    points.Push([600, 640])
    points.Push([584, 640])
    points.Push([542, 560])
    points.Push([563, 600])
    points.Push([600, 680])

    PrintCharacter(points)
return


$O up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([560, 520])
    points.Push([560, 680])
    points.Push([600, 520])
    points.Push([600, 560])
    points.Push([600, 600])
    points.Push([600, 640])
    points.Push([600, 680])

    PrintCharacter(points)
return


$P up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([560, 520])
    points.Push([560, 600])
    points.Push([591, 541])
    points.Push([591, 583])
    points.Push([520, 680])

    PrintCharacter(points)
return


$Q up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([560, 520])
    points.Push([560, 680])
    points.Push([600, 520])
    points.Push([600, 560])
    points.Push([600, 600])
    points.Push([600, 640])
    points.Push([586, 667])
    points.Push([575.5, 636])
    points.Push([596.5, 698])

    PrintCharacter(points)
return


$R up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([560, 520])
    points.Push([560, 600])
    points.Push([586, 640])
    points.Push([591, 541])
    points.Push([591, 583])
    points.Push([600, 680])

    PrintCharacter(points)
return


$S up::
    points := []

    points.Push([595, 525])
    points.Push([560, 520])
    points.Push([530, 530])
    points.Push([520, 560])
    points.Push([530, 590])
    points.Push([560, 600])
    points.Push([590, 610])
    points.Push([600, 640])
    points.Push([590, 670])
    points.Push([560, 680])
    points.Push([525, 675])

    PrintCharacter(points)
return


$T up::
    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([560, 560])
    points.Push([560, 600])
    points.Push([560, 640])
    points.Push([560, 680])

    PrintCharacter(points)
return


$U up::
    points := []

    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([520, 640])
    points.Push([520, 680])
    points.Push([560, 680])
    points.Push([600, 520])
    points.Push([600, 560])
    points.Push([600, 600])
    points.Push([600, 640])
    points.Push([600, 680])

    PrintCharacter(points)
return


$V up::
    points := []

    points.Push([530, 520])
    points.Push([544, 560])
    points.Push([558, 600])
    points.Push([572, 640])
    points.Push([642, 520])
    points.Push([628, 560])
    points.Push([614, 600])
    points.Push([600, 640])
    points.Push([586, 680])

    PrintCharacter(points)
return


$W up::
    points := []

    points.Push([520, 520])
    points.Push([533.5, 560])
    points.Push([544, 600])
    points.Push([554.5, 640])
    points.Push([560, 680])
    points.Push([600, 520])
    points.Push([596.5, 560])
    points.Push([586, 600])
    points.Push([575.5, 640])
    points.Push([617.5, 560])
    points.Push([628, 600])
    points.Push([638.5, 640])
    points.Push([649, 680])
    points.Push([691, 520])
    points.Push([680.5, 560])
    points.Push([670, 600])
    points.Push([659.5, 640])

    PrintCharacter(points)
return


$X up::
    points := []

    points.Push([520, 520])
    points.Push([544, 560])
    points.Push([560, 600])
    points.Push([586, 640])
    points.Push([600, 680])
    points.Push([600, 520])
    points.Push([586, 560])
    points.Push([544, 640])
    points.Push([520, 680])

    PrintCharacter(points)
return


$Y up::
    points := []

    points.Push([510, 520])
    points.Push([534, 560])
    points.Push([560, 600])
    points.Push([610, 520])
    points.Push([586, 560])
    points.Push([560, 640])
    points.Push([560, 680])

    PrintCharacter(points)
return


$Z up::
    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([586, 560])
    points.Push([560, 600])
    points.Push([544, 640])
    points.Push([520, 680])
    points.Push([560, 680])
    points.Push([600, 680])

    PrintCharacter(points)
return



; \\\\\ 

$1 up::
    points := []

    points.Push([560, 520])
    points.Push([534, 548])
    points.Push([509, 575])
    points.Push([560, 560])
    points.Push([560, 600])
    points.Push([560, 640])
    points.Push([560, 680])

    PrintCharacter(points)
return


$2 up::
    points := []

    points.Push([525, 540])
    points.Push([560, 520])
    points.Push([595, 540])
    points.Push([595, 580])
    points.Push([575, 615])
    points.Push([551, 647])
    points.Push([525, 679])
    points.Push([565, 679])
    points.Push([605, 679])

    PrintCharacter(points)
return


$3 up::
    points := []

    points.Push([525, 540])
    points.Push([560, 520])
    points.Push([595, 540])
    points.Push([600, 565])
    points.Push([585, 600])
    points.Push([545, 600])
    points.Push([600, 635])
    points.Push([595, 660])
    points.Push([560, 680])
    points.Push([525, 660])

    PrintCharacter(points)
return


$4 up::
    points := []

    points.Push([560, 680])
    points.Push([560, 640])
    points.Push([560, 600])
    points.Push([560, 560])
    points.Push([560, 520])
    points.Push([532, 552])
    points.Push([507, 585])
    points.Push([487, 620])
    points.Push([527, 620])
    points.Push([595, 620])

    PrintCharacter(points)
return


$5 up::
    points := []

    points.Push([600, 520])
    points.Push([560, 520])
    points.Push([520, 520])
    points.Push([520, 560])
    points.Push([520, 600])
    points.Push([560, 600])
    points.Push([586, 614])
    points.Push([600, 640])
    points.Push([586, 666])
    points.Push([560, 680])
    points.Push([520, 680])

    PrintCharacter(points)
return


$6 up::
    points := []

    points.Push([525, 620])
    points.Push([525, 660])
    points.Push([560, 680])
    points.Push([595, 660])
    points.Push([595, 620])
    points.Push([560, 600])
    points.Push([525, 580])
    points.Push([525, 540])
    points.Push([560, 520])
    points.Push([595, 540])

    PrintCharacter(points)
return


$7 up::
    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([590, 560])
    points.Push([575, 598])
    points.Push([560, 635])
    points.Push([545, 673])

    PrintCharacter(points)
return


$8 up::
    points := []

    points.Push([540, 600])
    points.Push([522, 570])
    points.Push([534, 534])
    points.Push([560, 520])
    points.Push([586, 534])
    points.Push([598, 570])
    points.Push([580, 600])
    points.Push([598, 630])
    points.Push([586, 666])
    points.Push([560, 680])
    points.Push([534, 666])
    points.Push([522, 630])
    points.Push([520, 570])

    PrintCharacter(points)
return


$9 up::
    points := []

    points.Push([540, 600])
    points.Push([522, 570])
    points.Push([534, 534])
    points.Push([560, 520])
    points.Push([586, 534])
    points.Push([598, 570])
    points.Push([580, 600])
    points.Push([598, 600])
    points.Push([598, 630])
    points.Push([586, 666])
    points.Push([560, 680])
    points.Push([534, 666])

    PrintCharacter(points)
return


$0 up::
    points := []

    points.Push([525, 540])
    points.Push([518, 580])
    points.Push([518, 620])
    points.Push([525, 660])
    points.Push([560, 680])
    points.Push([595, 660])
    points.Push([602, 620])
    points.Push([602, 580])
    points.Push([595, 540])
    points.Push([560, 520])

    PrintCharacter(points)
return


$? up::
KeyWait, LShift

    points := []

    points.Push([525, 540])
    points.Push([560, 520])
    points.Push([595, 540])
    points.Push([595, 580])
    points.Push([560, 600])
    points.Push([560, 680])

    PrintCharacter(points)
return


$+1 up::
KeyWait, LShift

    points := []

    points.Push([560, 520])
    points.Push([560, 560])
    points.Push([560, 600])
    points.Push([560, 680])

    PrintCharacter(points)
return


$. up::
send,{shift down}{c}{h}{shift up}
Return


$, up::
    points := []

    points.Push([532, 520])
    points.Push([529, 542])
    points.Push([520, 560])

    PrintCharacter(points)
return


$= up::
KeyWait, LShift

    points := []

    points.Push([520, 520])
    points.Push([560, 520])
    points.Push([600, 520])
    points.Push([520, 580])
    points.Push([560, 580])
    points.Push([600, 580])

    PrintCharacter(points)
return


$" up::
KeyWait, LShift

    points := []

    points.Push([520, 520])
    points.Push([520, 540])
    points.Push([570, 520])
    points.Push([570, 540])

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