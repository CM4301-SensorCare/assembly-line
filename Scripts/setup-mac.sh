#!/bin/bash

location="../test-environment"
relative_env_file_path="./.env"

cd "$(dirname "$0")"

echo "Creating Environment in '$location'"

mkdir -p "$location"
cd "$location"

# Check modifiable stuff.
if [ ! -f "$relative_env_file_path" ]; then
    echo "REMOTE_PASSWORD=" > "$relative_env_file_path"
    echo "Generated .env file. Please add your database password inside."
    cd ".."
    exit
fi

dependencies_installed=0

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install Homebrew first from https://brew.sh/"
    exit 1
fi

# Check dependencies
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Installing via brew:"
    brew install node
    dependencies_installed=$((dependencies_installed + 1))
else
    echo "[/] Node.js Installed"
fi

if ! command -v python3 &> /dev/null; then
    echo "Python is not installed. Installing via brew:"
    brew install python
    dependencies_installed=$((dependencies_installed + 1))
else
    echo "[/] Python Installed"
fi

if [ $dependencies_installed -gt 0 ]; then
    echo "Installed $dependencies_installed dependencies. Please Re-run this script..."
    cd ".."
    exit
fi

# remote: api (api + insights within), dashboard
# local: localhub

git clone --recursive "git@github.com:CM4301-SensorCare/dummy-api.git" "api"
git clone --recursive "git@github.com:CM4301-SensorCare/carer-sensor-dashboard.git" "web"
git clone "git@github.com:CM4301-SensorCare/SensorHub-Lib.git" "localhub"
echo "[/] Cloned 3/3 Repositories"

# Create shared venv
python3 -m venv .venv
source .venv/bin/activate
echo "[/] Created Python Environment"

# Setup localhub
cd "localhub"
pip install -e .
cd ".."
echo "[/] Setup LocalHub"

# Setup api
cd "api"
pip install -r requirements.txt
cd ".."

# Setup web dashboard
cd "web"
npm install .
cd ".."

echo "Environment successfully setup in '$location'! Ensure any project is ran from within via the '.venv'."