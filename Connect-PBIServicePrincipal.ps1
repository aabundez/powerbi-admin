<#

.SYNOPSIS
    Connects to Power BI REST API via Service Principal.

.DESCRIPTION
    Working example of how to authenticate to Power BI REST API with Service Principal.
    Follow instructions in the LINK provided to authorize the Service Principal and 
    assign it permissions to new workspaces. 
    Two important notes: 
        * admin API calls are not supported
        * only New Workspaces (v2) are supported    

.EXAMPLE
    .\Connect-PBIServicePrincipal.ps1


.LINK
    https://docs.microsoft.com/en-us/power-bi/developer/embed-service-principal

#>

# Registered App credentials
$aid = "APP_ID" 
$skey = "SECRET_KEY" 

# Tenant name or tenant ID. Tenant ID is available in "About Power BI" menu item in Power BI Service.
$tenant = "tenant.onmicrosoft.com"

# Create PSCredential
$skeysecure = ConvertTo-SecureString -String $skey -AsPlainText -Force  #Secure the string
$creds = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $aid, $skeysecure   #Create PSCredential

#Login
Connect-PowerBIServiceAccount -ServicePrincipal -Credential $creds -Tenant $tenant
$authtoken = Get-PowerBIAccessToken

#Test Power BI cmdlet
$url = "https://api.powerbi.com/v1.0/myorg/groups"
(Invoke-RestMethod -Headers $authtoken -Uri $url -Method Get).value


#Resolve-PowerBIError -Last
#Logout-PowerBI
