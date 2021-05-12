FROM debian:stable

RUN useradd user \
    && mkdir -p /home/user \
    && chown user:user /home/user

RUN apt-get update -q \
    && apt-get install -y chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY :0

#ENTRYPOINT /usr/bin/chromium
