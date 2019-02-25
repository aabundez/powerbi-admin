<#

.SYNOPSIS
 Exports datasource details given a Power BI Workspace and Dataset published to the PBI Service.

.DESCRIPTION
 Need the details of all the data sources used in a report? Publish it to the service and use this script.
 Uses the Power BI powershell cmdlets: 
    https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps
 and the Power BI REST API endpoints: 
    https://docs.microsoft.com/en-us/rest/api/power-bi/

.EXAMPLE
 & '.\Export Datasources.ps1' -Workspace "BI Team" -Dataset "Executive Dashboard" -Display

.LINK
 http://www.angelabundez.com

#>


#Connect to the Power BI Service
param (
    [Parameter(Position = 0, Mandatory = $true)][string]$Workspace,
    [Parameter(Position = 1, Mandatory = $true)][string]$Dataset,
    [Parameter(Position = 2)][switch]$Display
    #[Parameter(Position = 3)][switch]$exportdata = $false
)

try {
    Get-PowerBIAccessToken 
}
catch {
    Login-PowerBIServiceAccount
}


$wid = (Get-PowerBIWorkspace -Scope Organization -First 10 -Filter "name eq '$Workspace'").Id
$did = (Get-PowerBIDataset -WorkspaceId $wid -Name $Dataset -Scope Organization).Id


$url = "groups/$wid/datasets/$did/datasources"
if ($Display) {
    (Invoke-PowerBIRestMethod -Url $url -Method Get | ConvertFrom-Json).value
}
#(Invoke-PowerBIRestMethod -Url $url -Method Get | ConvertFrom-Json).value | Export-Csv -Path "C:\temp\datasources.csv" -NoTypeInformation

#Resolve-PowerBIError -Last