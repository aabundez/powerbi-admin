<#

.SYNOPSIS
Collect Refresh History from Power BI and export to Excel.

.DESCRIPTION
 The script relies on the 'Refresh History in Group' API call to retrieve the data and the ImportExcel module in the PSGallery 
 to export to Excel without needing Excel installed. https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/getrefreshhistoryingroup

.EXAMPLE
./Refresh.ps1

.LINK
http://www.angelabundez.com

#>


#Connect to the Power BI Service
try {
    Get-PowerBIAccessToken 
}
catch {
    Login-PowerBIServiceAccount
}


#Get active Power BI Workspaces
$ws = Get-PowerBIWorkspace -Scope Organization -Filter "type eq 'Group' and state eq 'Active'"


#Initiate PSCustomObject to collect Refresh History
$refs = @()

#Start loop on each workspace
foreach ($w in $ws) {

    $wid = $w.Id
    $wname = $w.Name

    Write-Host "Workspace.id = " $wid " workspace.name = " $wname

    #Get datasets for workspace. If empty, continue to next workspace.
    $ds = Get-PowerBIDataset -WorkspaceId $wid -ErrorAction SilentlyContinue
    if(!$ds){continue}


    #Start loop on each dataset
    foreach ($d in $ds){

        #Get Refresh data
        $url = "groups/" + $w.id.ToString() + "/datasets/" + $d.Id.ToString() + "/refreshes"
        $ref = Invoke-PowerBIRestMethod -Url $url -Method Get | ConvertFrom-Json 

        #Add Dataset information
        $ref.value | Add-Member -MemberType NoteProperty -Name 'datasetid' -Value $d.id.ToString()
        $ref.value | Add-Member -MemberType NoteProperty -Name 'datasetname' -Value $d.name.ToString()

        #Add Workspace information
        $ref.value | Add-Member -MemberType NoteProperty -Name 'workspaceid' -Value $wid
        $ref.value | Add-Member -MemberType NoteProperty -Name 'workspacename' -Value $wname

        #Append to final object
        $refs += $ref
    }
}

#Export to incremental Excel file
$refs.value | Export-Excel -Path "C:\Users\angel\Dropbox\InData\Projects\Fillmore Piru Citrus\Powershell\refreshes2.xlsx"

#Merging data in Excel
Merge-Worksheet "refreshes.xlsx" "refreshes2.xlsx" -WorksheetName Sheet1 -OutputFile refreshcombined.xlsx -OutputSheetName Sheet1 -Key id