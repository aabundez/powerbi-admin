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
$ws = Get-PowerBIWorkspace -Filter "name eq 'Executive Dashboard'"


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
        
        $did = $d.Id
        $dname = $d.Name

        Write-Host "Dataset.id = " $did " workspace.name = "$dname

        #Get Refresh data
        $url = "groups/" + $wid + "/datasets/" + $did + "/refreshes"
        Write-Host $url
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
$refs.value | Export-Csv -Path "C:\temp\refresh_history.csv" -NoTypeInformation



<#
####### TESTING ##############

 $url = "groups/559b76a8-ee6b-409c-a1c9-e9e59f74b799/datasets/9d1eab87-9fab-4693-b79e-e3fd4a7e58dd/refreshes"
 Invoke-PowerBIRestMethod -Url $url -Method Get | ConvertFrom-Json 

 Resolve-PowerBIError -Last

#>