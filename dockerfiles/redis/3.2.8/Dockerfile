FROM registry.wtransnet.local:5000/sistemas/ubuntu16.04:latest

# Redis Dockerfile
#
# https://github.com/dockerfile/redis
#

# Install Redis.
RUN \
  apt-get update && \
  apt-get install -y build-essential && \
  cd /tmp && \
  wget http://download.redis.io/releases/redis-3.2.8.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  rm -rf /var/lib/apt/lists/*
  
COPY redis.conf /etc/redis/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["redis-server", "/etc/redis/redis.conf"]

# Expose ports.
EXPOSE 6379
