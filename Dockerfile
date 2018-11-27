FROM alpine:edge

# Add project source
ADD . /usr/src/MusicBot
WORKDIR /usr/src/musicbot
COPY . ./

# Install dependencies
RUN apk update \
&& apk add --no-cache \
  ca-certificates \
  ffmpeg \
  opus \
  python3 \
  libsodium-dev \
\
# Install build dependencies
&& apk add --no-cache --virtual .build-deps \
  gcc \
  git \
  libffi-dev \
  make \
  musl-dev \
  python3-dev \
\
# Install pip dependencies
&& pip3 install --no-cache-dir -r requirements.txt \
&& pip3 install --upgrade --force-reinstall --version websockets==4.0.1 \
\
# Clean up build dependencies
&& apk del .build-deps



# Create volume for mapping the config
VOLUME /usr/src/MusicBot/config
VOLUME /usr/src/MusicBot/audio_cache
VOLUME /usr/src/MusicBot/data
VOLUME /usr/src/MusicBot/logs


ENV APP_ENV=docker

ENTRYPOINT ["python3", "run.py"]
