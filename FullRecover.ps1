# Not Working

Clear-Host  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"  

$SiteUrl = "https://fammd.sharepoint.com/sites/Projekte9"  
$UserName = "projects_file_manager@fam.de"  
$Password = Read-host -assecurestring "Passwort"  
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $Password)  

Try {  
    $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)  
    $Context.Credentials = $Credentials  
    $Site = $Context.Site  
    $RecycleBinItems = $Site.RecycleBin  
    #$Context.Load($Site)  
    $Context.Load($RecycleBinItems)  
    $Context.ExecuteQuery()  
    $RecycleBinItems | Select-Object Title, DeletedByEmail, DeletedDate, ItemType, ItemState | Format-Table -AutoSize  
} catch {  
    write-host "Error: $($_.Exception.Message) $($_.Exception.Line)" -foregroundcolor Red  
    write-Output $_.Exception
}

$DeletedByUser = "HANDGE@fam.de" 
$DeletedByUser = $RecycleBinItems | Where-Object {$_.DeletedByEmail -eq $DeletedByUserAccount} | Format-Table  

Write-Output $DeletedByUser

pause

Foreach ($Restoreitem in $DeletedByUser) {
    $Restoreitem | % {  
        $_.Restore()  
    }  
    $Context.ExecuteQuery()  
    Write-Host $Restoreitem.Title "Restored" -ForegroundColor Yellow  
}  

