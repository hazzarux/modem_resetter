#cs
#APPLICATION# =================================================================================================================
Name							: ModemResetter v1.1
Description						: Resets home modem for generating a new IP.
Author 							: YigitOzkan
Modified						;
Remarks 						: Uses Internet Explorer  + 192.168.1.1 + no password
Related 						;
Link 							;
Example 						;
Changes since previous version	;
===============================================================================================================================
#ce

Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)

#include <IE.au3>

;BlockInput(1)

;Variables------------------------
$IESleepTime = 3000
$generalsleeptime = 15000 ;15 seconds
$x = 2
$y = 2
$rebootFile = "ModemReboots.txt"
;	@SEC Seconds value of clock. Range is 00 to 59
;	@MIN Minutes value of clock. Range is 00 to 59
;	@HOUR Hours value of clock in 24-hour format. Range is 00 to 23
;	@MDAY Current day of month. Range is 01 to 31
;	@MON Current month. Range is 01 to 12
;	@YEAR Current four-digit year
;	@WDAY Numeric day of week. Range is 1 to 7 which corresponds to Sunday through Saturday.
;	@YDAY Current day of year. Range is 1 to 366 (or 365 if not a leap year)
$rebootinfo = @MDAY & "/" & @MON & "/" & @YEAR & "					" & @HOUR & ":" & @MIN & ":" & @SEC
;---------------------------------
$begin = TimerInit()

$oIE = _IECreate("192.168.1.1")

WinWaitActive("Belgacom - Windows Internet Explorer")
WinSetState("Belgacom - Windows Internet Explorer", "", @SW_MAXIMIZE)

Sleep($IESleepTime)

ControlClick("Belgacom - Windows Internet Explorer", "", 0, 'left', 1, 410, 562)   ;disconnect
Sleep($generalsleeptime)
While $x = 2
	$varDisconnect = Ping("www.Google.com", 250) ;checks if connected to internet
If $varDisconnect Then; also possible:  If @error = 0 Then ...
	ControlClick("Belgacom - Windows Internet Explorer", "", 0, 'left', 1, 410, 562) ;disconnect
	Sleep($generalsleeptime)
Else
	$x = 3
EndIf
WEnd

WinWaitActive("Belgacom - Windows Internet Explorer")
ControlClick("Belgacom - Windows Internet Explorer", "", 0, 'left', 1, 315, 561)
Sleep($generalsleeptime)
While $y = 2
$varConnect = Ping("www.Google.com", 250)
If $varConnect Then; also possible:  If @error = 0 Then ...
	$y = 3
Else
	ControlClick("Belgacom - Windows Internet Explorer", "", 0, 'left', 1, 315, 561)
	Sleep($generalsleeptime)
EndIf
WEnd

WinWaitActive("Belgacom - Windows Internet Explorer")
WinClose("Belgacom - Windows Internet Explorer")

$dif = TimerDiff($begin)
FileWrite($rebootFile, $rebootinfo & "					" & $dif & @CRLF)