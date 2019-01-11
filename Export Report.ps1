<#

.SYNOPSIS
 Attempts to exports report given Workspace name and report name. 

.DESCRIPTION
 This script uses the Export Report in Group API endpoint: https://docs.microsoft.com/en-us/rest/api/power-bi/reports/exportreportingroup
 You're required to be an Admin of the Workspace or a Member of a Workspace that allows members to edit content.

#>

#Connect to the Power BI Service
try {
    Get-PowerBIAccessToken 
}
catch {
    Login-PowerBIServiceAccount
}

$workspace_name = 'WorkspaceName'
$report_name = 'ReportName'
$target_path = 'C:\pbiexports\'

# Workspace ID
$w = Get-PowerBIWorkspace -Scope Organization | Where-Object {($_.Name -eq $workspace_name)} 
$wid = $w.Id.ToString()
"Workspace Id is $wid"

$r = Get-PowerBIReport -Scope Organization -WorkspaceId $wid | Where-Object {($_.Name -eq $report_name)}
$rid = $r.Id.ToString()
"Report Id is $rid"

$url = "groups/" + $wid + "/reports/" + $rid + "/Export"
$full_path = $target_path + $report_name + ".pbix"
#"API URL is $url"
Invoke-PowerBIRestMethod -Url $url -Method Get -OutFile $full_path

#Display last error
Resolve-PowerBIError -Last