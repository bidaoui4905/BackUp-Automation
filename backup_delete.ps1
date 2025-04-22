#This script will find latest  backups in a directory and delete all other backups files before a specified rpo
$RPO= 8
$backupFolder= Read-Host("Please specify the backup folder")
if (!(Test-Path -Path $backupFolder)){
    Write-Output "Folder does not exist quiting .............."
    exit
}
$backupFolder= "C:\Backup PC DESKTOP-4AOQCQD\Job DESKTOP-4AOQCQD"
#$backupFiles = get-childItem -path $backupFolder -include('*.vbk','*vib', '*vbm') -File -Recurse
if($backupFiles){
    Write-Output("BackUp files found in $backupFolder")
    $backupFiles | ForEach-object {
        Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
        #add condition toc output file type
        if (($_.Extension) -eq ".vbk"){
            Write-Output "File Type : Full backup file"
        }
        if (($_.Extension) -eq ".vib"){
            Write-Output " File Type : Incremental backup file"
        }
        if (($_.Extension) -eq ".vbm"){
            Write-Output " File Type : Backup metadata file"
        }
        Write-Output "---------------------------------------------"
    }
    $filestoDelete = $backupFiles | Where-Object {$_.LastWriteTime -lt (Get-Date).adddays(-$RPO)}
    if($filestoDelete){
        $delete = Read-Host "Delete all backups before $rpo days ? (Yes/No)"
        if($delete -eq "yes"){
            Write-Output "=======================WARNING:========================"
            Write-Output "****The following backup files will be deleted ********"
            $filestoDelete | ForEach-Object {
            Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
            }
            $confirm = Read-Host "Are you sure ? "
            if($confirm -eq "yes"){
                $filestoDelete | ForEach-Object {
                    Remove-Item -Path $_.FullName -Force
                    Write-Output "Backup located at ($_.Fullname) deleted successfuly ! "
                }
            }
            else {
                Write-Output "Delete aborted,quiting .........."
                exit
            }
        }
        else {
            Write-Output "Quitting......................."
            exit
        }
    }
    else{Write-Output "No files to delete, quitting..................."}
}
else {
    Write-Output "No backup files found in $backupfolder"
}

     <#$sortedbackupFiles = $backupFiles | Sort-Object -Property CreationTime -Descending
    Write-Output "---------------------------------------------"
    Write-Output "============Sorted by date =================="
    Write-Output "---------------------------------------------"
    $sortedbackupFiles | ForEach-Object {
        Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
        Write-Output "---------------------------------------------"
    }
    $latestbackups = $sortedbackupFiles | Select-Object -First 3
    Write-Output "=============Latest 3 Backups================ "
    $latestbackups | ForEach-Object {
        Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
        Write-Output "---------------------------------------------"
    }
    $filestoDelete = $sortedbackupFiles | Select-Object -Skip 3
    $delete = Read-Host "Delete Old Backups ? Yes/No (anything else to quit)" 
    if($delete -eq "Yes"){write output "yes"}
    if($filestoDelete){
        Write-Output "The following backup files will be deleted"
        $filestoDelete | ForEach-Object {
            Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
            Write-Output "---------------------------------------------"
        }
    } <# and #>
