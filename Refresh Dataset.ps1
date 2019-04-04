<#

.SYNOPSIS
 Refreshes Dataset in Power BI and see the status.

.DESCRIPTION
 The script relies on the 'Refresh History in Group' API call:
 https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/getrefreshhistoryingroup

.EXAMPLE
./Refresh Dataset.ps1

.LINK
http://www.angelabundez.com

#>


#Connect to the Power BI Service
try {
    Get-PowerBIAccessToken 
}
catch {
    Login-PowerBIServiceAccount
}


#Set your environment 
$workspace_name = 'Workspace'
$dataset_name = 'Dataset'


#Get Workspace Id
$ws = Get-PowerBIWorkspace -Scope Organization -Filter "name eq '$workspace_name'"
$wid = $ws.Id
"Workspace Id is $wid"

#Get Dataset Id
$d = Get-PowerBIDataset -Scope Organization -WorkspaceId $wid -Filter "name eq 'DW Dashboard Visuals'"
$did = $d.Id
"Datset Id is $did"

#Refresh Dataset
$url = "groups/$wid/datasets/$did/refreshes"
#"API URL is $url"
Invoke-PowerBIRestMethod -Url $url -Method Post

#Get Refresh History
Invoke-PowerBIRestMethod -Url $url -Method Get

#Logout of Power BI Service
#Logout-PowerBIServiceAccount