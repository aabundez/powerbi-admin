<#

.SYNOPSIS
 Collect Power BI assets across a tenant.

.DESCRIPTION
 The script relies on multiple API end points from the Power BI Rest API. 
 For more information, reference Microsoft docs: https://docs.microsoft.com/en-us/rest/api/power-bi/

.EXAMPLE
 ./PBI_Inventory.ps1

.LINK
 https://docs.microsoft.com/en-us/rest/api/power-bi/

#>

#Connect to the Power BI Service
try {
    Get-PowerBIAccessToken 
}
catch {
    Login-PowerBIServiceAccount
}

#Get Power BI Workspaces
$ws = Get-PowerBIWorkspace -Scope Organization -Top 2000
$ws | Export-Csv -Path "C:\temp\workspaces.csv" -NoTypeInformation


#Get Power BI Datasets

#Initiate PSCustomObject to collect Datasets
$refs = @()
$i = 0

#Start loop on each workspace
foreach ($w in $ws) {

    $wid = $w.Id
    $wname = $w.Name
    $i = $i + 1

    Write-Host $i. "Workspace.id = " $wid " workspace.name = " $wname

    #Get datasets for workspace. If empty, continue to next workspace.
    $ds = Get-PowerBIDataset -WorkspaceId $wid -Scope Organization -ErrorAction SilentlyContinue 
    if(!$ds){continue}

    #Add Workspace information
    $ds | Add-Member -MemberType NoteProperty -Name 'workspaceid' -Value $wid
    $ds | Add-Member -MemberType NoteProperty -Name 'workspacename' -Value $wname

    #Append to final object
    $refs += $ds


   }

$refs | Export-Csv -Path "C:\temp\datasets.csv" -NoTypeInformation

# Get Power BI Reports

$rp = Get-PowerBIReport -Scope Organization
$rp | Export-Csv -Path "C:\temp\reports.csv" -NoTypeInformation


Logout-PowerBIServiceAccount
#Resolve-PowerBIError -Last