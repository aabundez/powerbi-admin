<# REMOVE USER FROM WORKSPACE AS POWER BI ADMIN 

Requirements:
-Install Power BI Powershell module (https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps)
-Interactive login
-User must be Power BI Admin
-Run in steps

#>

#1. Get your access token
Login-PowerBI
$authtoken = Get-PowerBIAccessToken


#2. Fill out your workspace Id
$groupId = "b81c4cc2-3c2f-42fe-b771-31255f86a93a"

#3. See what permissions you need to clear (user or group)
$url = "https://api.powerbi.com/v1.0/myorg/admin/groups/$groupId/users"
$results = Invoke-RestMethod -Uri $url -Headers $authtoken -Method Get
$results.value

#4. Fill out the user or security group Id you want to remove
$userOrGroupId = "759707a6-fcab-498d-b830-5a08e78d0cec"

#5. Remove user from workspace
$url = "https://api.powerbi.com/v1.0/myorg/admin/groups/$groupId/users/$userOrGroupId"
$results = Invoke-RestMethod -Uri $url -Headers $authtoken -Method Delete

#6. Check that the user has been removed
$url = "https://api.powerbi.com/v1.0/myorg/admin/groups/$groupId/users"
$results = Invoke-RestMethod -Uri $url -Headers $authtoken -Method Get
$results.value