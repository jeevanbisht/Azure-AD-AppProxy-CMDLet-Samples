<# 
 
.SYNOPSIS
	FomrsAppPublishSample.ps1 is a Windows PowerShell script to create an Appproxy App using powershell which uses Anonynous/Forms Based Authenticaion
.DESCRIPTION
	Version: 1.0.0
	FomrsAppPublishSample.ps1 is a Windows PowerShell script to publish the Internal Web Application running Anonynous/Forms Based Authneticaiton and pulish using Powershell
    You can simply update the values and publish the app and assign appropraite user/group access permissions.
    
.DISCLAIMER
	THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
#> 


##FormBasedAuth
$displayName="ContosoExpense"
$connectorGroupName="prodapps"
$internalURL="http://apps/formssample/"
$externalURL="https://expense-jbgtp1.msappproxy.net/formssample/"

$connectorGroup = Get-AzureADApplicationProxyConnectorGroup |  where-object {$_.name -eq $connectorGroupName}
New-AzureADApplicationProxyApplication -DisplayName $displayName -InternalUrl $internalURL -ConnectorGroupId $connectorGroup.id -ExternalUrl $externalURL -ExternalAuthenticationType AadPreAuthentication 
$AppProxyApp1=Get-AzureADApplication  | where-object {$_.Displayname -eq $displayName}
#Set-AzureADApplicationProxyApplicationSingleSignOn -ObjectId $AppProxyApp1.Objectid -SingleSignOnMode None 

##Assign to users
$userid="user0@jblab.work"
$user=get-azureaduser -ObjectId $userid
$AppProxyAppServicePrincipal1=Get-AzureADServicePrincipal | where-object {$_.Displayname -eq $displayName}
New-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId -PrincipalId $user.ObjectId -ResourceId $AppProxyAppServicePrincipal1.ObjectId -Id ([Guid]::Empty)


##Assign to groups
$userGroupName="HRWebAppUsers"
$userGroup=Get-AzureADGroup | where-object {$_.DisplayName -eq $userGroupName}
New-AzureADGroupAppRoleAssignment -ObjectId $userGroup.ObjectId -PrincipalId $userGroup.ObjectId -ResourceId $AppProxyAppServicePrincipal1.ObjectId -Id ([Guid]::Empty)

