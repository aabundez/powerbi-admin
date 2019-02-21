#Connect to the Power BI Service
try {
    Get-PowerBIAccessToken 
}
catch {
    Login-PowerBIServiceAccount
}

$wid = (Get-PowerBIWorkspace -Scope Organization -First 10 -Filter "name eq 'Workspace'").Id

$did = (Get-PowerBIDataset -WorkspaceId $wid -Name 'DatasetName' -Scope Organization).Id

Get-PowerBIDatasource -DatasetId $did -Scope Organization

$url = "groups/$wid/datasets/$did/datasources"
(Invoke-PowerBIRestMethod -Url $url -Method Get | ConvertFrom-Json).value | Export-Csv -Path "C:\temp\datasources.csv" -NoTypeInformation

Resolve-PowerBIError -Last