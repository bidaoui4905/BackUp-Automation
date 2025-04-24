#This script will find latest  backups in a directory and delete all other backups files before a specified rpo
$RPO= 16

#Uncomment the line below to set a fixed path & comment the line after
$backupFolder= "A:\Backup HV-C\Backup Job 2 for OS C on HYPER-V\192.168.1.61"
#or
#$backupFolder= Read-Host("Please specify the backup folder")
if (!(Test-Path -Path $backupFolder)){
    Write-Output "Folder does not exist quiting .............."
    exit
}
$backupFiles = get-childItem -path $backupFolder -include('*.vbk','*.vib', '*.vbm') -File -Recurse
if($backupFiles){
    Write-Output("BackUp files found in $backupFolder")
    $backupFiles | ForEach-object {
        Write-Output " Path : $($_.Fullname) `n Created : $($_.CreationTime) `n Last Modified : $($_.LastWriteTime)"
        #add condition to output file type
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
    #$filestoDelete = $backupFiles | Where-Object {$_.LastWriteTime -lt $RPO}
    $filestoDelete = $backupFiles | Where-Object {$_.LastWriteTime -lt (Get-Date).adddays(-$RPO)}
    if($filestoDelete){
        $delete = Read-Host "Delete all backups before $rpo days ? (Yes/No)"
        if($delete -eq "yes"){
            Write-Output "======================================================="
            Write-Output "                      WARNING:                        "
            Write-Output "======================================================="
            Write-Output "      The following backup files will be deleted      "
            Write-Output "======================================================="
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
    else{
        Write-Output "No files to delete, quitting..................."
        exit
    }
}
else {
    Write-Output "No backup files found in $backupfolder"
}