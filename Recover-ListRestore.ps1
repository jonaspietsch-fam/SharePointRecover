$Url = "https://fammd.sharepoint.com/sites/P_145106_Westshore_Reclaimer"
$batch = 1

Connect-PnPOnline -Url $SiteURL -Interactive

function Restore-RecycleBinItem {
    param(
        [Parameter(Mandatory)]
        [String]
        $Ids
    )
    
    $siteUrl = (Get-PnPSite).Url
    $apiCall = $siteUrl + "/_api/site/RecycleBin/RestoreByIds"
    $body = "{""ids"":[$($Ids)]}"   
    Invoke-PnPSPRestMethod -Method Post -Url $apiCall -Content $body 

}

$stopWatch = [system.diagnostics.stopwatch]::StartNew()

# Batch restore up to 200 at a time

$Input = Import-Csv -Path ".\export.csv"

$restoreList = $Input

$restoreListCount = $restoreList.count
$start = 0
$leftToProcess = $restoreListCount - $start


$stopWatch = [system.diagnostics.stopwatch]::StartNew()
while($leftToProcess -gt 0){
    If($leftToProcess -lt $batch){$numToProcess = $leftToProcess} Else {$numToProcess = $batch}
    Write-Host -ForegroundColor Yellow "Building statement to restore the following $numToProcess files"
    $Ids = @()
    for($i=0; $i -lt $numToProcess; $i++){
        $cur = $start + $i
        $curItem = $restoreList[$cur]
        
        $Ids+=$curItem.Id
    }
   
    Write-Host -ForegroundColor Yellow "Performing API Call to Restore items from RecycleBin..."
    $Ids_As_string = [System.String]::Join(",", $($Ids | % {'"'+ $_.tostring() + '"'}))
    Restore-RecycleBinItem -Ids $Ids_As_string
    
    $start += $batch
    $leftToProcess = $restoreListCount - $start
}

$stopWatch.Stop()
Write-Host Time it took to restore $restoreListCount documents from the $($SiteURL+$DestinationFolderUrl)  -ForegroundColor Cyan
$stopWatch