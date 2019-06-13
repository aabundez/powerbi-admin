<#

.SYNOPSIS
 Collect Power BI assets across a tenant. 
 Must have Power BI Administration or Global Administrator role in O365.

.DESCRIPTION
 The script relies on Power BI REST API and Power BI Powershell module. 
 For more information, reference Microsoft docs: 
 https://docs.microsoft.com/en-us/rest/api/power-bi/
 https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps

.EXAMPLE
 ./PBI_Inventory.ps1

.LINK
 https://docs.microsoft.com/en-us/rest/api/power-bi/
 https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps

#>

#Install Power BI Module
$moduleinstalled = Find-Module -Name MicrosoftPowerBIMgmt
if (!$moduleInstalled){
    Install-Module -Name MicrosoftPowerBIMgmt
}
else{
    Write-Host "Power BI PS Module Installed!"
}

#Get Headers
try {
    $authtoken = Get-PowerBIAccessToken
}
catch {
    Write-Host "Have not logged in yet. Initiating login..."
    Login-PowerBIServiceAccount
}

#Set Output Path
$path = "C:\tempug"

#Get Power BI Workspaces
Write-Host "Exporting Power BI Workspaces..."
$results = Invoke-RestMethod -Headers $authtoken -Uri "https://api.powerbi.com/v1.0/myorg/admin/groups?`$top=100&`$expand=users" -Method Get
$ws = $results.value
# Export Power BI Workspaces 
$ws | Export-Csv -Path "$path\workspaces.csv" -NoTypeInformation

#Get Power BI Datasets
Write-Host "Exporting Power BI Datasets..."
#Initiate PSCustomObject to collect Datasets
$refs = @()
$i = 0

#Start loop on each workspace
foreach ($w in $ws) {

    $wid = $w.Id
    $wname = $w.Name
    $i = $i + 1

    Write-Host $i. "Workspace.id = " $wid " workspace.name = " $wname

    # Base dataset of Datasets
    $results = Invoke-RestMethod -Headers $authtoken -Uri "https://api.powerbi.com/v1.0/myorg/admin/groups/$wid/datasets" -Method Get
    $ds = $results.value
    if(!$ds){continue}

    #Add Workspace information
    $ds | Add-Member -MemberType NoteProperty -Name 'workspaceid' -Value $wid
    $ds | Add-Member -MemberType NoteProperty -Name 'workspacename' -Value $wname

    #Append to final object
    $refs += $ds
}

$refs | Export-Csv -Path "$path\datasets.csv" -NoTypeInformation

# Get Power BI Reports
Write-Host "Exporting Power BI Reports..."
$rp = Get-PowerBIReport -Scope Organization
$rp | Export-Csv -Path "$path\reports.csv" -NoTypeInformation


Logout-PowerBIServiceAccount
#Resolve-PowerBIError -Last