function Backup-ADGroup ($GroupName, $FileName, $Credential) {
	Get-ADGroupMember $GroupName -Credential $Credential `
        | select-object @{Name="NetID"; Expression={$_.SamAccountName}} `
        | Export-Csv -NoTypeInformation $FileName
}

function Regenerate-ADGroup ($FileName, $Credential) {
	$ADGroup = $FileName.BaseName
	$Users = Import-Csv $FileName.FullName
    
    Backup-ADGroup -GroupName $ADGroup `
        -Credential $Credential `
        -FileName (Join-Path -path $FileName.Directory -ChildPath ($ADGroup + "_" `
            + (Get-Date).AddDays(-1).ToString('MMddyyyyTHHmm') `
            + ".bkp"))

    Remove-ADGroupMember $ADGroup `
        -Members (Get-ADGroupMember $ADGroup -Credential $Credential) `
        -Credential $Credential `
        -Confirm:$false

    $Users | ForEach-Object {
        Add-ADGroupMember -Credential $Credential `
            -Identity $ADGroup `
            -Member $_.NetID
    }   
}

function Clean-ListDir ($WorkingDir) {
     Push-Location $WorkingDir
     foreach ($CsvFile in (Get-ChildItem | Where-Object {$_.Extension -eq ".csv"})) {
        # We had to do the Push-Pop trick above because powershell made some mildly retarded design choices 
        # and wont operate on the full path of childitems prefering to assume they are relative to the CWD.
        Remove-Item ( Get-ChildItem `
            | Where-Object {$_.BaseName -like  ( $CsvFile.BaseName + "*") } `
            | Where-Object {$_.Extension -eq ".bkp"} `
            | sort -Descending `
            | select -Skip 1 )
    }
    Pop-Location
}

function Pull-Lists ($SourceDir, $WorkingDir, $Credential) {
    New-PSDrive -name luna -PSProvider FileSystem -Credential $Credential -Root $SourceDir
    Copy-Item -Path "luna:\*" -Filter *.csv -Destination $WorkingDir -Force
    Remove-PSDrive luna
}