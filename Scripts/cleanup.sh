
echo "Killing DB Process"
pkill -f mariadb

echo "Clearing Test Environment"
rm -rf "test-environment"