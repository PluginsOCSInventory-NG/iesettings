'----------------------------------------------------------
' Plugin for OCS Inventory NG 2.x
' Script :		Retrieve Internet Explorer settings
' Version :		2.01
' Date :		05/11/2017
' Authors :		Guillaume PRIOU and Stéphane PAUTREL (acb78.com)
'----------------------------------------------------------
' OS checked [X] on	32b	64b	(Professionnal edition)
'	Windows XP		[ ]
'	Windows Vista	[X]	[X]
'	Windows 7		[X]	[X]
'	Windows 8.1		[X]	[X]	
'	Windows 10		[X]	[X]
' ---------------------------------------------------------
' NOTE : No checked on Windows 8
' ---------------------------------------------------------
On Error Resume Next

Const HKEY_LOCAL_MACHINE = &H80000002
Dim strRegistry, Result

Set WShell = CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:root\cimv2")

IEVersion = WShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\svcVersion")
If err.number <> 0 Then
	IEVersion = WShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Version")
End If
Err.Clear

strRegistry = "Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\"

Result = _
	"<IESETTINGS>" & VbCrLf &_
	"<VERSION>" & IEVersion & "</VERSION>" & VbCrLf

LastSession = _
	ReadRegStr (HKEY_LOCAL_MACHINE, strRegistry, "LastLoggedOnUser", 64)
	asplit = split(LastSession, "\")
	LastSession = asplit(1)

Result = _
	Result & "<LASTSESSION>" & LastSession & "</LASTSESSION>" & VbCrLf

Set ColItems = objWMIService.ExecQuery("SELECT * FROM Win32_UserAccount where name='" & LastSession & "'",,48)
For Each ObjItem in ColItems
	strRegistry = "HKEY_USERS\" & objItem.SID & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\"
	Proxyenable = WShell.RegRead(strRegistry & "ProxyEnable")

	If err.number = 0 Then
		Result = Result &	"<SID>" & objItem.SID & "</SID>" & VbCrLf &_
							"<PROXYENABLE>" & Proxyenable & "</PROXYENABLE>" & VbCrLf
		Err.Clear
		
		AutoConfURL = WShell.RegRead(strRegistry & "AutoConfigURL")
		If err.number = 0 Then
			Result = Result & "<AUTOCONFIGURL>" & AutoConfURL & "</AUTOCONFIGURL>" & VbCrLf
		Else
			Result = Result & "<AUTOCONFIGURL>No auto script</AUTOCONFIGURL>" & VbCrLf
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
		If err.number = 0 Then
			ProxyOver = replace(ProxyOver,"<local>","")
			Result = Result & "<PROXYOVERRIDE>" & ProxyOver & "</PROXYOVERRIDE>" & VbCrLf
		Else
			Result = Result & "<PROXYOVERRIDE>No local param</PROXYOVERRIDE>" & VbCrLf
		End If
	End If
Next

Function ReadRegStr (RootKey, Key, Value, RegType)
	Dim oCtx, oLocator, oReg, oInParams, oOutParams

	Set oCtx = CreateObject("WbemScripting.SWbemNamedValueSet")
	oCtx.Add "__ProviderArchitecture", RegType

	Set oLocator = CreateObject("Wbemscripting.SWbemLocator")
	Set oReg = oLocator.ConnectServer("", "root\default", "", "", , , , oCtx).Get("StdRegProv")

	Set oInParams = oReg.Methods_("GetStringValue").InParameters
		oInParams.hDefKey = RootKey
		oInParams.sSubKeyName = Key
		oInParams.sValueName = Value

	Set oOutParams = oReg.ExecMethod_("GetStringValue", oInParams, , oCtx)
	ReadRegStr = oOutParams.sValue
End Function

Result = Result & "</IESETTINGS>"
Wscript.Echo Result