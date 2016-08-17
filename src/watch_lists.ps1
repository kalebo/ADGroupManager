. .\list_functions.ps1

$folder  = "..\lists"
$filter = "physics-grp-*.csv"

$watcher = New-Object IO.FileSystemWatcher -Property @{
    Path = $folder
    Filter = $filter
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

