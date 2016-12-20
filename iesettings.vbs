' This script was written to gather information about the running processes for OCS Invetory NG.
' Note, that the process memory is being reported based on the Working Set Size across all operating systems.
' This is the figure that win2k and xp is reporting in their task managers. Vista, 7 and 2008 are
' by default showing the Private Working Set values in their task managers which is slightly diferent,
' and is not suppoprted by win2k and xp.

'start with detecting the operating system in use
strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colOperatingSystems
    If InStr(objOperatingSystem.version,"5.0.")<>0 Then  'os is windows 2000
        CompPropNum=16
        DescrPropNum=17
    End If
    If InStr(objOperatingSystem.version,"5.1.")<>0 Or InStr(objOperatingSystem.version,"5.2.")<>0 Then 'os is windows XP or 2003
        CompPropNum=35
        DescrPropNum=36
    End If
    If InStr(objOperatingSystem.version,"6.0.")<>0 Or InStr(objOperatingSystem.version,"6.1.")<>0 Then 'os is windows Vista or 2008 or Windows 7 or 2008 r2
        CompPropNum=33
        DescrPropNum=34
    End If
Next

If CompPropNum=0 Then wscript.quit 2              'operating system not supported, exiting with code 2

Wscript.Echo "<IESETTINGS>"
set c=CreateObject("WScript.Shell" )
DerniereSession = c.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultUserName")
Wscript.Echo "<LASTSESSION>"& DerniereSession &"</LASTSESSION>"
Set WshNetwork = WScript.CreateObject("WScript.Network")
user = WshNetwork.UserName

Dim ColItems, ObjItem, Sid, strComputer, Wmi
strComputer = "."
Set Wmi = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
Set ColItems = Wmi.ExecQuery("SELECT * FROM Win32_UserAccount where name='"& DerniereSession &"'",,48)
For Each ObjItem in ColItems
    SID = objItem.SID
Next
Wscript.Echo "<SID>"& SID &"</SID>"
proxyenable = c.RegRead("HKEY_USERS\"& SID &"\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable")
If err.number = 0 then
    Wscript.Echo "<PROXYENABLE>" & proxyenable & "</PROXYENABLE>"
else
    Wscript.Echo "<PROXYENABLE> READ ERROR </PROXYENABLE>"
end if
err.clear
autoconfurl = c.RegRead("HKEY_USERS\"& SID &"\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\AutoConfigURL")
if err.number = 0 then
Wscript.Echo "<AUTOCONFIGURL>" & autoconfurl & "</AUTOCONFIGURL>"
else
Wscript.Echo "<AUTOCONFIGURL> READ ERROR </AUTOCONFIGURL>"
end if
err.clear
proxyserv = c.RegRead("HKEY_USERS\"& SID &"\software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyServer")
if err.number = 0 then
Wscript.Echo "<PROXYSERVER>" & proxyserv & "</PROXYSERVER>"
else
Wscript.Echo "<PROXYSERVER> READ ERROR </PROXYSERVER>"
end if
err.clear
Wscript.Echo "</IESETTINGS>"
