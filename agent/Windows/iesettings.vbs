'----------------------------------------------------------
' Plugin for OCS Inventory NG 2.x
' Script : Retrieve Internet Explorer settings
' Version : 2.0
' Date : 05/08/2017
' Authors : Guillaume PRIOU and Stéphane PAUTREL
'----------------------------------------------------------
On error resume next

Dim ColItems, ObjItem, Sid, strComputer, objWMIService, asplit, Result

Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set WShell = CreateObject("WScript.Shell")

Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colOperatingSystems
	If InStr(objOperatingSystem.version,"5.1.")<>0 Or InStr(objOperatingSystem.version,"5.2.")<>0 Then 'OS is windows XP or 2003
		LastSession = WShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultUserName")
	Else
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
		Result = Result & "<LASTSESSION>" & LastSession & "</LASTSESSION>" & VbCrLf
		Result = Result & "<SID>" & objItem.SID & "</SID>" & VbCrLf
		Result = Result & "<PROXYENABLE>" & Proxyenable & "</PROXYENABLE>" & VbCrLf
		Err.Clear
		
		AutoConfURL = WShell.RegRead(strRegistry & "AutoConfigURL")
		If err.number = 0 Then
			Result = Result & "<AUTOCONFIGURL>" & AutoConfURL & "</AUTOCONFIGURL>" & VbCrLf
		Else
			Result = Result & "<AUTOCONFIGURL>No script</AUTOCONFIGURL>" & VbCrLf
		End If
		Err.Clear
		
		ProxyServ = WShell.RegRead(strRegistry & "ProxyServer")
		If err.number = 0 Then
			Result = Result & "<PROXYSERVER>" & ProxyServ & "</PROXYSERVER>" & VbCrLf
		Else
			Result = Result & "<PROXYSERVER>No proxy</PROXYSERVER>" & VbCrLf
		End If
		Err.Clear
		
		ProxyOver = WShell.RegRead(strRegistry & "ProxyOverride")
		ProxyOver = replace(ProxyOver,"<local>","")
		If err.number = 0 Then
			Result = Result & "<PROXYOVERRIDE>" & ProxyOver & "</PROXYOVERRIDE>" & VbCrLf
		Else
			Result = Result & "<PROXYOVERRIDE>No proxy override</PROXYOVERRIDE>" & VbCrLf
		End If

		Result = Result & "</IESETTINGS>" & VbCrLf
		Wscript.echo Result
	End If
Next
Err.Clear