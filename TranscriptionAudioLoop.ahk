#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;TranscriptionAudioLoop.ahk
	;
;


#SingleInstance,Force
#NoEnv
SetBatchLines,-1
SetKeyDelay,-1
SendMode,Event

applicationname=TranscriptionAudioLoop

Gosub,INIREAD
Gosub,TRAYMENU

i := 0
toggle := 0
F8::
toggle := !toggle
if (toggle) {
	TrayTip, Starting, Starting loop
SetTimer, audio_loop_keys, 10
} else {
	TrayTip, Stopping, Stopping loop please wait...
	SetTImer, audio_loop_keys, Off
}
return

audio_loop_keys:
;play
send {f9}
sleepValue := delay1 * 1000
sleep %sleepValue%
;stop
send {F4}
;wait
sleepValue := delay2 * 1000
sleep %sleepValue%
;rewind
send {F7 down}
sleep %rewindtime%
send {F7 up}
sleep 200
if (!toggle)
	TrayTip, Stopped, Loop now stopped
return



TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Default,%applicationname%
Menu,Tray,Add,&Settings...,SETTINGS 
;Menu,Tray,Add,&About...,About 
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname% 
Return 


SETTINGS:
Gui,Destroy
Gui,Margin,20

Gui,Add,GroupBox,xm-10 y+10 w420 h120,&Speed
Gui,Add,Edit,xm yp+20 w100 vvdelay1
Gui,Add,UpDown, Range0-999,%delay1%
Gui,Add,Text,x+10 yp+5,How long to play for in seconds

Gui,Add,Edit,xm y+10 w100 vvdelay2
Gui,Add,UpDown,Range0-999,%delay2%
Gui,Add,Text,x+10 yp+5,How long to stop for in seconds


Gui,Add,Edit,xm y+10 w100 vvrewindtime
Gui,Add,UpDown,Range0-5000,%rewindtime%
Gui,Add,Text,x+10 yp+5,How long to hold the rewind key for
Gui,Add,Text,xp y+5,(in miliseconds)

Gui,Add,Button,xm y+30 w75 gSETTINGSOK Default,&OK
Gui,Add,Button,x+5 yp w75 gSETTINGSCANCEL,&Cancel

Gui,Show,w440,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
delay1:=vdelay1
delay2:=vdelay2
rewindtime:=vrewindtime
Gosub,INIWRITE
Gosub,SETTINGSCANCEL
Return

SETTINGSCANCEL:
Gui,Destroy
Return

GuiClose:
Gosub,SETTINGSCANCEL
Return

EXIT:
ExitApp


INIREAD:
IfNotExist,%applicationname%.ini 
{
	delay1=5
	delay2=5
	rewindtime=500
	Gosub,INIWRITE
	Gosub,ABOUT
}
IniRead,delay1,%applicationname%.ini,Settings,delay1
IniRead,delay2,%applicationname%.ini,Settings,delay2
IniRead,rewindtime,%applicationname%.ini,Settings,rewindtime


If (delay1="Error" or delay1="")
delay1=5
If (delay2="Error" or delay2="")
delay2=5
If (rewindtime="Error" or rewindtime="")
rewindtime=500
Gosub,INIWRITE
Return


INIWRITE:
IniWrite,%delay1%,%applicationname%.ini,Settings,delay1
IniWrite,%delay2%,%applicationname%.ini,Settings,delay2
IniWrite,%rewindtime%,%applicationname%.ini,Settings,rewindtime
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Font,Bold
Gui,99:Add,Text,xm yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Press F8 to start/stop an audio loop.
Gui,99:Add,Text,y+10,Works with the default hot-keys of
Gui,99:Add,Text,y+10,Express Scribe Transcription Software Pro
Gui,99:Add,Text,y+10,- To change the settings, choose Settings in the tray menu.

Gui,99:Font,Bold
Gui,99:Add,Text,y+10,Find this on GitHub
Gui,99:Font
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 G1GITHUB,https://github.com/a-henderson/autohotkey-transcription-audio-loop
Gui,99:Font

Gui,99:Font,Bold
Gui,99:Add,Text,y+10,AutoHotkey
Gui,99:Font
Gui,99:Add,Text,y+10,This tool was made using the powerful
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,99:Font

Gui,99:Show,,%applicationname% About
Return

1GITHUB:
Run,https://github.com/a-henderson/autohotkey-transcription-audio-loop
Return

AUTOHOTKEY:
Run,http://www.autohotkey.com,,UseErrorLevel
Return

99GuiClose:
Gui,99:Destroy
Return