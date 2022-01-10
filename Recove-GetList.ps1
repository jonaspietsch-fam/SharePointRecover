[CmdletBinding(SupportsShouldProcess)]
param(

    # The url to the site containing the Site Requests list
    [string]$URL="fammd.sharepoint.com/sites/Projekte9",
    [string]$Stage="First",
    [string]$Path="C:\SAP\SharePointDiscover\export.csv",
    [int]$RowLimit=150000
)


Connect-PnPOnline -Url:$URL -UseWebLogin

Write-Host "Getting recycle bin items..."
$RecycleStage;
$RecycleStage = Get-PnPRecycleBinItem -FirstStage -RowLimit $RowLimit | ? -Property DeletedByEmail -eq "annette.handge@fam.de"
$Output = @()


$RecycleStage | ForEach-Object {
    $Item = $PSItem
    $Obj = "" | Select-Object ID
    #$Obj.Title = $Item.Title
    #$Obj.AuthorEmail = $Item.AuthorEmail
    #$Obj.AuthorName = $Item.AuthorName
    #$Obj.DeletedBy = $Item.DeletedByName
    #$Obj.DeletedByEmail = $Item.DeletedByEmail
    #$Obj.DeletedDate = $Item.DeletedDate
    #$Obj.Directory = $Item.DirName
    $Obj.ID = $Item.ID
    #$Obj.ItemState = $Item.ItemState
    #$Obj.ItemType = $Item.ItemType
    #$Obj.LeafName = $Item.LeafName
    #$Obj.Size = $Item.Size

    $output += $Obj
}

$Output | Export-csv $Path -NoTypeInformation

Write-Host "Done"