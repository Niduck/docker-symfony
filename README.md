## Installation

####  Download or clone the repository
```html
git clone path/to/the/repository .docker
```
#### Create your own .env from the .env.dist file

>The `APP_ALIAS` variable is important it will be the alias name to run the projet.

#### Run the install script
`cd .docker/scripts && sh install.sh`

## Build the projet

Let's assume `APP_ALIAS='myapp'`

Running `myapp build` from anywhere will build your project.

## Troubleshooting
  * "Unable du read/write _app/logs_ files" or any files in _.cache_ folder.
    - run from your _local machine_ `sudo chown YOURUSER:YOURGRP .cache`
    - OR
    - run from your _local machine_ `sudo chmod 777 -R .cache`
