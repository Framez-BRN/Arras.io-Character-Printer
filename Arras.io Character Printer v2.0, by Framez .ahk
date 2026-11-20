;If you change anything in here im gona rip your dih off
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

SetKeyDelay -1
SetMouseDelay 1
#Requires AutoHotkey v1.1
#SingleInstance Force
#Persistent

^!s::
    Suspend, Toggle

    if (A_IsSuspended)
        ShowTooltip1("Script paused")
    else
        ShowTooltip1("Script unpaused")
return

ShowTooltip1(text) {
    Tooltip, %text%
    SetTimer, RemoveTooltip1, -1000
}

RemoveTooltip1:
    Tooltip
return

^!e::ExitApp

^!r::Reload

enter::
send,{enter}
    Suspend, On

    if (A_IsSuspended)
        ShowTooltip2("Script paused")
    else
        ShowTooltip2("Script unpaused")
return

ShowTooltip2(text) {
    Tooltip, %text%
    SetTimer, RemoveTooltip2, -1000
}

RemoveTooltip2:
    Tooltip
return

selectedHotkey1 := ""
selectedHotkey2 := ""

F1::
Gui, Destroy
Gui, Font, s18 Bold
Gui, Add, Text, x20 y170 w400 Center, ATTENTION!
Gui, Font, s12 Norm, Calibri
Gui, Add, Text, x20 y+10 w400 Center, If you abuse using this script in any way and get punished for it, that is your fault. not mine. This text is here so that before you think about complaining that my script got you demoted or anything, that you have read this and were aware that spam or similar forms of abuse are not tolerated using my script.
Gui, Add, Text, x20 y+10 w400 Center, In the case that you have not read the big fat attention text and still complain about it, then thats on you not me, since i have clearly stated it here.
Gui, Font, s10, Calibri
Gui, Add, Text, x20 y20 w400 Center, The Default keybind for pausing/unpausing the script is CapsLock.
Gui, Add, Text, x20 y40 w400 Center, choose a keybind combination to pause/unpause the script:
Gui, Add, Hotkey, x20 y75 w150 vHotkeyInput1 hwndhHotkey1, %selectedHotkey1%
Gui, Add, Button, x+10 y74 w130 h26 gAssignHotkey1, Assign Pause Key
Gui, Add, Hotkey, x20 y111 w150 vHotkeyInput2 hwndhHotkey2, %selectedHotkey2%
Gui, Add, Button, x+10 y110 w130 h26 gAssignHotkey1, Assign Sandbox Key
Gui, Add, Button, x+10 y74 w100 h26 gShowHelp, Help
Gui, Show, w440, Arras.io Character Printer (F1)
return

ControlFocus,, ahk_id %hHotkey1%
return

GuiClose:
Gui, Destroy
return

ShowHelp:
Gui, 2:Destroy
Gui, 2:Font, s13 Bold, Calibri
Gui, 2:Add, Text, x15 y10 w350, List of currently printable characters:
Gui, 2:Font, s11 Norm,
Gui, 2:Add, Text, x25 y+5 w200, - Full Alphabet, A-Z
Gui, 2:Add, Text, x25 y+1 w200, - All numbers, 0-9
Gui, 2:Add, Text, x25 y+1 w200, - Special characters: ?, !
Gui, 2:Font, s13 Bold,
Gui, 2:Add, Text, x15 y+25 w350, Info/Help:
Gui, 2:Font, s11 Norm,
Gui, 2:Add, Text, x25 y+5 w770, • If you want to print out a character you have to first make sure the script isnt paused. (see first window for key assigning)
Gui, 2:Add, Text, x25 y+8 w770, • Once you made sure that the script is active (look for message box on bottom left of screen), you can press any of the
Gui, 2:Add, Text, x36 y+0 w770, currently supported characters in order to print them out. example: press A to print out A.
Gui, 2:Add, Text, x25 y+8 w770, • The last ball that your cursor is on, after printing, is the one that you need to drag in order to move the entire letter.
Gui, 2:Add, Text, x36 y+0 w770, I suggest you use W instead of D, because it makes it easier to seperate the stacked balls.
Gui, 2:Add, Text, x25 y+8 w770, • You can also joint together words by simply jointing the last balls of each letter to the next one.
Gui, 2:Add, Text, x25 y+8 w770, • Printing size can be changed by simply zooming in/out or by changing your tank size. Though i will add officialy
Gui, 2:Add, Text, x36 y+0 w770, supported sizes (see discord post) in the future. (for characters that have perfectly spaced balls, simply be lvl 45, increase your size once using the size change command and then print.)
Gui, 2:Font, s13 Bold,
Gui, 2:Add, Text, x15 y+25 w350, Default Keys:
Gui, 2:Font, s11 Norm,
Gui, 2:Add, Text, x25 y+5 w770, • F1 = brings up menu
Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + S = pause/unpause script
Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + E = exit script
Gui, 2:Add, Text, x25 y+0 w770, • CTRL + ALT + R = reload script
Gui, 2:Add, Text, x25 y+0 w770, • CapsLock = pause/unpause script
Gui, 2:Add, Text, x25 y+0 w770, • Enter = only pauses but not unpauses
Gui, 2:Show, w790, Help
Return

CloseHelp:
Gui, 2:Destroy
Return

AssignHotkey1:
Gui, Submit, NoHide

if (HotkeyInput1 = "")
{
    MsgBox, Please choose a key first.
    return
}

if (selectedHotkey1 != "")
    Hotkey, %selectedHotkey1%, Off

selectedHotkey1 := HotkeyInput1
Hotkey, %selectedHotkey1%, TriggerAction1, On

MsgBox, Pause Key assigned: %selectedHotkey1%
return

TriggerAction1:
    Suspend, Toggle

    if (A_IsSuspended)
        ShowTooltip3("Script paused")
    else
        ShowTooltip3("Script unpaused")
return

ShowTooltip3(text) {
    Tooltip, %text%
    SetTimer, RemoveTooltip3, -1000
}

RemoveTooltip3:
    Tooltip
return

CapsLock::
    Suspend, Toggle

    if (A_IsSuspended)
        ShowTooltip4("Script paused")
    else
        ShowTooltip4("Script unpaused")
return

ShowTooltip4(text) {
    Tooltip, %text%
    SetTimer, RemoveTooltip4, -1000
}

RemoveTooltip4:
    Tooltip
return

#IfWinActive arras.io

#NoEnv
#SingleInstance Force
SetBatchLines, -1

toggle := false
prevX := 0
prevY := 0

F3::
toggle := !toggle
if (toggle) {
    MouseGetPos, prevX, prevY
    SetTimer, LoopAction, 100
} else {
    SetTimer, LoopAction, Off
}
return

LoopAction:
if (!toggle)
    return

MouseGetPos, currX, currY

if (currX != prevX || currY != prevY) {
    send, {Shift down}{c}{h}{Shift up}
}

prevX := currX
prevY := currY
return

!A::
sleep, 500
mousemove, 500, 300
send,{shift down}chchch
mousemove, 540, 300
send,chchch
mousemove, 580, 300
send,chchch
mousemove, 620, 300
send,chchch
mousemove, 660, 300
send,chchch
mousemove, 700, 300
send,chchch
mousemove, 740, 300
send,chchch
mousemove, 780, 300
send,chchch
mousemove, 820, 300
send,chchch
mousemove, 860, 300
send,chchch
mousemove, 900, 300
send,chchch
mousemove, 940, 300
send,chchch
mousemove, 980, 300
send,chchch
mousemove, 1020, 300
send,chchch
mousemove, 1060, 300
send,chchch
mousemove, 1100, 300
send,chchch
mousemove, 1140, 300
send,chchch
mousemove, 1180, 300
send,chchch
mousemove, 1220, 300
send,chchch
mousemove, 1260, 300
send,chchch
mousemove, 1300, 300
send,chchch
mousemove, 1340, 300
send,chchch
mousemove, 500, 400
send,chchch
mousemove, 540, 400
send,chchch
mousemove, 580, 400
send,chchch
mousemove, 620, 400
send,chchch
mousemove, 660, 400
send,chchch
mousemove, 700, 400
send,chchch
mousemove, 740, 400
send,chchch
mousemove, 780, 400
send,chchch
mousemove, 820, 400
send,chchch
mousemove, 860, 400
send,chchch
mousemove, 900, 400
send,chchch
mousemove, 940, 400
send,chchch
mousemove, 980, 400
send,chchch
mousemove, 1020, 400
send,chchch
mousemove, 1060, 400
send,chchch
mousemove, 1100, 400
send,chchch
mousemove, 1140, 400
send,chchch
mousemove, 1180, 400
send,chchch
mousemove, 1220, 400
send,chchch
mousemove, 1260, 400
send,chchch
mousemove, 1300, 400
send,chchch
mousemove, 1340, 400
send,chchch
mousemove, 500, 300
send,{j down}
mousemove, 540, 300
send,{j up}{j down}
mousemove, 580, 300
send,{j up}{j down}
mousemove, 620, 300
send,{j up}{j down}
mousemove, 660, 300
send,{j up}{j down}
mousemove, 700, 300
send,{j up}{j down}
mousemove, 740, 300
send,{j up}{j down}
mousemove, 780, 300
send,{j up}{j down}
mousemove, 820, 300
send,{j up}{j down}
mousemove, 860, 300
send,{j up}{j down}
mousemove, 900, 300
send,{j up}{j down}
mousemove, 940, 300
send,{j up}{j down}
mousemove, 980, 300
send,{j up}{j down}
mousemove, 1020, 300
send,{j up}{j down}
mousemove, 1060, 300
send,{j up}{j down}
mousemove, 1100, 300
send,{j up}{j down}
mousemove, 1140, 300
send,{j up}{j down}
mousemove, 1180, 300
send,{j up}{j down}
mousemove, 1220, 300
send,{j up}{j down}
mousemove, 1260, 300
send,{j up}{j down}
mousemove, 1300, 300
send,{j up}{j down}
mousemove, 1340, 300
send,{j up}
mousemove, 500, 400
send,{j down}
mousemove, 540, 400
send,{j up}{j down}
mousemove, 580, 400
send,{j up}{j down}
mousemove, 620, 400
send,{j up}{j down}
mousemove, 660, 400
send,{j up}{j down}
mousemove, 700, 400
send,{j up}{j down}
mousemove, 740, 400
send,{j up}{j down}
mousemove, 780, 400
send,{j up}{j down}
mousemove, 820, 400
send,{j up}{j down}
mousemove, 860, 400
send,{j up}{j down}
mousemove, 900, 400
send,{j up}{j down}
mousemove, 940, 400
send,{j up}{j down}
mousemove, 980, 400
send,{j up}{j down}
mousemove, 1020, 400
send,{j up}{j down}
mousemove, 1060, 400
send,{j up}{j down}
mousemove, 1100, 400
send,{j up}{j down}
mousemove, 1140, 400
send,{j up}{j down}
mousemove, 1180, 400
send,{j up}{j down}
mousemove, 1220, 400
send,{j up}{j down}
mousemove, 1260, 400
send,{j up}{j down}
mousemove, 1300, 400
send,{j up}{j down}
mousemove, 1340, 400
send,{j up}{shift up}
return

$A up::
sleep, 500
mousemove, 560, 520
send,{shift down}chchch
mousemove, 545, 560
send,chchch
mousemove, 530, 600
send,chchch
mousemove, 515, 640
send,chchch
mousemove, 500, 680
send,chchch
mousemove, 545, 630
send,chchch
mousemove, 575, 630
send,chchch
mousemove, 575, 560
send,chchch
mousemove, 590, 600
send,chchch
mousemove, 605, 640
send,chchch
mousemove, 620, 680
send,chchch
mousemove, 560, 520
send,{j down}
mousemove, 545, 560
send,{j up}{j down}
mousemove, 530, 600
send,{j up}{j down}
mousemove, 515, 640
send,{j up}{j down}
mousemove, 500, 680
send,{j up}{j down}
mousemove, 545, 630
send,{j up}{j down}
mousemove, 575, 630
send,{j up}{j down}
mousemove, 575, 560
send,{j up}{j down}
mousemove, 590, 600
send,{j up}{j down}
mousemove, 605, 640
send,{j up}{j down}
mousemove, 620, 680
send,{j up}{shift up}
return

$B up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 585, 545
send,chchch
mousemove, 585, 575
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 592, 625
send,chchch
mousemove, 592, 655
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 585, 545
send,{j up}{j down}
mousemove, 585, 575
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 592, 625
send,{j up}{j down}
mousemove, 592, 655
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{shift up}
return

$C up::
sleep, 500
mousemove, 532, 532
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 515, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 532, 668
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 532, 532
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 515, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 532, 672
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$D up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 583, 537
send,chchch
mousemove, 595, 565
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 583, 667
send,chchch
mousemove, 595, 635
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 583, 537
send,{j up}{j down}
mousemove, 595, 565
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 583, 667
send,{j up}{j down}
mousemove, 595, 635
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{shift up}
return

$E up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$F up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{shift up}
return

$G up::
sleep, 500
mousemove, 532, 532
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 515, 600
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 532, 668
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 530, 530
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 515, 600
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 530, 670
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$H up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 600, 560
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 600, 560
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$I up::
sleep, 500
mousemove, 560, 520
send,{shift down}chchch
mousemove, 560, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 560, 640
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 560, 520
send,{j down}
mousemove, 560, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 560, 640
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{shift up}
return

$J up::
sleep, 500
mousemove, 600, 520
send,{shift down}chchch
mousemove, 600, 560
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 586, 666
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 530, 670
send,chchch
mousemove, 600, 520
send,{j down}
mousemove, 600, 560
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 586, 666
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 530, 670
send,{j up}{shift up}
return

$K up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 600, 520
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 586, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 586, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 586, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 586, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$L up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$M up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 649, 520
send,chchch
mousemove, 649, 560
send,chchch
mousemove, 649, 600
send,chchch
mousemove, 649, 640
send,chchch
mousemove, 649, 680
send,chchch
mousemove, 544, 541
send,chchch
mousemove, 560, 560
send,chchch
mousemove, 586, 583
send,chchch
mousemove, 600, 560
send,chchch
mousemove, 628, 541
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 649, 520
send,{j up}{j down}
mousemove, 649, 560
send,{j up}{j down}
mousemove, 649, 600
send,{j up}{j down}
mousemove, 649, 640
send,{j up}{j down}
mousemove, 649, 680
send,{j up}{j down}
mousemove, 544, 541
send,{j up}{j down}
mousemove, 560, 560
send,{j up}{j down}
mousemove, 586, 583
send,{j up}{j down}
mousemove, 600, 560
send,{j up}{j down}
mousemove, 628, 541
send,{j up}{shift up}
return

$N up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 600, 560
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 584, 640
send,chchch
mousemove, 542, 560
send,chchch
mousemove, 563, 600
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 600, 560
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 584, 640
send,{j up}{j down}
mousemove, 542, 560
send,{j up}{j down}
mousemove, 563, 600
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$O up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 600, 560
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 600, 560
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$P up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 591, 541
send,chchch
mousemove, 591, 583
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 591, 541
send,{j up}{j down}
mousemove, 591, 583
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{shift up}
return

$Q up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 600, 560
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 586, 667
send,chchch
mousemove, 575.5, 636
send,chchch
mousemove, 596.5, 698
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 600, 560
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 586, 667
send,{j up}{j down}
mousemove, 575.5, 636
send,{j up}{j down}
mousemove, 596.5, 698
send,{j up}{shift up}
return

$R up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 586, 640
send,chchch
mousemove, 591, 541
send,chchch
mousemove, 591, 583
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 586, 640
send,{j up}{j down}
mousemove, 591, 541
send,{j up}{j down}
mousemove, 591, 583
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$S up::
sleep, 500
mousemove, 595, 525
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 530, 530
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 530, 590
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 590, 610
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 590, 670
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 525, 675
send,chchch
mousemove, 600, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 520, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{shift up}
return

$T up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 560, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 560, 640
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 560, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 560, 640
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{shift up}
return

$U up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 520, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 600, 560
send,chchch
mousemove, 600, 600
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 520, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 600, 560
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$V up::
sleep, 500
mousemove, 530, 520
send,{shift down}chchch
mousemove, 544, 560
send,chchch
mousemove, 558, 600
send,chchch
mousemove, 572, 640
send,chchch
mousemove, 642, 520
send,chchch
mousemove, 628, 560
send,chchch
mousemove, 614, 600
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 586, 680
send,chchch
mousemove, 530, 520
send,{j down}
mousemove, 544, 560
send,{j up}{j down}
mousemove, 558, 600
send,{j up}{j down}
mousemove, 572, 640
send,{j up}{j down}
mousemove, 642, 520
send,{j up}{j down}
mousemove, 628, 560
send,{j up}{j down}
mousemove, 614, 600
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 586, 680
send,{j up}{shift up}
return

$W up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 533.5, 560
send,chchch
mousemove, 544, 600
send,chchch
mousemove, 554.5, 640
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 596.5, 560
send,chchch
mousemove, 586, 600
send,chchch
mousemove, 575.5, 640
send,chchch
mousemove, 617.5, 560
send,chchch
mousemove, 628, 600
send,chchch
mousemove, 638.5, 640
send,chchch
mousemove, 649, 680
send,chchch
mousemove, 691, 520
send,chchch
mousemove, 680.5, 560
send,chchch
mousemove, 670, 600
send,chchch
mousemove, 659.5, 640
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 533.5, 560
send,{j up}{j down}
mousemove, 544, 600
send,{j up}{j down}
mousemove, 554.5, 640
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 596.5, 560
send,{j up}{j down}
mousemove, 586, 600
send,{j up}{j down}
mousemove, 575.5, 640
send,{j up}{j down}
mousemove, 617.5, 560
send,{j up}{j down}
mousemove, 628, 600
send,{j up}{j down}
mousemove, 638.5, 640
send,{j up}{j down}
mousemove, 691, 520
send,{j up}{j down}
mousemove, 680.5, 560
send,{j up}{j down}
mousemove, 670, 600
send,{j up}{j down}
mousemove, 659.5, 640
send,{j up}{j down}
mousemove, 649, 680
send,{j up}{shift up}
return

$X up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 544, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 586, 640
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 586, 560
send,chchch
mousemove, 544, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 544, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 586, 640
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 586, 560
send,{j up}{j down}
mousemove, 544, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{shift up}
return

$Y up::
sleep, 500
mousemove, 510, 520
send,{shift down}chchch
mousemove, 534, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 610, 520
send,chchch
mousemove, 586, 560
send,chchch
mousemove, 560, 640
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 510, 520
send,{j down}
mousemove, 534, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 610, 520
send,{j up}{j down}
mousemove, 586, 560
send,{j up}{j down}
mousemove, 560, 640
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{shift up}
return

$Z up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 586, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 544, 640
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 600, 680
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 586, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 544, 640
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 600, 680
send,{j up}{shift up}
return

$1 up::
sleep, 500
mousemove, 560, 520
send,{shift down}chchch
mousemove, 534, 548
send,chchch
mousemove, 509, 575
send,chchch
mousemove, 560, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 560, 640
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 560, 520
send,{j down}
mousemove, 534, 548
send,{j up}{j down}
mousemove, 509, 575
send,{j up}{j down}
mousemove, 560, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 560, 640
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{shift up}
return

$2 up::
sleep, 500
mousemove, 525, 540
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 595, 540
send,chchch
mousemove, 595, 580
send,chchch
mousemove, 575, 615
send,chchch
mousemove, 551, 647
send,chchch
mousemove, 525, 679
send,chchch
mousemove, 565, 679
send,chchch
mousemove, 605, 679
send,chchch
mousemove, 525, 540
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 595, 540
send,{j up}{j down}
mousemove, 595, 580
send,{j up}{j down}
mousemove, 575, 615
send,{j up}{j down}
mousemove, 551, 647
send,{j up}{j down}
mousemove, 525, 679
send,{j up}{j down}
mousemove, 565, 679
send,{j up}{j down}
mousemove, 605, 679
send,{j up}{shift up}
return

$3 up::
sleep, 500
mousemove, 525, 540
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 595, 540
send,chchch
mousemove, 600, 565
send,chchch
mousemove, 585, 600
send,chchch
mousemove, 545, 600
send,chchch
mousemove, 600, 635
send,chchch
mousemove, 595, 660
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 525, 660
send,chchch
mousemove, 525, 540
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 595, 540
send,{j up}{j down}
mousemove, 600, 565
send,{j up}{j down}
mousemove, 585, 600
send,{j up}{j down}
mousemove, 545, 600
send,{j up}{j down}
mousemove, 600, 635
send,{j up}{j down}
mousemove, 595, 660
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 525, 660
send,{j up}{shift up}
return

$4 up::
sleep, 500
mousemove, 560, 680
send,{shift down}chchch
mousemove, 560, 640
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 560, 560
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 532, 552
send,chchch
mousemove, 507, 585
send,chchch
mousemove, 487, 620
send,chchch
mousemove, 527, 620
send,chchch
mousemove, 595, 620
send,chchch
mousemove, 560, 680
send,{j down}
mousemove, 560, 640
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 560, 560
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 532, 552
send,{j up}{j down}
mousemove, 507, 585
send,{j up}{j down}
mousemove, 487, 620
send,{j up}{j down}
mousemove, 527, 620
send,{j up}{j down}
mousemove, 595, 620
send,{j up}{shift up}
return

$5 up::
sleep, 500
mousemove, 600, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 520, 520
send,chchch
mousemove, 520, 560
send,chchch
mousemove, 520, 600
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 586, 614
send,chchch
mousemove, 600, 640
send,chchch
mousemove, 586, 666
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 520, 680
send,chchch
mousemove, 600, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 520, 520
send,{j up}{j down}
mousemove, 520, 560
send,{j up}{j down}
mousemove, 520, 600
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 586, 614
send,{j up}{j down}
mousemove, 600, 640
send,{j up}{j down}
mousemove, 586, 666
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 520, 680
send,{j up}{shift up}
return

$6 up::
sleep, 500
mousemove, 525, 620
send,{shift down}chchch
mousemove, 525, 660
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 595, 660
send,chchch
mousemove, 595, 620
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 525, 580
send,chchch
mousemove, 525, 540
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 595, 540
send,chchch
mousemove, 525, 620
send,{j down}
mousemove, 525, 660
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 595, 660
send,{j up}{j down}
mousemove, 595, 620
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 525, 580
send,{j up}{j down}
mousemove, 525, 540
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 595, 540
send,{j up}{shift up}
return

$7 up::
sleep, 500
mousemove, 520, 520
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 600, 520
send,chchch
mousemove, 590, 560
send,chchch
mousemove, 575, 598
send,chchch
mousemove, 560, 635
send,chchch
mousemove, 545, 673
send,chchch
mousemove, 520, 520
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 600, 520
send,{j up}{j down}
mousemove, 590, 560
send,{j up}{j down}
mousemove, 575, 598
send,{j up}{j down}
mousemove, 560, 635
send,{j up}{j down}
mousemove, 545, 673
send,{j up}{shift up}
return


mousemove, 586, 666


$8 up::
sleep, 500
mousemove, 540, 600
send,{shift down}chchch
mousemove, 522, 570
send,chchch
mousemove, 534, 534
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 586, 534
send,chchch
mousemove, 598, 570
send,chchch
mousemove, 580, 600
send,chchch
mousemove, 598, 630
send,chchch
mousemove, 586, 666
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 534, 666
send,chchch
mousemove, 522, 630
send,chchch
mousemove, 520, 570
send,{j down}
mousemove, 534, 534
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 586, 534
send,{j up}{j down}
mousemove, 600, 570
send,{j up}{j down}
mousemove, 580, 600
send,{j up}{j down}
mousemove, 600, 630
send,{j up}{j down}
mousemove, 586, 666
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 534, 666
send,{j up}{j down}
mousemove, 520, 630
send,{j up}{j down}
mousemove, 540, 600
send,{j up}{shift up}
return

$9 up::
sleep, 500
mousemove, 540, 600
send,{shift down}chchch
mousemove, 522, 570
send,chchch
mousemove, 534, 534
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 586, 534
send,chchch
mousemove, 598, 570
send,chchch
mousemove, 580, 600
send,chchch
mousemove, 598, 600
send,chchch
mousemove, 598, 630
send,chchch
mousemove, 586, 666
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 534, 666
send,chchch
mousemove, 540, 600
send,{j down}
mousemove, 520, 570
send,{j up}{j down}
mousemove, 534, 534
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 586, 534
send,{j up}{j down}
mousemove, 600, 570
send,{j up}{j down}
mousemove, 580, 600
send,{j up}{j down}
mousemove, 600, 600
send,{j up}{j down}
mousemove, 600, 630
send,{j up}{j down}
mousemove, 586, 666
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 534, 666
send,{j up}{shift up}
return

$0 up::
sleep, 500
mousemove, 525, 540
send,{shift down}chchch
mousemove, 518, 580
send,chchch
mousemove, 518, 620
send,chchch
mousemove, 525, 660
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 595, 660
send,chchch
mousemove, 602, 620
send,chchch
mousemove, 602, 580
send,chchch
mousemove, 595, 540
send,chchch
mousemove, 560, 520
send,chchch
mousemove, 525, 540
send,{j down}
mousemove, 518, 580
send,{j up}{j down}
mousemove, 518, 620
send,{j up}{j down}
mousemove, 525, 660
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{j down}
mousemove, 595, 660
send,{j up}{j down}
mousemove, 602, 620
send,{j up}{j down}
mousemove, 602, 580
send,{j up}{j down}
mousemove, 595, 540
send,{j up}{j down}
mousemove, 560, 520
send,{j up}{shift up}
return

$? up::
sleep, 500
mousemove, 525, 540
send,{shift down}chchch
mousemove, 560, 520
send,chchch
mousemove, 595, 540
send,chchch
mousemove, 595, 580
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 525, 540
send,{j down}
mousemove, 560, 520
send,{j up}{j down}
mousemove, 595, 540
send,{j up}{j down}
mousemove, 595, 580
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{shift up}
return

$! up::
sleep, 500
mousemove, 560, 520
send,{shift down}chchch
mousemove, 560, 560
send,chchch
mousemove, 560, 600
send,chchch
mousemove, 560, 680
send,chchch
mousemove, 560, 520
send,{j down}
mousemove, 560, 560
send,{j up}{j down}
mousemove, 560, 600
send,{j up}{j down}
mousemove, 560, 680
send,{j up}{shift up}
return

$. up::
send,{shift down}{c}{h}{shift up}
Return

#IfWinActive