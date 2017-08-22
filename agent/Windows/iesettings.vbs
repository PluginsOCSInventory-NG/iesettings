'----------------------------------------------------------
' Plugin for OCS Inventory NG 2.x
' Script :		Retrieve Internet Explorer settings
' Version :		2.00
' Date :		05/08/2017
' Authors :		Guillaume PRIOU and Stéphane PAUTREL (acb78.com)
'----------------------------------------------------------
' OS checked [X] on	32b	64b	(Professionnal edition)
'	Windows XP	[X]	[ ]
'	Windows Vista	[X]	[N]
'	Windows 7	[N]	[N]
'	Windows 8.1	[N]	[N]	
'	Windows 10	[X]	[N]
' ---------------------------------------------------------
' NOTE : No checked on Windows 8
' ---------------------------------------------------------
On error resume next

Dim objWMIService, WShell, colOperatingSystems, objOperatingSystem
Dim IEVersion, LastSession, asplit, ColItems, ObjItem, strRegistry
Dim Proxyenable, Result, AutoConfURL, ProxyServ, ProxyOver

Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set WShell = CreateObject("WScript.Shell")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colOperatingSystems
	If InStr(objOperatingSystem.version,"5.1.")<>0 Or InStr(objOperatingSystem.version,"5.2.")<>0 Then 'OS is windows XP or 2003
		IEVersion = WShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Version")
		LastSession = WShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultUserName")
	Else
		IEVersion = WShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\svcVersion")
		LastSession = WShell.RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\LastLoggedOnUser")
		asplit = split(LastSession, "\")
		LastSession = asplit(1)
	End If
Next

Set ColItems = objWMIService.ExecQuery("SELECT * FROM Win32_UserAccount where name='" & LastSession & "'",,48)
For Each ObjItem in ColItems
	strRegistry = "HKEY_USERS\" & objItem.SID & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\"
	Proxyenable = WShell.RegRead(strRegistry & "ProxyEnable")

	If err.number = 0 Then
		Result = "<IESETTINGS>" & VbCrLf
		Result = Result & "<VERSION>" & IEVersion & "</VERSION>" & VbCrLf
		Result = Result & "<LASTSESSION>" & LastSession & "</LASTSESSION>" & VbCrLf
		Result = Result & "<SID>" & objItem.SID & "</SID>" & VbCrLf
		Result = Result & "<PROXYENABLE>" & Proxyenable & "</PROXYENABLE>" & VbCrLf
		Err.Clear
		
		AutoConfURL = WShell.RegRead(strRegistry & "AutoConfigURL")
		If err.number = 0 Then
			Result = Result & "<AUTOCONFIGURL>" & AutoConfURL & "</AUTOCONFIGURL>" & VbCrLf
		Else
			Result = Result & "<AUTOCONFIGURL>Pas de script auto</AUTOCONFIGURL>" & VbCrLf
		End If
		Err.Clear
		
		ProxyServ = WShell.RegRead(strRegistry & "ProxyServer")
		If err.number = 0 Then
			Result = Result & "<PROXYSERVER>" & ProxyServ & "</PROXYSERVER>" & VbCrLf
		Else
			Result = Result & "<PROXYSERVER>Pas de proxy</PROXYSERVER>" & VbCrLf
		End If
		Err.Clear
		
		ProxyOver = WShell.RegRead(strRegistry & "ProxyOverride")
		ProxyOver = replace(ProxyOver,"<local>","")
		If err.number = 0 Then
			Result = Result & "<PROXYOVERRIDE>" & ProxyOver & "</PROXYOVERRIDE>" & VbCrLf
		Else
			Result = Result & "<PROXYOVERRIDE>Pas de param local</PROXYOVERRIDE>" & VbCrLf
		End If

		Result = Result & "</IESETTINGS>" & VbCrLf
		Wscript.echo Result
	End If
Next
Err.Clear
