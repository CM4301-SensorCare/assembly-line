$location = "..\test-environment"
$relative_env_file_path = ".\.env"

Set-Location $PSScriptRoot

Write-Host "Creating Environment in '$location'"

New-Item -Name $location -Force -ItemType "Directory" | Out-Null
Set-Location -Path $location

# Check modifiable stuff.
if (-not(Test-Path -Path $relative_env_file_path)) {
    "REMOTE_PASSWORD=..." | Out-File -FilePath $relative_env_file_path | Out-Null
    Write-Host "Generated .env file. Please add your database password inside."
    Set-Location -Path ".."
    Exit
}

$dependencies_installed = 0

# Check dependencies
if (-not(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js is not installed. Installing via winget:"
    winget.exe install nodejs
    $dependency_installed += 1
} else {
    Write-Host "[/] Node.js Installed"
}

if (-not(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python is not installed. Installing via winget:"
    winget.exe install python
    $dependency_installed += 1
} else {
    Write-Host "[/] Python Installed"
}

if ($dependencies_installed -gt 0) {
    Write-Host "Installed", $dependencies_installed, "dependencies. Please Re-run this script..."
    Set-Location -Path ".."
}


# remote: api (api + insights within), dashboard
# local: localhub

&git clone --recursive "git@github.com:CM4301-SensorCare/dummy-api.git" "api"
&git clone --recursive "git@github.com:CM4301-SensorCare/carer-sensor-dashboard.git" "web"
&git clone "git@github.com:CM4301-SensorCare/SensorHub-Lib.git" "localhub"
Write-Host "[/] Cloned 3/3 Repositories"

# Create shared venv
&python -m venv .venv
.venv/Scripts/activate.ps1
Write-Host "[/] Created Python Environment"

# Setup localhub
Set-Location -Path ".\localhub"
&pip install -e .
Set-Location -Path ".."
Write-Host "[/] Setup LocalHub"

# Setup api
Set-Location -Path ".\api"
pip install -r requirements.txt
Set-Location -Path ".."

# Setup web dashboard
Set-Location -Path ".\web"
npm install .
Set-Location -Path ".."

Write-Host "Environment successfully setup in '$location'! Ensure any project is ran from within via the '.venv'."