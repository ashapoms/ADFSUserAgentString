# ADFSUserAgentString
This script allows you to resolve an issue with access to Active Directory Federation Services (ADFS) from Android mobile devices and/or Android Emulators that are located inside corporate network.

Imagine that I’m software engineer who is developing Xamarin LOB app for my company. The app should use Azure AD for authentication. My company implemented federated identity based on Azure AD and ADFS, so every authentication request from corporate user leveraging mobile device goes to Azure AD and then Azure AD redirects the request to ADFS located in CorpNet. And that works well when I’m testing app on mobile device outside CorpNet:

![ADFS Extranet](https://github.com/ashapoms/ADFSUserAgentString/blob/master/img/ADFSExtranet.PNG)

But when I’m trying to do the same test within CorpNet I get an error from ADFS like this:

![ADFS Intranet](https://github.com/ashapoms/ADFSUserAgentString/blob/master/img/ADFSIntranet.PNG)

The problem is that by default, Windows Integrated Authentication (WIA) is enabled in ADFS in Windows Server 2012 R2 for authentication requests that occur within the intranet. WIA provides end users with seamless logon to the applications without having to manually entering their credentials. However, some devices and browsers (Android mobile devices in my case) are not capable of supporting WIA and as a result authentication requests from these devices fail.

The recommended approach is to fallback to forms-based authentication for such devices and browsers. To implement that ADFS administrators should edit **WIASupportedUserAgentStrings** property on AFDS server. The **WIASupportedUserAgentStrings** defines the user agents which support WIA. ADFS analyzes the user agent string when performing logins in a browser or browser control. If the component of the user agent string does not match any of the components of the user agent strings that are configured in **WIASupportedUserAgentStrings** property, ADFS will fall back to providing forms-based authentication. You can find more details [here](https://docs.microsoft.com/en-us/windows-server/identity/ad-fs/operations/configure-intranet-forms-based-authentication-for-devices-that-do-not-support-wia).

On the screenshot below you can see initial configuration of **WIASupportedUserAgentStrings** on corporate ADFS.

![Agent String Before](https://github.com/ashapoms/ADFSUserAgentString/blob/master/img/AgentStringBefore.PNG)

Pay attention to the last string: *Mozilla/5.0*. Because of that any browsers that have *Mozilla/5.0* as a substring in their user agent string has been forced to use WIA. For example, here are two user agent strings of Google Chrome browsers running on Windows and on Android respectively:
```
Mozilla/5.0 (Windows NT 10.0; Win64; x64)
Mozilla/5.0 (Linux; Android 7.1.1; XT1064 Build/MPBS24.65-34-4)      
```
Both have substring mentioned above, and both are enforced to use WIA. Chrome browser on Android smartphones doesn’t support WIA, ADFS prevents it from using forms-based authentication so it fails.

The first idea is to remove *Mozilla/5.0* from **WIASupportedUserAgentStrings** completely. Well, it could be solution. But as a result, we’ll actually disable WIA for all versions of Google Chrome browsers including running on Windows. In my company it is not right approach.

After several experiments we found some tricky string that helped to resolve the issue. And here is it:
```
Mozilla/5.0 (Windows NT
```
Yes, the second parenthesis is missed by intent – we need substring function used by ADFS to match any Windows version on NT kernel (Windows 2000 and later). For instance, for previous example with Chrome on Windows user agent string matching is marked in green:
```
Mozilla/5.0 (Windows NT 10.0; Win64; x64)
```
With this workaround we managed to fully fix the situation by running the PowerShell script that published in this repo. The final **WIASupportedUserAgentStrings** in our case looks like this:

![Agent String After](https://github.com/ashapoms/ADFSUserAgentString/blob/master/img/AgentStringAfter.PNG)