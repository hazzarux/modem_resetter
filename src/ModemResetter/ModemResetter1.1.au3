
; #APPLICATION# =================================================================================================================
; Name...........: ModemResetter v1.1
; Description ...: Resets home modem for generating a new IP.
; Author ........: YigitOzkan
; Modified.......;
; Remarks .......: Uses Google Chrome  + 192.168.1.1 + no password
; Related .......;
; Link ..........;
; Example .......;
; CHANGES...........;
; ===============================================================================================================================
;BlockInput(1)

;Variables------------------------
$googleChromeSleepTime = 3000
$generalsleeptime = 15000 ;10 seconds
$rebootFile = "ModemReboots.txt"
;	@SEC Seconds value of clock. Range is 00 to 59
;	@MIN Minutes value of clock. Range is 00 to 59
;	@HOUR Hours value of clock in 24-hour format. Range is 00 to 23
;	@MDAY Current day of month. Range is 01 to 31
;	@MON Current month. Range is 01 to 12
;	@YEAR Current four-digit year
;	@WDAY Numeric day of week. Range is 1 to 7 which corresponds to Sunday through Saturday.
;	@YDAY Current day of year. Range is 1 to 366 (or 365 if not a leap year)
$rebootinfo = @MDAY & "/" & @MON & "/" & @YEAR & "			" & @HOUR & ":" & @MIN & ":" & @SEC
;---------------------------------
$begin = TimerInit()
ShellExecute("C:\Users\Magnet\Desktop\GoogleChrome.lnk")
WinWaitActive("about:blank - Google Chrome")
WinSetState("about:blank - Google Chrome", "", @SW_MAXIMIZE)

MouseClick("left", 1906, 81)

ControlClick("Google Chrome", "", 9496544, 1, 109, 12)
Send("^a")
ClipPut("http://192.168.1.1/")
Send("^v")
Sleep(1000)
Send("{ENTER}")

WinWait("Belgacom - Google Chrome")
WinActivate("Belgacom - Google Chrome")
MouseClick("left", 414, 652) ;disconnect
Sleep($generalsleeptime)
$varDisconnect = Ping("www.Google.com", 250) ;checks if connected to internet
If $varDisconnect Then; also possible:  If @error = 0 Then ...
	MouseClick("left", 414, 652) ;disconnect
	Sleep($generalsleeptime)
Else
EndIf

WinWait("Belgacom - Google Chrome")
WinActivate("Belgacom - Google Chrome")
MouseClick("left", 318, 654)
Sleep($generalsleeptime)
$varConnect = Ping("www.Google.com", 250)
If $varConnect Then; also possible:  If @error = 0 Then ...

Else
	MouseClick("left", 318, 654)
	Sleep($generalsleeptime)
EndIf

WinWait("Belgacom - Google Chrome")
WinActivate("Belgacom - Google Chrome")
WinClose("Belgacom - Google Chrome")

$dif = TimerDiff($begin)
FileWrite($rebootFile, $rebootinfo & "			" & $dif & @CRLF)