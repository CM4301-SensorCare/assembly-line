
cd "$(dirname "$0")/../test-environment"

# Check dependencies
if ! command -v mysql.server &> /dev/null; then
    echo "MariaDB is not installed. Installing via brew:"
    brew install mariadb
else
    echo "[/] MariaDB Installed"
fi

echo "Running MariaDB Server"
mysql.server start &

echo "Setting Up Local MariaDB Tables"
source ".venv/bin/activate"
cd localhub
pip install -e .
python -m sensorhub.testremoteserver

echo "Ready!"