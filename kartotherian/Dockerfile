FROM debian:buster

RUN apt-get update && apt-get install -y nodejs \
    git \
    wget \
    python \
    build-essential \
    apt-transport-https \
    ca-certificates \
    fonts-dejavu \
    libboost-filesystem-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libcairo2-dev \
    libfreetype6-dev \
    libgdal-dev \
    libharfbuzz-dev \
    libjpeg-dev \
    libpng-dev \
    libpq-dev \
    libproj-dev \
    libtiff-dev \
    libwebp-dev \
    libxml2-dev \
    libmapbox-variant-dev \
    libboost-program-options-dev \
    libboost-thread-dev \
    apt-transport-https \
    libmapnik3.0 \
    libmapnik-dev \
    mapnik-utils \
    mapnik-doc \
    && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /opt/nvm
ENV NODE_VERSION 10.15.2

RUN mkdir ${NVM_DIR}
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.39.2/install.sh | bash \
	&& . ${NVM_DIR}/nvm.sh \
	&& nvm install ${NODE_VERSION}
ENV PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:${PATH}

RUN npm i -g nodemon

WORKDIR /home/kartotherian
