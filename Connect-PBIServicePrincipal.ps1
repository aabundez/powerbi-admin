<#

.SYNOPSIS
    Connects to Power BI REST API via Service Principal.

.DESCRIPTION
    Uses Azure App Registration ID and Secret Key to authenticate to the Power BI REST API.
    TO-DO: 
    

.EXAMPLE
    .\Connect-PBIServicePrincipal.ps1


.LINK
    https://docs.microsoft.com/en-us/power-bi/developer/embed-service-principal

#>



#Registered App credentials
$aid = "APP_ID" 
$skey = "SECRET_KEY" 
$tenant = "tenant.onmicrosoft.com"

#Create PSCredential
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