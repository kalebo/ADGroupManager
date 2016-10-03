
$AllUsersGroupName = "physics-grp-users"
$UserDirs = "E:\Users\"
$AllUsers = Get-ADGroupMember $AllUsersGroupName -Recursive

function Setup-UserFolder($UserName, $Path) {

    $UserPath = Join-Path $Path $UserName
    if (!(Test-Path $UserPath)) {
        New-Item -ItemType directory -Path $Path -Name $UserName
        echo $UserPath

        $Acl = Get-Acl $UserPath
        $AccessRule  = New-Object System.Security.AccessControl.FileSystemAccessRule($UserName, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $Acl.SetAccessRule($AccessRule)
  
        Set-Acl $UserPath $Acl
    }
}

$AllUsers | ForEach-Object {
    Setup-UserFolder -UserName $_.SamAccountName -Path $UserDirs
}

