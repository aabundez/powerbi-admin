<#

.SYNOPSIS
 Collect Power BI user memberships across a tenant.

.DESCRIPTION
 The script relies on multiple API end points from the Power BI Rest API. 
 For more information, reference Microsoft docs: https://docs.microsoft.com/en-us/rest/api/power-bi/

.EXAMPLE
 

.LINK
 

#>

#Connect to the Power BI Service
try {
    Get-PowerBIAccessToken 
}
catch {
    Login-PowerBIServiceAccount
}

#Set your environment 
$workspace_name = 'Workspace Name'


#Get Workspace Id
$ws = Get-PowerBIWorkspace -Scope Organization -Filter "name eq '$workspace_name'"
$wid = $ws.Id
"Workspace Id is $wid"

#TO-DO: Add conditional logic if Workspace is of type "Group"
#Add-PowerBIGroupUser -Scope Organization -Id $wid -UserEmailAddress 'angel@dmsandbox.onmicrosoft.com' -AccessRight Admin


#Get users
$url = "groups/$wid/users"
#"API URL is $url"
Invoke-PowerBIRestMethod -Url $url -Method Get

Resolve-PowerBIError -Last
Logout-PowerBIServiceAccount