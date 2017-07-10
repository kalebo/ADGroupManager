# This is just harness to call the group update and create user dir scripts
# in sequence so as to add to task manager easier.

Write-Output "Updating Groups..."
.\src\populate_grps.ps1 -WorkingDir .\lists -ADCredentialFile .\BYU_physics_admin_cred.xml -FileAccessCredentialFile .\PHYSICS_admin_cred.xml

Write-Output "Creating User Directories..."
.\src\create_user_dirs.ps1