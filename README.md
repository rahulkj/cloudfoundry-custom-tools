CUSTOM CLOUDFOUNDRY TOOLS
---

* Script to download resource configuration from one foundation and apply it to another foundation
* Curate the raw JSON file for a tile to extract the required fields to create the config task for that Pivotal Product and create the pipeline


## Environments

The `set-env.sh` file will set the configurable variables for this application.  As such, this file will use the `ENV_FILE` variable to determine which environment file to load.  One should copy the `env` file to `.env.*` to set custom values for the scripts.

__`ENV_FILE` defaults to `.env.local`__
