FROM node:20-bookworm

# Install apt dependencies for mapnik builds
RUN apt-get update && apt-get install -y \
    python3 python3-dev \
    build-essential git libboost-all-dev libharfbuzz-dev \
    libtiff-dev libicu-dev zlib1g-dev libfreetype-dev \
    libxml2-dev libpng-dev libwebp-dev libproj-dev \
    libcairo2-dev libjpeg-dev libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

# Build and install mapnik
RUN git clone https://github.com/mapnik/mapnik.git /srv/mapnik

WORKDIR /srv/mapnik
RUN git checkout v4.0.2
RUN git submodule update --init
RUN python3 ./scons/scons.py configure
RUN python3 ./scons/scons.py install -j8

RUN npm i -g nodemon
WORKDIR /home/kartotherian
