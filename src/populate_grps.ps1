param (
    [Parameter(Mandatory=$true)][string]$WorkingDir,
    [PSCredential]$BYUCredential = (Get-Credential),
    [PSCredential]$OLDCredential = (Get-Credential)
)

Import-module ActiveDirectory
. "C:\ADGroupManager\src\list_functions.ps1"

$WorkingDir = Resolve-Path $WorkingDir

Pull-Lists -SourceDir "\\luna\c$\Inetpub\Websites\WWW Physics Web Site\App_Data\groups" -WorkingDir $WorkingDir -Credential $OLDCredential

$csv_files = Get-ChildItem $WorkingDir -Filter physics-grp-*.csv
$csv_files | ForEach-Object {
	Write-Host "Processing $_ ..." -ForegroundColor cyan
	Regenerate-ADGroup -File $_ -Credential $BYUCredential
}
Clean-ListDir $WorkingDir

