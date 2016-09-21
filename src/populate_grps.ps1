[CmdletBinding(DefaultParameterSetName="simple")]

param (
    [Parameter(Mandatory=$true)][string]$WorkingDir,
    $ADCredentialFile,
    $FileAccessCredentialFile
)


Import-module ActiveDirectory
. "C:\ADGroupManager\src\list_functions.ps1"
. "C:\ADGroupManager\src\credential_functions.ps1"


$WorkingDir = Resolve-Path $WorkingDir


if (!$ADCredentialFile){
    [PSCredential]$ADCredential = (Get-Credential)
} else {
    $ADCredential = Import-SecureCredential -Path $ADCredentialFile
}

if (!$FileAccessCredentialFile) {
    [PSCredential]$FileAccessCredential = (Get-Credential)
} else {
    $FileAccessCredential = Import-SecureCredential -Path $FileAccessCredentialFile
}



Pull-Lists -SourceDir "\\luna\c$\Inetpub\Websites\WWW Physics Web Site\App_Data\groups" `
           -WorkingDir $WorkingDir `
           -Credential $FileAccessCredential

$csv_files = Get-ChildItem $WorkingDir -Filter physics-grp-*.csv
$csv_files | ForEach-Object {
	Write-Host "Processing $_ ..." -ForegroundColor cyan
	Regenerate-ADGroup -File $_ -Credential $ADCredential
}
Clean-ListDir $WorkingDir

