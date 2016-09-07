function Store-SecureCredential($Path) {
$Credential = Get-Credential
$Credential | Export-CliXml $path
}

function Import-SecureCredential($Path) {
$Credential = Import-Clixml -Path $Path
return $Credential
}