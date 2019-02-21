
#https://docs.microsoft.com/en-us/power-bi/service-admin-auditing#use-powershell-to-search-audit-logs

Set-ExecutionPolicy RemoteSigned

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session
Search-UnifiedAuditLog -StartDate 1/1/2019 -EndDate 2/19/2019 -RecordType PowerBI -ResultSize 1000 | Export-CSV -Path "C:\temp\unifiedauditlog.csv" -NoTypeInformation