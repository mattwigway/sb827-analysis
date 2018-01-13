#!/bin/bash

HOST=`hostname`

if [ ! -e data/${HOST}/valhalla_tiles.tar ]; then
  mkdir -p data/${HOST}/valhalla_tiles
  valhalla_build_config --mjolnir-tile-dir "${PWD}/data/${HOST}/valhalla_tiles"\
    --mjolnir-tile-extract "${PWD}/data/${HOST}/valhalla_tiles.tar" \
    --mjolnir-timezone "${PWD}/data/${HOST}/valhalla_tiles/timezones.sqlite" \
    --mjolnir-admin "${PWD}/data/${HOST}/valhalla_tiles/admins.sqlite" > data/${HOST}/valhalla.json
fi

valhalla_build_tiles -c data/${HOST}/valhalla.json data/la.osm.pbf
find data/${HOST}/valhalla_tiles | sort -n | tar cf data/${HOST}/valhalla_tiles.tar --no-recursion -T -

valhalla_route_service data/valhalla.json 2 # I have two cores
