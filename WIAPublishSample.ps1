<# 
 
.SYNOPSIS
	WIAPublishSample.ps1 is a Windows PowerShell script to create an Appproxy App using powershell which uses Windows Integrated Authentication
.DESCRIPTION
	Version: 1.0.0
	WIAPublishSample.ps1 is a Windows PowerShell script to publish the Internal Web Application running Kerberos and pulish using Powershell
    You can simply update the values and publish the app and assign appropraite user/group access permissions.
    
.DISCLAIMER
	THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
#> 


$displayName="ContosoHRWEB" 
$connectorGroupName="prodapps"
$internalURL="http://apps/wiasample/"
$externalURL="https://hrweb-jbgtp1.msappproxy.net/wiasample/"
$spn ="http/apps.jblab.work"

$connectorGroup = Get-AzureADApplicationProxyConnectorGroup |  where-object {$_.name -eq $connectorGroupName}
New-AzureADApplicationProxyApplication -DisplayName $displayName -InternalUrl $internalURL -ConnectorGroupId $connectorGroup.id -ExternalUrl $externalURL -ExternalAuthenticationType AadPreAuthentication 
$AppProxyApp1=Get-AzureADApplication  | where-object {$_.Displayname -eq $displayName}
Set-AzureADApplicationProxyApplicationSingleSignOn -ObjectId $AppProxyApp1.Objectid -SingleSignOnMode OnPremisesKerberos -KerberosInternalApplicationServicePrincipalName $spn -KerberosDelegatedLoginIdentity OnPremisesUserPrincipalName

##Assign Access to User
$userid="user0@jblab.work"
$user=get-azureaduser -ObjectId $userid
$AppProxyAppServicePrincipal1=Get-AzureADServicePrincipal | where-object {$_.Displayname -eq $displayName}
New-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId -PrincipalId $user.ObjectId -ResourceId $AppProxyAppServicePrincipal1.ObjectId -Id ([Guid]::Empty)


##Assign Access to Group
$userGroupName="HRWebAppUsers"
$userGroup=Get-AzureADGroup | where-object {$_.DisplayName -eq $userGroupName}
New-AzureADGroupAppRoleAssignment -ObjectId $userGroup.ObjectId -PrincipalId $userGroup.ObjectId -ResourceId $AppProxyAppServicePrincipal1.ObjectId -Id ([Guid]::Empty)

