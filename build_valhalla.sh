#!/bin/bash
# Copyright 2018 Matthew Wigginton Conway
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
