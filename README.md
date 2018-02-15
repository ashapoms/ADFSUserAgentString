# ADFSUserAgentString
This script allows you to resolve an issue with access to Active Directory Federation Services (ADFS) from Android mobile devices and/or Android Emulators that are located inside corporate network.

Imagine that I’m software engineer who is developing Xamarin LOB app for my company. The app should use Azure AD for authentication. My company implemented federated identity based on Azure AD and ADFS, so every authentication request from corporate user leveraging mobile device goes to Azure AD and then Azure AD redirects the request to ADFS located in CorpNet. And that works well when I’m testing app on mobile device outside CorpNet:

