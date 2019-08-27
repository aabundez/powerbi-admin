<#

.SYNOPSIS
 Collect Premium Capacities in a Power BI Tenant. 
 

.DESCRIPTION
 The script relies on the Power BI Powershell module. Run this script as an administrator if you have not yet installed the module.

.EXAMPLE
 ./Get-Capacities.ps1

.LINK
 https://docs.microsoft.com/en-us/rest/api/power-bi/admin/getcapacitiesasadmin

#>

#Install Power BI Module (requires elevated permissions to run)
$moduleinstalled = Find-Module -Name MicrosoftPowerBIMgmt
if (!$moduleInstalled){
    Install-Module -Name MicrosoftPowerBIMgmt
}
else{
    Write-Host "Power BI PS Module Installed!"
}

# Authenticate to Power BI
try {
    $authtoken = Get-PowerBIAccessToken
}
catch {
    Write-Host "Have not logged in yet. Initiating login..."
    $auth = Login-PowerBIServiceAccount
    Write-Host "Successfully logged in as $($auth.UserName)"
}

# Call "Get Capacities As admin"
if(!$authtoken) { $authtoken = Get-PowerBIAccessToken}
$url = "https://api.powerbi.com/v1.0/myorg/admin/capacities"


(Invoke-RestMethod -Headers $authtoken -Uri $url -Method Get).value




