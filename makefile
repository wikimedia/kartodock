############################# Useful commands for kartodock operations #############################
include .env

# Run osm-initial-import
#
# Usage: make osm \
# 			ARGS='-p http://download.geofabrik.de/asia/israel-and-palestine-latest.osm.pbf'
osm:
	docker-compose exec workspace osm-initial-import $(ARGS) -s -H postgres-postgis

run_kartotherian:
	docker-compose exec kartotherian nodemon --ext js,json,yaml --signal SIGHUP server.js -c config.docker.yaml

npm_test:
	docker-compose exec kartotherian npm test

npm_install:
	docker-compose exec kartotherian npm install --unsafe-perm

npm_link:
	docker-compose exec kartotherian -w /srv/dependencies/osm-bright.tm2source npm link
	docker-compose exec kartotherian -w /srv/dependencies/osm-bright.tm2 npm link
	docker-compose exec kartotherian -w /home/kartotherian/packages/kartotherian npm link @kartotherian/osm-bright-source
	docker-compose exec kartotherian -w /home/kartotherian/packages/kartotherian npm link @kartotherian/osm-bright-style

imposm_run:
	docker-compose exec workspace imposm run -config /etc/imposm/config.json -expiretiles-zoom 15

# pregen_dequeue:
#     docker-compose exec tegola /etc/pregenerate-maps-tile.sh
#
# pregen_enqueue:
#     docker-compose exec tegola poppy --broker-url redis://redis:6379 --queue-name pregen enqueue --message-entry tile 1/1/1

install:
	# TODO
	# Check if kartotherian is installed and clone if it isn't
	# docker-compose up --build kartotherian
	# Execute (clean and?) npm install
	# Execute osm-initial-import
	# Execute keyspace_setup
	# Execute kartotherian monorepo tests

up:
	docker-compose up --detach kartotherian
