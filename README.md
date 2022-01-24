# Shintolin

A node.js port of [Isaac Lewis' Ruby version of Shintolin](https://github.com/IsaacLewis/Shintolin) - a persistent multiplayer browser game, set in the stone age.

Forked from https://github.com/troygoode/shintolin

## Running Locally (Docker Compose) - UPDATED INSTRUCTIONS

* Download the code via [git](http://git-scm.com/): `git clone https://github.com/tmpillbox/shintolin`
* Install [docker](https://www.docker.com/)

### Prepare directory. In this case, I am deploying into a subdirectory of /opt/game on my linux host. Replace `/opt/game` with the appropriate substitution for your environment.

I will be storing my MongoDB database data in a host-mapped subdirectory rather than in a docker volume. By default, this will be called `mongodb` in the parent directory of the application/docker-compose

```bash
├── mongodb <------ database data path
└── shintolin
    ├── apps
    ├── bin
    ├── commands
    ├── data
    ├── node_modules
    ├── queries
    └── test
```

```bash
# on host

mkdir /opt/game/shintolin
cd /opt/game/shintolin
mkdir /opt/game/shintolin/mongodb

git clone https://github.com/tmpillbox/shintolin
cd shintolin
```

### Run Docker-Compose to build the stack

```bash
docker-compose up -d
```

### Verify Docker containers are running. There are 3 expected

```bash
$ docker-compose ps

pillbox@host:/opt/game/shintolin/shintolin$ docker-compose ps
            Name                          Command               State            Ports          
------------------------------------------------------------------------------------------------
shintolin_shintolin3-clock_1   docker-entrypoint.sh node  ...   Up                              
shintolin_shintolin3-mongo_1   docker-entrypoint.sh mongod      Up      0.0.0.0:27017->27017/tcp
shintolin_shintolin3_1         docker-entrypoint.sh bin/d ...   Up      0.0.0.0:3000->3000/tcp  
```

`shintolin_` is the name of the Docker-Compose stack. If the directory the docker-compose.yml file was in was called 'irregularwalrus', then the containers would be prefixed with `irregularwalrus_`. `shintolin3`, `shintolin3-clock`, and `shintolin3-mongo` are the names of the services/containers in the docker-compose.yml file. The trailing `_1` means it is the first instance of that container (docker-compose has built-in auto-scaling functionality, which will not be used)

### FIRST TIME ONLY -- INITIALIZE DATABASE

The previous steps can be used to re-build a pre-existing instance, such as after a reboot of the host. However, out of the box, there is no data in the database and the app will not function properly. To bootstrap the production data, use the following command:

```bash
pillbox@host:/opt/game/shintolin/shintolin$ docker exec -it shintolin_shintolin3_1 bash

#################
#### CAUTION ####
#################

root@f53cedf1dfb2:/usr/src/app# bin/dev/bootstrap-production shintolin.tsv

```

This will populate the database with the default terrain/map and developer/admin users, Ecce.

### Logging in

By default, there is an admin user created called Ecce. You can log into this account by browsing to http://<hostip>:3000/, clicking "Log In", and then enterring username: `ecce@example.com`, password: `password`. I recommend changing the password for this user before opening access to the server to the internet.

### Port-Forwarding and Internet Hosting

(outside of the scope of this document)

Note that the web server will be listening on port 3000. IT IS NOT RECOMMENDED TO MAKE A PORT FORWARD FOR PORT 27017, there is no need for outside access directly to the database.


# License

Shintolin: a persistent multiplayer browser game, set in the stone age.
Copyright (C) 2013 Troy Goode

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program.  If not, see [<http://www.gnu.org/licenses/>](http://www.gnu.org/licenses/).
