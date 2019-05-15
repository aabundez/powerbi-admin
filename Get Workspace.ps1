<#

.SYNOPSIS
 Collect Power BI Workspaces across a tenant.

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

#Get Power BI Workspaces
$ws = Get-PowerBIWorkspace -Scope Organization -Top 2000 -Filter "type eq '$workspace_name'"
$ws
$ws | Export-Csv -Path "C:\temp\workspaces.csv" -NoTypeInformation