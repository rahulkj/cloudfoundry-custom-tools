CUSTOM CLOUDFOUNDRY TOOLS
---

This repository contains some miscellaneous tools to perform the following:

* Download resource configuration from one foundation and apply it to another foundation
* Curate the raw JSON file for a tile to extract the required fields to create the config task for that Pivotal Product
* Generate the `task.sh` and `task.yml` for each of the staged product tiles in your ops manager

To use this repository
* Fill out the `env` file with your ops manager details

| Functionality | Script |
| --- | --- |
| Download product properties and resource configuration for all product tiles | ./scripts/download-product-properties
| Curate the product properties to get the fields required for configuring the tile | ./scripts/cleanup-json PROPERTIES_FILE PRODUCT_NAME
| To generate `task.sh` and `task.yml` files for all the tiles staged on ops manager | ./scripts/generate-config-tasks
| Download all the resource configuration for deployed products | ./scripts/get-existing-deployment-configuration
| Update another site with the downloaded properties from the previous command | ./scripts/update-existing-deployment-configuration
| Update state of errands in a given environment | ./scripts/update-errands-state


Word of caution with the `task.sh` and `task.yml` files generated. The output there is a good starting point to modify the logic to match the tile configuration. So please take a look at the files before using them directly.

## Environments

The `set-env.sh` file will set the configurable variables for this application.  As such, this file will use the `ENV_FILE` variable to determine which environment file to load.  One should copy the `env` file to `.env.*` to set custom values for the scripts.

__`ENV_FILE` defaults to `.env.local`__
