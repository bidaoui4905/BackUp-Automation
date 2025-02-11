$backupFolder = Read-Host "Please enter the folder to check  " #"C:\Users\user\Documents"
$backupFiles = get-childItem -path $backupFolder #-include('*.bvk','*vib', '*vbm') -File -Recurse
if ($backupFiles){
    Write-Output "Veeam BackUp files found in : '$backupFolder' : "
    $backupFiles | ForEach-object {
        Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
    }
}
else {
    Write-Output "No Veeam BackUp files found in : '$backupFolder' : "
}
$sevenDaysAgo = (get-date).Date.adddays(-7)
Write-Output "$sevenDaysAgo"
$backupFiles | ForEach-Object {
    if (($_.CreationTime) -eq $sevenDaysAgo){
        Write-Output "BackUp Created 7 days ago : $($_.FullName)"
    } 
}
$manualCopy = Read-Host " Manual Copy ? Yes/No "
if ($manualCopy -eq "Yes"){
    $backupSource = Read-Host "Enter the source folder path  "
    #Add condition if backup source exist
    $filestoCopy = Get-ChildItem -Path $backupSource
    $backupDestination = Read-Host "Enter the destination folder path : " 
    if ($filestoCopy){
        $filestoCopy | ForEach-Object {
            Copy-Item -Path ($_.FullName) -Destination $backupDestination -Recurse -Force
        } 
    }
}
