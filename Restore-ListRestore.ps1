$SiteURL = "https://fammd.sharepoint.com/sites/Projekte9"
Connect-PnPOnline -Url $SiteURL -UseWebLogin


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

$Input = Import-Csv -Path "C:\SAP\SharePointDiscover\export.csv"

$restoreList = $Input

$restoreListCount = $restoreList.count
$start = 0
$leftToProcess = $restoreListCount - $start


$stopWatch = [system.diagnostics.stopwatch]::StartNew()
while($leftToProcess -gt 0){
    If($leftToProcess -lt 200){$numToProcess = $leftToProcess} Else {$numToProcess = 200}
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
    
    $start += 200
    $leftToProcess = $restoreListCount - $start
}

$stopWatch.Stop()
Write-Host Time it took to restore $restoreListCount documents from the $($SiteURL+$DestinationFolderUrl)  -ForegroundColor Cyan
$stopWatch