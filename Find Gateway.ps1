#Find Gateway by Workspace and Dataset
#Note: only returns results for Gateways you are an administrator for. Otherwise, errors will occur. Power BI Admin or Global Admin roles in O365 do not inherit.


Login-PowerBIServiceAccount

$wid = (Get-PowerBIWorkspace -Scope Organization -First 100 -Filter "name eq 'IT-Analytics'").Id
"Workspace Id: $wid"


$did = (Get-PowerBIDataset -WorkspaceId $wid -Name 'Dataset' -Scope Organization).Id
"Dataset Id: $did"


#https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/getgatewaydatasourcesingroup
$url = "groups/$wid/datasets/$did/Default.GetBoundGatewayDatasources"
(Invoke-PowerBIRestMethod -Url $url -Method Get | ConvertFrom-Json).value

#https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/discovergatewaysingroup
#Note: appears to only display Gateways you are an administrator for. Need to do further testing
$url = "groups/$wid/datasets/$did/Default.DiscoverGateways"
(Invoke-PowerBIRestMethod -Url $url -Method Get | ConvertFrom-Json).value


$url = "gateways/36c45123-0853-4f51-9618-1110cfce6c25"
Invoke-PowerBIRestMethod -Url $url -Method Get



Resolve-PowerBIError -Last