<#############################################################
 #                                                           #
 # ADFSUserAgents.ps1										 #
 #                                                           #
 #############################################################>

<#
 .Synopsis
	This script allows you to resolve an issue with access to Active Directory Federation Services (ADFS)
    from Android mobile devices and/or Android Emulators that are located inside corporate network.
 #>


# Get current ADFS properties  
$myadfs = Get-AdfsProperties

# Remove user agent strings that contain "Mozilla/5.0"
$newAgents = $myadfs.WIASupportedUserAgents -notlike "Mozilla/5.0"
Set-AdfsProperties -WIASupportedUserAgents $newAgents

# Add user agent string that contains "Mozilla/5.0 (Windows NT" 
Set-AdfsProperties -WIASupportedUserAgents ((Get-ADFSProperties | Select -ExpandProperty WIASupportedUserAgents) + “Mozilla/5.0 (Windows NT”)

# List all user agent strings to check result 
Get-AdfsProperties | Select -ExpandProperty WIASupportedUserAgents
