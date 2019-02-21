$CredentialName = " FILL ME IN "
$clientId = " FILL ME IN "
$subscriptionId = "FILL ME IN"

# Get Automation Credential 
Write-Output "Getting Credential `"$CredentialName`" from stored Automation-Credential ..." 
$Credential = Get-AutomationPSCredential -Name $CredentialName 
 
if ($Credential -eq $null) 
{ 
    throw "Could not retrieve '$CredentialName' credential asset. Check that you created this first in the Automation service." 
}   
# Get the username and password from the Automation Credential 
$pbiUsername = $Credential.UserName
$pbiPassword = $Credential.GetNetworkCredential().Password
Write-Output "Done!"


$authUrl = "https://login.windows.net/common/oauth2/token/"
$body = @{
    "resource" = “https://analysis.windows.net/powerbi/api";
    "client_id" = $clientId;
    "grant_type" = "password";
    "username" = $pbiUsername;
    "password" = $pbiPassword;
    "scope" = "openid"
}

Write-Output "Getting Authentication-Token ..." 
$authResponse = Invoke-RestMethod -Uri $authUrl –Method POST -Body $body
Write-Output "Done!"

$headers = @{
    "Content-Type" = "application/json";
    "Authorization" = $authResponse.token_type + " " + $authResponse.access_token
}

#Get Workspaces
$restURL = "https://api.powerbi.com/v1.0/myorg/admin/groups?`$top=10"
$ws = Invoke-RestMethod -Uri $restURL –Method GET -Headers $headers 
$ws.value | Export-Csv "workspaces.csv" -NoTypeInformation
$wsv = $ws.value


#Get Power BI Datasets

#Initiate PSCustomObject to collect Datasets
$refs = @()
$i = 0

#Start loop on each workspace
foreach ($w in $wsv) {

    $wid = $w.Id
    $wname = $w.Name
    $i = $i + 1

    Write-Host $i. "Workspace.id = " $wid " workspace.name = " $wname

    #Get datasets for workspace. If empty, continue to next workspace.
    $restURL = "https://api.powerbi.com/v1.0/myorg/admin/groups/$wid/datasets"
    $ds = Invoke-RestMethod -Uri $restURL –Method GET -Headers $headers 
    if(!$ds.value){continue}

    #Add Workspace information
    $ds.value | Add-Member -MemberType NoteProperty -Name 'workspaceid' -Value $wid
    $ds.value | Add-Member -MemberType NoteProperty -Name 'workspacename' -Value $wname

    #Append to final object
    $refs += $ds.value


   }

$refs | Export-Csv "datasets.csv" -NoTypeInformation

#Connect to AzureRM
Connect-AzureRmAccount -Credential $Credential
Select-AzureRmSubscription -Subscription $subscriptionId

#Set the Current Storage Account
Set-AzureRmCurrentStorageAccount -StorageAccountName "pbimonitor" -ResourceGroupName "pbidemo"
Set-AzureStorageBlobContent -Container "workspaces" -File workspaces.csv -Blob workspaces.csv -Force

#Set the Current Storage Account
Set-AzureRmCurrentStorageAccount -StorageAccountName "pbimonitor" -ResourceGroupName "pbidemo"
Set-AzureStorageBlobContent -Container "datasets" -File datasets.csv -Blob datasets.csv -Force
