<#

.SYNOPSIS
Refresh user permissions.

.DESCRIPTION
 Refresh user permissions API call. See https://docs.microsoft.com/en-us/rest/api/power-bi/users/refreshuserpermissions

.EXAMPLE
./RefreshUserPermissions.ps1

.LINK
http://www.angelabundez.com

#>

Login-PowerBI

$token = Get-PowerBIAccessToken

$url = "https://api.powerbi.com/v1.0/myorg/RefreshUserPermissions"

Invoke-RestMethod -Headers $token -Uri $url -Method Post

Resolve-PowerBIError -Last