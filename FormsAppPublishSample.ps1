
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

