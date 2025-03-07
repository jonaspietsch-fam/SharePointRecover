$URL = "https://fammd.sharepoint.com/sites/P_145106_Westshore_Reclaimer"
$DeleteMail = "alexey.baryshnikov@fam.de"

$Stage="First"
$Path=".\export.csv"
$RowLimit=150000


Connect-PnPOnline -Url $URL -Interactive

Write-Host "Getting recycle bin items..."
$RecycleStage;
$RecycleStage = Get-PnPRecycleBinItem -FirstStage -RowLimit $RowLimit | ? -Property DeletedByEmail -eq $DeleteMail
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