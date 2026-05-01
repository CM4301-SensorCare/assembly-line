
# Assembly Line

Hi! This project builds an environment (`test-environment/`) to test all the project components together. See the contents of `Scripts`.

## Support

The initial scripts were made for Powershell but they're now incomplete. The mac scripts, however, are fully implemented.


## Running:

All dependencies install themselves via the scripts. The process you'll want to setup the full chain will be:

- Cleanup
  - If you change the code and commit to git, a cleanup is advised.
- Setup Environment (x2)
  - Fill out the generated .env with your local database's password
- Setup & Start Local DB
- Run API 
- Run LocalHub Server
- Run Web Dashboard
- Run Test Client / Sensors 

### Example (MacOS):

**Setup**
```
Scripts/cleanup.sh
Scripts/setup-mac.sh
   ... fill out .env with password. ...
Scripts/setup-mac.sh
Scripts/run-local-db-mac.sh
```

**Running API (Open New Terminal)**
```
cd test-environment
source .venv/bin/activate
cd api
python run.py
```

**Running LocalHub (Open New Terminal)**

After running the following, look into the configs in `test-environment/localhub/data/server-config.cfg` if it doesn't work out of the box.
```
cd test-environment
source .venv/bin/activate
cd localhub
python -m sensorhub.localserver
```

**Running Web Dashboard (Open New Terminal)**
```
cd test-environment/web
npm run dev
```

**Running Test Client (Open New Terminal)**

After running the following, look into the configs in `test-environment/localhub/data/client-config.cfg` if it doesn't work out of the box.
```
cd test-environment
source .venv/bin/activate
cd localhub
python -m sensorhub.test-client
```