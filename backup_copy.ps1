$backupFolder = Read-Host "Please enter the folder to check  " 
if (!(Test-Path -Path $backupFolder)){
    Write-Output "Folder does not exist quiting .............."
    exit
}
$backupFiles = get-childItem -path $backupFolder -include('*.vbk','*vib', '*vbm') -File -Recurse
if ($backupFiles){
    Write-Output "Veeam BackUp files found in : '$backupFolder' : "
    $backupFiles | ForEach-object {
        Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
        #add condition toc output file type
        if (($_.Extension) -eq ".bvk"){
            Write-Output " File Type : Full backup file"
        }
        if (($_.Extension) -eq ".vib"){
            Write-Output " File Type : Incremental backup file"
        }
        if (($_.Extension) -eq ".vbm"){
            Write-Output " File Type : Backup metadata file"
        }
        Write-Output "---------------------------------------------"
    }
}
else {
    Write-Output "No Veeam BackUp files found in : '$backupFolder' : "
}

$sevenDaysAgo = (get-date).Date.adddays(-7)
Write-Output "Seven Days ago $sevenDaysAgo"
Write-Output "Checking for latest backup ............................"
$backupFiles | ForEach-Object {
    if (($_.CreationTime) -eq $sevenDaysAgo){
        Write-Output "BackUp Created 7 days ago : $($_.FullName) "
        $latestbackup = $_.FullName
    }
}
if (!($latestbackup)){
    Write-Output "No BackUp Created 7 days ago"
}
$manualCopy = Read-Host "Manual Copy ? Yes/No (Anything else to exit)"
if ($manualCopy -eq "Yes"){
    $backupSource = Read-Host "Enter the source folder path  "
    #Exit if  backup source folder doesn't exist
    if (!(Test-Path -Path $backupSource)){
        Write-Output "Source folder does not exist quiting .............."
        exit
    }
    $filestoCopy = Get-ChildItem -Path $backupSource
    $backupDestination = Read-Host "Enter the destination folder path " 
    #exit if dest folder doesn't exist
    if (!(Test-Path -Path $backupDestination)){
        Write-Output "Destination folder does not exist quitting ........."
        exit
    }
    if ($filestoCopy){
        $filestoCopy | ForEach-Object {
            Copy-Item -Path ($_.FullName) -Destination $backupDestination -Recurse -Force
        }
    }
}
else {
    exit
}
