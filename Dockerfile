FROM debian:10-slim as baseenv

ARG FIX_MIRROR=mirrors.tuna.tsinghua.edu.cn
ARG APT_MIRROR=mirrors.sjtug.sjtu.edu.cn

ENV LANG=C.UTF-8\
    DISPLAY=unix:1

# 修复无法使用https源
RUN set -xe\
 && echo "deb http://${FIX_MIRROR}/debian buster main" > /etc/apt/sources.list\
 && apt-get update\
 && apt-get install -y ca-certificates\
 && echo "deb https://${APT_MIRROR}/debian/ buster main contrib non-free" > /etc/apt/sources.list\
 && echo "deb https://${APT_MIRROR}/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list\
 && echo "deb https://${APT_MIRROR}/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list\
 && echo "deb https://${APT_MIRROR}/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list

# 安装环境
RUN apt-get update\
 && apt-get install -y fuse libgl1 libglib2.0-0 xcb fonts-wqy-zenhei\
 && apt-get -y autoremove && apt-get clean -y && apt-get autoclean -y\
 && find /var/lib/apt/lists -type f -delete\
 && find /var/cache -type f -delete\
 && find /var/log -type f -delete\
 && find /usr/share/doc -type f -delete\
 && find /usr/share/man -type f -delete

FROM alpine:latest as downloader

RUN set -xe\
 && cd /tmp/\
 && wget http://cajviewer.cnki.net/download.html\
 && for i in `seq 5 20`; do URL=$(grep ">CAJViewer for Linux<" download.html -A$i | grep "<a" | cut -d'"' -f2); [ ! -z "$URL" ] && break; done\
 && wget $URL -O /tmp/CAJViewer\
 && chmod +x /tmp/CAJViewer

FROM baseenv
COPY --from=downloader /tmp/CAJViewer /CAJViewer
VOLUME [ "/HostHome" ]
ENTRYPOINT [ "/CAJViewer" ]